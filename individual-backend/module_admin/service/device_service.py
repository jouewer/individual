from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.device_dao import DeviceDao
from module_admin.entity.do.device_do import ElectronicDevice
from module_admin.entity.vo.device_vo import DeviceQuery, DeviceCreate, DeviceUpdate, DeviceModel
from utils.response_util import ResponseUtil
from utils.common_util import CamelCaseUtil

class DeviceService:
    @classmethod
    async def get_device_list(cls, db: AsyncSession, query: DeviceQuery):
        result = await DeviceDao.get_device_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_device_detail(cls, db: AsyncSession, device_id: int):
        device = await DeviceDao.get_device_by_id(db, device_id)
        return device

    @classmethod
    async def add_device(cls, db: AsyncSession, device_in: DeviceCreate, current_user):
        device = ElectronicDevice(**device_in.model_dump())
        device.user_id = current_user.user_id
        await DeviceDao.add_device(db, device)
        return device

    @classmethod
    async def update_device(cls, db: AsyncSession, device_in: DeviceUpdate):
        await DeviceDao.update_device(db, device_in)
        return device_in

    @classmethod
    async def delete_device(cls, db: AsyncSession, device_ids: str):
        ids = [int(i) for i in device_ids.split(',')]
        await DeviceDao.delete_device(db, ids)
