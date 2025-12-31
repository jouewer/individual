from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.plant_service import PlantService
from module_admin.service.login_service import LoginService
from module_admin.entity.vo.plant_vo import PlantQuery, PlantModel
from module_admin.entity.vo.user_vo import CurrentUserModel
from utils.response_util import ResponseUtil

plantController = APIRouter(prefix='/plant')

@plantController.get('/list')
async def list_plant(
    page_num: int = 1,
    page_size: int = 10,
    plant_name: str = None,
    plant_type: str = None,
    growth_stage: str = None,
    health_status: str = None,
    db: AsyncSession = Depends(get_db)
):
    query_params = PlantQuery(
        page_num=page_num,
        page_size=page_size,
        plant_name=plant_name,
        plant_type=plant_type,
        growth_stage=growth_stage,
        health_status=health_status
    )
    result = await PlantService.get_plant_list(db, query_params, is_page=True)
    return ResponseUtil.success(model_content=result)

@plantController.get('/{plant_id}')
async def get_plant(plant_id: int, db: AsyncSession = Depends(get_db)):
    result = await PlantService.get_plant_detail(db, plant_id)
    return ResponseUtil.success(data=result)

@plantController.post('')
async def add_plant(
    plant: PlantModel,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    plant.user_id = current_user.user.user_id
    await PlantService.add_plant(db, plant)
    return ResponseUtil.success()

@plantController.put('')
async def update_plant(plant: PlantModel, db: AsyncSession = Depends(get_db)):
    await PlantService.update_plant(db, plant)
    return ResponseUtil.success()

@plantController.delete('/{plant_id}')
async def delete_plant(plant_id: int, db: AsyncSession = Depends(get_db)):
    await PlantService.delete_plant(db, plant_id)
    return ResponseUtil.success()
