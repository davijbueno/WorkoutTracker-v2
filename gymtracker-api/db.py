import json
import re
from contextlib import contextmanager
from urllib.parse import urlparse, unquote

import certifi
import pytds

# Em serverless (Vercel) não há pool persistente entre invocações.
# Cada request abre e fecha sua própria conexão — igual ao padrão anterior
# com psycopg2/Supabase, só que agora contra Azure SQL Database.

# ============================================================
# COMPAT: pytds.tls valida o hostname do certificado do servidor
# usando a API legada do pyOpenSSL (X509.get_extension), removida
# nas versões recentes do pyOpenSSL/cryptography. Fixar uma versão
# antiga do pyOpenSSL para manter esse método force o build (Vercel)
# a compilar `cryptography` do zero (sem wheel pra versão do Python
# usada lá) — trava o deploy. Em vez disso, repõe só o que o pytds
# usa (leitura do SAN do certificado) via a API moderna da lib
# `cryptography`, mantendo pyOpenSSL/cryptography na última versão.
# ============================================================
try:
    import OpenSSL.crypto as _ssl_crypto

    if not hasattr(_ssl_crypto.X509, "get_extension"):
        from cryptography import x509 as _cx509

        class _SANExtCompat:
            def __init__(self, dns_names):
                self._text = ", ".join(f"DNS:{d}" for d in dns_names)

            def get_short_name(self):
                return b"subjectAltName"

            def __str__(self):
                return self._text

        def _get_san(x509_obj):
            try:
                ext = x509_obj.to_cryptography().extensions.get_extension_for_class(
                    _cx509.SubjectAlternativeName
                )
                return ext.value.get_values_for_type(_cx509.DNSName)
            except _cx509.ExtensionNotFound:
                return []

        def _get_extension_count(self):
            return 1 if _get_san(self) else 0

        def _get_extension(self, index):
            return _SANExtCompat(_get_san(self))

        _ssl_crypto.X509.get_extension_count = _get_extension_count
        _ssl_crypto.X509.get_extension = _get_extension
except Exception as _e:  # nunca deve impedir o app de subir
    print(f"[db] aviso: shim de compat TLS não aplicado: {_e}")

_conn_kwargs = None


def init_db_config(app):
    global _conn_kwargs
    db_url = app.config.get("DATABASE_URL")
    if db_url:
        # formato esperado: mssql://usuario:senha@host:porta/database
        parsed = urlparse(db_url)
        _conn_kwargs = dict(
            server=parsed.hostname,
            port=parsed.port or 1433,
            database=parsed.path.lstrip("/"),
            user=unquote(parsed.username) if parsed.username else None,
            password=unquote(parsed.password) if parsed.password else None,
        )
    else:
        _conn_kwargs = dict(
            server=app.config["DB_HOST"],
            port=app.config.get("DB_PORT", 1433),
            database=app.config["DB_NAME"],
            user=app.config["DB_USER"],
            password=app.config["DB_PASSWORD"],
        )


def _connect():
    # cafile habilita TLS completo na sessão inteira — obrigatório pelo
    # Azure SQL Database (sem isso a conexão é recusada com "encryption
    # required"). Usa o bundle de CAs públicas do certifi.
    return pytds.connect(
        as_dict=True, autocommit=False, cafile=certifi.where(), **_conn_kwargs
    )


# ============================================================
# CAMADA DE COMPATIBILIDADE POSTGRES → T-SQL
# ------------------------------------------------------------
# As queries no resto do código foram escritas para PostgreSQL.
# Em vez de reescrever cada uma manualmente, esta camada traduz
# os padrões mecânicos e recorrentes automaticamente:
#   - NOW()                  -> SYSUTCDATETIME()
#   - TRUE / FALSE            -> 1 / 0
#   - "... RETURNING x"       -> "OUTPUT INSERTED.x ..." (posição correta)
#   - "... LIMIT n"            -> "SELECT TOP n ..."
# Padrões não-mecânicos (ANY(), FILTER, ||, NOT col) foram
# corrigidos diretamente nas queries dos módulos.
# ============================================================

_RETURNING_RE = re.compile(r"\bRETURNING\s+(\*|[\w, ]+?)\s*$", re.IGNORECASE)
_LIMIT_RE = re.compile(r"\bLIMIT\s+(\d+)\s*$", re.IGNORECASE)
_TRUE_RE = re.compile(r"\bTRUE\b", re.IGNORECASE)
_FALSE_RE = re.compile(r"\bFALSE\b", re.IGNORECASE)
_NOW_RE = re.compile(r"\bNOW\(\)", re.IGNORECASE)


def _rewrite_returning(sql):
    m = _RETURNING_RE.search(sql.strip())
    if not m:
        return sql
    cols = m.group(1).strip()
    if cols == "*":
        output_cols = "INSERTED.*"
    else:
        output_cols = ", ".join(f"INSERTED.{c.strip()}" for c in cols.split(","))
    body = sql[: m.start()].rstrip()

    stripped = body.lstrip()
    if stripped[:6].upper() == "INSERT":
        v_idx = re.search(r"\bVALUES\b", body, re.IGNORECASE)
        s_idx = re.search(r"\bSELECT\b", body, re.IGNORECASE)
        idx = None
        if v_idx and (not s_idx or v_idx.start() < s_idx.start()):
            idx = v_idx.start()
        elif s_idx:
            idx = s_idx.start()
        if idx is not None:
            return body[:idx] + f"OUTPUT {output_cols} " + body[idx:]
        return body
    elif stripped[:6].upper() == "UPDATE":
        w_idx = re.search(r"\bWHERE\b", body, re.IGNORECASE)
        if w_idx:
            return body[: w_idx.start()] + f"OUTPUT {output_cols} " + body[w_idx.start() :]
        return body + f" OUTPUT {output_cols}"
    return body


