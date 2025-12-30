from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.camera_dao import CameraDao
from module_admin.entity.vo.camera_vo import CameraQuery, CameraModel
from utils.common_util import CamelCaseUtil
from uuid import uuid4

class CameraService:
    @classmethod
    async def get_camera_list(cls, db: AsyncSession, query_params: CameraQuery, is_page: bool = False):
        return await CameraDao.get_camera_list(db, query_params, is_page)

    @classmethod
    async def get_camera_detail(cls, db: AsyncSession, camera_id: str):
        camera = await CameraDao.get_camera_by_id(db, camera_id)
        return CamelCaseUtil.transform_result(camera)

    @classmethod
    async def add_camera(cls, db: AsyncSession, camera: CameraModel):
        if not camera.id:
            camera.id = str(uuid4())
        await CameraDao.add_camera(db, camera)
        return CamelCaseUtil.transform_result(camera)

    @classmethod
    async def update_camera(cls, db: AsyncSession, camera: CameraModel):
        await CameraDao.update_camera(db, camera)
        return CamelCaseUtil.transform_result(camera)

    @classmethod
    async def delete_camera(cls, db: AsyncSession, camera_ids: str):
        ids = camera_ids.split(',')
        for camera_id in ids:
            await CameraDao.delete_camera(db, camera_id)
