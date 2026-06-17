# Deep Learning GPU Workspace

This workspace provides a high-performance environment for Deep Learning using NVIDIA GPUs, featuring PyTorch (GPU), Transformers, and ONNX Runtime GPU.

## Dependency Management

Dependencies are managed in `pyproject.toml`.

- **Core Dependencies**: PyTorch (GPU), Transformers, NVIDIA management tools (`pynvml`), and standard data science tools.
- **GPU Extensions (`gpu`)**: `onnxruntime-gpu` (kept optional to support ARM64 builds).
- **Extra Dependencies (`extra`)**: Additional tools like `jupyterlab-git`.

### Installing Optional Dependencies

To include extra tools or GPU-specific runtimes, modify the `Dockerfile`:

```dockerfile
# Change this line:
RUN uv pip install .

# To this (on compatible x86_64 NVIDIA systems):
RUN uv pip install ".[gpu,extra]"
```

> **Note on ARM64 (Apple Silicon):** `onnxruntime-gpu` is currently unavailable for Linux ARM64 on PyPI for Python 3.12. It is moved to an optional group so the image can still be built on Macs for development purposes.

## Optimizations
- **Multi-stage builds**: Minimizes image size while keeping heavy GPU binaries.
- **Non-root user**: Secure execution environment.
- **Healthchecks**: Built-in monitoring for the Jupyter service.

## Prerequisites
To use GPU acceleration, you must have:
1. NVIDIA Drivers installed on the host.
2. [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) installed and configured.
3. Run the container with the `--gpus all` flag.
