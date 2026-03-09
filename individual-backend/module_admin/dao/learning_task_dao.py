from sqlalchemy import select, update, delete, func
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.learning_task_do import LearningTask
from module_admin.entity.vo.learning_task_vo import LearningTaskQuery, LearningTaskCreate, LearningTaskUpdate
from utils.page_util import PageUtil

class LearningTaskDao:
    
    @classmethod
    async def get_task_list(cls, db: AsyncSession, query: LearningTaskQuery):
        stmt = select(LearningTask)
        
        if query.task_name:
            stmt = stmt.where(LearningTask.task_name.like(f'%{query.task_name}%'))
        if query.learning_area:
            stmt = stmt.where(LearningTask.learning_area == query.learning_area)
        if query.task_status:
            stmt = stmt.where(LearningTask.task_status == query.task_status)
        if query.is_active is not None:
            stmt = stmt.where(LearningTask.is_active == query.is_active)
            
        stmt = stmt.order_by(LearningTask.create_time.desc())
        
        return await PageUtil.paginate(db, stmt, query.page_num, query.page_size, is_page=True)

    @classmethod
    async def get_task_detail(cls, db: AsyncSession, task_id: int):
        stmt = select(LearningTask).where(LearningTask.id == task_id)
        result = await db.execute(stmt)
        return result.scalars().first()

    @classmethod
    async def create_task(cls, db: AsyncSession, task: LearningTaskCreate, user_id: int):
        task_data = task.model_dump(exclude_unset=True)
        task_data['user_id'] = user_id
        
        new_task = LearningTask(**task_data)
        db.add(new_task)
        await db.flush()
        return new_task

    @classmethod
    async def update_task(cls, db: AsyncSession, task: LearningTaskUpdate):
        update_values = task.model_dump(exclude={'id'}, exclude_unset=True)
        
        stmt = update(LearningTask).where(LearningTask.id == task.id).values(
            **update_values
        ).execution_options(synchronize_session="fetch")
        
        await db.execute(stmt)
        return await cls.get_task_detail(db, task.id)

    @classmethod
    async def delete_task(cls, db: AsyncSession, task_id: int):
        stmt = delete(LearningTask).where(LearningTask.id == task_id)
        await db.execute(stmt)
