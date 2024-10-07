from fastapi import FastAPI
from user import router as user_router
from feed import router as feed_router
from footprint import router as footprint_router
from manage import router as manage_router

app = FastAPI()
app.include_router(user_router, prefix="/user", tags=["user"])
app.include_router(feed_router, prefix="/footprint", tags=["footprint"])
app.include_router(footprint_router, prefix="/feed", tags=["feed"])
app.include_router(manage_router, prefix="/manage", tags=["manage"])



if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host = "127.0.0.1", port = 8000)
