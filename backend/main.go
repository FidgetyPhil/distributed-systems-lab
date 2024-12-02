package main

import (
	"encoding/json"
	"log"
	"net/http"
	"sync"
)

type Item struct {
	Name   string `json:"name"`
	Amount int    `json:"amount"`
}

var (
	items []Item
	mutex sync.Mutex
)

func main() {
	http.HandleFunc("/items", handleItems)
	http.HandleFunc("/items/", handleItemByName)
	log.Println("Server läuft auf Port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func handleItems(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case http.MethodGet:
		getItems(w, r)
	case http.MethodPost:
		addItem(w, r)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}

func handleItemByName(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Path[len("/items/"):]
	if name == "" {
		http.Error(w, "Item name is required", http.StatusBadRequest)
		return
	}

	switch r.Method {
	case http.MethodPut:
		updateItem(w, r, name)
	case http.MethodDelete:
		deleteItem(w, r, name)
	default:
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
	}
}

func getItems(w http.ResponseWriter, r *http.Request) {
	mutex.Lock()
	defer mutex.Unlock()

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(items)
}

func addItem(w http.ResponseWriter, r *http.Request) {
	var item Item
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	mutex.Lock()
	defer mutex.Unlock()

	items = append(items, item)
	w.WriteHeader(http.StatusCreated)
}

func updateItem(w http.ResponseWriter, r *http.Request, name string) {
	var updatedItem Item
	if err := json.NewDecoder(r.Body).Decode(&updatedItem); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	mutex.Lock()
	defer mutex.Unlock()

	for i, item := range items {
		if item.Name == name {
			items[i].Amount = updatedItem.Amount
			w.WriteHeader(http.StatusOK)
			return
		}
	}

	http.Error(w, "Item not found", http.StatusNotFound)
}

func deleteItem(w http.ResponseWriter, r *http.Request, name string) {
	mutex.Lock()
	defer mutex.Unlock()

	for i, item := range items {
		if item.Name == name {
			items = append(items[:i], items[i+1:]...)
			w.WriteHeader(http.StatusOK)
			return
		}
	}

	http.Error(w, "Item not found", http.StatusNotFound)
}
