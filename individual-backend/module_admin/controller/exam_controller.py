from fastapi import APIRouter, Depends, Request
from sqlalchemy.ext.asyncio import AsyncSession
from config.get_db import get_db
from module_admin.service.login_service import LoginService, CurrentUserModel
from module_admin.service.exam_service import ExamService
from module_admin.entity.vo.exam_vo import ExamQuery, ExamCreate, ExamUpdate
from utils.response_util import ResponseUtil

examController = APIRouter(prefix='/monitor/exam', tags=['综合考试模块'])

@examController.get('/list')
async def get_exam_list(
    request: Request,
    query: ExamQuery = Depends(),
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ExamService.get_exam_list(db, query)

@examController.get('/{exam_id}')
async def get_exam_detail(
    request: Request,
    exam_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ExamService.get_exam_detail(db, exam_id)

@examController.post('')
async def create_exam(
    request: Request,
    exam: ExamCreate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ExamService.create_exam(db, exam, current_user.user.user_id)

@examController.put('')
async def update_exam(
    request: Request,
    exam: ExamUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ExamService.update_exam(db, exam)

@examController.delete('/{exam_id}')
async def delete_exam(
    request: Request,
    exam_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: CurrentUserModel = Depends(LoginService.get_current_user)
):
    return await ExamService.delete_exam(db, exam_id)
