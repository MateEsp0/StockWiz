package main

import (
	"io"
	"log"
	"net/http"
	"os"
)

func main() {
	productURL := os.Getenv("PRODUCT_SERVICE_URL")
	inventoryURL := os.Getenv("INVENTORY_SERVICE_URL")

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(`{"status":"healthy","service":"api-gateway"}`))
	})

	http.HandleFunc("/products", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get(productURL + "/products")
		if err != nil {
			http.Error(w, "Service error", 500)
			return
		}
		defer resp.Body.Close()
		body, _ := io.ReadAll(resp.Body)
		w.Write(body)
	})

	http.HandleFunc("/inventory", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get(inventoryURL + "/inventory")
		if err != nil {
			http.Error(w, "Service error", 500)
			return
		}
		defer resp.Body.Close()
		body, _ := io.ReadAll(resp.Body)
		w.Write(body)
	})

	log.Println("API Gateway running on :8000")
	http.ListenAndServe(":8000", nil)
}
