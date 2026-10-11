FROM python:3.12-slim-bookworm
WORKDIR /app
COPY app/ ./app/
COPY config/app.conf ./config/app.conf
RUN python -m compileall -q app && useradd --create-home --uid 10001 labuser
ENV PYTHONUNBUFFERED=1 PYTHONDONTWRITEBYTECODE=1 APP_HOST=0.0.0.0 APP_PORT=8080
LABEL lab.owner="sarsembayev-eldar-devops" lab.student_id="37006"
USER labuser
EXPOSE 8080
HEALTHCHECK --interval=3s --timeout=2s --start-period=5s --retries=5 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health', timeout=1)"
CMD ["python", "-m", "app.main"]

