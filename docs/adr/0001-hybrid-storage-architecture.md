# 1. Hybrid Storage Architecture for Dual-Persistence Data Ingestion

* Status: Accepted
* Date: 2026-09-24

## Context and Problem Statement

The **SocialPulse AI** platform ingests unstructured documents (PDFs, Word files, spreadsheets, images, and raw text) regarding vulnerable families and individuals. The data contains both **narrative contextual descriptions** (e.g., family background, qualitative social worker observations) and **structured metrics/entities** (e.g., family member count, income, vulnerability level).

Querying unstructured data with pure vector search (Semantic Search) often fails on exact numeric or categorical aggregations (e.g., "Count how many families have a monthly income below $200"). Conversely, storing everything in a relational database destroys the qualitative nuances necessary for humanized RAG conversational agents.

## Decision Drivers

- Need for high accuracy in both qualitative narratives and quantitative analytics.
- Ability to generate structured reports and charts alongside conversational answers.
- Compliance readiness (filtering/deleting specific family IDs for LGPD data subject requests).

## Considered Options

1. **Pure Vector DB:** Storing all document chunks and metadata only in Qdrant.
2. **Pure Relational DB:** Parsing documents into relational tables entirely.
3. **Hybrid Storage (Dual-Persistence):** Separating extracted structured entities into a Relational DB (SQL) and chunked narrative embeddings into a Vector DB (Qdrant).

## Decision Outcome

Chosen Option: **Option 3 (Hybrid Storage / Dual-Persistence)**.

### System Flow
1. Incoming documents are normalized to unified Markdown format.
2. An LLM-driven structured extraction step parses deterministic entities/metrics into a **Relational DB (SQL)** using strict Zod schemas and tools.
3. Simultaneously, the document is semantically chunked and stored with embeddings and foreign key metadata in **Qdrant (Vector DB)**.

### Positives
- Enables precise numeric/categorical filtering via SQL.
- Preserves full qualitative text context in Qdrant for humanized RAG queries.
- Facilitates granular access control (RBAC) and individual data removal (LGPD compliance).

### Negatives
- Increases pipeline complexity by requiring synchronization between two storage layers.
- Requires two LLM calls per document (one for structured entity extraction, one for vector embeddings/indexing).