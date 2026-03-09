from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.exam_dao import ExamDao
from module_admin.entity.do.exam_do import ComprehensiveExam
from module_admin.entity.vo.exam_vo import ExamQuery, ExamCreate, ExamUpdate, ExamModel
from utils.response_util import ResponseUtil
from datetime import datetime

class ExamService:
    @classmethod
    async def get_exam_list(cls, db: AsyncSession, query: ExamQuery):
        """
        获取考试列表
        """
        exams = await ExamDao.get_exam_list(db, query)
        return ResponseUtil.success(model_content=exams)

    @classmethod
    async def get_exam_detail(cls, db: AsyncSession, exam_id: int):
        """
        获取考试详情
        """
        exam = await ExamDao.get_exam_detail(db, exam_id)
        if not exam:
            return ResponseUtil.error(msg="考试不存在")
        # Transform SQLAlchemy object to Pydantic model to ensure camelCase keys
        return ResponseUtil.success(data=ExamModel.model_validate(exam))

    @classmethod
    async def create_exam(cls, db: AsyncSession, exam: ExamCreate, user_id: int):
        """
        创建考试
        """
        try:
            new_exam = await ExamDao.create_exam(db, exam, user_id)
            await db.commit()
            return ResponseUtil.success(data=new_exam)
        except Exception as e:
            await db.rollback()
            return ResponseUtil.error(msg=f"创建失败: {str(e)}")

    @classmethod
    async def update_exam(cls, db: AsyncSession, exam: ExamUpdate):
        """
        更新考试
        """
        try:
            existing_exam = await ExamDao.get_exam_detail(db, exam.id)
            if not existing_exam:
                return ResponseUtil.error(msg="考试不存在")
            
            updated_exam = await ExamDao.update_exam(db, exam)
            await db.commit()
            return ResponseUtil.success(data=updated_exam)
        except Exception as e:
            await db.rollback()
            return ResponseUtil.error(msg=f"更新失败: {str(e)}")

    @classmethod
    async def delete_exam(cls, db: AsyncSession, exam_id: int):
        """
        删除考试
        """
        try:
            existing_exam = await ExamDao.get_exam_detail(db, exam_id)
            if not existing_exam:
                return ResponseUtil.error(msg="考试不存在")
                
            await db.delete(existing_exam)
            await db.commit()
            return ResponseUtil.success(msg="删除成功")
        except Exception as e:
            await db.rollback()
            return ResponseUtil.error(msg=f"删除失败: {str(e)}")
