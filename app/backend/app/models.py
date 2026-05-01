from pydantic import BaseModel

# ──────────────────────────────────────────────
# STEP 4: Pydantic Models
# ──────────────────────────────────────────────
# Models define WHAT your data looks like.
# Think of them as a "contract" — if data doesn't
# match this shape, FastAPI rejects it automatically.


# Response model — what we SEND back to the frontend
class Product(BaseModel):
    id: int
    name: str
    price: float
    unit: str


# Request model — what the frontend SENDS to us (e.g., when placing an order)
class OrderItem(BaseModel):
    product_id: int
    quantity: int  # how many litres/kg


# Full order request
class OrderRequest(BaseModel):
    items: list[OrderItem]  # a list of items to order


# ──────────────────────────────────────────────
# Auth models
# ──────────────────────────────────────────────
class RegisterRequest(BaseModel):
    name: str
    email: str
    password: str


class LoginRequest(BaseModel):
    email: str
    password: str
