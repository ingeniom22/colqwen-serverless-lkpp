FROM nvidia/cuda:12.1.0-base-ubuntu22.04 


# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    poppler-utils \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*


RUN ldconfig /usr/local/cuda-12.1/compat/

# Copy binaries
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy application code
COPY . /app

# Set working directory
WORKDIR /app

# Install Python dependencies
RUN uv sync --frozen --no-cache

RUN python3 -c "\
from byaldi import RAGMultiModalModel; \
RAGMultiModalModel.from_index('../byaldi/lkpp-multimodal')"

# Start the application
CMD ["uv", "run", "src/main.py"]
