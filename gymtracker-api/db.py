import psycopg2
import psycopg2.extras
import os
from contextlib import contextmanager

# Em serverless (Vercel) não há pool persistente entre invocações.
# Cada request abre e fecha sua própria conexão.
# O Supabase Transaction Pooler (porta 6543) gerencia o pool real.

_dsn = None
_dsn_kwargs = None


def init_db_config(app):
    global _dsn, _dsn_kwargs
    db_url = app.config.get("DATABASE_URL")
    if db_url:
        if "sslmode" not in db_url:
            sep = "&" if "?" in db_url else "?"
            db_url = f"{db_url}{sep}sslmode=require"
        _dsn = db_url
    else:
        _dsn_kwargs = dict(
            host=app.config["DB_HOST"],
            port=app.config["DB_PORT"],
            dbname=app.config["DB_NAME"],
            user=app.config["DB_USER"],
            password=app.config["DB_PASSWORD"],
            sslmode=app.config.get("DB_SSLMODE", "prefer"),
        )


def _connect():
    kw = dict(cursor_factory=psycopg2.extras.RealDictCursor)
    if _dsn:
        return psycopg2.connect(_dsn, **kw)
    return psycopg2.connect(**_dsn_kwargs, **kw)


@contextmanager
def db():
    conn = _connect()
    try:
        cur = conn.cursor()
        # Injeta user_id para RLS (SET LOCAL — escopo da transação)
        try:
            from flask import g
            user_id = getattr(g, "user_id", None)
            if user_id is not None:
                cur.execute("SET LOCAL app.current_user_id = %s", (str(user_id),))
        except RuntimeError:
            pass
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def query(sql, params=None):
    with db() as conn:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        return cur.fetchall()


def query_one(sql, params=None):
    with db() as conn:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        return cur.fetchone()


def execute(sql, params=None):
    with db() as conn:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        try:
            return cur.fetchone()
        except Exception:
            return None


def init_db():
    """Executa schema.sql e seed.sql. Use apenas em desenvolvimento local (INIT_DB=true)."""
    base = os.path.dirname(os.path.abspath(__file__))
    with db() as conn:
        cur = conn.cursor()
        with open(os.path.join(base, "schema.sql"), encoding="utf-8") as f:
            cur.execute(f.read())
    try:
        with db() as conn:
            cur = conn.cursor()
            with open(os.path.join(base, "seed.sql"), encoding="utf-8") as f:
                cur.execute(f.read())
    except Exception as e:
        print(f"[DB] Seed skipped: {e}")
