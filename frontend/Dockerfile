FROM nginx:alpine

# Arbeitsverzeichnis in Nginx setzen
WORKDIR /usr/share/nginx/html

# Kopiere die Dateien aus dem src-Ordner
COPY ./src /usr/share/nginx/html

# Exponiere den Standard-Port für HTTP
EXPOSE 80

# Starte Nginx im Vordergrund
CMD ["nginx", "-g", "daemon off;"]