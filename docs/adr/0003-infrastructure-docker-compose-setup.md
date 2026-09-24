# 3. Infrastructure & Local Development Setup via Docker Compose

* Status: Accepted
* Date: 2026-09-24

## Context and Problem Statement

The **SocialPulse AI** platform requires three local infrastructure dependencies to run the ingestion and RAG pipeline during development and demonstration (POC):
1. A Relational Database to store structured family metrics and entities.
2. A Vector Database to store and query narrative text embeddings.
3. An S3-compatible Object Storage service to store original uploaded files (PDFs, Word documents, images).

We need a lightweight, reproducible containerized setup managed locally without adding Node.js/Next.js into Docker, allowing fast hot-reload during application development while isolating database dependencies.

## Decision Drivers

- Fast container initialization and minimal memory footprint.
- S3 compatibility for storing raw document uploads securely.
- Explicit environment variable configuration bound to `.env.local`.
- Zero friction for local developer setup.

## Considered Options

1. **Local Native Install:** Installing PostgreSQL, Qdrant, and Object Storage natively on the host machine.
2. **Docker Compose Stack (PostgreSQL + Qdrant + Garage):** Containerizing external services while running Next.js natively on the host.
3. **Docker Compose Stack (SeaweedFS / MinIO instead of Garage):** Using heavier or multi-component object storage solutions.

## Decision Outcome

Chosen Option: **Option 2 (Docker Compose with PostgreSQL, Qdrant, and Garage)**.

### Positives
- **Garage S3:** Exceptionally lightweight (single small binary) with fast setup and low CPU/RAM overhead compared to MinIO or SeaweedFS.
- **Data Persistence:** Managed via explicit named volumes (`postgres_data`, `qdrant_data`, `garage_data`).
- **Environment Isolation:** Database credentials strictly sourced from `.env.local`.

### Negatives
- Requires Docker Engine / Docker Desktop installed on the developer machine.