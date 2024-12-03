# Basis-Image für Go
FROM golang:1.23

WORKDIR /app

# Kopiere die Dateien aus dem src-Ordner
COPY ./src /app

# Lade Abhängigkeiten
RUN go mod tidy

# Baue die Anwendung
RUN go build -o main .

# Exponiere den Port
EXPOSE 8080

# Starte die Anwendung
CMD ["./main"]
