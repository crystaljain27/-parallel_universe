from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.routes import auth, chat, universe, future_self
from core.database import engine, Base

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Parallel Universe API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/auth", tags=["Auth"])
app.include_router(chat.router, prefix="/api/chat", tags=["Chat"])
app.include_router(universe.router, prefix="/api/universe", tags=["Universe"])
app.include_router(future_self.router, prefix="/api/future_self", tags=["Future Self"])

@app.get("/health")
def health_check():
    return {"status": "ok"}
