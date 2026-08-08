from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from core.database import get_db
from schemas.universe import UniverseResponse
from services.ai_service import get_ai_service, IAIService
from models.universe import Universe
import uuid

router = APIRouter()

@router.post("/generate", response_model=List[UniverseResponse])
async def generate_universes(
    db: Session = Depends(get_db),
    ai_service: IAIService = Depends(get_ai_service)
):
    # In reality, get user_id from auth token
    fake_user_id = "test-user-id"
    
    generated_data = await ai_service.generate_universe({"skills": ["flutter", "python"]})
    
    universes = []
    for data in generated_data:
        db_universe = Universe(
            user_id=fake_user_id,
            **data
        )
        db.add(db_universe)
        db.commit()
        db.refresh(db_universe)
        universes.append(db_universe)
        
    return universes
