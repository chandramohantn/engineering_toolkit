# This can be built from either dl-workspace-cpu or dl-workspace-gpu
ARG BASE_IMAGE=dl-workspace-cpu:latest
FROM ${BASE_IMAGE}

# Set working directory
WORKDIR /workspace

# Copy dependency file
COPY pyproject.toml .

# Install LLM specific libraries
RUN uv pip install --system .

# Default command remains the same
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
