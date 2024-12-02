# Stage 1: Build Stage
FROM dart:stable as build

# Arbeitsverzeichnis erstellen und setzen
WORKDIR /app

# Kopiere alle relevanten Dateien ins Build-Image
COPY pubspec.* ./
RUN dart pub get
COPY main.dart ./

# Kompiliere den Dart-Code zu JavaScript
RUN dart compile js main.dart -o build/main.js

# Stage 2: Serve Stage
FROM nginx:alpine

# Arbeitsverzeichnis für statische Dateien
WORKDIR /usr/share/nginx/html

# Standard Nginx-Konfiguration entfernen und eigene hinzufügen
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/

# Kopiere die kompilierten Dateien, index.html und styles.css ins Web-Verzeichnis
COPY --from=build /app/build/main.js /usr/share/nginx/html/
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/

# Expose den Port 80
EXPOSE 80

# Starte Nginx
CMD ["nginx", "-g", "daemon off;"]
