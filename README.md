
# Distributed Systems Lab Documentation

This Application is desired to be used in a GitHub Codespace!

## How to start the App using Docker

### Building and Starting your Containers

Run:
#### docker compose up --build

 To avoid CORS blocking you have to use the open-backend-port Script:

#### chmod +x open-backend-port.sh
#### ./open-backend-port.sh

Stop and Remove all Containers:

#### docker compose down

## How to start with Kubernetes:

Grant privileges to use the script:

 - #### chmod +x kubernetes_starter.sh

 Run the starting Script:

 - #### ./kubernetes_starter.sh

Right after, forward the following ports: (Use in different Terminals)

 - #### kubectl port-forward -n shopping-app-namespace service/backend 8080:8080 
   
 - #### kubectl port-forward -n shopping-app-namespace service/frontend 30081:80


To avoid CORS blocking you have to use the open-backend-port Script:

grant privileges first:
#### chmod +x open-backend-port.sh
 Then run:
#### ./open-backend-port.sh

Checking Pod Health with:

#### kubectl get all -n shopping-app-namespace

To delete the kubernetes config use:

#### kubectl delete all --all -n shopping-app-namespace

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
