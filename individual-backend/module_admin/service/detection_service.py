from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.detection_dao import DetectionDao
from module_admin.entity.vo.detection_vo import DetectionQuery
from utils.response_util import ResponseUtil

class DetectionService:
    @classmethod
    async def get_detection_list(cls, db: AsyncSession, query: DetectionQuery):
        result = await DetectionDao.get_detection_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_detection_detail(cls, db: AsyncSession, detection_id: int):
        detection = await DetectionDao.get_detection_by_id(db, detection_id)
        return detection
