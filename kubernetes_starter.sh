#!/bin/bash

# Beende das Skript bei einem Fehler
set -e

# Funktion zur Anzeige von Statusmeldungen
log() {
  echo -e "\n\033[1;32m$1\033[0m\n"
}

wait_with_progress() {
  local seconds=10  # Anzahl der Sekunden zum Warten

  for ((i=1; i<=seconds; i++)); do
    echo "Wartezeit: $i Sekunde(n)"
    sleep 1
  done
  echo "Wartezeit abgeschlossen!"
}

# 1. Minikube starten
log "[1/10] Starte Minikube..."
minikube start

# 2. Pulle die Docker-Images von Docker Hub
log "[2/10] Pulle Docker-Images von Docker Hub..."
docker pull philthygpt/frontend:latest
docker pull philthygpt/backend:latest
docker pull postgres:latest

# 3. Lade die Docker-Images in Minikube
log "[3/10] Lade Docker-Images in Minikube..."
minikube image load philthygpt/frontend:latest
minikube image load philthygpt/backend:latest
minikube image load postgres:latest

# 4. Namespace erstellen
log "[4/10] Erstelle Namespace..."
kubectl apply -f ./k8s/namespace.yml

# 5. PostgreSQL Deployment und Service erstellen
log "[5/10] Deploye PostgreSQL (Deployment und Service)..."
kubectl apply -f ./k8s/postgresql-deployment.yml
kubectl apply -f ./k8s/postgresql-service.yml

# 6. Backend Deployment und Service erstellen
log "[6/10] Deploye Backend (Deployment und Service)..."
kubectl apply -f ./k8s/backend-deployment.yml
kubectl apply -f ./k8s/backend-service.yml

# 7. Frontend Deployment und Service erstellen
log "[7/10] Deploye Frontend (Deployment und Service)..."
kubectl apply -f ./k8s/frontend-deployment.yml
kubectl apply -f ./k8s/frontend-service.yml

# 8. Warten, bis alle Pods bereit sind (10 Sekunden)
log "[8/10] Warten bis alle Pods bereit sind..."
wait_with_progress
log "Genug gewartet."

# 9. Zeige den Status der Ressourcen im Namespace an
log "[9/10] Zeige Status aller Ressourcen im Namespace 'shopping-app-namespace'..."
kubectl get all -n shopping-app-namespace

#10. Hole die URL des Frontend-Services
log "[10/10] Frontend-URL abrufen..."
minikube service frontend -n shopping-app-namespace --url
