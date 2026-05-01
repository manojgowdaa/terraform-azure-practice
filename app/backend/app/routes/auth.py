import logging
import bcrypt
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session

from app.models import LoginRequest
from app.db.models import User
from app.db.database import get_db


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode(), hashed.encode())

logger = logging.getLogger("namma_dairy.auth")

router = APIRouter(prefix="/auth", tags=["Auth"])


# POST /auth/login → verify credentials (only users from users.xlsx can login)
@router.post("/login")
def login(req: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()

    if not user or not verify_password(req.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password")

    logger.info(f"User logged in: {user.email} (id={user.id}, role={user.role})")

    return {
        "message": "Login successful!",
        "user_id": user.id,
        "name": user.name,
        "email": user.email,
        "role": user.role,
    }


# GET /auth/users → admin only: list all users
@router.get("/users")
def list_users(admin_id: int = None, db: Session = Depends(get_db)):
    # Verify caller is admin
    if admin_id:
        admin = db.query(User).filter(User.id == admin_id).first()
        if not admin or admin.role != "admin":
            raise HTTPException(status_code=403, detail="Admin access required")
    else:
        raise HTTPException(status_code=403, detail="Admin access required")

    users = db.query(User).all()
    return [
        {"id": u.id, "name": u.name, "email": u.email, "role": u.role}
        for u in users
    ]
