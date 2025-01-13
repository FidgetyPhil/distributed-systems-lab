# Distributed Systems Lab Documentation

# How to start the App using Docker

#### Install Docker in your Codespace

## Building and Starting your Containers

#### docker compose up --build

Set Port 8080 to "Public" (CORS Problems)

## Stop and Remove all Containers

#### docker compose down

# How to start with Kubernetes:

Grant privileges to use the script:

#### chmod +x start_kubernetes.sh

Run the starting Script:

##### ./kubernetes_starter.sh

## Checking Pod Health with:

#### kubectl get all -n shopping-app-namespace

To delete the kubernetes config use:

##### kubectl delete all --all -n shopping-app-namespace

To delete the minikube cluster use:

#### minikube delete

## Database connection and Commands

To connect to the database use:
### docker exec -it shoppingdb-container psql -U hse24 -d shoppingdb

To list tables use:
### /dt

To end the database connection use:
### \q

## Happy Shopping!