# Booking App

A general-purpose booking application with user/admin roles, built as a practice
app for DevOps/GitOps platform projects. Kept intentionally simple so the focus
stays on the platform (Terraform, EKS, ArgoCD, CI/CD, Observability) rather than
the application itself.

## Stack

| Layer    | Technology                     |
|----------|---------------------------------|
| Frontend | React (Vite)                    |
| Backend  | Node.js + Express                |
| Database | PostgreSQL                       |
| Auth     | JWT with role-based middleware   |

## Features

- User registration/login (JWT)
- Users browse available items and submit booking requests
- Users can view and cancel their own pending bookings
- Admins can view all bookings, filter by status, and approve/reject
- Admins can manage (create/activate/deactivate) bookable items
- `/healthz` (liveness) and `/readyz` (readiness) endpoints for k8s probes

## Project layout

```
booking-app/
├── backend/
│   ├── src/
│   │   ├── config/db.js        # PostgreSQL pool
│   │   ├── db/schema.sql       # Schema (idempotent, CREATE TABLE IF NOT EXISTS)
│   │   ├── db/migrate.js       # Runs schema.sql (useful for a Helm pre-install Job)
│   │   ├── db/seed.js          # Seeds a default admin user
│   │   ├── middleware/auth.js  # JWT auth + role guard
│   │   ├── routes/auth.js
│   │   ├── routes/items.js
│   │   ├── routes/bookings.js
│   │   └── server.js
│   ├── Dockerfile
│   └── .env.example
├── frontend/
│   ├── src/
│   │   ├── api/client.js
│   │   ├── context/AuthContext.jsx
│   │   ├── components/ProtectedRoute.jsx
│   │   └── pages/{Login,Register,UserDashboard,AdminDashboard}.jsx
│   ├── Dockerfile
│   ├── nginx.conf
│   └── .env.example
└── docker-compose.yml
```

## Running locally

```bash
docker compose up --build
```

Then, run the database migration and seed an admin user (one-time):

```bash
docker compose exec backend node src/db/migrate.js
docker compose exec backend node src/db/seed.js
```

Default admin credentials (override via `SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD`
env vars before seeding):

- Email: `admin@example.com`
- Password: `Admin@123`

Frontend: http://localhost:5173
Backend API: http://localhost:4000/api

## API summary

| Method | Path                       | Auth        | Description                     |
|--------|----------------------------|-------------|----------------------------------|
| POST   | /api/auth/register         | Public      | Register a new user              |
| POST   | /api/auth/login            | Public      | Login, returns JWT                |
| GET    | /api/auth/me               | User        | Current user profile              |
| GET    | /api/items                 | User        | List active items                 |
| GET    | /api/items/all              | Admin       | List all items (incl. inactive)   |
| POST   | /api/items                 | Admin       | Create item                       |
| PATCH  | /api/items/:id              | Admin       | Update item                       |
| DELETE | /api/items/:id              | Admin       | Delete item                       |
| POST   | /api/bookings               | User        | Create a booking request          |
| GET    | /api/bookings/mine           | User        | List own bookings                 |
| PATCH  | /api/bookings/:id/cancel     | User        | Cancel own pending booking        |
| GET    | /api/bookings                | Admin       | List all bookings (?status=)      |
| PATCH  | /api/bookings/:id/status      | Admin       | Approve or reject a booking       |
| GET    | /healthz                    | Public      | Liveness probe                    |
| GET    | /readyz                     | Public      | Readiness probe (checks DB)       |

## Notes for the GitOps/CI-CD platform project

- `src/db/migrate.js` is idempotent (`CREATE TABLE IF NOT EXISTS`) — suitable as
  a Helm pre-install/pre-upgrade Job, same pattern used in the previous project.
- `/healthz` and `/readyz` are separated intentionally so liveness and readiness
  probes in Kubernetes can be configured independently.
- Both Dockerfiles use multi-stage builds to keep final images small.
- No business logic complexity beyond Auth + Roles + one-to-many relations —
  this keeps the app "swappable" so the platform itself stays the focus.
