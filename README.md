
# Distributed Systems Lab Documentation

This Application is desired to be used in a GitHub Codespace!

## Technologies used

 - GO
 - Dart
 - Docker
 - Kubernetes (with Minikube)

## How to start the App using Docker

### Building and Starting your Containers

Run:
```` 
docker compose up --build
````
 To avoid CORS blocking you have to use the open-backend-port Script:

````
chmod +x open-backend-port.sh
````
````
./open-backend-port.sh
````

Stop and Remove all Containers:

#### docker compose down

## How to start with Kubernetes:

Grant privileges to use the script:

````
chmod +x kubernetes_starter.sh
````
 Run the starting Script:

````
./kubernetes_starter.sh
````
Right after, forward the following ports: (Use in different Terminals)

````
 kubectl port-forward -n shopping-app-namespace service/backend 8080:8080 
````
````
kubectl port-forward -n shopping-app-namespace service/frontend 30081:80
````

To avoid CORS blocking you have to use the open-backend-port Script:

grant privileges first:
````
 chmod +x open-backend-port.sh
````
 Then run:
 ````
 ./open-backend-port.sh
````
Checking Pod Health with:
````
 kubectl get all -n shopping-app-namespace
````
To delete the kubernetes config use:
````
kubectl delete all --all -n shopping-app-namespace
````
To delete the minikube cluster use:
````
minikube delete
````
## Database connection and Commands

To connect to the database use:
````
docker exec -it shoppingdb-container psql -U hse24 -d shoppingdb
````
To list tables use:
````
/dt
````
To end the database connection use:
````
\q
````

## 12 Factor Principles
**1. Codebase:** A single codebase is used for the entire project and is managed in a GitHub repository, shared across all environments.

**2. Dependencies:** Dependencies are explicitly defined in the `go.mod/main.dart.js.deps` files for the backend/frontend and in Docker images for the entire application.

**3. Config:** Configuration values like database credentials and host information are provided through environment variables (`DB_HOST`, `DB_USER`, etc.).

**4. Backing Services:** The PostgreSQL database is treated as an attached service and integrated as an external service via Docker Compose or Kubernetes.

**5. Build, Release, Run:** The build process is standardized with Docker images, utilizing separate steps for build (creating the image), release (tagging the image), and run (starting the container).

**6. Processes:** The backend is executed as a stateless process, relying entirely on the database for persistent data.

**7. Port Binding:** The HTTP server in the backend binds to a port (`8080`) to accept requests and is made accessible via NodePort or port forwarding. Same way for frontend.

**8. Concurrency:** Multiple instances of the backend or frontend can be provided through Kubernetes replicas for horizontal scaling.

**9. Disposability:** Containerized services are quick to start and can be gracefully shut down, with data persistently stored in the PostgreSQL database.

**10. Dev/Prod Parity:** Development, testing, and production environments use the same Docker images and Kubernetes deployment configurations, ensuring high parity between environments.

**11. Logs:** Logs are written directly to standard output (`stdout`), allowing them to be collected and managed by containers or Kubernetes.

**12. Admin Processes:** Simple administrative tasks, such as opening ports or preparing the database, can be automated through Bash scripts or direct container commands.

## Happy Shopping!
