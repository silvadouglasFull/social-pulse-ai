# Spec: Task Automation & CLI Shortcuts

* Author: Software Engineering Team
* Date: 2026-09-24
* Status: Approved

## 1. Objective
Provide a clean CLI interface using a `Makefile` to streamline local environment setup, container orchestration, Next.js application execution, and database maintenance.

## 2. Technical Scope
- **Environment Integration:** Sourcing environment variables directly from `.env.local`.
- **Infrastructure Targets:** Commands to start, stop, restart, and inspect Docker containers.
- **Application Targets:** Shortcuts for Next.js development server, production builds, and linter/formatter.
- **Data Hygiene Targets:** Commands to reset volumes and clear local cache safely.

## 3. Acceptance Criteria
- [ ] Executing `make help` displays a formatted list of all available commands with descriptions.
- [ ] Executing `make infra-up` starts all Docker services using `.env.local`.
- [ ] Executing `make dev` starts the Next.js development server locally.