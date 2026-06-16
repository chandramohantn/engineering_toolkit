# AI/ML Docker Workspaces

This directory contains a hierarchical set of Docker images optimized for different stages of Machine Learning and AI development.

## Architecture

```text
base-python-dev
    ├── ml-workspace
    ├── dl-workspace-cpu
    ├── dl-workspace-gpu
    └── llm-workspace (built from dl-workspace-cpu by default)
```

## How to Build

You can use the provided `Makefile` for convenient management, or use Docker Compose directly.

### Using Make (Recommended)

To see all available commands:
```bash
make help
```

Common build commands:
```bash
make build-all      # Build everything in order
make build-ml       # Build only the ML workspace
make build-llm      # Build the LLM workspace
```

### Using Docker Compose Directly

To build all images in the correct order:
```bash
docker compose build
```

Alternatively, to build a specific image:
```bash
docker compose build ml-workspace
```

## How to Run

### Using Make

```bash
make up-ml          # Starts ML workspace
make up-llm         # Starts LLM workspace
make down           # Stops all workspaces
```

### Using Docker Run
Each image is configured to start JupyterLab by default on port 8888.

```bash
docker run -p 8888:8888 ml-workspace:latest
```

### GPU Support
To run the GPU-enabled image, ensure you have the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed:

```bash
docker run --gpus all -p 8888:8888 dl-workspace-gpu:latest
```

## Image Descriptions

- **base-python-dev**: Lean foundation with `uv`, JupyterLab, and code quality tools.
- **ml-workspace**: Classical ML (Scikit-learn, XGBoost, Polars, DuckDB).
- **dl-workspace-cpu**: Deep Learning for CPU environments (PyTorch CPU, Transformers).
- **dl-workspace-gpu**: Deep Learning for GPU environments (PyTorch CUDA, NVIDIA tools).
- **llm-workspace**: LLM experimentation (PEFT, TRL, LlamaIndex, LangGraph).
