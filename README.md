To start the Application please install Docker in your Codespace and use the following command:

docker compose up --build

It may take 2 tries, because the backend often initializes before the database.

In that case use :

docker compose down
docker compose up --build

In the end open the backend port 8080 to "public" in the Port Window.
