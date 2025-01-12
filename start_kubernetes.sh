#!/bin/bash

# Beende das Skript bei einem Fehler
set -e

# Funktion zur Anzeige von Statusmeldungen
log() {
  echo -e "\n\033[1;32m$1\033[0m\n"
}

# Funktion, um auf bereitgestellte Pods zu warten
wait_for_pods_with_timeout() {
  log "Warte 10 Sekunden, bis Pods laufen..."
  sleep 10
  log "Warten abgeschlossen."
}

# 1. Minikube starten
log "Starte Minikube..."
minikube start

# 2. Pulle die Docker-Images von Docker Hub
log "Pulle Docker-Images von Docker Hub..."
docker pull philthygpt/frontend:latest
docker pull philthygpt/backend:latest
docker pull postgres:latest

# 3. Lade die Docker-Images in Minikube
log "Lade Docker-Images in Minikube..."
minikube image load philthygpt/frontend:latest
minikube image load philthygpt/backend:latest
minikube image load postgres:latest

# 4. Namespace erstellen
log "Erstelle Namespace..."
kubectl apply -f ./k8s/namespace.yml

# 5. PostgreSQL Deployment und Service erstellen
log "Deploye PostgreSQL (Deployment und Service)..."
kubectl apply -f ./k8s/postgresql-deployment.yml
kubectl apply -f ./k8s/postgresql-service.yml

# 6. Backend Deployment und Service erstellen
log "Deploye Backend (Deployment und Service)..."
kubectl apply -f ./k8s/backend-deployment.yml
kubectl apply -f ./k8s/backend-service.yml

# 7. Frontend Deployment und Service erstellen
log "Deploye Frontend (Deployment und Service)..."
kubectl apply -f ./k8s/frontend-deployment.yml
kubectl apply -f ./k8s/frontend-service.yml

# 8. Warten, bis alle Pods bereit sind (10 Sekunden)
wait_for_pods_with_timeout

# 9. Zeige den Status der Ressourcen im Namespace an
log "Zeige Status aller Ressourcen im Namespace 'shopping-app-namespace'..."
kubectl get all -n shopping-app-namespace

# 10. Hole die URL des Frontend-Services
log "Frontend-URL abrufen..."
minikube service frontend -n shopping-app-namespace --url
