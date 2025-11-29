package main

import (
    "encoding/json"
    "fmt"
    "io"
    "log"
    "net/http"
    "os"
    "strings"
)

func enableCORS(w http.ResponseWriter) {
    w.Header().Set("Access-Control-Allow-Origin", "*")
    w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    w.Header().Set("Access-Control-Allow-Headers", "Content-Type")
}

func proxyRequest(w http.ResponseWriter, r *http.Request, targetURL string) {
    req, err := http.NewRequest(r.Method, targetURL, r.Body)
    if err != nil {
        http.Error(w, "Bad request", 400)
        return
    }

    req.Header = r.Header

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        http.Error(w, "Service unreachable", 500)
        return
    }
    defer resp.Body.Close()

    w.WriteHeader(resp.StatusCode)
    io.Copy(w, resp.Body)
}

func main() {
    productURL := os.Getenv("PRODUCT_SERVICE_URL")
    inventoryURL := os.Getenv("INVENTORY_SERVICE_URL")

    mux := http.NewServeMux()

    // HEALTH
    mux.HandleFunc("/api/health", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w)
        if r.Method == "OPTIONS" {
            return
        }
        json.NewEncoder(w).Encode(map[string]string{
            "status":  "healthy",
            "service": "api-gateway",
        })
    })

    // ░░░░ PRODUCTS (FULL PROXY) ░░░░
    mux.HandleFunc("/api/products", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w)
        if r.Method == "OPTIONS" {
            return
        }
        target := productURL + "/products"
        proxyRequest(w, r, target)
    })

    mux.HandleFunc("/api/products/", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w)
        if r.Method == "OPTIONS" {
            return
        }
        id := strings.TrimPrefix(r.URL.Path, "/api/products/")
        target := productURL + "/products/" + id
        proxyRequest(w, r, target)
    })

    // PRODUCTS FULL MERGE
    mux.HandleFunc("/api/products-full", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w)
        if r.Method == "OPTIONS" {
            return
        }

        resp, err := http.Get(productURL + "/products")
        if err != nil {
            http.Error(w, "Service unreachable", 500)
            return
        }
        defer resp.Body.Close()

        var products []map[string]interface{}
        json.NewDecoder(resp.Body).Decode(&products)

        // Add inventory to each product
        for i := range products {
            id := int(products[i]["id"].(float64))

            invURL := fmt.Sprintf("%s/inventory/product/%d", inventoryURL, id)
            invResp, err := http.Get(invURL)

            if err != nil {
                products[i]["inventory"] = nil
                continue
            }

            var inv map[string]interface{}
            json.NewDecoder(invResp.Body).Decode(&inv)
            invResp.Body.Close()

            products[i]["inventory"] = inv
        }

        w.Header().Set("Content-Type", "application/json")
        json.NewEncoder(w).Encode(products)
    })

    // ░░░░ INVENTORY (FULL PROXY) ░░░░
    mux.HandleFunc("/api/inventory", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w)
        if r.Method == "OPTIONS" {
            return
        }
        target := inventoryURL + "/inventory"
        proxyRequest(w, r, target)
    })

    mux.HandleFunc("/api/inventory/", func(w http.ResponseWriter, r *http.Request) {
        enableCORS(w)
        if r.Method == "OPTIONS" {
            return
        }
        id := strings.TrimPrefix(r.URL.Path, "/api/inventory/")
        target := inventoryURL + "/inventory/" + id
        proxyRequest(w, r, target)
    })

    log.Println("API Gateway running on :8000")
    http.ListenAndServe(":8000", mux)
}
