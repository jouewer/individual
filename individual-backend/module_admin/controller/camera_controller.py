from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.camera_service import CameraService
from module_admin.entity.vo.camera_vo import CameraQuery, CameraModel
from utils.response_util import ResponseUtil

cameraController = APIRouter(prefix='/camera')

@cameraController.get('/list')
async def list_camera(
    page_num: int = 1,
    page_size: int = 10,
    keyword: str = None,
    camera_status: str = None,
    db: AsyncSession = Depends(get_db)
):
    query_params = CameraQuery(
        page_num=page_num,
        page_size=page_size,
        keyword=keyword,
        camera_status=camera_status
    )
    result = await CameraService.get_camera_list(db, query_params, is_page=True)
    return ResponseUtil.success(model_content=result)

@cameraController.get('/{camera_id}')
async def get_camera(camera_id: str, db: AsyncSession = Depends(get_db)):
    result = await CameraService.get_camera_detail(db, camera_id)
    return ResponseUtil.success(data=result)

@cameraController.post('')
async def add_camera(camera: CameraModel, db: AsyncSession = Depends(get_db)):
    result = await CameraService.add_camera(db, camera)
    return ResponseUtil.success(data=result)

@cameraController.put('')
async def update_camera(camera: CameraModel, db: AsyncSession = Depends(get_db)):
    result = await CameraService.update_camera(db, camera)
    return ResponseUtil.success(data=result)

@cameraController.delete('/{camera_ids}')
async def delete_camera(camera_ids: str, db: AsyncSession = Depends(get_db)):
    await CameraService.delete_camera(db, camera_ids)
    return ResponseUtil.success(msg='删除成功')
