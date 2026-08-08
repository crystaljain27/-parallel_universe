from fastapi import APIRouter

router = APIRouter()

@router.post("/login")
def login():
    return {"status": "success", "user": {"id": "test-user-id"}}
