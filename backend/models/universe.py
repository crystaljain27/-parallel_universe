from sqlalchemy import Column, String, Integer, DateTime, JSON, ForeignKey
from sqlalchemy.sql import func
from core.database import Base
import uuid

class Universe(Base):
    __tablename__ = "universes"

    id = Column(String, primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"))
    name = Column(String)
    cover_image = Column(String)
    summary = Column(String)
    confidence_score = Column(Integer)
    difficulty_level = Column(String)
    estimated_timeline = Column(String)
    required_skills = Column(JSON) # List of strings
    key_milestones = Column(JSON) # List of dicts
    salary_progression = Column(JSON) # List of ints
    pros = Column(JSON)
    cons = Column(JSON)
    daily_routine = Column(String)
    ai_recommendation = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
