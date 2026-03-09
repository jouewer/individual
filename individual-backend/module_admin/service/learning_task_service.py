from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.learning_task_dao import LearningTaskDao
from module_admin.entity.vo.learning_task_vo import LearningTaskQuery, LearningTaskCreate, LearningTaskUpdate, LearningTaskModel
from utils.response_util import ResponseUtil

class LearningTaskService:
    @classmethod
    async def get_task_list(cls, db: AsyncSession, query: LearningTaskQuery):
        """
        获取学习任务列表
        """
        tasks = await LearningTaskDao.get_task_list(db, query)
        return ResponseUtil.success(model_content=tasks)

    @classmethod
    async def get_task_detail(cls, db: AsyncSession, task_id: int):
        """
        获取学习任务详情
        """
        task = await LearningTaskDao.get_task_detail(db, task_id)
        if not task:
            return ResponseUtil.error(msg="任务不存在")
        return ResponseUtil.success(data=LearningTaskModel.model_validate(task))

    @classmethod
    async def create_task(cls, db: AsyncSession, task: LearningTaskCreate, user_id: int):
        """
        创建学习任务
        """
        try:
            new_task = await LearningTaskDao.create_task(db, task, user_id)
            await db.commit()
            return ResponseUtil.success(data=new_task)
        except Exception as e:
            await db.rollback()
            return ResponseUtil.error(msg=f"创建失败: {str(e)}")

    @classmethod
    async def update_task(cls, db: AsyncSession, task: LearningTaskUpdate):
        """
        更新学习任务
        """
        try:
            existing_task = await LearningTaskDao.get_task_detail(db, task.id)
            if not existing_task:
                return ResponseUtil.error(msg="任务不存在")
            
            updated_task = await LearningTaskDao.update_task(db, task)
            await db.commit()
            return ResponseUtil.success(data=updated_task)
        except Exception as e:
            await db.rollback()
            return ResponseUtil.error(msg=f"更新失败: {str(e)}")

    @classmethod
    async def delete_task(cls, db: AsyncSession, task_id: int):
        """
        删除学习任务
        """
        try:
            existing_task = await LearningTaskDao.get_task_detail(db, task_id)
            if not existing_task:
                return ResponseUtil.error(msg="任务不存在")
                
            await LearningTaskDao.delete_task(db, task_id)
            await db.commit()
            return ResponseUtil.success(msg="删除成功")
        except Exception as e:
            await db.rollback()
            return ResponseUtil.error(msg=f"删除失败: {str(e)}")
