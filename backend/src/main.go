package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"net/http"

	_ "github.com/lib/pq"
)

type Item struct {
	Name   string `json:"name"`
	Amount int    `json:"amount"`
}

var db *sql.DB

// Verbindung zur PostgreSQL-Datenbank herstellen
func connectToDatabase() {
	var err error

	// Daten aus Umgebungsvariablen beziehen
	dbHost := os.Getenv("DB_HOST")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")

	// Fallback für fehlende Umgebungsvariablen
	if dbHost == "" || dbUser == "" || dbPassword == "" || dbName == "" {
		log.Fatalf("Database configuration incomplete. Ensure DB_HOST, DB_USER, DB_PASSWORD, and DB_NAME are set.")
	}

	// Verbindungskonfigurationszeichenkette erstellen
	connStr := fmt.Sprintf("postgres://%s:%s@%s:5432/%s?sslmode=disable", dbUser, dbPassword, dbHost, dbName)

	// Verbindung zur Datenbank öffnen
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Unable to connect to database: %v\n", err)
	}

	// Testen der Datenbankverbindung
	if err = db.Ping(); err != nil {
		log.Fatalf("Database connection failed: %v\n", err)
	}

	log.Println("Connected to the database")

	// Tabelle erstellen, falls sie nicht existiert
	createTableIfNotExists()
}

// Tabelle erstellen, falls sie nicht existiert
func createTableIfNotExists() {
	query := `
	CREATE TABLE IF NOT EXISTS items (
		name TEXT PRIMARY KEY,
		amount INTEGER NOT NULL
	);
	`

	_, err := db.Exec(query)
	if err != nil {
		log.Fatalf("Error creating table: %v\n", err)
	}

	log.Println("Table 'items' is ready.")
}

// Middleware für CORS
func enableCORS(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", "*") // Erlaubt alle Ursprünge
	w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
}

// Startpunkt der Anwendung
func main() {
	// Verbindung zur Datenbank herstellen
	connectToDatabase()
	defer db.Close() // Schließt die Datenbankverbindung, wenn das Programm beendet wird

	// HTTP-Handler registrieren
	http.HandleFunc("/items", handleItems)
	http.HandleFunc("/items/", handleItemByName)

	log.Println("Starting server on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

// Handler für die Route "/items"
func handleItems(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		// Stelle sicher, dass Preflight-Anfragen erfolgreich beantwortet werden
		w.WriteHeader(http.StatusOK)
		return
	}

	switch r.Method {
	case http.MethodGet:
		getItems(w)
	case http.MethodPost:
		addItem(w, r)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}

// Handler für "/items/{name}"
func handleItemByName(w http.ResponseWriter, r *http.Request) {
	enableCORS(w)
	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	name := r.URL.Path[len("/items/"):]
	if name == "" {
		http.Error(w, "Item name is required", http.StatusBadRequest)
		return
	}

	switch r.Method {
	case http.MethodPut:
		updateItem(w, r, name)
	case http.MethodDelete:
		deleteItem(w, name)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}

// Alle Artikel aus der Datenbank abrufen
func getItems(w http.ResponseWriter) {
	rows, err := db.Query("SELECT name, amount FROM items")
	if err != nil {
		http.Error(w, "Error fetching items", http.StatusInternalServerError)
		log.Println("Error fetching items:", err)
		return
	}
	defer rows.Close()

	var items []Item
	for rows.Next() {
		var item Item
		if err := rows.Scan(&item.Name, &item.Amount); err != nil {
			http.Error(w, "Error reading item", http.StatusInternalServerError)
			log.Println("Error reading item:", err)
			return
		}
		items = append(items, item)
	}

	// Stelle sicher, dass immer eine leere Liste zurückgegeben wird
	if items == nil {
		items = []Item{}
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(items)
}

// Neuen Artikel zur Datenbank hinzufügen
func addItem(w http.ResponseWriter, r *http.Request) {
	var item Item
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	if item.Name == "" || item.Amount < 0 {
		http.Error(w, "Invalid item data", http.StatusBadRequest)
		return
	}

	_, err := db.Exec("INSERT INTO items (name, amount) VALUES ($1, $2)", item.Name, item.Amount)
	if err != nil {
		http.Error(w, "Error adding item", http.StatusInternalServerError)
		log.Println("Error adding item:", err)
		return
	}

	w.WriteHeader(http.StatusCreated)
}

// Artikel in der Datenbank aktualisieren
func updateItem(w http.ResponseWriter, r *http.Request, name string) {
	var updatedItem Item
	if err := json.NewDecoder(r.Body).Decode(&updatedItem); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	_, err := db.Exec("UPDATE items SET amount = $1 WHERE name = $2", updatedItem.Amount, name)
	if err != nil {
		http.Error(w, "Error updating item", http.StatusInternalServerError)
		log.Println("Error updating item:", err)
		return
	}

	w.WriteHeader(http.StatusOK)
}

// Artikel aus der Datenbank löschen
func deleteItem(w http.ResponseWriter, name string) {
	_, err := db.Exec("DELETE FROM items WHERE name = $1", name)
	if err != nil {
		http.Error(w, "Error deleting item", http.StatusInternalServerError)
		log.Println("Error deleting item:", err)
		return
	}

	w.WriteHeader(http.StatusOK)
}
