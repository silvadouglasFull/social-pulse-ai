# ==============================================================================
# SocialPulse AI - Developer Automation Makefile
# ==============================================================================

.PHONY: help infra-up infra-down infra-stop infra-logs infra-ps infra-restart dev build start lint clean infra-clean storage-status storage-key-create storage-bucket-create storage-bucket-allow storage-init storage-setup
# Load environment variables from .env.local if file exists
ifneq ($(wildcard .env.local),)
    include .env.local
    export
endif

ENV_FILE := .env.local
DOCKER_COMPOSE := docker compose --env-file $(ENV_FILE)
GARAGE_KEY_NAME ?= $(STORAGE_KEY_NAME)

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
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
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
## 📦 GARAGE STORAGE MANAGEMENT
## -----------------------------------------------------------------------------

storage-status: ## Check Garage storage cluster status
	$(DOCKER_COMPOSE) exec garage /garage status

STORAGE_BUCKET_NAME ?= $(BUCKET)

storage-init: ## Initialize Garage node layout (assigns single node and applies layout)
	@echo "⚙️ Initializing Garage layout..."
	@NODE_ID=$$($(DOCKER_COMPOSE) exec garage /garage node id | head -n 1) && \
	if [ -z "$$NODE_ID" ]; then \
		echo "❌ Error: Could not retrieve Garage Node ID."; \
		exit 1; \
	fi; \
	echo "📌 Node ID detected: $$NODE_ID"; \
	$(DOCKER_COMPOSE) exec garage /garage layout assign $$NODE_ID -z dc1 -c 10G && \
	$(DOCKER_COMPOSE) exec garage /garage layout apply --version 1

storage-key-create: ## Create a new Garage API key (uses STORAGE_KEY_NAME from .env.local)
	@if [ -z "$(GARAGE_KEY_NAME)" ]; then \
		echo "❌ Error: GARAGE_KEY_NAME or STORAGE_KEY_NAME is not set in $(ENV_FILE)"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) exec garage /garage key create $(GARAGE_KEY_NAME)

storage-bucket-create: ## Create a Garage bucket (uses STORAGE_BUCKET_NAME from .env.local)
	@if [ -z "$(STORAGE_BUCKET_NAME)" ]; then \
		echo "❌ Error: STORAGE_BUCKET_NAME is not set in $(ENV_FILE) nor passed as BUCKET=..."; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) exec garage /garage bucket create $(STORAGE_BUCKET_NAME)

storage-bucket-allow: ## Allow key read/write permissions on bucket (uses STORAGE_BUCKET_NAME from .env.local)
	@if [ -z "$(STORAGE_BUCKET_NAME)" ] || [ -z "$(GARAGE_KEY_NAME)" ]; then \
		echo "❌ Error: STORAGE_BUCKET_NAME and GARAGE_KEY_NAME/STORAGE_KEY_NAME are required in $(ENV_FILE)."; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) exec garage /garage bucket allow $(STORAGE_BUCKET_NAME) --read --write --key $(GARAGE_KEY_NAME)

storage-setup: storage-init ## Fully setup Garage: init layout, create bucket, key, set permissions, and save keys to .env.local
	@if [ -z "$(GARAGE_KEY_NAME)" ] || [ -z "$(STORAGE_BUCKET_NAME)" ]; then \
		echo "❌ Error: STORAGE_KEY_NAME and STORAGE_BUCKET_NAME must be set in $(ENV_FILE)"; \
		exit 1; \
	fi
	@echo "📦 Creating bucket '$(STORAGE_BUCKET_NAME)'..."
	@$(DOCKER_COMPOSE) exec garage /garage bucket create $(STORAGE_BUCKET_NAME) > /dev/null 2>&1 || true
	@echo "🔑 Generating API Key '$(GARAGE_KEY_NAME)'..."
	@KEY_OUTPUT=$$($(DOCKER_COMPOSE) exec garage /garage key create $(GARAGE_KEY_NAME)) && \
	KEY_ID=$$(echo "$$KEY_OUTPUT" | grep -i "Key ID:" | awk '{print $$3}') && \
	SECRET_KEY=$$(echo "$$KEY_OUTPUT" | grep -i "Secret key:" | awk '{print $$3}') && \
	if [ -z "$$KEY_ID" ] || [ -z "$$SECRET_KEY" ]; then \
		echo "❌ Error: Failed to extract Key ID or Secret Key."; \
		exit 1; \
	fi; \
	echo "🔐 Allowing key permissions on bucket..." && \
	$(DOCKER_COMPOSE) exec garage /garage bucket allow $(STORAGE_BUCKET_NAME) --read --write --key $(GARAGE_KEY_NAME) > /dev/null 2>&1 && \
	echo "📝 Updating $(ENV_FILE) with S3 credentials..." && \
	sed -i '/^S3_ACCESS_KEY_ID=/d' $(ENV_FILE) 2>/dev/null || true; \
	sed -i '/^S3_SECRET_ACCESS_KEY=/d' $(ENV_FILE) 2>/dev/null || true; \
	sed -i '/^S3_BUCKET_NAME=/d' $(ENV_FILE) 2>/dev/null || true; \
	sed -i '/^S3_ENDPOINT=/d' $(ENV_FILE) 2>/dev/null || true; \
	sed -i '/^S3_REGION=/d' $(ENV_FILE) 2>/dev/null || true; \
	echo "" >> $(ENV_FILE); \
	echo "S3_ACCESS_KEY_ID=$$KEY_ID" >> $(ENV_FILE); \
	echo "S3_SECRET_ACCESS_KEY=$$SECRET_KEY" >> $(ENV_FILE); \
	echo "S3_BUCKET_NAME=$(STORAGE_BUCKET_NAME)" >> $(ENV_FILE); \
	echo "S3_ENDPOINT=http://localhost:3900" >> $(ENV_FILE); \
	echo "S3_REGION=garage" >> $(ENV_FILE); \
	echo "✅ Garage storage setup successfully finished! Credentials saved to $(ENV_FILE)."
	
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