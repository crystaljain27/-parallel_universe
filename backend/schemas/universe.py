from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class MilestoneSchema(BaseModel):
    title: str
    description: str
    year: str

class UniverseBase(BaseModel):
    name: str
    cover_image: str
    summary: str
    confidence_score: int
    difficulty_level: str
    estimated_timeline: str
    required_skills: List[str]
    key_milestones: List[MilestoneSchema]
    salary_progression: List[int]
    pros: List[str]
    cons: List[str]
    daily_routine: str
    ai_recommendation: str

class UniverseCreate(UniverseBase):
    pass

class UniverseResponse(UniverseBase):
    id: str
    user_id: str
    created_at: datetime

    class Config:
        from_attributes = True
