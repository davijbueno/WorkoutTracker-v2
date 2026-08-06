# GymTracker 16W (v2) — Setup

> **v2 usa Azure SQL Database** (não Postgres/Supabase). Driver: `python-tds`
> (puro Python, sem dependência de ODBC — funciona em serverless/Vercel sem
> empacotar binários nativos). Ver [db.py](gymtracker-api/db.py) para a
> camada de compatibilidade Postgres→T-SQL.

---

## 1. Banco de dados: Azure SQL Database

### 1.1 Criar o servidor/banco

Portal do Azure → **Azure SQL Database** → **Create**. Anote: nome do
servidor, usuário admin, senha, nome do banco. Em **Networking**, habilite
acesso público com uma regra de firewall ampla (`0.0.0.0`–`255.255.255.255`)
— necessário pois o Vercel (serverless) tem IP de saída dinâmico.

### 1.2 Aplicar o schema

`gymtracker-api/schema.sql` é T-SQL puro, dividido em batches por `GO`.
Aplique via `sqlcmd`, Azure Data Studio/SSMS, ou um script Python com
`python-tds` que divide o arquivo por linhas `GO` e executa cada batch
(ver histórico do commit da migração para um exemplo).

### 1.3 Connection string

Formato usado pelo `db.py` (`DATABASE_URL`):

```
mssql://usuario:senha@servidor.database.windows.net:1433/nome_do_banco
```

> **Atenção:** se a senha tiver `@` ou `$`, encode antes de colar na URL:
> `@` → `%40` · `$` → `%24`

---

## 2. Deploy do Backend (Vercel)

### 2.1 Criar projeto na Vercel

1. Acesse [vercel.com](https://vercel.com) → **Add New Project**
2. Importe o repositório `davijbueno/WorkoutTracker-v2`
3. Em **"Root Directory"** defina: `gymtracker-api`
4. Framework Preset: **Other**
5. Clique em **Deploy** (vai falhar na primeira vez — normal, precisa das env vars)

### 2.2 Configurar variáveis de ambiente

No painel do projeto Vercel → **Settings → Environment Variables**

Adicione cada variável:

| Variável | Valor |
|---|---|
| `DATABASE_URL` | `mssql://usuario:senha@servidor.database.windows.net:1433/banco` |
| `SECRET_KEY` | String aleatória 64 chars |
| `JWT_SECRET_KEY` | Outra string aleatória 64 chars |
| `ANTHROPIC_API_KEY` | `sk-ant-api03-...` |
| `FRONTEND_URL` | URL do projeto frontend na Vercel |

> `INIT_DB` deixe **vazio** — o schema já foi aplicado no Azure SQL.
>
> **Importante:** o commit sendo implantado precisa ter o e-mail do autor
> associado a uma conta GitHub com acesso ao repositório — senão a Vercel
> bloqueia o deploy silenciosamente (fica em "Building..." sem log e sem
> erro claro). Confira `git log -1 --format="%ae"` antes de fazer deploy.

### 2.3 Fazer redeploy

Vercel → **Deployments → Redeploy** (agora com as variáveis corretas)

### 2.4 Domínio customizado do backend

1. Vercel → projeto do backend → **Settings → Domains**
2. Adicione: `api.workouttracker.consbueno.com`
3. A Vercel exibe um registro CNAME — anote-o

---

## 3. Deploy do Frontend (Vercel)

### 3.1 Criar segundo projeto na Vercel

1. Vercel → **Add New Project** → mesmo repositório `Consbueno/WorkoutTracker`
2. Em **"Root Directory"** defina: `gymtracker-app`
3. Framework Preset: **Vite**
4. Clique em **Deploy**

### 3.2 Variável de ambiente do frontend

Vercel → projeto do frontend → **Settings → Environment Variables**

| Variável | Valor |
|---|---|
| `VITE_API_URL` | `https://api.workouttracker.consbueno.com` |

Redeploy após adicionar.

### 3.3 Domínio customizado do frontend

1. Vercel → projeto do frontend → **Settings → Domains**
2. Adicione: `workouttracker.consbueno.com`
3. A Vercel exibe um registro CNAME — anote-o

---

## 4. DNS na Hostinger

Painel Hostinger → **Domínios → consbueno.com → DNS / Nameservers → Gerenciar DNS**

Adicione dois registros CNAME:

| Tipo | Nome | Destino |
|---|---|---|
| CNAME | `workouttracker` | `cname.vercel-dns.com` |
| CNAME | `api.workouttracker` | `cname.vercel-dns.com` |

> O destino `cname.vercel-dns.com` é o padrão da Vercel. Confirme o valor exato
> que cada projeto exibe em **Settings → Domains** antes de salvar.

Propagação do DNS: 5 minutos a 2 horas.

---

## 5. Resultado final

| URL | O que é |
|---|---|
| `workouttracker.consbueno.com` | React PWA (frontend) |
| `api.workouttracker.consbueno.com` | Flask API (backend) |
| *(interno)* | PostgreSQL no Supabase |

---

## Desenvolvimento local

### Backend

```bash
cd gymtracker-api
python -m venv .venv
.venv\Scripts\activate        # Windows
pip install -r requirements.txt
```

Adicione `INIT_DB=true` no `.env` local para aplicar schema/seed automaticamente.

```bash
flask --app app:create_app run --debug --port 5000
```

Teste: `http://localhost:5000/health` → `{"status": "ok"}`

### Frontend

```bash
cd gymtracker-app
npm install
npm run dev    # http://localhost:5173
```

`.env.local` do frontend:
```env
VITE_API_URL=http://localhost:5000
```

---

## Ícones PWA

Substitua em `gymtracker-app/public/`:
- `favicon.ico` (32×32)
- `icon-192.png` (192×192)
- `icon-512.png` (512×512)

Use `public/icon.svg` como base via [realfavicongenerator.net](https://realfavicongenerator.net).
