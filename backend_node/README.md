# projek-mobile backend (minimal)

This is a tiny Node.js Express backend intended for local development and demo.

Quick start:

1. cd backend_node
2. npm install
3. npm run dev (requires nodemon) or npm start

Available endpoints:
- GET /health
- GET /courses
- POST /auth/register { email, password }
- POST /auth/login { email, password }
- GET /me (requires Authorization: Bearer <token>)

Security: this is only for local/testing use. Do not use the default JWT secret in production.
