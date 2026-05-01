"""
Database connection setup using SQLAlchemy

SQLAlchemy has 3 main parts:
1. Engine    → the connection to the database (like a phone line)
2. Session   → a conversation over that line (send queries, get results)
3. Base      → the parent class for all our table definitions
"""
import os
from urllib.parse import quote_plus
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Load .env file
load_dotenv()

# Read connection details from .env
DB_SERVER = os.getenv("DB_SERVER")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = os.getenv("DB_PORT", "1433")

# Connection URL for pymssql
# quote_plus() escapes special characters like @ in the password
DATABASE_URL = f"mssql+pymssql://{DB_USER}:{quote_plus(DB_PASSWORD)}@{DB_SERVER}:{DB_PORT}/{DB_NAME}"

# Engine → manages the actual database connection
engine = create_engine(DATABASE_URL, echo=True)

# SessionLocal → a factory that creates new database sessions
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)

# Base → all our table models will inherit from this
Base = declarative_base()


def get_db():
    """Dependency: gives each request a database session, closes it when done."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
