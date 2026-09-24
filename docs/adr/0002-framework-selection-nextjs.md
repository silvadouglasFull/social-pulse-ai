
# 2. Framework Selection: Next.js (TypeScript) & Project Structure

* Status: Accepted
* Date: 2026-09-24

## Context and Problem Statement

For the **SocialPulse AI** project, we need a robust, scalable backend environment capable of running the LangChain ecosystem, handling multi-format file uploads, serving API endpoints, and displaying a humanized chat interface for demonstration to stakeholders in a short development window (POC).

We previously considered NestJS, but shifted focus to optimize for developer velocity, fullstack cohesion, and UI integration without sacrificing Domain-Driven Design (DDD) and Clean Architecture principles.

## Decision Drivers

- Core developer expertise in Next.js (7+ years of software engineering experience).
- Rapid delivery requirement for the initial Proof of Concept (POC).
- Need to serve both API endpoints (Route Handlers) and an interactive dashboard/chat frontend in a single repository.
- Native TypeScript support and seamless compatibility with `@langchain/core`.
- Maintainability through strict domain separation, isolating business logic from framework-specific routing.

## Considered Options

1. **NestJS (Node.js):** Enterprise backend-only framework using controllers and decorators.
2. **Next.js (App Router / TypeScript) with Modular Architecture:** Fullstack React/Node.js framework using Route Handlers for API endpoints and a decoupled `src/modules` directory for core domain logic.
3. **Fastify / Express standalone:** Lightweight Node.js API server.

## Decision Outcome

Chosen Option: **Option 2 (Next.js with Modular Domain-Driven Architecture)**.

### Architectural & Directory Design
The project structure cleanly separates web routing concerns (`src/app`) from pure business logic (`src/modules`):

```bash
src/
├── app/                        # Next.js App Router (Web Layer)
│   ├── (dashboard)/            # React UI Components & Pages
│   └── api/                    # Route Handlers (HTTP Endpoints)
│       ├── ingest/route.ts     # Ingestion HTTP Entry Point
│       └── chat/route.ts       # RAG Chat HTTP Entry Point (Streaming)
│
├── modules/                    # Business Domain Core (Framework Agnostic)
│   ├── ingestion/              # Ingestion Services, Use Cases & Parsers
│   ├── storage/                # Repositories (SQL & Qdrant) & Zod Schemas
│   └── agent/                  # LangChain Tools, RAG Prompts & Orchestration
│
└── shared/                     # Cross-Cutting Concerns
    ├── components/             # Reusable UI Components
    ├── config/                 # Environment Variables & Global Constants
    └── types/                  # Global Utility Types & Interfaces

```

### Key Implementation Guidelines

* **Route Handlers as Thin Controllers:** Files in `src/app/api/*/route.ts` only parse HTTP requests, invoke domain Use Cases from `src/modules`, and return JSON or streaming responses.
* **Use Cases over Controllers:** Business workflows are encapsulated in dedicated Use Case classes (e.g., `IngestDocumentUseCase`).
* **Framework Independence:** Logic inside `src/modules/` must remain independent of Next.js HTTP primitives, allowing it to be reused in CLI scripts, background workers, or ported to another framework if necessary.

### Positives

* Extremely high development velocity and zero cross-origin (CORS) friction during local demos.
* High architectural cohesion: Domain logic is clean, testable, and isolated from Next.js web APIs.
* Simplifies real-time streaming responses (Server-Sent Events) from the AI Agent directly to the React UI.

### Negatives

* Serverless execution timeouts on standard deployment platforms (mitigated by configuring long-running execution limits or node runtime handlers for ingestion endpoints).

```

---

Com a **ADR 0002** atualizada, a arquitetura do projeto está completamente alinhada e pronta.

Podemos seguir para a criação do **Schema da Família em Zod (`src/modules/storage/schemas/family.schema.ts`)** para garantir que a extração estruturada do LLM para o banco SQL seja 100% precisa?
