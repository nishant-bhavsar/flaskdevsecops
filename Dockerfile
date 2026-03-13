# ──────────────────────────────────────────────
# Stage 1 – Builder
# ──────────────────────────────────────────────
FROM python:3.12-alpine AS builder

WORKDIR /build

# Install build deps needed to compile C-extension wheels
RUN apk add --no-cache gcc musl-dev libffi-dev

COPY requirements.txt .
RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# ──────────────────────────────────────────────
# Stage 2 – Runtime (minimal Alpine)
# ──────────────────────────────────────────────
FROM python:3.12-alpine AS runtime

LABEL maintainer="nishantbhvsr@gmail.com"
LABEL org.opencontainers.image.source="https://github.com/nishant-bhavsar/flaskdevsecops"

# Prevent .pyc files & ensure logs flush immediately
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Security: run as non-root
RUN addgroup -S appuser && adduser -S -G appuser -h /app -s /sbin/nologin appuser

WORKDIR /app

# Copy virtualenv from builder (no build toolchain in runtime)
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy application code
COPY app.py .

# Drop privileges
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget --spider --quiet http://localhost:5000/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--access-logfile", "-", "app:app"]
