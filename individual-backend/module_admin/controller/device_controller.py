from fastapi import APIRouter, Depends, Request
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.login_service import LoginService, CurrentUserModel
from module_admin.service.device_service import DeviceService
from module_admin.entity.vo.device_vo import DeviceQuery, DeviceCreate, DeviceUpdate, DeviceModel
from utils.response_util import ResponseUtil

deviceController = APIRouter(prefix='/device', tags=['电子设备模块'])

@deviceController.get('/list', response_model=None)
async def get_device_list(
    request: Request,
    query: DeviceQuery = Depends(),
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await DeviceService.get_device_list(db, query)

@deviceController.get('/{device_id}', response_model=None)
async def get_device_detail(
    request: Request,
    device_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    result = await DeviceService.get_device_detail(db, device_id)
    return ResponseUtil.success(data=result)

@deviceController.post('', response_model=None)
async def add_device(
    request: Request,
    device_in: DeviceCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    result = await DeviceService.add_device(db, device_in, current_user)
    return ResponseUtil.success(data=result)

@deviceController.put('', response_model=None)
async def update_device(
    request: Request,
    device_in: DeviceUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    result = await DeviceService.update_device(db, device_in)
    return ResponseUtil.success(data=result)

@deviceController.delete('/{device_ids}', response_model=None)
async def delete_device(
    request: Request,
    device_ids: str,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    await DeviceService.delete_device(db, device_ids)
    return ResponseUtil.success()
