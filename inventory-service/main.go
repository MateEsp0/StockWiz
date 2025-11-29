package main

import (
	"encoding/json"
	"net/http"
	"strconv"
	"sync"
	"time"

	"github.com/go-chi/chi/v5"
)

type Inventory struct {
	ID          int       `json:"id"`
	ProductID   int       `json:"product_id"`
	Quantity    int       `json:"quantity"`
	Warehouse   string    `json:"warehouse"`
	LastUpdated time.Time `json:"last_updated"`
}

const (
	PathInventoryID = "/inventory/{id}"
	MsgNotFound     = "Not found"
	MsgInvalidID    = "Invalid ID"
)

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

	r.Get(PathInventoryID, func(w http.ResponseWriter, r *http.Request) {
		idStr := chi.URLParam(r, "id")
		id, err := strconv.Atoi(idStr)

		if err != nil {
			w.WriteHeader(400)
			json.NewEncoder(w).Encode(map[string]string{"error": MsgInvalidID})
			return
		}

		for _, inv := range inventoryData {
			if inv.ID == id {
				json.NewEncoder(w).Encode(inv)
				return
			}
		}

		w.WriteHeader(404)
		json.NewEncoder(w).Encode(map[string]string{"error": MsgNotFound})
	})

	r.Get("/inventory/product/{product_id}", func(w http.ResponseWriter, r *http.Request) {
		pid, err := strconv.Atoi(chi.URLParam(r, "product_id"))
		if err != nil {
			w.WriteHeader(400)
			json.NewEncoder(w).Encode(map[string]string{"error": MsgInvalidID})
			return
		}

		for _, inv := range inventoryData {
			if inv.ProductID == pid {
				json.NewEncoder(w).Encode(inv)
				return
			}
		}

		json.NewEncoder(w).Encode(map[string]interface{}{})
	})

	r.Post("/inventory", func(w http.ResponseWriter, r *http.Request) {
		var req Inventory
		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "Bad request", 400)
			return
		}

		mutex.Lock()
		req.ID = nextID
		req.LastUpdated = time.Now()
		nextID++
		inventoryData = append(inventoryData, req)
		mutex.Unlock()

		json.NewEncoder(w).Encode(req)
	})

	r.Put(PathInventoryID, func(w http.ResponseWriter, r *http.Request) {
		id, _ := strconv.Atoi(chi.URLParam(r, "id"))

		var body struct {
			Quantity  int    `json:"quantity"`
			Warehouse string `json:"warehouse"`
		}

		if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
			http.Error(w, "Bad request", 400)
			return
		}

		mutex.Lock()
		defer mutex.Unlock()

		for i := range inventoryData {
			if inventoryData[i].ID == id {
				inventoryData[i].Quantity = body.Quantity
				inventoryData[i].Warehouse = body.Warehouse
				inventoryData[i].LastUpdated = time.Now()
				json.NewEncoder(w).Encode(inventoryData[i])
				return
			}
		}

		http.Error(w, MsgNotFound, 404)
	})

	r.Delete(PathInventoryID, func(w http.ResponseWriter, r *http.Request) {
		id, _ := strconv.Atoi(chi.URLParam(r, "id"))

		mutex.Lock()
		defer mutex.Unlock()

		for i := range inventoryData {
			if inventoryData[i].ID == id {
				inventoryData = append(inventoryData[:i], inventoryData[i+1:]...)
				json.NewEncoder(w).Encode(map[string]string{"status": "deleted"})
				return
			}
		}

		http.Error(w, MsgNotFound, 404)
	})

	http.ListenAndServe(":8002", r)
}
