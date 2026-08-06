# GymTracker 16W — Setup

---

## 1. Banco de dados: Supabase

### 1.1 Criar projeto

1. Acesse [supabase.com](https://supabase.com) → **New project**
2. Anote: **Project Ref**, **Region**, **Database Password**

### 1.2 Aplicar schema e seed

Painel do Supabase → **SQL Editor → New query**

Execute na ordem:
1. Cole o conteúdo de `gymtracker-api/schema.sql` → **Run**
2. Cole o conteúdo de `gymtracker-api/seed.sql` → **Run**

### 1.3 Obter a connection string (Transaction Pooler)

> Para Vercel (serverless) use o **Transaction Pooler** (porta 6543).

1. Painel do Supabase → **Project Settings** (⚙️ no menu lateral)
2. Clique em **Database**
3. Role até **"Connection pooling"**
4. Clique na aba **`URI`**
5. Copie a string (formato abaixo) e substitua `[YOUR-PASSWORD]` pela senha real:

```
postgresql://postgres.[PROJECT_REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
```

> **Atenção:** se a senha tiver `@` ou `$`, encode antes de colar na URL:
> `@` → `%40` · `$` → `%24`

---

## 2. Deploy do Backend (Vercel)

### 2.1 Criar projeto na Vercel

1. Acesse [vercel.com](https://vercel.com) → **Add New Project**
2. Importe o repositório `Consbueno/WorkoutTracker`
3. Em **"Root Directory"** defina: `gymtracker-api`
4. Framework Preset: **Other**
5. Clique em **Deploy** (vai falhar na primeira vez — normal, precisa das env vars)

### 2.2 Configurar variáveis de ambiente

No painel do projeto Vercel → **Settings → Environment Variables**

Adicione cada variável:

| Variável | Valor |
|---|---|
| `DATABASE_URL` | Connection string do Supabase (Transaction Pooler, porta 6543) |
| `SECRET_KEY` | String aleatória 64 chars |
| `JWT_SECRET_KEY` | Outra string aleatória 64 chars |
| `ANTHROPIC_API_KEY` | `sk-ant-api03-...` |
| `FRONTEND_URL` | `https://workouttracker.consbueno.com` |

> `INIT_DB` deixe **vazio** — o schema já foi aplicado no Supabase.

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
