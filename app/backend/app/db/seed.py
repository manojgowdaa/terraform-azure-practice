"""
Seed script — populates the database with initial products

Run from app/backend/:
    python -m app.db.seed
"""
from app.db.database import engine, SessionLocal, Base
from app.db.models import Product

# Create all tables (if they don't exist)
print("Creating tables...")
Base.metadata.create_all(bind=engine)
print("Tables created!")

# Insert seed data
db = SessionLocal()

existing = db.query(Product).count()
if existing > 0:
    print(f"Products table already has {existing} rows. Skipping seed.")
else:
    products = [
        Product(name="Full Cream Milk", price=60, unit="litre", description="Rich and creamy whole milk with natural goodness"),
        Product(name="Toned Milk", price=48, unit="litre", description="Low-fat milk perfect for everyday consumption"),
        Product(name="Organic Milk", price=80, unit="litre", description="100% organic milk from grass-fed cows"),
        Product(name="Curd", price=45, unit="kg", description="Fresh, thick curd made from pure milk"),
        Product(name="Paneer", price=320, unit="kg", description="Soft and fresh cottage cheese for cooking"),
    ]
    db.add_all(products)
    db.commit()
    print(f"Inserted {len(products)} products!")

# Verify
all_products = db.query(Product).all()
print("\nProducts in database:")
for p in all_products:
    print(f"  {p.id}. {p.name} — ₹{p.price}/{p.unit}")

db.close()
