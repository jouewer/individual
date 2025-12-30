from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.food_service import FoodService
from module_admin.service.login_service import LoginService
from module_admin.entity.vo.food_vo import FoodDiariesQuery, FoodDiariesCreate, FoodDiariesUpdate
from module_admin.entity.vo.user_vo import CurrentUserModel

foodController = APIRouter(prefix='/food', tags=['Food Diaries'])

@foodController.get("/list", response_model=None)
async def get_food_list(query: FoodDiariesQuery = Depends(), db: AsyncSession = Depends(get_db)):
    return await FoodService.get_food_list(query, db)

@foodController.get("/{food_id}", response_model=None)
async def get_food_detail(food_id: int, db: AsyncSession = Depends(get_db)):
    return await FoodService.get_food_detail(food_id, db)

@foodController.post("", response_model=None)
async def add_food(
    food: FoodDiariesCreate, 
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await FoodService.add_food(food, db, current_user)

@foodController.put("", response_model=None)
async def update_food(
    food: FoodDiariesUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await FoodService.update_food(food, db)

@foodController.delete("/{food_ids}", response_model=None)
async def delete_food(
    food_ids: str,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await FoodService.delete_food(food_ids, db)
