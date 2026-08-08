from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from services.ai_service import get_ai_service, IAIService
from pydantic import BaseModel

router = APIRouter()

class ChatRequest(BaseModel):
    universe_id: str
    universe_name: str
    message: str

@router.get("/intro")
async def get_intro(universe_id: str, universe_name: str, ai_service: IAIService = Depends(get_ai_service)):
    intro = await ai_service.get_future_self_intro(universe_id, universe_name)
    return {"message": intro}

@router.post("/stream")
async def stream_chat(req: ChatRequest, ai_service: IAIService = Depends(get_ai_service)):
    return StreamingResponse(
        ai_service.stream_future_self_chat(req.universe_id, req.message), 
        media_type="text/event-stream"
    )
