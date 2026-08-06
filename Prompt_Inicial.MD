# SPEC PROMPT — GymTracker 16W
## App de Controle de Treino com Periodização em Blocos de 16 Semanas

---

## PREMISSAS ADOTADAS

> **Premissa 1:** O app é single-user (1 atleta por instalação), com autenticação por email/senha via JWT.
> **Premissa 2:** Frontend e Backend são serviços separados no EasyPanel. Frontend = React SPA servido por nginx. Backend = Flask API REST na porta 5000.
> **Premissa 3:** O módulo de Análise com IA usa a Anthropic API (Claude) chamada diretamente pelo backend Flask. A API key nunca é exposta no frontend.
> **Premissa 4:** PWA com service worker para cache offline e instalação na home screen. Não é app nativo.
> **Premissa 5:** Idioma da interface: Português do Brasil (pt-BR). Todos os textos, labels, mensagens de erro e placeholders em pt-BR.
> **Premissa 6:** O protocolo de destino no EasyPanel é HTTP (não HTTPS), pois o reverse proxy do EasyPanel faz a terminação SSL.

---

## SEÇÃO 1 — CONTEXTO DO APP

GymTracker 16W é um app web progressivo (PWA) de controle de treino baseado em periodização em blocos de 16 semanas. Permite ao atleta cadastrar exercícios, configurar cronogramas de treino com blocos de Resistência, Hipertrofia e Força, executar os treinos dia a dia marcando exercícios realizados, registrar medições corporais e de saúde, e ao final do ciclo de 16 semanas, gerar automaticamente o próximo ciclo com opções de progressão de carga. Inclui um módulo de análise com IA que interpreta os dados de treino e medições gerando diagnóstico e sugestões de melhoria. O app é responsivo (mobile-first) e funciona como PWA instalável.

---

## SEÇÃO 2 — STACK TÉCNICA

### Frontend
```
Framework:      React 18 + TypeScript + Vite
Estilização:    Tailwind CSS 3.x + shadcn/ui
Estado:         Zustand (estado global) + TanStack Query (cache/fetch de dados)
HTTP Client:    Axios (interceptors para JWT e refresh token)
Gráficos:       Recharts
PWA:            vite-plugin-pwa (Workbox)
Build/Serve:    Vite build → nginx container no EasyPanel
```

### Backend
```
Linguagem:      Python 3.12
Framework:      Flask 3.x com Blueprints (modular)
Auth:           Flask-JWT-Extended (JWT access + refresh tokens)
Banco:          psycopg2-binary (conexão direta, sem ORM)
Pooling:        psycopg2.pool.ThreadedConnectionPool
Migrations:     schema.sql com CREATE TABLE IF NOT EXISTS
CORS:           Flask-CORS
Hashing:        Flask-Bcrypt
IA:             anthropic (SDK Python da Anthropic)
Validação:      marshmallow (serialização/validação de input)
Servidor Prod:  gunicorn (4 workers)
```

### Infraestrutura
```
VPS:            Hostinger VPS
Orquestração:   EasyPanel (3 serviços: PostgreSQL + Flask API + React Frontend)
Banco:          PostgreSQL 16 (serviço nativo do EasyPanel)
HTTPS:          Gerenciado pelo EasyPanel (reverse proxy com Let's Encrypt)
Domínio:        Subdomínio para API (api.gymtracker.dominio.com) e app (gymtracker.dominio.com)
```

### Estrutura de Pastas — Backend (Flask)
```
gymtracker-api/
├── app.py                    # Factory pattern: create_app()
├── config.py                 # Configurações por ambiente
├── db.py                     # Pool de conexões + helpers (query, execute, db context manager)
├── schema.sql                # DDL completo (CREATE TABLE IF NOT EXISTS)
├── seed.sql                  # Dados iniciais (exercícios padrão)
├── requirements.txt
├── Dockerfile
├── gunicorn.conf.py
├── .env                      # Apenas desenvolvimento local (NÃO vai no ZIP)
├── .gitignore
├── modules/
│   ├── __init__.py
│   ├── auth/
│   │   └── __init__.py       # Blueprint: login, registro, refresh token
│   ├── cadastros/
│   │   └── __init__.py       # Blueprint: exercícios, atleta, academia
│   ├── treino/
│   │   └── __init__.py       # Blueprint: programa, execução, dias de treino
│   ├── resultados/
│   │   └── __init__.py       # Blueprint: medições
│   └── analise/
│       └── __init__.py       # Blueprint: análise IA
└── utils/
    ├── __init__.py
    ├── validators.py         # Marshmallow schemas
    └── ai_client.py          # Client para Anthropic API
```

### Estrutura de Pastas — Frontend (React)
```
gymtracker-app/
├── index.html
├── vite.config.ts
├── tailwind.config.ts
├── tsconfig.json
├── package.json
├── Dockerfile
├── nginx.conf
├── public/
│   ├── icon-192.png
│   ├── icon-512.png
│   └── favicon.ico
└── src/
    ├── main.tsx
    ├── App.tsx
    ├── routes.tsx              # React Router v6
    ├── api/
    │   ├── axios.ts            # Instância Axios com interceptors JWT
    │   ├── auth.ts             # Endpoints de auth
    │   ├── cadastros.ts        # Endpoints de cadastros
    │   ├── treino.ts           # Endpoints de treino
    │   ├── resultados.ts       # Endpoints de medições
    │   └── analise.ts          # Endpoint de análise IA
    ├── stores/
    │   ├── auth-store.ts       # Zustand: user, token, isAuthenticated
    │   └── app-store.ts        # Zustand: tema, unidades, config geral
    ├── hooks/
    │   ├── use-auth.ts
    │   └── use-training.ts
    ├── components/
    │   ├── ui/                 # shadcn/ui components
    │   ├── layout/
    │   │   ├── sidebar.tsx
    │   │   ├── bottom-nav.tsx
    │   │   └── page-header.tsx
    │   ├── training/
    │   │   ├── exercise-card.tsx
    │   │   ├── rest-timer.tsx
    │   │   ├── block-badge.tsx
    │   │   └── progress-bar.tsx
    │   └── charts/
    │       ├── weight-chart.tsx
    │       ├── adherence-chart.tsx
    │       └── measurements-chart.tsx
    ├── pages/
    │   ├── dashboard.tsx
    │   ├── login.tsx
    │   ├── cadastros/
    │   │   ├── exercicios.tsx
    │   │   ├── atleta.tsx
    │   │   └── academia.tsx
    │   ├── treino/
    │   │   ├── manutencao.tsx  # Wizard 4 passos
    │   │   ├── execucao.tsx    # Treino do dia
    │   │   ├── fim-ciclo.tsx
    │   │   ├── resultados.tsx
    │   │   ├── nova-medicao.tsx
    │   │   └── analise.tsx
    │   └── configuracoes.tsx
    └── lib/
        ├── utils.ts            # cn(), formatters, calculators
        └── constants.ts        # Enums, muscle groups, equipment types
```

**Instrução ao construtor:** Use exclusivamente a stack acima. Não adicione bibliotecas não listadas sem justificativa explícita. Use shadcn/ui para todos os componentes de interface. Não use Material UI, Ant Design, Chakra ou similares.

---

## SEÇÃO 2B — CONFIGURAÇÃO DE INFRAESTRUTURA

