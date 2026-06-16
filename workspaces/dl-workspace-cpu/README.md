# Deep Learning CPU Workspace

This workspace provides a specialized environment for Deep Learning on CPU, featuring PyTorch, Hugging Face Transformers, and Lightning.

## Dependency Management

Dependencies are managed in `pyproject.toml`. It specifically uses the PyTorch CPU-only index to keep the image size manageable (avoiding multi-gigabyte CUDA binaries).

- **Core Dependencies**: PyTorch (CPU), Transformers, ONNX, and standard data science tools.
- **Extra Dependencies (`extra`)**: Additional tools like `jupyterlab-git`.

### Installing Optional Dependencies

To include extra tools, modify the `Dockerfile`:

```dockerfile
# Change this line:
RUN uv pip install .

# To this:
RUN uv pip install ".[extra]"
```

## Optimizations
- **CPU-Specific Wheels**: Uses `https://download.pytorch.org/whl/cpu` to avoid large GPU binaries.
- **Multi-stage builds**: Discards build-time overhead.
- **Non-root user**: Secure execution environment.
- **Healthchecks**: Built-in monitoring for the Jupyter service.
