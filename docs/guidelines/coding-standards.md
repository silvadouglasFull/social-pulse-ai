# SocialPulse AI - Coding Standards & Architectural Guidelines

This document outlines the coding standards, naming conventions, and architectural principles for the **SocialPulse AI** codebase. Adhering to these rules ensures readability, maintainability, and consistency across the entire project.

---

## 📐 Core Principles

1. **Clean Code:** Code must be self-explanatory, concise, and focused on readability.
2. **SOLID Principles:** Strict adherence to Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion.
3. **Explicit Contracts:** Interfaces and types must be defined before creating concrete implementations.
4. **Immutability:** Prefer `const` over `let`. Avoid mutating objects; return new instances instead.

---

## 🏷 Naming Conventions

### 1. Files & Directories

- **Pattern:** `kebab-case` with explicit architectural suffixes.
- **Suffixes:** `.service.ts`, `.controller.ts`, `.interface.ts`, `.dto.ts`, `.repository.ts`, `.use-case.ts`.
- **Examples:**
  - `pdf-parser.service.ts`
  - `family-data.repository.ts`
  - `ingest-document.use-case.ts`
  - `document-metadata.interface.ts`


### 2. Classes, Interfaces & Enums

- **Pattern:** `PascalCase`.
- **Classes:** Nouns in singular representing responsibility. (e.g., `DocumentIngestionService`, `FamilyRepository`).
- **Interfaces:** `PascalCase` without `I` prefix. (e.g., `DocumentParser`, `VectorStorageProvider`).
- **Enums:** `PascalCase` for both the enum name and its keys.
  ```typescript
  export enum VulnerabilityLevel {
    Low = 'LOW',
    Medium = 'MEDIUM',
    High = 'HIGH',
    Critical = 'CRITICAL',
  }
  ```

### 3. Methods & Functions

- **Pattern:** `camelCase`.
- **Rule:** Must begin with an explicit verb describing the exact action performed.
- **Examples:**
- `parsePdfToMarkdown(file: Express.Multer.File): Promise<string>`
- `extractMetricsViaLlm(documentText: string): Promise<FamilyMetricsDto>`
- `saveVectorEmbeddings(chunks: DocumentChunk[]): Promise<void>`
- `findByFamilyId(familyId: string): Promise<FamilyEntity | null>`



### 4. Variables & Properties

- **Pattern:** `camelCase`.
- **Booleans:** Must start with auxiliary verbs (`is`, `has`, `should`, `can`). (e.g., `isValidDocument`, `hasChildren`).
- **Arrays/Collections:** Use plural nouns. (e.g., `familyMembers`, `documentChunks`).



### 5. Constants & Configuration

- **Pattern:** `UPPER_SNAKE_CASE`.
- **Rule:** Reserved for global immutable values known at compile-time or config keys.
- **Examples:**
- `MAX_FILE_SIZE_BYTES = 10485760`
- `DEFAULT_CHUNK_SIZE = 1000`
- `QDRANT_COLLECTION_NAME = 'social_pulse_families'`

---



## 🛠 Summary Reference Table


| Artifact                 | Pattern            | Example                              |
| ------------------------ | ------------------ | ------------------------------------ |
| **Files / Folders**      | `kebab-case`       | `pdf-parser.service.ts`              |
| **Classes / Interfaces** | `PascalCase`       | `PdfParserService`, `DocumentParser` |
| **Methods / Functions**  | `camelCase` (verb) | `extractMetrics()`, `saveVector()`   |
| **Variables**            | `camelCase`        | `familyCount`, `isValid`             |
| **Global Constants**     | `UPPER_SNAKE_CASE` | `MAX_CHUNK_OVERLAP`                  |
| **Enums (Name / Keys)**  | `PascalCase`       | `RiskLevel.Critical`                 |


---



## 🧩 Dependency Injection Tokens

To enforce the Dependency Inversion Principle in NestJS, use explicit `Symbols` for injection tokens instead of concrete classes:

```typescript
export const INGESTION_TOKENS = {
  DOCUMENT_PARSER: Symbol('DOCUMENT_PARSER'),
  VECTOR_STORAGE: Symbol('VECTOR_STORAGE'),
  FAMILY_REPOSITORY: Symbol('FAMILY_REPOSITORY'),
} as const;
```

