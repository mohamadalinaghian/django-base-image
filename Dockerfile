FROM python:3.12-slim as builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY uv_install_script.sh .
RUN ./uv_install_script.sh


COPY python_pakage.txt .
RUN  uv venv && uv pip install -r python_pakage.txt

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    libffi-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*




# Stage 2: Runtime
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

# فقط پکیج‌های runtime لازم
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libffi7 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# کپی فقط venv نهایی از builder
COPY --from=builder /build/.venv /opt/venv
