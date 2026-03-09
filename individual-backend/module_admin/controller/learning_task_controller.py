from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Optional
from config.get_db import get_db
from module_admin.service.learning_task_service import LearningTaskService
from module_admin.entity.vo.learning_task_vo import LearningTaskQuery, LearningTaskCreate, LearningTaskUpdate
from utils.response_util import ResponseUtil

learning_task_controller = APIRouter(prefix='/learning/task', tags=['学习任务管理'])

@learning_task_controller.get("/list")
async def get_task_list(
    task_name: Optional[str] = Query(None, alias="taskName"),
    learning_area: Optional[str] = Query(None, alias="learningArea"),
    task_status: Optional[str] = Query(None, alias="taskStatus"),
    is_active: Optional[bool] = Query(None, alias="isActive"),
    page_num: int = Query(1, alias="pageNum"),
    page_size: int = Query(10, alias="pageSize"),
    db: AsyncSession = Depends(get_db)
):
    query = LearningTaskQuery(
        task_name=task_name,
        learning_area=learning_area,
        task_status=task_status,
        is_active=is_active,
        page_num=page_num,
        page_size=page_size
    )
    return await LearningTaskService.get_task_list(db, query)

@learning_task_controller.get("/{taskId}")
async def get_task_detail(taskId: int, db: AsyncSession = Depends(get_db)):
    return await LearningTaskService.get_task_detail(db, taskId)

@learning_task_controller.post("")
async def create_task(task: LearningTaskCreate, db: AsyncSession = Depends(get_db)):
    # Assuming user_id is 1 for now, or extract from token if auth implemented
    user_id = 1 
    return await LearningTaskService.create_task(db, task, user_id)

@learning_task_controller.put("")
async def update_task(task: LearningTaskUpdate, db: AsyncSession = Depends(get_db)):
    return await LearningTaskService.update_task(db, task)

@learning_task_controller.delete("/{taskId}")
async def delete_task(taskId: int, db: AsyncSession = Depends(get_db)):
    return await LearningTaskService.delete_task(db, taskId)
