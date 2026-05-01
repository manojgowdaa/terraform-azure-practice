import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import product  # Import the product router
from app.routes import order    # Import the order router
from app.routes import auth     # Import the auth router

# ──────────────────────────────────────────────
# LOGGING SETUP
# ──────────────────────────────────────────────
# logging levels (from least to most severe):
#   DEBUG → INFO → WARNING → ERROR → CRITICAL
# We set INFO so we see INFO and above (not DEBUG)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger("namma_dairy")

app = FastAPI(title="Namma Dairy API")

# CORS - allows our React frontend to call this backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://localhost:5174",
        "http://localhost:5175",
        "https://webapp-linux-tf2026-2.azurewebsites.net",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ──────────────────────────────────────────────
# STEP 3: Using Routers
# ──────────────────────────────────────────────
app.include_router(product.router)
app.include_router(order.router)  # Plug in order routes
app.include_router(auth.router)   # Plug in auth routes


# Root and health stay here (they're app-level, not product-specific)
@app.get("/")
def root():
    logger.info("Root endpoint hit")
    return {"message": "Namma Dairy Backend Running"}


@app.get("/health")
def health_check():
    logger.info("Health check called")
    return {"status": "healthy", "service": "Namma Dairy API"}

