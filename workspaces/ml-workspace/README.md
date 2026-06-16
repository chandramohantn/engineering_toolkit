# ML Development Workspace

This workspace provides a comprehensive environment for classical Machine Learning, including NumPy, Pandas, Scikit-Learn, and XGBoost.

## Dependency Management

Dependencies are managed in `pyproject.toml`.

- **Core Dependencies**: Scientific and ML libraries.
- **Extra Dependencies (`extra`)**: Additional Jupyter extensions like `jupyterlab-git`.

### Installing Optional Dependencies

To include extra tools, modify the `Dockerfile`:

```dockerfile
# Change this line:
RUN uv pip install .

# To this:
RUN uv pip install ".[extra]"
```

## Optimizations
- **Multi-stage builds**: Reduces image size by discarding build tools.
- **Non-root user**: Runs as `appuser` for security.
- **Persistence**: Optimized for use with volumes mounted at `/workspace`.
