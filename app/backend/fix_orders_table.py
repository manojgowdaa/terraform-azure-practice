"""Add user_id column to orders table if it doesn't exist."""
from app.db.database import engine
from sqlalchemy import text

with engine.connect() as conn:
    result = conn.execute(text(
        "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS "
        "WHERE TABLE_NAME='orders' AND COLUMN_NAME='user_id'"
    ))
    rows = result.fetchall()
    if rows:
        print("user_id column already exists")
    else:
        print("Adding user_id column to orders table...")
        conn.execute(text("ALTER TABLE orders ADD user_id INT NULL"))
        conn.execute(text(
            "ALTER TABLE orders ADD CONSTRAINT FK_orders_users "
            "FOREIGN KEY (user_id) REFERENCES users(id)"
        ))
        conn.commit()
        print("Done! user_id column added.")
