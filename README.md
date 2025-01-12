# Distributed Systems Lab Documentation

# How to start the App using Docker

#### Install Docker in your Codespace

## Building and Starting your Containers

#### docker compose up --build

Set Port 8080 to "Public" (CORS Problems)

## Stop and Remove all Containers

#### docker compose down

In the end open the backend port 8080 to "public" in the Port Window.

# How to start with Kubernetes:

Grant privileges to use the script:

#### chmod +x start_kubernetes.sh

Run the starting Script:

##### ./start_kubernetes.sh

To delete the kubernetes config use:

##### kubectl delete all --all -n shopping-app-namespace

To delete the minikube cluster use:

#### minikube delete

# Happy Shopping!