def _rewrite_limit(sql):
    m = _LIMIT_RE.search(sql.strip())
    if not m:
        return sql
    n = m.group(1)
    body = sql[: m.start()].rstrip()
    return re.sub(r"\bSELECT\b", f"SELECT TOP {n}", body, count=1, flags=re.IGNORECASE)


def _translate(sql):
    sql = _rewrite_returning(sql)
    sql = _rewrite_limit(sql)
    sql = _NOW_RE.sub("SYSUTCDATETIME()", sql)
    sql = _TRUE_RE.sub("1", sql)
    sql = _FALSE_RE.sub("0", sql)
    return sql


def _adapt_param(p):
    """list/dict -> JSON text (equivalente ao auto-adapt de JSONB/array do psycopg2)."""
    if isinstance(p, (list, dict)):
        return json.dumps(p, ensure_ascii=False)
    return p


def _adapt_params(params):
    if params is None:
        return None
    return [_adapt_param(p) for p in params]


def _maybe_parse_json(v):
    if isinstance(v, str) and v[:1] in ("[", "{"):
        try:
            parsed = json.loads(v)
        except (ValueError, TypeError):
            return v
        if isinstance(parsed, (list, dict)):
            return parsed
    return v


def _decode_row(row):
    if row is None:
        return None
    return {k: _maybe_parse_json(v) for k, v in row.items()}


def _decode_rows(rows):
    return [_decode_row(r) for r in rows]


# ============================================================
# CURSOR WRAPPER
# ------------------------------------------------------------
# Vários pontos do código (transações multi-statement em
# modules/treino e modules/treinador) pegam `conn.cursor()`
# diretamente e chamam cur.execute()/fetchone()/fetchall() sem
# passar pelas funções query()/query_one()/execute() abaixo.
# Para que a tradução Postgres→T-SQL e a (des)serialização JSON
# valham para TODO ponto de acesso — não só query()/execute() —
# a tradução mora aqui, no cursor, e não é duplicada por chamador.
# ============================================================


class _CursorWrapper:
    def __init__(self, raw_cursor):
        self._cur = raw_cursor

    def execute(self, sql, params=None):
        return self._cur.execute(_translate(sql), _adapt_params(params) or ())

    def fetchone(self):
        return _decode_row(self._cur.fetchone())

    def fetchall(self):
        return _decode_rows(self._cur.fetchall())

    def fetchmany(self, size=None):
        rows = self._cur.fetchmany(size) if size is not None else self._cur.fetchmany()
        return _decode_rows(rows)

    def __getattr__(self, name):
        return getattr(self._cur, name)


class _ConnWrapper:
    def __init__(self, raw_conn):
        self._conn = raw_conn

    def cursor(self):
        return _CursorWrapper(self._conn.cursor())

    def __getattr__(self, name):
        return getattr(self._conn, name)


# ============================================================
# API pública (mesma assinatura de antes)
# ============================================================


@contextmanager
def db():
    raw_conn = _connect()
    conn = _ConnWrapper(raw_conn)
    try:
        cur = conn.cursor()
        # Injeta user_id para RLS via SESSION_CONTEXT (equivalente ao
        # SET LOCAL app.current_user_id do Postgres — aqui é por conexão,
        # o que é suficiente pois cada request abre sua própria conexão).
        try:
            from flask import g

            user_id = getattr(g, "user_id", None)
            # pytds trata "EXEC proc @param=%s" como RPC call e quebra o
            # nome do procedimento quando há parâmetro — por isso o valor
            # vai embutido como literal. Seguro pois user_id sempre passa
            # por int() antes (só aceita inteiro, nunca texto arbitrário).
            if user_id is not None:
                cur.execute(
                    f"EXEC sp_set_session_context @key=N'app_user_id', @value=N'{int(user_id)}'"
                )
            else:
                cur.execute("EXEC sp_set_session_context @key=N'app_user_id', @value=NULL")
        except RuntimeError:
            pass
        yield conn
        raw_conn.commit()
    except Exception:
        raw_conn.rollback()
        raise
    finally:
        raw_conn.close()


def query(sql, params=None):
    with db() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)
        return cur.fetchall()


def query_one(sql, params=None):
    with db() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)
        return cur.fetchone()


def execute(sql, params=None):
    with db() as conn:
        cur = conn.cursor()
        cur.execute(sql, params)
        try:
            return cur.fetchone()
        except Exception:
            return None


def _split_batches(script):
    """T-SQL exige que CREATE TRIGGER/FUNCTION/SECURITY POLICY sejam o único
    statement do seu batch. GO é o separador de batch convencional (não é
    T-SQL de verdade, então precisamos dividir manualmente antes de executar)."""
    batches, current = [], []
    for line in script.splitlines():
        if line.strip().upper() == "GO":
            if current:
                batches.append("\n".join(current))
                current = []
        else:
            current.append(line)
    if current:
        batches.append("\n".join(current))
    return [b for b in batches if b.strip()]


def init_db():
    """Executa schema.sql e seed.sql. Use apenas em desenvolvimento local (INIT_DB=true)."""
    import os

    base = os.path.dirname(os.path.abspath(__file__))
    with db() as conn:
        cur = conn.cursor()
        with open(os.path.join(base, "schema.sql"), encoding="utf-8") as f:
            script = f.read()
        for batch in _split_batches(script):
            cur.execute(batch)
    try:
        with db() as conn:
            cur = conn.cursor()
            with open(os.path.join(base, "seed.sql"), encoding="utf-8") as f:
                script = f.read()
            for batch in _split_batches(script):
                cur.execute(batch)
    except Exception as e:
        print(f"[DB] Seed skipped: {e}")
