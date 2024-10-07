from fastapi import APIRouter

router = APIRouter()


@router.get('/')
async def read_itmes():
    return {"message" : "Read all itmes"}


@router.get("/{item_id}")
async def read_item(item_id : int):
    return {"itme_id" : item_id}
