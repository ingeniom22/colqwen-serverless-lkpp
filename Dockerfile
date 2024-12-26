FROM runpod/base:0.4.0-cuda11.8.0

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY . /app

# Python dependencies
WORKDIR /app
RUN uv sync --frozen --no-cache

CMD python3.11 -u src/main.py