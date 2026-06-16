# LLM Experimentation Workspace

This workspace is designed for experimenting with Large Language Models, Fine-tuning, and RAG (Retrieval-Augmented Generation).

## Dependency Management

Dependencies are managed in `pyproject.toml`.

- **Core Dependencies**: `trl`, `peft`, `langgraph`, `llama-index`, and Vector DB clients.
- **Evaluation Dependencies (`eval`)**: Tools for LLM evaluation like `ragas` and `deepeval`.
- **Extra Dependencies (`extra`)**: Additional tools like `jupyterlab-git`.

### Installing Optional Dependencies

To include evaluation or extra tools, modify the `Dockerfile`:

```dockerfile
# Change this line:
RUN uv pip install .

# To this (for everything):
RUN uv pip install ".[eval,extra]"
```

## Optimizations
- **Multi-stage builds**: Keeps the runtime image clean of build tools.
- **Non-root user**: Secure execution by default.
- **Caching**: Uses `uv` cache mounts for faster dependency updates.
