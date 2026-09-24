# Spec: Local Infrastructure & Service Services

* Author: Software Engineering Team
* Date: YYYY-MM-DD
* Status: Approved

## 1. Objective
Provide a unified, single-command containerized infrastructure stack for **SocialPulse AI** using Docker Compose.

## 2. Technical Scope
- **In Scope:**
  - **PostgreSQL 16:** Relational database for structured entity and metric storage.
  - **Qdrant (latest):** Vector database for document embeddings and semantic search.
  - **Garage (v1.x):** S3-compatible object storage for original uploaded files.
  - Explicit configuration sourcing from `.env.local`.
- **Out of Scope:**
  - Containerizing the Next.js/Node.js application (runs natively on host for hot-reloading).

## 3. Architecture & Port Mapping

| Service | Container Name | Host Port | Container Port | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **PostgreSQL** | `socialpulse-db` | `5432` | `5432` | Structured Family Metrics |
| **Qdrant** | `socialpulse-qdrant` | `6333` / `6334` | `6333` / `6334` | Vector Embeddings & Payload |
| **Garage** | `socialpulse-storage` | `3900` (S3) / `3902` (Admin) | `3900` / `3902` | Raw File Object Storage |

## 4. Environment Variables Contract (`.env.local`)
The following environment variables must be defined in `.env.local` on the host machine:

```env
# PostgreSQL Configuration
POSTGRES_USER=socialpulse_user
POSTGRES_PASSWORD=socialpulse_password
POSTGRES_DB=socialpulse_db
POSTGRES_PORT=5432

# Qdrant Configuration
QDRANT_PORT=6333
QDRANT_GRPC_PORT=6334

# Garage S3 Configuration
GARAGE_S3_PORT=3900
GARAGE_RPC_PORT=3901
GARAGE_ADMIN_PORT=3902
```

## 5. Acceptance Criteria
[ ] Running docker compose --env-file .env.local up -d starts all 3 services without errors.

[ ] PostgreSQL accepts connections on port 5432 using credentials from .env.local.

[ ] Qdrant web dashboard/REST API is accessible at http://localhost:6333.

[ ] Garage S3 API endpoint is accessible at http://localhost:3900.

[ ] Volumes persist data across container restarts.