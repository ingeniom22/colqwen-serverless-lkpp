FROM runpod/pytorch:2.1.1-py3.10-cuda12.1.1-devel-ubuntu22.04


# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    git-lfs \
    poppler-utils \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*



RUN git clone https://huggingface.co/vidore/colqwen2-v1.0-merged /tmp/colqwen2

# RUN ldconfig /usr/local/cuda-12.1/compat/


# Copy binaries
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy application code
COPY . /app

# Set working directory
WORKDIR /app

# Install Python dependencies
RUN uv sync --frozen --no-cache

# RUN uv run src/setup.py

# Start the application
CMD ["uv", "run", "src/main.py"]
