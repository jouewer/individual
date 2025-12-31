from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.login_service import LoginService
from module_admin.entity.vo.user_vo import CurrentUserModel
from module_admin.service.shopping_service import ShoppingService
from module_admin.entity.vo.shopping_vo import HolidayShoppingCreate, HolidayShoppingUpdate, HolidayShoppingQuery
from utils.response_util import ResponseUtil

shoppingController = APIRouter(prefix='/shopping', tags=['节日购物模块'])

@shoppingController.get("/list", response_model=None)
async def get_shopping_list(query: HolidayShoppingQuery = Depends(), db: AsyncSession = Depends(get_db)):
    return await ShoppingService.get_shopping_list(query, db)

@shoppingController.get("/{shopping_id}", response_model=None)
async def get_shopping_detail(shopping_id: int, db: AsyncSession = Depends(get_db)):
    return await ShoppingService.get_shopping_detail(shopping_id, db)

@shoppingController.post("", response_model=None)
async def add_shopping(
    shopping: HolidayShoppingCreate, 
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ShoppingService.add_shopping(shopping, db, current_user)

@shoppingController.put("", response_model=None)
async def update_shopping(
    shopping: HolidayShoppingUpdate, 
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ShoppingService.update_shopping(shopping, db)

@shoppingController.delete("/{shopping_id}", response_model=None)
async def delete_shopping(
    shopping_id: int, 
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ShoppingService.delete_shopping(shopping_id, db)
