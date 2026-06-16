# Base Python Development Workspace

This workspace provides a lean, optimized Python environment based on `python:3.12-slim`.

## Dependency Management

Dependencies are managed in `pyproject.toml` and categorized into three groups:

1.  **Core Dependencies**: Required for runtime (FastAPI, JupyterLab, Pydantic, etc.).
2.  **Dev Dependencies (`dev`)**: Tools for linting and static analysis (`ruff`, `mypy`, `pre-commit`).
3.  **Test Dependencies (`test`)**: Tools for running tests (`pytest`, `pytest-cov`).

### Installing Optional Dependencies

By default, the Dockerfile only installs the **Core Dependencies** to keep the image size minimal. 

To build an image that includes the development and testing tools, modify the `Dockerfile` in the builder stage:

```dockerfile
# Change this line:
RUN uv pip install .

# To this:
RUN uv pip install ".[dev,test]"
```

## Docker Image Optimizations

The Dockerfile uses several advanced techniques to minimize size and maximize security:
- **Multi-stage builds**: Compilation tools and the `uv` binary are discarded in the final image.
- **Non-root user**: The container runs as `appuser` (UID 1000) for better security.
- **BuildKit Caching**: Uses `--mount=type=cache` for the `uv` cache to speed up subsequent builds.
- **Slim Base**: Uses `python:3.12-slim` as the base image.
- **Healthchecks**: Includes a built-in health check to monitor the JupyterLab service.
