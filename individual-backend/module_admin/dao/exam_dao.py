from sqlalchemy import select, update, delete
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.exam_do import ComprehensiveExam
from module_admin.entity.vo.exam_vo import ExamQuery, ExamCreate, ExamUpdate
from utils.page_util import PageUtil

class ExamDao:
    
    @classmethod
    async def get_exam_list(cls, db: AsyncSession, query: ExamQuery):
        stmt = select(ComprehensiveExam)
        
        if query.record_type:
            stmt = stmt.where(ComprehensiveExam.record_type == query.record_type)
        if query.exam_name:
            stmt = stmt.where(ComprehensiveExam.exam_name.like(f'%{query.exam_name}%'))
        if query.exam_subject:
            stmt = stmt.where(ComprehensiveExam.exam_subject.like(f'%{query.exam_subject}%'))
        if query.is_active is not None:
            stmt = stmt.where(ComprehensiveExam.is_active == query.is_active)
            
        stmt = stmt.order_by(ComprehensiveExam.create_time.desc())
        
        return await PageUtil.paginate(db, stmt, query.page_num, query.page_size, is_page=True)

    @classmethod
    async def get_exam_detail(cls, db: AsyncSession, exam_id: int):
        stmt = select(ComprehensiveExam).where(ComprehensiveExam.id == exam_id)
        result = await db.execute(stmt)
        return result.scalars().first()

    @classmethod
    async def create_exam(cls, db: AsyncSession, exam: ExamCreate, user_id: int):
        exam_data = exam.model_dump(exclude_unset=True)
        exam_data['user_id'] = user_id
        
        new_exam = ComprehensiveExam(**exam_data)
        db.add(new_exam)
        await db.flush()
        return new_exam

    @classmethod
    async def update_exam(cls, db: AsyncSession, exam: ExamUpdate):
        update_values = exam.model_dump(exclude={'id'}, exclude_unset=True)
        
        stmt = update(ComprehensiveExam).where(ComprehensiveExam.id == exam.id).values(
            **update_values
        ).execution_options(synchronize_session="fetch")
        
        await db.execute(stmt)
        return await cls.get_exam_detail(db, exam.id)

    @classmethod
    async def delete_exam(cls, db: AsyncSession, exam_id: int):
        stmt = delete(ComprehensiveExam).where(ComprehensiveExam.id == exam_id)
        await db.execute(stmt)
