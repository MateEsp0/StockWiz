package main

import (
	"encoding/json"
	"net/http"
	"strconv"
	"sync"

	"github.com/go-chi/chi/v5"
)

type Inventory struct {
	ID        int    `json:"id"`
	ProductID int    `json:"product_id"`
	Quantity  int    `json:"quantity"`
	Warehouse string `json:"warehouse"`
}

var (
	inventoryData = []Inventory{}
	nextID        = 1
	mutex         = &sync.Mutex{}
)

func main() {
	r := chi.NewRouter()

	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]string{
			"status":  "healthy",
			"service": "inventory-service",
		})
	})

	r.Get("/inventory", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(inventoryData)
	})

	r.Get("/inventory/{id}", func(w http.ResponseWriter, r *http.Request) {
		id, err := strconv.Atoi(chi.URLParam(r, "id"))
		if err != nil {
			http.Error(w, "Invalid ID", 400)
			return
		}

		for _, inv := range inventoryData {
			if inv.ID == id {
				json.NewEncoder(w).Encode(inv)
				return
			}
		}
		http.Error(w, "Not found", 404)
	})

	r.Post("/inventory", func(w http.ResponseWriter, r *http.Request) {
		var req Inventory
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "Bad request", 400)
			return
		}

		mutex.Lock()
		req.ID = nextID
		nextID++
		inventoryData = append(inventoryData, req)
		mutex.Unlock()

		json.NewEncoder(w).Encode(req)
	})

	http.ListenAndServe(":8002", r)
}
