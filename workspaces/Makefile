# Makefile for Engineering Toolkit Workspaces

.PHONY: help build-all build-base build-ml build-dl-cpu build-dl-gpu build-llm up-base up-ml up-dl-cpu up-dl-gpu up-llm logs-base logs-ml logs-dl-cpu logs-dl-gpu logs-llm down clean

# Default target
help:
	@echo "Engineering Toolkit - Workspace Management"
	@echo "==========================================="
	@echo "Build Targets:"
	@echo "  make build-all      - Build all images in the correct dependency order"
	@echo "  make build-base     - Build the base Python development image"
	@echo "  make build-ml       - Build the Machine Learning workspace"
	@echo "  make build-dl-cpu   - Build the Deep Learning (CPU) workspace"
	@echo "  make build-dl-gpu   - Build the Deep Learning (GPU) workspace"
	@echo "  make build-llm      - Build the LLM workspace (depends on dl-cpu)"
	@echo ""
	@echo "Run Targets:"
	@echo "  make up-ml          - Start the ML workspace in background"
	@echo "  make up-dl-cpu      - Start the DL CPU workspace in background"
	@echo "  make up-dl-gpu      - Start the DL GPU workspace in background"
	@echo "  make up-llm         - Start the LLM workspace in background"
	@echo "  make logs-ml        - Follow logs for ML workspace"
	@echo "  make logs-dl-cpu    - Follow logs for DL CPU workspace"
	@echo "  make logs-dl-gpu    - Follow logs for DL GPU workspace"
	@echo "  make logs-llm       - Follow logs for LLM workspace"
	@echo "  make down           - Stop all running workspace containers"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean          - Remove all toolkit images"

# Build Targets
build-base:
	docker compose build base-python-dev

build-ml: build-base
	docker compose build ml-workspace

build-dl-cpu: build-base
	docker compose build dl-workspace-cpu

build-dl-gpu: build-base
	docker compose build dl-workspace-gpu

build-llm: build-dl-cpu
	docker compose build llm-workspace

# Sequential build to avoid parallel resolution issues with local images
build-all: 
	@$(MAKE) build-base
	@$(MAKE) build-ml
	@$(MAKE) build-dl-cpu
	@$(MAKE) build-dl-gpu
	@$(MAKE) build-llm

# Run Targets
up-base:
	docker compose up -d base-python-dev

up-ml:
	docker compose up -d ml-workspace

up-dl-cpu:
	docker compose up -d dl-workspace-cpu

up-dl-gpu:
	docker compose up -d dl-workspace-gpu

up-llm:
	docker compose up -d llm-workspace

# Log Targets
logs-base:
	docker compose logs -f base-python-dev

logs-ml:
	docker compose logs -f ml-workspace

logs-dl-cpu:
	docker compose logs -f dl-workspace-cpu

logs-dl-gpu:
	docker compose logs -f dl-workspace-gpu

logs-llm:
	docker compose logs -f llm-workspace

down:
	docker compose down

clean:
	docker rmi base-python-dev:latest ml-workspace:latest dl-workspace-cpu:latest dl-workspace-gpu:latest llm-workspace:latest || true
