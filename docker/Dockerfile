FROM python:3.13-alpine AS builder

WORKDIR /build

COPY app/requirements.txt .

RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir \
       -r requirements.txt \
    && /opt/venv/bin/python -m pip uninstall -y pip


FROM python:3.13-alpine AS runtime

ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
COPY app/ .

RUN adduser -D -u 10001 obbygate \
    && rm -rf /usr/local/lib/python3.13/site-packages/pip \
              /usr/local/lib/python3.13/site-packages/pip-*.dist-info

USER 10001

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health')"

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]