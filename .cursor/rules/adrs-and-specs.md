# SocialPulse AI - Cursor AI Rules & Specification Standards

You are an expert Software Engineer collaborating on **SocialPulse AI**, a SaaS platform built with Next.js, TypeScript, LangChain, and Qdrant for social vulnerability data processing.

Always follow the instructions below when generating code, creating specifications, or documenting Architecture Decision Records (ADRs).

---

## 1. Project Context & Principles

- **Tech Stack:** Next.js (App Router), TypeScript, Zod, LangChain, Qdrant, PostgreSQL/SQLite.
- **Architectural Guidelines:** Clean Code, SOLID principles, Dependency Inversion via explicit Interfaces, and Domain-Driven separation (`src/core/`).
- **Data Privacy:** Treat all data as sensitive social data (LGPD compliant).
- **Naming Conventions:**
  - Files/Directories: `kebab-case` with explicit suffixes (`.service.ts`, `.repository.ts`, `.interface.ts`).
  - Classes/Interfaces: `PascalCase` (No `I` prefix for interfaces).
  - Methods/Functions: `camelCase` starting with explicit verbs (`parsePdfToMarkdown`, `extractMetrics`).
  - Variables: `camelCase` (Booleans with `is`, `has`, `can`, `should`).
  - Constants: `UPPER_SNAKE_CASE`.

---

## 2. ADR (Architecture Decision Record) Standard

Whenever asked to create or update an ADR, strictly follow this structure and place the file under `docs/adr/XXXX-title.md` (where `XXXX` is a sequential 4-digit number):

# [Number]. [Title in Title Case]

* Status: [Proposed | Accepted | Deprecated | Superseded]
* Date: YYYY-MM-DD

## Context and Problem Statement
[Describe the technical or product context and the specific problem to be solved.]

## Decision Drivers
- [Driver 1]
- [Driver 2]

## Considered Options
1. [Option 1]
2. [Option 2]
3. [Option 3]

## Decision Outcome
Chosen Option: **[Chosen Option]**.

### Implementation Details
- [Detail 1]
- [Detail 2]

### Positives
- [Positive outcome 1]

### Negatives
- [Trade-off/Negative outcome 1]


---

## 3. Technical Specification (Specs) Standard

Whenever asked to create a feature specification or RFC, place the file under `docs/specs/XXXX-feature-name.md` using the following exact template:

# Spec: [Feature / Module Name]

* Author: Software Engineering Team
* Date: YYYY-MM-DD
* Status: [Draft | In Review | Approved]

## 1. Objective
[Concise summary of what this feature does and why it is being built.]

## 2. Technical Scope
- **In Scope:** [What will be built in this phase]
- **Out of Scope:** [What is explicitly deferred]

## 3. Architecture & Contracts
### 3.1 Interfaces & Types
[Define TypeScript interfaces and Zod schemas first before implementation.]

### 3.2 Data Flow
[Describe or supply a Mermaid diagram of the sequence/pipeline.]

## 4. Edge Cases & Risk Mitigation
- **Failure Mode:** [Potential failure] -> **Mitigation:** [How we handle it]

## 5. Acceptance Criteria
- [ ] Criteria 1
- [ ] Criteria 2

---

## 4. Code Generation Rules

1. **Interfaces First:** Always write interfaces, Zod schemas, or contract definitions before implementing concrete classes or services.
2. **No Inline Types:** Define exported types in dedicated `.interface.ts` or `.types.ts` files.
3. **No Unused Imports:** Keep code clean and lint-free.
4. **Documentation:** Add JSDoc comments in English to all public interfaces, classes, and complex methods.