### Dockerfile — Backend (Flask)
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["gunicorn", "--config", "gunicorn.conf.py", "app:create_app()"]
```

### gunicorn.conf.py
```python
bind = "0.0.0.0:5000"
workers = 4
timeout = 120
accesslog = "-"
errorlog = "-"
```

### Dockerfile — Frontend (React)
```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf (Frontend)
```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /assets {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### requirements.txt
```
flask==3.1.0
flask-cors==5.0.0
flask-jwt-extended==4.7.1
flask-bcrypt==1.0.1
psycopg2-binary==2.9.9
python-dotenv==1.0.1
marshmallow==3.23.2
anthropic==0.49.0
gunicorn==23.0.0
```

### Variáveis de Ambiente — Backend (.env / EasyPanel)
```
DB_HOST=gymtracker_postgres        # Nome interno do serviço no EasyPanel
DB_PORT=5432
DB_NAME=gymtracker
DB_USER=gymtracker_user
DB_PASSWORD=<senha-segura-gerada>
SECRET_KEY=<string-criptograficamente-segura-64-chars>
JWT_SECRET_KEY=<outra-string-segura-diferente-da-secret-key>
JWT_ACCESS_TOKEN_EXPIRES=3600      # 1 hora em segundos
JWT_REFRESH_TOKEN_EXPIRES=2592000  # 30 dias em segundos
ANTHROPIC_API_KEY=sk-ant-...       # Chave da API Anthropic
FRONTEND_URL=https://gymtracker.dominio.com  # Para CORS
```

### Variáveis de Ambiente — Frontend (Vite .env)
```
VITE_API_URL=https://api.gymtracker.dominio.com
```

### EasyPanel — Serviços
| Serviço | Tipo | Porta | Domínio |
|---------|------|-------|---------|
| gymtracker_postgres | PostgreSQL | 5432 (interno) | — |
| gymtracker_api | App (Dockerfile) | 5000 → HTTP | api.gymtracker.dominio.com |
| gymtracker_app | App (Dockerfile) | 80 → HTTP | gymtracker.dominio.com |

**CRÍTICO:** No EasyPanel, o protocolo de destino deve ser **HTTP** (não HTTPS). O reverse proxy do EasyPanel faz a terminação SSL automaticamente.

---

## SEÇÃO 2C — AUTENTICAÇÃO (JWT)

### Backend: Flask-JWT-Extended

```python
# modules/auth/__init__.py — Padrão de referência
from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt_identity
from flask_bcrypt import check_password_hash, generate_password_hash
import db

bp = Blueprint("auth", __name__)

@bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    hashed = generate_password_hash(data["password"]).decode("utf-8")
    user = db.execute(
        "INSERT INTO users (email, password_hash, full_name) VALUES (%s, %s, %s) RETURNING id, email, full_name",
        (data["email"], hashed, data["full_name"])
    )
    return jsonify({"message": "Conta criada com sucesso."}), 201

@bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    user = db.query_one("SELECT * FROM users WHERE email = %s AND is_active = TRUE", (data["email"],))
    if not user or not check_password_hash(user["password_hash"], data["password"]):
        return jsonify({"error": "Email ou senha inválidos."}), 401
    access_token = create_access_token(identity=str(user["id"]))
    refresh_token = create_refresh_token(identity=str(user["id"]))
    return jsonify({"access_token": access_token, "refresh_token": refresh_token, "user": {"id": user["id"], "email": user["email"], "full_name": user["full_name"]}})

@bp.route("/refresh", methods=["POST"])
@jwt_required(refresh=True)
def refresh():
    identity = get_jwt_identity()
    access_token = create_access_token(identity=identity)
    return jsonify({"access_token": access_token})
```

### Frontend: Axios Interceptors

```typescript
// src/api/axios.ts — Padrão de referência
import axios from 'axios';
import { useAuthStore } from '@/stores/auth-store';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: { 'Content-Type': 'application/json' },
});

