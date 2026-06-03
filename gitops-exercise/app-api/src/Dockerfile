FROM python:3.9-slim
WORKDIR /app
COPY gitops-exercise/app-api/src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY gitops-exercise/app-api/src/ .
CMD ["python", "app.py"]