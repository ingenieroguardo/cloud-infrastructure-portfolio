FROM python:3.9-slim
WORKDIR /app
COPY gitops-exercise/app-frontend/src/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY gitops-exercise/app-frontend/src/ .
EXPOSE 5000
CMD ["python", "app.py"]