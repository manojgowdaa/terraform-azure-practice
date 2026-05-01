import logging
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.models import Product as ProductSchema  # Pydantic model (response shape)
from app.db.models import Product                # SQLAlchemy model (database table)
from app.db.database import get_db               # Database session dependency

# Get a logger for this module
logger = logging.getLogger("namma_dairy.products")

# APIRouter works like a mini FastAPI app — groups related endpoints together
router = APIRouter(prefix="/products", tags=["Products"])


# ──────────────────────────────────────────────
# NOW READING FROM DATABASE (no more hardcoded list!)
# ──────────────────────────────────────────────

# GET /products → list all products from DB
@router.get("/", response_model=list[ProductSchema])
def get_products(db: Session = Depends(get_db)):
    logger.info("Fetching all products from database")
    products = db.query(Product).all()
    return products


# GET /products/{product_id} → get one product by ID from DB
@router.get("/{product_id}", response_model=ProductSchema)
def get_product(product_id: int, db: Session = Depends(get_db)):
    logger.info(f"Fetching product with id={product_id} from database")
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        logger.warning(f"Product with id={product_id} not found")
        raise HTTPException(status_code=404, detail="Product not found")
    return product
