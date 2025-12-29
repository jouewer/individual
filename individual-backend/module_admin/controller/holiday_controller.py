from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.holiday_service import HolidayService
from module_admin.service.login_service import LoginService
from module_admin.entity.vo.holiday_vo import HolidayScheduleQuery, HolidayScheduleCreate, HolidayScheduleUpdate
from module_admin.entity.vo.user_vo import CurrentUserModel

holidayController = APIRouter(prefix='/holiday', tags=['Holiday Schedules'])

@holidayController.get("/list", response_model=None)
async def get_holiday_list(query: HolidayScheduleQuery = Depends(), db: AsyncSession = Depends(get_db)):
    return await HolidayService.get_holiday_list(query, db)

@holidayController.get("/{holiday_id}", response_model=None)
async def get_holiday_detail(holiday_id: int, db: AsyncSession = Depends(get_db)):
    return await HolidayService.get_holiday_detail(holiday_id, db)

@holidayController.post("", response_model=None)
async def add_holiday(
    holiday: HolidayScheduleCreate, 
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await HolidayService.add_holiday(holiday, db, current_user)

@holidayController.put("", response_model=None)
async def update_holiday(
    holiday: HolidayScheduleUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await HolidayService.update_holiday(holiday, db)

@holidayController.delete("/{holiday_ids}", response_model=None)
async def delete_holiday(
    holiday_ids: str,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await HolidayService.delete_holiday(holiday_ids, db)
