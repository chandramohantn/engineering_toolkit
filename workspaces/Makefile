# Makefile for Engineering Toolkit Workspaces

.PHONY: help build-all build-base build-ml build-dl-cpu build-dl-gpu build-llm up-ml up-dl-cpu up-dl-gpu up-llm down clean

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
	@echo "  make up-ml          - Start the ML workspace (JupyterLab on :8888)"
	@echo "  make up-dl-cpu      - Start the DL CPU workspace (JupyterLab on :8888)"
	@echo "  make up-dl-gpu      - Start the DL GPU workspace (JupyterLab on :8888)"
	@echo "  make up-llm         - Start the LLM workspace (JupyterLab on :8888)"
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
up-ml:
	docker compose up ml-workspace

up-dl-cpu:
	docker compose up dl-workspace-cpu

up-dl-gpu:
	docker compose up dl-workspace-gpu

up-llm:
	docker compose up llm-workspace

down:
	docker compose down

clean:
	docker rmi base-python-dev:latest ml-workspace:latest dl-workspace-cpu:latest dl-workspace-gpu:latest llm-workspace:latest || true
