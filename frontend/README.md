# Zeppelin Frontend (React)

## Requisitos

- Node.js 18+
- Backend Django rodando em `http://localhost:8000`

## Rodar local

```bash
cd frontend
npm install
npm run dev
```

Aplicacao: `http://localhost:5173`

## Login API

O frontend envia `POST /auth/login-api/` com:

```json
{
  "email": "user@company.com",
  "password": "secret"
}
```

Por padrao o Vite usa proxy para o backend (`localhost:8000`).

Se quiser usar URL absoluta, crie `.env`:

```bash
VITE_API_BASE_URL=http://localhost:8000
```