api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().accessToken;
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401 && !error.config._retry) {
      error.config._retry = true;
      try {
        const refreshToken = useAuthStore.getState().refreshToken;
        const { data } = await axios.post(`${import.meta.env.VITE_API_URL}/auth/refresh`, {}, {
          headers: { Authorization: `Bearer ${refreshToken}` },
        });
        useAuthStore.getState().setAccessToken(data.access_token);
        error.config.headers.Authorization = `Bearer ${data.access_token}`;
        return api(error.config);
      } catch {
        useAuthStore.getState().logout();
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export default api;
```

---

## SEÇÃO 2D — BANCO DE DADOS (db.py com Connection Pool)

```python
# db.py — Conexão com pool thread-safe
import psycopg2
import psycopg2.extras
import psycopg2.pool
import os
from dotenv import load_dotenv
from contextlib import contextmanager

load_dotenv()

_pool = None

def init_pool():
    global _pool
    _pool = psycopg2.pool.ThreadedConnectionPool(
        minconn=2,
        maxconn=10,
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT", 5432),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        cursor_factory=psycopg2.extras.RealDictCursor
    )

@contextmanager
def db():
    conn = _pool.getconn()
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        _pool.putconn(conn)

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
        print(f"[DB] Seed ignorado (provavelmente já aplicado): {e}")
```

---

## SEÇÃO 2E — API REST ENDPOINTS

### Padrão de rotas da API

Todos os endpoints retornam JSON. Todos (exceto /auth/*) exigem JWT válido via header `Authorization: Bearer <token>`.

| Método | Rota | Blueprint | Descrição |
|--------|------|-----------|-----------|
| **Auth** | | | |
| POST | /auth/register | auth | Criar conta |
| POST | /auth/login | auth | Login (retorna access + refresh token) |
| POST | /auth/refresh | auth | Renovar access token |
| **Exercícios** | | | |
| GET | /cadastros/exercicios | cadastros | Listar exercícios (filtro por grupo muscular via query param) |
| POST | /cadastros/exercicios | cadastros | Criar exercício |
| PUT | /cadastros/exercicios/:id | cadastros | Editar exercício |
| PATCH | /cadastros/exercicios/:id/toggle | cadastros | Ativar/desativar exercício |
| **Atleta** | | | |
| GET | /cadastros/atleta | cadastros | Retornar perfil do atleta (ou null se não existe) |
| POST | /cadastros/atleta | cadastros | Criar perfil do atleta |
| PUT | /cadastros/atleta | cadastros | Atualizar perfil do atleta |
| **Academia** | | | |
| GET | /cadastros/academias | cadastros | Listar academias |
| POST | /cadastros/academias | cadastros | Criar academia |
| PUT | /cadastros/academias/:id | cadastros | Editar academia |
| PATCH | /cadastros/academias/:id/toggle | cadastros | Ativar/desativar academia |
| **Programa de Treino** | | | |
| GET | /treino/programas | treino | Listar programas (filtro por status) |
| GET | /treino/programas/:id | treino | Detalhe completo do programa (blocos + splits + exercícios + configs) |
| POST | /treino/programas | treino | Criar programa completo (recebe JSON com blocos, splits, exercícios e configs) |
| PUT | /treino/programas/:id | treino | Editar programa (só afeta training_days com status 'pending') |
| GET | /treino/programas/ativo | treino | Retornar o programa com status 'active' |
| **Dias de Treino** | | | |
| GET | /treino/dias | treino | Listar dias do programa ativo (com filtro por status, semana, bloco) |
| GET | /treino/dias/proximo | treino | Retornar o próximo dia pendente (ou in_progress) |
| GET | /treino/dias/:id | treino | Detalhe do dia com exercícios e parâmetros |
| PATCH | /treino/dias/:id/iniciar | treino | Marcar dia como 'in_progress' + setar started_at |
| PATCH | /treino/dias/:id/concluir | treino | Marcar como 'completed' + salvar dados de execução |
| PATCH | /treino/dias/:id/falta | treino | Marcar como 'missed' |
| PATCH | /treino/dias/:id/rascunho | treino | Salvar progresso parcial (status permanece 'in_progress') |
| **Exercícios do Dia** | | | |
| PATCH | /treino/dias/:dayId/exercicios/:exId | treino | Atualizar dados de execução de um exercício (carga efetiva, reps efetivas, observação, is_completed) |
| **Fim de Ciclo** | | | |
| GET | /treino/programas/:id/resumo | treino | Estatísticas do ciclo (taxa adesão, treinos por semana, etc.) |
| POST | /treino/programas/:id/duplicar | treino | Duplicar programa (cópia exata) |
| POST | /treino/programas/:id/progressao | treino | Duplicar com progressão de carga (recebe percentual) |
| **Medições** | | | |
| GET | /resultados/medicoes | resultados | Listar medições (filtro por período) |
| POST | /resultados/medicoes | resultados | Criar medição (valida: máx 1 por dia) |
| PUT | /resultados/medicoes/:id | resultados | Editar medição existente |
| GET | /resultados/medicoes/evolucao | resultados | Dados para gráficos de evolução |
| **Análise IA** | | | |
| POST | /analise/gerar | analise | Gerar análise com IA (coleta dados automaticamente do programa ativo) |
| GET | /analise/historico | analise | Listar análises anteriores |
| GET | /analise/:id | analise | Detalhe de uma análise |

### Padrão de resposta da API

**Sucesso:**
```json
{
  "data": { ... },
  "message": "Operação realizada com sucesso."
}
```

**Erro de validação (400):**
```json
{
  "error": "Dados inválidos.",
  "details": { "campo": ["mensagem de erro"] }
}
```

**Não autorizado (401):**
```json
{ "error": "Token inválido ou expirado." }
```

**Não encontrado (404):**
```json
{ "error": "Recurso não encontrado." }
```

**Conflito de negócio (409):**
```json
{ "error": "Já existe uma medição registrada para esta data." }
```

---

## SEÇÃO 3 — TELAS E FLUXO DE NAVEGAÇÃO

A navegação principal é por **barra inferior (mobile)** ou **sidebar (desktop)** com os seguintes itens:

```
📋 Cadastros (submenu: Exercícios, Atleta, Academia)
🏋️ Treino (submenu: Manutenção Treino, Treino do Dia, Resultados, Análise IA)
📊 Dashboard (tela inicial / home)
⚙️ Configurações
```

---

### Tela: Login / Registro
**Rota:** `/login`
**Acesso:** Público
**Descrição:** Tela de autenticação com abas Login e Registro.

**Aba Login:**
- Campo: Email (text, obrigatório, validação de formato)
- Campo: Senha (password, obrigatório, mínimo 6 chars)
- Botão: "Entrar"
- Link: "Não tem conta? Crie uma"

**Aba Registro:**
- Campo: Nome completo (text, obrigatório)
- Campo: Email (text, obrigatório, validação de formato)
- Campo: Senha (password, obrigatório, mínimo 6 chars)
- Campo: Confirmar senha (password, obrigatório, deve coincidir)
- Botão: "Criar Conta"

**Após login:** armazena access_token e refresh_token no Zustand (memória), redireciona para `/`.
**Após registro:** redireciona para login com toast "Conta criada. Faça login para continuar."

---

### Tela: Dashboard / Home
**Rota:** `/`
**Acesso:** Autenticado
**Descrição:** Visão geral do ciclo atual de 16 semanas. É a primeira tela após login.

**Componentes principais:**
- **Card de Progresso do Ciclo:** barra de progresso visual mostrando quantos dias de treino foram concluídos vs. total esperado no ciclo de 16 semanas. Exemplo: "Semana 7 de 16 — Bloco: Hipertrofia — 28/64 treinos realizados". A semana exibida é calculada com base nos treinos efetivamente concluídos (realizados ou falta), não pela data do calendário.
- **Card do Bloco Atual:** indica o bloco vigente (Resistência / Hipertrofia / Força / Deload), com a cor do bloco (Azul / Amarelo / Vermelho / Cinza), as repetições-alvo e a intensidade do bloco.
- **Card do Próximo Treino:** mostra qual é o próximo treino pendente (ex: "Treino B — Costas + Bíceps"), com botão "Iniciar Treino" que navega para a tela de execução do treino.
- **Card de Última Medição:** mostra a última medição registrada (peso, data) e botão "Nova Medição".
- **Mini-gráfico (sparkline):** evolução do peso corporal nas últimas 8 medições.
- **Card de Streak:** quantos treinos consecutivos foram realizados sem falta.

**Ações disponíveis:**
- Clicar em "Iniciar Treino" → navega para `/treino/execucao`
- Clicar em "Nova Medição" → navega para `/treino/resultados/nova`
- Clicar em qualquer card → navega para a respectiva seção

**Estados especiais:**
- Estado vazio (nenhum ciclo criado): mostra mensagem "Nenhum ciclo de treino configurado. Crie seu primeiro programa de 16 semanas." com botão "Criar Programa" que navega para `/treino/manutencao`.
- Estado de carregamento: skeleton nos cards.

---

### Tela: Cadastro de Exercícios
**Rota:** `/cadastros/exercicios`
**Acesso:** Autenticado
**Descrição:** Lista todos os exercícios cadastrados com filtro por grupo muscular. Permite criar, editar e desativar exercícios.

**Componentes principais:**
- **Barra de busca:** filtra exercícios por nome em tempo real (debounce 300ms)
- **Filtro por grupo muscular:** dropdown multi-select com os grupos: Peito, Costas, Ombros, Bíceps, Tríceps, Antebraço, Quadríceps, Posterior, Glúteos, Panturrilha, Abdômen, Trapézio, Lombar, Core (Geral)
- **Tabela/Lista de exercícios:** colunas: Nome | Grupo Muscular | Equipamento | Status (Ativo/Inativo)
- **Botão "Novo Exercício":** abre modal/sheet para cadastro

**Modal de Cadastro/Edição de Exercício:**
- Campo: Nome do exercício (text, obrigatório, máx 100 chars)
- Campo: Grupo muscular principal (select, obrigatório, usando os grupos listados acima)
- Campo: Grupo muscular secundário (select, opcional)
- Campo: Equipamento (select: Barra, Halter, Máquina, Polia/Cabo, Peso Corporal, Elástico, Kettlebell, Smith, Outro)
- Campo: Tipo de exercício (select: Composto, Isolado, Cardio, Isométrico)
- Campo: Observações (textarea, opcional, máx 500 chars)
- Campo: Status (toggle: Ativo / Inativo)
- Botão "Salvar" e "Cancelar"

**Ações disponíveis:**
- Criar novo exercício → abre modal vazio
- Clicar em exercício na lista → abre modal preenchido para edição
- Toggle de status → desativa/ativa exercício (soft delete — nunca apagar, apenas desativar)
- Busca por nome → filtra lista em tempo real

**Estados especiais:**
- Estado vazio: "Nenhum exercício cadastrado. Comece adicionando seus exercícios." + botão "Novo Exercício"
- Busca sem resultado: "Nenhum exercício encontrado para '[termo]'."

---

### Tela: Cadastro de Atleta
**Rota:** `/cadastros/atleta`
**Acesso:** Autenticado
**Descrição:** Formulário único para cadastro e edição dos dados do atleta. Somente 1 perfil de atleta por conta.

**Componentes principais — Seção Dados Pessoais:**
- Campo: Nome completo (text, obrigatório)
- Campo: Data de nascimento (date picker, obrigatório) — a idade é calculada automaticamente e exibida ao lado
- Campo: Sexo (select: Masculino, Feminino)
- Campo: Peso atual em kg (number, 2 casas decimais, obrigatório)
- Campo: Altura em cm (number, inteiro, obrigatório)
- Campo: IMC (calculado automaticamente: peso / (altura_m)², exibido como badge com classificação: Abaixo do peso / Normal / Sobrepeso / Obesidade Grau I / Obesidade Grau II / Obesidade Grau III)

**Componentes principais — Seção Condições de Saúde:**
- Toggle: É diabético? (boolean)
- Toggle: É hipertenso? (boolean)
- Toggle: É cardiopata? (boolean)
- Campo: Observações gerais de saúde (textarea, opcional)

**Componentes principais — Seção Restrições Corporais:**
Exibir como checklist visual com lista e ícones. Para cada região, o atleta marca se tem alguma restrição/problema:

| Região | Toggle (Sim/Não) | Campo Observação (aparece se Sim) |
|--------|:-:|---|
| Cabeça/Pescoço | ☐ | text |
| Ombro Direito | ☐ | text |
| Ombro Esquerdo | ☐ | text |
| Braço/Cotovelo Direito | ☐ | text |
| Braço/Cotovelo Esquerdo | ☐ | text |
| Punho/Mão Direita | ☐ | text |
| Punho/Mão Esquerda | ☐ | text |
| Peito | ☐ | text |
| Costas (Superior) | ☐ | text |
| Coluna (Lombar) | ☐ | text |
| Quadril | ☐ | text |
| Joelho Direito | ☐ | text |
| Joelho Esquerdo | ☐ | text |
| Perna Direita | ☐ | text |
| Perna Esquerda | ☐ | text |
| Tornozelo/Pé Direito | ☐ | text |
| Tornozelo/Pé Esquerdo | ☐ | text |

Quando uma região é marcada como "Sim", o campo de observação expande abaixo dela (accordion) para o atleta descrever a restrição.

**Ações disponíveis:**
- Salvar perfil → persiste no banco via PUT /cadastros/atleta
- Ao alterar peso, recalcula IMC automaticamente no frontend

**Estados especiais:**
- Primeira vez: formulário vazio com instrução "Preencha seus dados para personalizar seu programa de treino."
- Após salvar: toast de sucesso "Perfil atualizado com sucesso."

---

### Tela: Cadastro de Academia
**Rota:** `/cadastros/academia`
**Acesso:** Autenticado
**Descrição:** Cadastro da(s) academia(s) onde o atleta treina. Permite múltiplas academias.

**Componentes principais:**
- **Lista de academias cadastradas:** card para cada academia com nome, endereço e valor mensal
- **Botão "Nova Academia":** abre modal/sheet

**Modal de Cadastro/Edição:**
- Campo: Nome da academia (text, obrigatório, máx 100 chars)
- Campo: Endereço (text, opcional)
- Campo: Telefone (text, opcional, máscara de telefone BR)
- Campo: Valor mensal (number, BRL, 2 casas decimais, opcional)
- Campo: Data de vencimento da mensalidade (number 1-31, opcional)
- Campo: Horário preferido de treino (text, opcional, ex: "06:00 - 07:30")
- Campo: Observações (textarea, opcional)
- Campo: Status (toggle: Ativa / Inativa)
- Botão "Salvar" e "Cancelar"

**Ações disponíveis:**
- Criar nova academia → modal vazio
- Editar academia → modal preenchido
- Desativar academia → toggle de status

---

### Tela: Manutenção de Treino (Criação e Edição do Programa)
**Rota:** `/treino/manutencao`
**Acesso:** Autenticado
**Descrição:** Tela principal para criar e editar o programa de treino de 16 semanas. É um wizard de 4 passos.

**Wizard — Passo 1: Configuração Geral**
- Campo: Nome do programa (text, obrigatório, ex: "Ciclo 1 — Periodização 16 Semanas")
- Campo: Atleta (select, preenchido automaticamente com o atleta cadastrado)
- Campo: Academia (select, lista academias ativas)
- Campo: Total de semanas do ciclo (number, default 16, mínimo 8, máximo 24)
- Campo: Frequência semanal de musculação (number, mínimo 2, máximo 6)
- Campo: Frequência semanal de cardio (number, mínimo 0, máximo 6)

**Wizard — Passo 2: Estrutura dos Blocos**
Exibir uma timeline visual horizontal com os blocos. O atleta define:

| Configuração do Bloco | Campos |
|---|---|
| Bloco 1 | Nome (default "Resistência"), Semana início, Semana fim, Cor do bloco (select: Azul, Amarelo, Vermelho, Cinza, Verde, Roxo), Reps-alvo (text, ex: "15-25"), Intensidade (text, ex: "50-65% 1RM"), Descanso padrão em segundos (number) |
| Bloco 2 | Idem |
| Bloco 3 | Idem |
| Bloco 4 | Idem (default "Deload") |

- Botão "+ Adicionar Bloco" (máximo 6 blocos)
- Botão "Remover Bloco" em cada bloco (mínimo 2 blocos)
- **Validação crítica:** a soma das semanas dos blocos deve ser igual ao total de semanas definido no Passo 1. Exibir erro inline se não bater: "A soma dos blocos (X semanas) é diferente do total do ciclo (Y semanas). Ajuste os blocos."

**Wizard — Passo 3: Divisão de Treinos (Split)**
O atleta define quantos treinos distintos existem na semana (ex: Treino A, B, C, D, E). Para cada treino:

- Campo: Letra/Nome do treino (text, default A, B, C..., editável)
- Campo: Descrição do treino (text, ex: "Peito + Tríceps")
- Campo: Grupos musculares principais (multi-select dos grupos musculares)

Abaixo de cada treino, uma **tabela de exercícios** com as colunas:

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| Ordem | number (auto) | Ordem de execução (drag and drop para reordenar) |
| Exercício | select (busca) | Busca nos exercícios cadastrados, filtrado pelo grupo muscular selecionado |
| Séries (por bloco) | number × N blocos | Uma coluna de séries para cada bloco. Ex: se 4 blocos → 4 colunas: "Séries B1", "Séries B2", "Séries B3", "Séries B4" |
| Reps (por bloco) | text × N blocos | Idem, uma coluna por bloco. Ex: "20", "10", "4", "15" |
| Carga (kg) (por bloco) | number × N blocos | Carga em kg para cada bloco. Se o atleta não souber, pode deixar 0 e preencher durante a execução |
| Descanso (seg) (por bloco) | number × N blocos | Tempo de descanso em segundos para cada bloco |

- Botão "+ Exercício" para adicionar linha à tabela
- Botão "🗑️" para remover exercício da tabela (com confirmação)
- Botão "+ Novo Treino" para adicionar mais uma letra ao split
- A tabela deve ser scrollável horizontalmente em mobile

**Wizard — Passo 4: Revisão e Confirmação**
Exibe um resumo visual completo do programa:
- Timeline dos blocos com cores
- Cada treino com seus exercícios e parâmetros
- Frequência semanal
- Botão "Salvar Programa" (envia POST /treino/programas com payload completo)
- Botão "Voltar" para editar qualquer passo

**Após salvar:**
- O backend gera automaticamente todos os "dias de treino" do ciclo. Exemplo: se o ciclo é de 16 semanas com 4 treinos por semana, são criados 64 registros de training_days, cada um com seu split, bloco, semana, e lista de exercícios com os parâmetros do bloco vigente.
- Toast: "Programa criado com sucesso! Bom treino! 💪"
- Navega para o Dashboard.

**Edição posterior:**
- Se o atleta acessar `/treino/manutencao` com um programa ativo, o wizard abre pré-preenchido (GET /treino/programas/ativo).
- **Alerta crítico:** se o programa já tem treinos com status "completed", exibir warning: "Este programa já tem treinos realizados. Alterações nos parâmetros afetarão apenas treinos futuros (não realizados). Treinos já realizados serão preservados."
- A edição nunca altera dados de treinos já concluídos.

---

### Tela: Treino do Dia (Execução)
**Rota:** `/treino/execucao`
**Acesso:** Autenticado
**Descrição:** Tela de execução do treino diário. O atleta vê os exercícios do treino pendente e vai marcando cada um como realizado.

**Header da tela:**
- Badge com o bloco atual (cor + nome, ex: "🟡 Hipertrofia")
- Texto: "Semana X de Y — Treino [Letra] — [Descrição]"
- Texto: Dia X de Z do ciclo (ex: "Dia 29 de 64")

**Componentes principais — Lista de Exercícios:**
Cada exercício é exibido como um **card expansível** com:

| Elemento | Descrição |
|----------|-----------|
| Checkbox | Grande, à esquerda. Ao marcar, o card fica com fundo verde suave e texto tachado. |
| Nome do exercício | Bold, principal |
| Grupo muscular | Badge pequeno abaixo do nome |
| Séries × Reps | Destaque: "4 × 10" |
| Carga esperada | "Carga: 30 kg" (editável inline — o atleta pode ajustar a carga durante o treino) |
| Descanso | "Descanso: 75s" |
| Campo: Carga efetiva (kg) | Input number que aparece ao expandir o card. O atleta registra a carga que realmente usou. Default = carga esperada. |
| Campo: Reps efetivas | Input number — reps que realmente fez em cada série. Pode registrar série a série (array) ou um valor único. |
| Campo: Observação | Text input curto para anotar algo sobre o exercício ("senti dor no ombro", "aumentar carga próxima vez") |

**Timer de Descanso (Opcional):**
- Quando o atleta marca um exercício (ou série), um timer de descanso aparece como uma barra flutuante no rodapé da tela.
- O timer conta o tempo de descanso configurado para aquele exercício.
- Ao zerar, vibra o celular (se suportado via navigator.vibrate) e exibe notificação visual.
- Botão para pular o timer.

**Botões de Ação (fixos no rodapé):**

| Botão | Ação |
|-------|------|
| ✅ **Concluir Treino (Realizado)** | Marca o dia como "completed" via PATCH /treino/dias/:id/concluir. Salva os dados de execução. Pergunta: "Deseja marcar este treino como Realizado mesmo com X de Y exercícios concluídos?" → Confirmação → Salva |
| ❌ **Marcar como Falta** | Marca o dia como "missed" via PATCH /treino/dias/:id/falta. Nenhum dado de exercício é salvo. Pergunta: "Deseja marcar este dia como Falta? Isso avançará para o próximo treino." → Confirmação → Salva |
| 💾 **Salvar Rascunho** | Salva o progresso parcial via PATCH /treino/dias/:id/rascunho. Status permanece 'in_progress'. |

**Regra crítica de progressão:**
- O ciclo de 16 semanas NÃO é baseado em datas do calendário. Os dias de treino avançam sequencialmente conforme o atleta conclui cada dia (como "completed" ou "missed").
- O ciclo só termina quando todos os dias de treino tiverem status "completed" ou "missed". Não existe data de término automática.

**Estados especiais:**
- Treino em andamento (rascunho): card aparece amarelo no Dashboard, texto "Continuar Treino"
- Todos os treinos do ciclo concluídos: navega para tela de "Fim de Ciclo"
- Nenhum programa criado: redireciona para `/treino/manutencao`

---

### Tela: Fim de Ciclo
**Rota:** `/treino/fim-ciclo`
**Acesso:** Autenticado (exibida automaticamente quando todos os dias do ciclo foram concluídos)
**Descrição:** Tela de encerramento do ciclo com estatísticas e opções para o próximo ciclo.

**Componentes principais:**
- **Card de Resumo:** total de treinos realizados, total de faltas, taxa de adesão (%), duração real do ciclo em dias corridos (diferença entre started_at do primeiro dia e completed_at do último)
- **Gráfico (Recharts):** evolução do peso corporal durante o ciclo (se houver medições)
- **Gráfico (Recharts):** aderência por semana (barras, % de treinos realizados vs. programados)

**Opções para o Próximo Ciclo — 3 Botões:**

| Opção | Descrição | Endpoint |
|-------|-----------|----------|
| 🔄 **Duplicar Ciclo** | Copia o programa exatamente como está para um novo ciclo | POST /treino/programas/:id/duplicar |
| 📈 **Progressão por Carga (%)** | Copia com % de aumento sobre todas as cargas | POST /treino/programas/:id/progressao (body: { percentual: 5 }) |
| ✏️ **Novo Programa Manual** | Abre wizard vazio para criar programa do zero | Navega para `/treino/manutencao` |

**Lógica de progressão de carga (backend):**
- O percentual é aplicado sobre TODAS as cargas (load_kg) de TODOS os blocos em split_exercise_block_config.
- Arredondamento: para o múltiplo de 0.5 kg mais próximo. Fórmula: `ROUND(load_kg * (1 + percentual/100) * 2) / 2`
- Exemplo: 30 kg × 1.05 = 31.5 kg. 22 kg × 1.05 = 23.1 → 23.0 kg.

**Após criar o novo ciclo:** navega para o Dashboard com o novo programa ativo.

---

### Tela: Resultados (Medições)
**Rota:** `/treino/resultados`
**Acesso:** Autenticado
**Descrição:** Histórico de medições corporais e de saúde. Permite visualizar evolução ao longo do tempo.

**Componentes principais:**
- **Tabela de medições:** lista todas as medições por data, mais recentes primeiro
- **Botão "Nova Medição":** navega para `/treino/resultados/nova`
- **Filtro por período:** date range picker
- **Gráficos de evolução (Recharts):**
  - Evolução do peso (linha)
  - Evolução de circunferências (linhas sobrepostas: braço, peito, cintura, quadril, coxa)
  - Evolução de glicose (linha com zona de referência)
  - Evolução de pressão arterial (duas linhas: sistólica e diastólica, com zonas de referência)

**Sub-tela: Nova Medição**
**Rota:** `/treino/resultados/nova`

**Campos de medição (todos opcionais exceto data e peso):**

| Seção | Campo | Tipo | Unidade |
|-------|-------|------|---------|
| **Básico** | Data da medição | date (default hoje) | — |
| | Peso | number (2 decimais) | kg |
| | Percentual de gordura | number (1 decimal) | % |
| **Circunferências** | Pescoço | number (1 decimal) | cm |
| | Ombros (largura) | number (1 decimal) | cm |
| | Peito | number (1 decimal) | cm |
| | Braço Direito (relaxado) | number (1 decimal) | cm |
| | Braço Direito (contraído) | number (1 decimal) | cm |
| | Braço Esquerdo (relaxado) | number (1 decimal) | cm |
| | Braço Esquerdo (contraído) | number (1 decimal) | cm |
| | Antebraço Direito | number (1 decimal) | cm |
| | Antebraço Esquerdo | number (1 decimal) | cm |
| | Cintura | number (1 decimal) | cm |
| | Quadril | number (1 decimal) | cm |
| | Coxa Direita | number (1 decimal) | cm |
| | Coxa Esquerda | number (1 decimal) | cm |
| | Panturrilha Direita | number (1 decimal) | cm |
| | Panturrilha Esquerda | number (1 decimal) | cm |
| **Saúde** | Glicose em jejum | number (inteiro) | mg/dL |
| | Pressão Sistólica | number (inteiro) | mmHg |
| | Pressão Diastólica | number (inteiro) | mmHg |
| | Frequência Cardíaca em repouso | number (inteiro) | bpm |
| **Observações** | Observações gerais | textarea | — |

**Validação:** máximo de 1 medição por dia. Se POST retornar 409, exibir: "Já existe uma medição registrada para esta data. Deseja editá-la?" → Abre a medição existente para edição.

---

### Tela: Análise IA
**Rota:** `/treino/analise`
**Acesso:** Autenticado
**Descrição:** Módulo de análise inteligente. Gera análise via IA comparando programa planejado com execução real.

**Componentes principais:**
- **Botão "Gerar Análise com IA":** botão grande, centralizado. Ao clicar, faz POST /analise/gerar.
- **Loading state:** skeleton + mensagem "Analisando seus dados de treino... Isso pode levar alguns segundos."
- **Card de Análise (resultado):** exibe o texto da análise formatado com Markdown renderizado (usar react-markdown).
- **Botão "Copiar Análise":** copia para clipboard
- **Botão "Nova Análise":** regenerar
- **Histórico:** lista de análises anteriores abaixo (GET /analise/historico), clicável para expandir

**Backend — Lógica da Edge Function substituída por rota Flask (modules/analise/):**

O endpoint POST /analise/gerar:
1. Coleta automaticamente todos os dados do programa ativo: atleta, blocos, splits, exercícios, dias de treino com execução, medições
2. Monta o payload estruturado
3. Chama a Anthropic API via SDK Python:

```python
# utils/ai_client.py
import anthropic
import os

client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

def gerar_analise(payload: dict) -> str:
    message = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=4096,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": json.dumps(payload, ensure_ascii=False)}]
    )
    return message.content[0].text
```

**System prompt da IA:**
```
Você é um preparador físico e analista de treino especializado em periodização por blocos.
Analise os dados de treino do atleta e gere um relatório estruturado em Português do Brasil com as seguintes seções:

1. RESUMO GERAL — visão geral da aderência e progresso
2. ANÁLISE POR BLOCO — como foi a execução em cada bloco (Resistência, Hipertrofia, Força)
3. PROGRESSÃO DE CARGA — exercícios que progrediram vs. estagnaram vs. regrediram
4. PONTOS DE ATENÇÃO — observações do atleta que indicam dor, desconforto ou limitação. Cruze com as restrições corporais cadastradas.
5. EVOLUÇÃO CORPORAL — análise das medições (peso, circunferências, indicadores de saúde)
6. DIAGNÓSTICO — conclusão geral: o ciclo está sendo efetivo? O que funcionou? O que não funcionou?
7. SUGESTÕES PARA O PRÓXIMO CICLO — recomendações concretas: ajustar carga em quais exercícios, mudar algum exercício, modificar frequência, alterar algum bloco, etc.

Considere as condições de saúde e restrições corporais do atleta ao fazer recomendações.
Seja direto e prático. Não use jargão desnecessário. Use dados específicos dos treinos na análise.
```

**Estados especiais:**
- Sem dados suficientes (menos de 4 treinos realizados): "Ainda não há dados suficientes para gerar uma análise. Continue treinando! Mínimo: 4 treinos realizados."
- Erro na API: "Não foi possível gerar a análise no momento. Tente novamente em alguns instantes."

---

### Tela: Configurações
**Rota:** `/configuracoes`
**Acesso:** Autenticado

**Componentes:**
- **Tema:** toggle Dark Mode / Light Mode (Tailwind dark: classes, preferência salva no localStorage)
- **Unidades:** toggle Quilogramas / Libras (afeta exibição em todo o app)
- **Timer de descanso:** toggle ligado/desligado (default: ligado)
- **Vibrar ao fim do descanso:** toggle ligado/desligado
- **Exportar dados:** botão para exportar todos os dados em JSON (GET /api/export)
- **Logout:** botão para sair (limpa tokens do Zustand)
- **Sobre:** versão do app, créditos

---

## SEÇÃO 4 — ENTIDADES DE DADOS E ESQUEMA (schema.sql)

```sql
-- ============================================
-- GymTracker 16W — Schema PostgreSQL
-- ============================================

-- Tabela de usuários (auth própria, não Supabase)
CREATE TABLE IF NOT EXISTS users (
    id              SERIAL PRIMARY KEY,
    email           VARCHAR(200) NOT NULL UNIQUE,
    password_hash   VARCHAR(300) NOT NULL,
    full_name       VARCHAR(200) NOT NULL,
    is_active       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Atleta (1 por usuário)
CREATE TABLE IF NOT EXISTS athletes (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL REFERENCES users(id),
    full_name       VARCHAR(200) NOT NULL,
    birth_date      DATE NOT NULL,
    sex             VARCHAR(1) NOT NULL CHECK (sex IN ('M', 'F')),
    weight_kg       NUMERIC(5,2) NOT NULL,
    height_cm       INTEGER NOT NULL,
    is_diabetic     BOOLEAN DEFAULT FALSE,
    is_hypertensive BOOLEAN DEFAULT FALSE,
    is_cardiac      BOOLEAN DEFAULT FALSE,
    health_notes    TEXT,
    body_restrictions JSONB DEFAULT '[]',
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Exercícios
CREATE TABLE IF NOT EXISTS exercises (
    id                      SERIAL PRIMARY KEY,
    user_id                 INTEGER NOT NULL REFERENCES users(id),
    name                    VARCHAR(100) NOT NULL,
    primary_muscle_group    VARCHAR(50) NOT NULL,
    secondary_muscle_group  VARCHAR(50),
    equipment               VARCHAR(50) NOT NULL,
    exercise_type           VARCHAR(20) NOT NULL CHECK (exercise_type IN ('compound','isolation','cardio','isometric')),
    notes                   VARCHAR(500),
    is_active               BOOLEAN DEFAULT TRUE,
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW()
);

-- Academias
CREATE TABLE IF NOT EXISTS gyms (
    id                  SERIAL PRIMARY KEY,
    user_id             INTEGER NOT NULL REFERENCES users(id),
    name                VARCHAR(100) NOT NULL,
    address             TEXT,
    phone               VARCHAR(20),
    monthly_fee         NUMERIC(8,2),
    payment_due_day     INTEGER CHECK (payment_due_day BETWEEN 1 AND 31),
    preferred_schedule  VARCHAR(50),
    notes               TEXT,
    is_active           BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT NOW(),
    updated_at          TIMESTAMP DEFAULT NOW()
);

-- Programa de treino
CREATE TABLE IF NOT EXISTS training_programs (
    id                      SERIAL PRIMARY KEY,
    user_id                 INTEGER NOT NULL REFERENCES users(id),
    athlete_id              INTEGER NOT NULL REFERENCES athletes(id),
    gym_id                  INTEGER REFERENCES gyms(id),
    name                    VARCHAR(200) NOT NULL,
    total_weeks             INTEGER NOT NULL DEFAULT 16,
    weekly_training_freq    INTEGER NOT NULL,
    weekly_cardio_freq      INTEGER NOT NULL DEFAULT 0,
    status                  VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','completed','archived')),
    created_at              TIMESTAMP DEFAULT NOW(),
    updated_at              TIMESTAMP DEFAULT NOW()
);

-- Blocos do programa (Resistência, Hipertrofia, Força, Deload)
CREATE TABLE IF NOT EXISTS training_blocks (
    id                  SERIAL PRIMARY KEY,
    program_id          INTEGER NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    block_order         INTEGER NOT NULL,
    name                VARCHAR(50) NOT NULL,
    start_week          INTEGER NOT NULL,
    end_week            INTEGER NOT NULL,
    color               VARCHAR(20) NOT NULL DEFAULT 'blue',
    target_reps         VARCHAR(20) NOT NULL,
    target_intensity    VARCHAR(30) NOT NULL,
    default_rest_seconds INTEGER NOT NULL DEFAULT 60,
    created_at          TIMESTAMP DEFAULT NOW()
);

-- Splits (Treino A, B, C, D, E)
CREATE TABLE IF NOT EXISTS training_splits (
    id              SERIAL PRIMARY KEY,
    program_id      INTEGER NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    letter          VARCHAR(5) NOT NULL,
    description     VARCHAR(200) NOT NULL,
    muscle_groups   TEXT[] NOT NULL,
    split_order     INTEGER NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Exercícios dentro de cada split
CREATE TABLE IF NOT EXISTS split_exercises (
    id              SERIAL PRIMARY KEY,
    split_id        INTEGER NOT NULL REFERENCES training_splits(id) ON DELETE CASCADE,
    exercise_id     INTEGER NOT NULL REFERENCES exercises(id),
    exercise_order  INTEGER NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Configuração de cada exercício POR BLOCO (séries, reps, carga, descanso)
CREATE TABLE IF NOT EXISTS split_exercise_block_config (
    id                  SERIAL PRIMARY KEY,
    split_exercise_id   INTEGER NOT NULL REFERENCES split_exercises(id) ON DELETE CASCADE,
    block_id            INTEGER NOT NULL REFERENCES training_blocks(id) ON DELETE CASCADE,
    sets                INTEGER NOT NULL,
    reps                VARCHAR(20) NOT NULL,
    load_kg             NUMERIC(6,2) DEFAULT 0,
    rest_seconds        INTEGER NOT NULL DEFAULT 60,
    is_included         BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT NOW(),
    UNIQUE(split_exercise_id, block_id)
);

-- Dias de treino (gerados automaticamente ao salvar programa)
CREATE TABLE IF NOT EXISTS training_days (
    id              SERIAL PRIMARY KEY,
    program_id      INTEGER NOT NULL REFERENCES training_programs(id) ON DELETE CASCADE,
    split_id        INTEGER NOT NULL REFERENCES training_splits(id),
    block_id        INTEGER NOT NULL REFERENCES training_blocks(id),
    week_number     INTEGER NOT NULL,
    day_number      INTEGER NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','in_progress','completed','missed')),
    started_at      TIMESTAMP,
    completed_at    TIMESTAMP,
    notes           TEXT,
    created_at      TIMESTAMP DEFAULT NOW(),
    updated_at      TIMESTAMP DEFAULT NOW()
);

-- Exercícios executados em cada dia de treino
CREATE TABLE IF NOT EXISTS training_day_exercises (
    id                  SERIAL PRIMARY KEY,
    training_day_id     INTEGER NOT NULL REFERENCES training_days(id) ON DELETE CASCADE,
    split_exercise_id   INTEGER NOT NULL REFERENCES split_exercises(id),
    exercise_id         INTEGER NOT NULL REFERENCES exercises(id),
    planned_sets        INTEGER NOT NULL,
    planned_reps        VARCHAR(20) NOT NULL,
    planned_load_kg     NUMERIC(6,2) DEFAULT 0,
    planned_rest_seconds INTEGER NOT NULL,
    actual_load_kg      NUMERIC(6,2),
    actual_reps         JSONB,
    is_completed        BOOLEAN DEFAULT FALSE,
    exercise_notes      TEXT,
    completed_at        TIMESTAMP,
    created_at          TIMESTAMP DEFAULT NOW()
);

-- Medições corporais e de saúde
CREATE TABLE IF NOT EXISTS measurements (
    id                      SERIAL PRIMARY KEY,
    user_id                 INTEGER NOT NULL REFERENCES users(id),
    athlete_id              INTEGER NOT NULL REFERENCES athletes(id),
    measurement_date        DATE NOT NULL,
    weight_kg               NUMERIC(5,2),
    body_fat_pct            NUMERIC(4,1),
    neck_cm                 NUMERIC(4,1),
    shoulders_cm            NUMERIC(4,1),
    chest_cm                NUMERIC(4,1),
    right_arm_relaxed_cm    NUMERIC(4,1),
    right_arm_flexed_cm     NUMERIC(4,1),
    left_arm_relaxed_cm     NUMERIC(4,1),
    left_arm_flexed_cm      NUMERIC(4,1),
    right_forearm_cm        NUMERIC(4,1),
    left_forearm_cm         NUMERIC(4,1),
    waist_cm                NUMERIC(4,1),
    hip_cm                  NUMERIC(4,1),
    right_thigh_cm          NUMERIC(4,1),
    left_thigh_cm           NUMERIC(4,1),
    right_calf_cm           NUMERIC(4,1),
    left_calf_cm            NUMERIC(4,1),
    fasting_glucose         INTEGER,
    systolic_bp             INTEGER,
    diastolic_bp            INTEGER,
    resting_hr              INTEGER,
    notes                   TEXT,
    created_at              TIMESTAMP DEFAULT NOW(),
    UNIQUE(athlete_id, measurement_date)
);

-- Análises geradas por IA
CREATE TABLE IF NOT EXISTS ai_analyses (
    id              SERIAL PRIMARY KEY,
    user_id         INTEGER NOT NULL REFERENCES users(id),
    program_id      INTEGER NOT NULL REFERENCES training_programs(id),
    analysis_text   TEXT NOT NULL,
    input_payload   JSONB NOT NULL,
    model_used      VARCHAR(50) NOT NULL DEFAULT 'claude-sonnet-4-6',
    created_at      TIMESTAMP DEFAULT NOW()
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_exercises_user ON exercises(user_id);
CREATE INDEX IF NOT EXISTS idx_exercises_muscle ON exercises(primary_muscle_group);
CREATE INDEX IF NOT EXISTS idx_training_days_program ON training_days(program_id);
CREATE INDEX IF NOT EXISTS idx_training_days_status ON training_days(status);
CREATE INDEX IF NOT EXISTS idx_training_day_exercises_day ON training_day_exercises(training_day_id);
CREATE INDEX IF NOT EXISTS idx_measurements_athlete_date ON measurements(athlete_id, measurement_date);
CREATE INDEX IF NOT EXISTS idx_programs_user_status ON training_programs(user_id, status);
```

---

## SEÇÃO 5 — REGRAS DE NEGÓCIO E COMPORTAMENTOS CRÍTICOS

**RN01 — Ciclo baseado em execução, não em calendário**
Descrição: O ciclo de 16 semanas avança exclusivamente pela conclusão sequencial dos dias de treino (status 'completed' ou 'missed'), nunca por data real do calendário. A "Semana 1" corresponde aos primeiros N dias de treino (onde N = weekly_training_freq), independente de quantos dias corridos isso levou.
Onde se aplica: training_days, Dashboard, Treino do Dia
Exemplo: Se o ciclo tem 64 dias de treino e o atleta leva 20 semanas reais para completar todos, o ciclo é de 16 semanas de treino em 20 semanas de calendário.

**RN02 — Progressão sequencial obrigatória**
Descrição: O atleta só pode executar o próximo dia de treino pendente (ou o que estiver 'in_progress'). Não pode pular para o Dia 30 se o Dia 15 está pendente. A exceção é se o Dia 15 for marcado como "Falta" — aí o Dia 16 se torna disponível.
Onde se aplica: GET /treino/dias/proximo, Treino do Dia

**RN03 — Treino parcial permitido**
Descrição: O atleta pode concluir um treino (marcar como "completed") mesmo que nem todos os exercícios tenham sido marcados. O sistema salva o que foi feito e registra os exercícios não realizados como is_completed = false.
Onde se aplica: PATCH /treino/dias/:id/concluir

**RN04 — Carga editável durante execução**
Descrição: O atleta pode alterar a carga durante a execução. A carga planejada original é preservada (planned_load_kg); a carga efetiva é registrada em actual_load_kg.
Onde se aplica: training_day_exercises

**RN05 — Máximo de 1 medição por dia**
Descrição: Constraint UNIQUE(athlete_id, measurement_date). Se POST retornar violação de unique, retornar 409 com mensagem.
Onde se aplica: POST /resultados/medicoes

**RN06 — Progressão automática de carga no novo ciclo**
Descrição: Ao duplicar com progressão, aplica percentual sobre TODAS as cargas em split_exercise_block_config. Arredondamento: `ROUND(load_kg * (1 + percentual/100.0) * 2) / 2` (múltiplo de 0.5 kg).
Onde se aplica: POST /treino/programas/:id/progressao

**RN07 — Programa ativo único**
Descrição: Somente 1 programa pode ter status 'active' por user_id. Ao criar novo, o anterior recebe status 'completed' ou 'archived'.
Onde se aplica: POST /treino/programas, POST /treino/programas/:id/duplicar

**RN08 — Soft delete universal**
Descrição: Nenhuma entidade é deletada fisicamente. Desativação via is_active ou status.
Onde se aplica: exercises, gyms, training_programs

**RN09 — Dados do atleta na análise IA**
Descrição: POST /analise/gerar deve incluir condições de saúde e restrições corporais no payload enviado à Anthropic API.
Onde se aplica: modules/analise/

**RN10 — Rascunho de treino**
Descrição: O atleta pode salvar progresso parcial (status 'in_progress'). Ao retornar, exercícios já marcados permanecem.
Onde se aplica: PATCH /treino/dias/:id/rascunho

**RN11 — Edição de programa ativo**
Descrição: Alterações em parâmetros só afetam training_days com status 'pending'. Dias com status 'completed' ou 'missed' são imutáveis.
Onde se aplica: PUT /treino/programas/:id

**RN12 — Cálculo automático de IMC**
Descrição: Calculado no frontend: IMC = peso_kg / (altura_m)². Classificação OMS: < 18.5 Abaixo do peso, 18.5-24.9 Normal, 25-29.9 Sobrepeso, 30-34.9 Obesidade I, 35-39.9 Obesidade II, ≥ 40 Obesidade III.
Onde se aplica: Cadastro de Atleta (frontend)

**RN13 — Geração dos dias de treino**
Descrição: Ao salvar programa, o backend gera todos os training_days + training_day_exercises. Para cada semana (1 a total_weeks), identifica o bloco vigente (baseado em start_week/end_week dos blocos), gera N dias (= weekly_training_freq) seguindo a ordem dos splits, e para cada dia gera os training_day_exercises com os parâmetros do bloco vigente (consultando split_exercise_block_config onde is_included = true).
Onde se aplica: POST /treino/programas

**RN14 — CORS configurado para frontend**
Descrição: Flask-CORS deve permitir apenas o domínio do frontend (FRONTEND_URL da env). Credentials habilitado para envio de headers de auth.
Onde se aplica: app.py / create_app()
```python
CORS(app, resources={r"/*": {"origins": os.getenv("FRONTEND_URL")}}, supports_credentials=True)
```

**RN15 — Todos os endpoints protegidos por user_id**
Descrição: Todo SELECT, INSERT e UPDATE deve filtrar por user_id = get_jwt_identity(). Nunca confiar em dados do frontend para identificar o usuário — sempre extrair do JWT.
Onde se aplica: Todos os blueprints

---

## SEÇÃO 6 — FORA DO ESCOPO (NÃO CONSTRUIR NO MVP)

❌ NÃO implementar no MVP:
- Multi-usuário / compartilhamento entre atleta e personal trainer — fase 2
- Notificações push / e-mail automático — fase 2
- Integração com wearables (Apple Watch, Garmin) — fase 2
- Integração com apps de saúde (Apple Health, Google Fit) — fase 2
- Upload de fotos de evolução (before/after) — fase 2
- Exportação para PDF / Excel dos relatórios — fase 2
- Vídeos demonstrativos dos exercícios — fase 2
- Plano alimentar / contagem de macros / calorias — fora do escopo permanente
- Chat com personal trainer — fora do escopo permanente
- Marketplace de programas de treino — fora do escopo permanente
- Sistema de pagamento / assinatura — fase 2
- Internacionalização (i18n) — interface somente em pt-BR
- Integração com academias reais (catraca) — fora do escopo permanente
- Modo offline completo com sync — fase 2 (PWA cache básico apenas)
- ORM (SQLAlchemy/Django ORM) — usa psycopg2 direto com SQL raw

---

## SEÇÃO 7 — INSTRUÇÕES GERAIS AO CONSTRUTOR

- Siga exatamente as telas, fluxos e endpoints descritos. Não adicione telas ou funcionalidades não especificadas.
- Use shadcn/ui para todos os componentes visuais. Não use Material UI, Ant Design ou Chakra.
- Todas as mensagens de interface em Português do Brasil (pt-BR).
- Campos de formulário devem ter validação visual em tempo real (border vermelho + mensagem de erro inline).
- Estados de carregamento obrigatórios (Skeleton do shadcn/ui) em todas as operações de fetch/submit.
- Nenhuma operação destrutiva sem Dialog de confirmação explícita.
- O código frontend deve ser componentizado: componentes em PascalCase, arquivos em kebab-case.
- O código backend deve usar Blueprints modulares: um blueprint por domínio (auth, cadastros, treino, resultados, analise).
- Cores dos blocos de treino consistentes em todo o app:
  - Resistência: azul (blue-500)
  - Hipertrofia: amarelo (yellow-500)
  - Força: vermelho (red-500)
  - Deload: cinza (gray-400)
- Mobile-first: todas as telas devem funcionar perfeitamente em viewport de 375px.
- Implementar PWA: manifest.json, service worker com cache básico, ícones para home screen.
- A ANTHROPIC_API_KEY nunca deve estar no frontend. Somente no backend Flask.
- Todo endpoint (exceto /auth/*) deve ser protegido com @jwt_required().
- Todo acesso ao banco deve filtrar por user_id extraído do JWT via get_jwt_identity().
- Toda tabela deve ter created_at (default NOW()) e updated_at (default NOW()).
- Flask deve rodar com gunicorn em produção (4 workers), nunca com app.run() em produção.
- Se houver dúvida entre duas implementações, escolha a mais simples que ainda cumpre o requisito.
- O schema.sql usa CREATE TABLE IF NOT EXISTS para segurança no redeploy.
- Nunca fazer DELETE físico no banco. Sempre soft delete via is_active ou status.

---

*Cole este Spec Prompt diretamente no chat inicial do Lovable, Bolt, Cursor ou Claude Code. Para iterações futuras, complemente com instruções específicas sobre o que ajustar — não reescreva tudo. Se usar Lovable, divida em 2 etapas: (1) Cadastros + Manutenção de Treino, (2) Execução + Resultados + Análise IA.*