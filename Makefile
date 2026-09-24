# ==============================================================================
# SocialPulse AI - Developer Automation Makefile
# ==============================================================================

.PHONY: help infra-up infra-down infra-logs infra-ps dev build start clean db-reset

# Load environment variables from .env.local if file exists
ifneq ( $(wildcard .env.local),)
    include .env.local
    export
endif

ENV_FILE := .env.local
DOCKER_COMPOSE := docker compose --env-file $(ENV_FILE)

# Default target when running 'make'
.DEFAULT_GOAL := help

## -----------------------------------------------------------------------------
## ℹ️  HELP & DOCUMENTATION
## -----------------------------------------------------------------------------

help: ## Show available commands and descriptions
	@echo "\n=============================================================================="
	@echo "                   🚀 SocialPulse AI - Development CLI                        "
	@echo "=============================================================================="
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

## -----------------------------------------------------------------------------
## 🐳 INFRASTRUCTURE (DOCKER) MANAGEMENT
## -----------------------------------------------------------------------------

infra-up: ## Start local infrastructure containers (PostgreSQL, Qdrant, Garage)
	@echo "🚀 Starting infrastructure containers..."
	$(DOCKER_COMPOSE) up -d

infra-down: ## Stop local infrastructure containers
	@echo "🛑 Stopping infrastructure containers..."
	$(DOCKER_COMPOSE) down

infra-stop: ## Pause running containers without removing them
	@echo "⏸️ Pausing containers..."
	$(DOCKER_COMPOSE) stop

infra-logs: ## Stream logs from all infrastructure containers
	$(DOCKER_COMPOSE) logs -f

infra-ps: ## Display status of infrastructure containers
	$(DOCKER_COMPOSE) ps

infra-restart: infra-down infra-up ## Restart all infrastructure containers

## -----------------------------------------------------------------------------
## 💻 NEXT.JS APPLICATION WORKFLOWS
## -----------------------------------------------------------------------------

dev: ## Start Next.js application in local development mode
	@echo "🔥 Starting Next.js development server..."
	npm run dev

build: ## Build Next.js application for production
	@echo "📦 Building Next.js production bundle..."
	npm run build

start: ## Run Next.js built production application
	@echo "🟢 Starting production server..."
	npm run start

lint: ## Run Linter to check code standards
	@echo "🔍 Running ESLint..."
	npm run lint

## -----------------------------------------------------------------------------
## 🧹 CLEANUP & UTILITIES
## -----------------------------------------------------------------------------

clean: ## Remove .next build cache, node_modules cache, and temp files
	@echo "🧹 Cleaning application cache..."
	rm -rf .next
	rm -rf node_modules/.cache

infra-clean: ## STOP and DESTROY all containers and persistent volumes (WARNING: Data will be lost)
	@echo "⚠️ Destroying infrastructure and wiping database volumes..."
	$(DOCKER_COMPOSE) down -v