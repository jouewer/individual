from sqlalchemy import select, update, delete, or_
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.camera_do import SxtCamera
from module_admin.entity.vo.camera_vo import CameraQuery, CameraModel
from utils.page_util import PageUtil

class CameraDao:
    @classmethod
    async def get_camera_list(cls, db: AsyncSession, query_params: CameraQuery, is_page: bool = False):
        query = select(SxtCamera).where(SxtCamera.del_flag == '0')

        if query_params.keyword:
            query = query.where(
                or_(
                    SxtCamera.lift_name.like(f'%{query_params.keyword}%'),
                    SxtCamera.camera_ip.like(f'%{query_params.keyword}%')
                )
            )
        
        if query_params.camera_status:
            query = query.where(SxtCamera.camera_status == query_params.camera_status)

        query = query.order_by(SxtCamera.create_time.desc())
        
        return await PageUtil.paginate(db, query, query_params.page_num, query_params.page_size, is_page)

    @classmethod
    async def get_camera_by_id(cls, db: AsyncSession, camera_id: str):
        query = select(SxtCamera).where(SxtCamera.id == camera_id, SxtCamera.del_flag == '0')
        result = await db.execute(query)
        return result.scalars().first()

    @classmethod
    async def add_camera(cls, db: AsyncSession, camera: CameraModel):
        db_camera = SxtCamera(**camera.model_dump(exclude_unset=True))
        db.add(db_camera)
        await db.flush()
        return db_camera

    @classmethod
    async def update_camera(cls, db: AsyncSession, camera: CameraModel):
        camera_dict = camera.model_dump(exclude_unset=True)
        if 'id' in camera_dict:
            del camera_dict['id']
        
        query = update(SxtCamera).where(SxtCamera.id == camera.id).values(**camera_dict)
        await db.execute(query)
        await db.flush()
        return camera

    @classmethod
    async def delete_camera(cls, db: AsyncSession, camera_id: str):
        query = update(SxtCamera).where(SxtCamera.id == camera_id).values(del_flag='1')
        await db.execute(query)
        await db.flush()
