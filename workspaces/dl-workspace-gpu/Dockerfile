# syntax=docker/dockerfile:1

# Stage 1: Builder
FROM python:3.12-slim AS builder

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# Install system dependencies needed for building
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml .

# Install dependencies into a virtual environment
# Note: This will install GPU-enabled PyTorch by default.
# onnxruntime-gpu is in the optional [gpu] group to allow builds on ARM64 (Mac).
# To install it on x86_64, use: uv pip install ".[gpu]"
RUN --mount=type=cache,target=/root/.cache/uv \
    uv venv --seed /opt/venv && \
    . /opt/venv/bin/activate && \
    uv pip install .

# Stage 2: Runtime
# We use python-slim but note that for actual GPU acceleration, 
# the host must have NVIDIA drivers and nvidia-container-toolkit installed.
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user with a home directory
RUN useradd -m -u 1000 appuser && \
    mkdir /workspace && \
    chown appuser:appuser /workspace

# Copy virtual environment from builder
COPY --from=builder --chown=appuser:appuser /opt/venv /opt/venv

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER appuser

# Expose JupyterLab port
EXPOSE 8888

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8888/api || exit 1

# Default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=''", "--ServerApp.password=''"]
