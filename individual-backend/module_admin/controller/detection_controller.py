from fastapi import APIRouter, Depends, Request
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.login_service import LoginService, CurrentUserModel
from module_admin.service.detection_service import DetectionService
from module_admin.entity.vo.detection_vo import DetectionQuery
from utils.response_util import ResponseUtil

detectionController = APIRouter(prefix='/action', tags=['综合检测模块'])

@detectionController.get('/list', response_model=None)
async def get_detection_list(
    request: Request,
    query: DetectionQuery = Depends(),
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await DetectionService.get_detection_list(db, query)

@detectionController.get('/{detection_id}', response_model=None)
async def get_detection_detail(
    request: Request,
    detection_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    result = await DetectionService.get_detection_detail(db, detection_id)
    return ResponseUtil.success(data=result)
