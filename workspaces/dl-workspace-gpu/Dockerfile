# Build from the base-python-dev image
FROM base-python-dev:latest

# Set working directory
WORKDIR /workspace

# Copy dependency file
COPY pyproject.toml .

# Install DL (GPU) specific libraries using uv
RUN uv pip install --system .

# Default command remains the same
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
