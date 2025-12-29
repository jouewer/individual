from fastapi import APIRouter, Depends, Body
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.travel_service import TravelService
from module_admin.service.login_service import LoginService
from module_admin.entity.vo.travel_vo import TravelFootprintQuery, TravelFootprintCreate, TravelFootprintUpdate
from module_admin.entity.vo.user_vo import CurrentUserModel

travelController = APIRouter(prefix='/travel', tags=['Travel Footprints'])

@travelController.get("/test")
async def test():
    return {"message": "hello"}

@travelController.get("/list", response_model=None)
async def get_travel_list(query: TravelFootprintQuery = Depends(), db: AsyncSession = Depends(get_db)):
    return await TravelService.get_travel_list(query, db)

@travelController.get("/{travel_id}", response_model=None)
async def get_travel_detail(travel_id: int, db: AsyncSession = Depends(get_db)):
    return await TravelService.get_travel_detail(travel_id, db)

@travelController.post("", response_model=None)
async def add_travel(
    travel: TravelFootprintCreate, 
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await TravelService.add_travel(travel, db, current_user)

@travelController.put("", response_model=None)
async def update_travel(
    travel: TravelFootprintUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await TravelService.update_travel(travel, db)

@travelController.delete("/{travel_ids}", response_model=None)
async def delete_travel(
    travel_ids: str,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await TravelService.delete_travel(travel_ids, db)
