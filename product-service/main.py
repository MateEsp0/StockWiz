from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timezone

app = FastAPI()

products = {}
next_id = 1

class ProductCreate(BaseModel):
    name: str
    price: float
    stock: int = 0
    description: Optional[str] = None
    category: Optional[str] = None

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    price: Optional[float] = None
    stock: Optional[int] = None
    description: Optional[str] = None
    category: Optional[str] = None

@app.get("/health")
def health():
    return {"status": "healthy", "service": "product-service"}

@app.get("/products")
def get_all():
    return list(products.values())

@app.get("/products/{id}")
def get_one(id: int):
    if id not in products:
        raise HTTPException(status_code=404, detail="Product not found")
    return products[id]

@app.post("/products")
def create(product: ProductCreate):
    global next_id
    item = {
        "id": next_id,
        "name": product.name,
        "price": product.price,
        "stock": product.stock,
        "description": product.description,
        "category": product.category,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    products[next_id] = item
    next_id += 1
    return item

@app.put("/products/{id}")
def update(id: int, data: ProductUpdate):
    if id not in products:
        raise HTTPException(status_code=404, detail="Product not found")

    p = products[id]
    if data.name is not None:
        p["name"] = data.name
    if data.price is not None:
        p["price"] = data.price
    if data.stock is not None:
        p["stock"] = data.stock
    if data.description is not None:
        p["description"] = data.description
    if data.category is not None:
        p["category"] = data.category

    p["updated_at"] = datetime.now(timezone.utc).isoformat()
    return p

@app.delete("/products/{id}")
def delete(id: int):
    if id not in products:
        raise HTTPException(status_code=404, detail="Product not found")
    del products[id]
    return {"deleted": True}
