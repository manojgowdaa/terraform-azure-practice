import logging
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.models import OrderRequest
from app.db.models import Product, Order, OrderItem
from app.db.database import get_db

# Get a logger for this module
logger = logging.getLogger("namma_dairy.orders")

router = APIRouter(prefix="/orders", tags=["Orders"])


# ──────────────────────────────────────────────
# NOW USING DATABASE (no more hardcoded products dict!)
# ──────────────────────────────────────────────

# POST /orders → place a new order
@router.post("/")
def place_order(order: OrderRequest, user_id: int = None, db: Session = Depends(get_db)):
    logger.info(f"Received order with {len(order.items)} items from user_id={user_id}")

    bill_items = []
    order_items = []
    total = 0

    for item in order.items:
        # Look up the product from DATABASE
        product = db.query(Product).filter(Product.id == item.product_id).first()

        if not product:
            logger.warning(f"Product id={item.product_id} not found")
            raise HTTPException(
                status_code=404,
                detail=f"Product with id={item.product_id} not found",
            )

        # Calculate line total
        line_total = product.price * item.quantity
        total += line_total

        # Prepare order item for DB
        order_items.append(OrderItem(
            product_id=product.id,
            quantity=item.quantity,
            price_per_unit=product.price,
            line_total=line_total,
        ))

        bill_items.append({
            "product": product.name,
            "quantity": item.quantity,
            "unit": product.unit,
            "price_per_unit": product.price,
            "line_total": line_total,
        })

    # Save order to database
    new_order = Order(total=total, user_id=user_id, items=order_items)
    db.add(new_order)
    db.commit()
    db.refresh(new_order)

    logger.info(f"Order #{new_order.id} saved. Total: ₹{total}")

    return {
        "message": "Order placed successfully!",
        "order_id": new_order.id,
        "items": bill_items,
        "total": total,
    }


# GET /orders → list all orders (optionally filter by user)
@router.get("/")
def get_orders(user_id: int = None, db: Session = Depends(get_db)):
    query = db.query(Order)
    if user_id:
        query = query.filter(Order.user_id == user_id)
    orders = query.order_by(Order.created_at.desc()).all()
    result = []
    for order in orders:
        items = []
        for oi in order.items:
            product = db.query(Product).filter(Product.id == oi.product_id).first()
            items.append({
                "product": product.name if product else "Unknown",
                "quantity": oi.quantity,
                "price_per_unit": oi.price_per_unit,
                "line_total": oi.line_total,
            })
        result.append({
            "order_id": order.id,
            "total": order.total,
            "created_at": order.created_at.isoformat(),
            "items": items,
        })
    return result
