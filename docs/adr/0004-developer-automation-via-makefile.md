# 4. Developer Automation via Makefile

* Status: Accepted
* Date: 2026-09-24

## Context and Problem Statement

To maintain developer productivity and prevent command misspelling during local development of **SocialPulse AI**, we need a unified, zero-dependency task runner interface. Executing long commands like `docker compose --env-file .env.local up -d` or running database migrations repeatedly introduces unnecessary friction.

## Decision Drivers

- Standardize local development workflows for all team members.
- Simplify lifecycle management of containerized services (PostgreSQL, Qdrant, Garage).
- Native execution on Unix-like systems (Linux/macOS) and WSL2 without requiring additional CLI tools.

## Decision Outcome

Chosen Option: **Makefile (GNU Make)**.

### Positives
- Native to Linux/macOS and requires zero additional package installations.
- Automatically handles `.env.local` variable sourcing for CLI commands.
- Provides short, memorable aliases (`make infra-up`, `make dev`, `make clean`).

### Negatives
- Windows developers must use WSL2 or Git Bash/Chocolatey to run `make`.    