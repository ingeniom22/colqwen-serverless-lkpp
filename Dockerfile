FROM nvidia/cuda:12.1.0-base-ubuntu22.04 

# Install dependencies
RUN apt-get update && \
    apt-get install -y poppler-utils && \
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

# Environment variables
ENV MODEL_NAME="vidore/colqwen2-v1.0" \
    MODEL_REVISION=$MODEL_REVISION \
    TOKENIZER_NAME=$TOKENIZER_NAME \
    TOKENIZER_REVISION=$TOKENIZER_REVISION \
    BASE_PATH=$BASE_PATH \
    QUANTIZATION=$QUANTIZATION \
    HF_DATASETS_CACHE="${BASE_PATH}/huggingface-cache/datasets" \
    HUGGINGFACE_HUB_CACHE="${BASE_PATH}/huggingface-cache/hub" \
    HF_HOME="${BASE_PATH}/huggingface-cache/hub" \
    HF_HUB_ENABLE_HF_TRANSFER=1 


# Handle optional HF_TOKEN and download model
RUN --mount=type=secret,id=HF_TOKEN,required=false \
    if [ -f /run/secrets/HF_TOKEN ]; then \
        HF_TOKEN=$(cat /run/secrets/HF_TOKEN); \
    fi && \
    python3 /src/download_model.py "$MODEL_NAME" "$HF_TOKEN"

# Start the application
CMD ["python3", "-u", "src/main.py"]
