# Stage 1: Build
FROM python:3.12-slim As builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && groupadd -g "${GID}" python \
  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" python 


USER python

ENV PYTHONUNBUFFERED="true" \
  PYTHONPATH="." \
  USER="python"

WORKDIR /build

COPY py-pakage.txt .
RUN python -m venv .venv && \
    .venv/bin/pip install --upgrade pip && \
    .venv/bin/pip install --no-cache-dir -r py-pakage.txt

# ----------------------------------------------------------------------

# Stage 2: Runtime
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --from=builder /build/.venv /venv
