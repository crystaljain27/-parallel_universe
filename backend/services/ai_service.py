from typing import AsyncGenerator
import json
import asyncio

class IAIService:
    async def generate_universe(self, user_profile: dict) -> list[dict]:
        raise NotImplementedError

    async def stream_future_self_chat(self, universe_id: str, message: str) -> AsyncGenerator[str, None]:
        raise NotImplementedError
        
    async def get_future_self_intro(self, universe_id: str, universe_name: str) -> str:
        raise NotImplementedError


class MockAIService(IAIService):
    async def generate_universe(self, user_profile: dict) -> list[dict]:
        await asyncio.sleep(2)
        return [
            {
                "name": "Backend Engineer",
                "cover_image": "https://picsum.photos/800/400",
                "summary": "Build highly scalable systems.",
                "confidence_score": 90,
                "difficulty_level": "Hard",
                "estimated_timeline": "1 Year",
                "required_skills": ["Python", "FastAPI", "PostgreSQL", "Docker"],
                "key_milestones": [{"title": "Learn FastAPI", "description": "Master async Python", "year": "Month 3"}],
                "salary_progression": [90000, 120000, 160000],
                "pros": ["High demand", "Remote friendly"],
                "cons": ["On-call shifts"],
                "daily_routine": "Coding and code reviews.",
                "ai_recommendation": "Focus on system design."
            }
        ]

    async def stream_future_self_chat(self, universe_id: str, message: str) -> AsyncGenerator[str, None]:
        response = f"I am your future self from universe {universe_id}. You said: {message}"
        words = response.split(' ')
        for word in words:
            await asyncio.sleep(0.1)
            yield f"{word} "
            
    async def get_future_self_intro(self, universe_id: str, universe_name: str) -> str:
        return f"Hello, I am you, 5 years from now, successfully a {universe_name}. Ask me anything."


def get_ai_service() -> IAIService:
    return MockAIService()
