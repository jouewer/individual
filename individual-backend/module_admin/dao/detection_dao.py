from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from module_admin.entity.do.detection_do import ComprehensiveDetection
from module_admin.entity.vo.detection_vo import DetectionQuery
from utils.page_util import PageUtil

class DetectionDao:
    @classmethod
    async def get_detection_list(cls, db: AsyncSession, query: DetectionQuery, is_page: bool = False):
        stmt = select(ComprehensiveDetection)
        if query.detection_type:
            stmt = stmt.where(ComprehensiveDetection.detection_type == query.detection_type)
        if query.emotion_type:
            stmt = stmt.where(ComprehensiveDetection.emotion_type == query.emotion_type)
        if query.action_type:
            stmt = stmt.where(ComprehensiveDetection.action_type == query.action_type)
        if query.person_type:
            stmt = stmt.where(ComprehensiveDetection.person_type == query.person_type)
        if query.safety_level:
            stmt = stmt.where(ComprehensiveDetection.safety_level == query.safety_level)
        if query.event_type:
            stmt = stmt.where(ComprehensiveDetection.event_type == query.event_type)
        
        stmt = stmt.order_by(ComprehensiveDetection.detection_time.desc())
        
        return await PageUtil.paginate(db, stmt, query.page_num, query.page_size, is_page)

    @classmethod
    async def get_detection_by_id(cls, db: AsyncSession, detection_id: int):
        result = await db.execute(select(ComprehensiveDetection).where(ComprehensiveDetection.id == detection_id))
        return result.scalars().first()
