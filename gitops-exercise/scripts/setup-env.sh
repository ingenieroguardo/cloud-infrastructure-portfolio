#!/bin/bash

# Script de automatización de entorno para GitOps Exercise
# Uso: chmod +x setup-env.sh && ./setup-env.sh

set -e # Detener el script si algo falla

echo "--- Iniciando configuración del entorno (Minikube + ArgoCD) ---"

# 1. Iniciar Minikube
echo "Iniciando Minikube..."
minikube start --driver=docker

# 2. Habilitar Ingress Controller
echo "Habilitando Nginx Ingress..."
minikube addons enable ingress

# 3. Crear Namespace para ArgoCD
echo "Creando namespace argocd..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# 3.5. Crear Namespace para Observabilidad
echo "Creando namespace monitoring..."
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# 4. Instalar ArgoCD (versión estable)
echo "Instalando ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 5. Esperar a que los pods de ArgoCD estén listos
echo "Esperando a que ArgoCD esté operativo (esto puede tomar un minuto)..."
kubectl rollout status deployment/argocd-server -n argocd

echo "--- Entorno listo ---"
echo "Para acceder a ArgoCD, ejecuta: minikube service argocd-server -n argocd"
echo "O usa port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443"