from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete, func
from module_admin.entity.do.device_do import ElectronicDevice
from module_admin.entity.vo.device_vo import DeviceQuery, DeviceUpdate, DeviceCreate
from utils.page_util import PageUtil

class DeviceDao:
    @classmethod
    async def get_device_list(cls, db: AsyncSession, query: DeviceQuery, is_page: bool = False):
        stmt = select(ElectronicDevice)
        if query.device_name:
            stmt = stmt.where(ElectronicDevice.device_name.like(f'%{query.device_name}%'))
        if query.device_type:
            stmt = stmt.where(ElectronicDevice.device_type == query.device_type)
        if query.device_status:
            stmt = stmt.where(ElectronicDevice.device_status == query.device_status)
        
        stmt = stmt.order_by(ElectronicDevice.create_time.desc())
        
        return await PageUtil.paginate(db, stmt, query.page_num, query.page_size, is_page)

    @classmethod
    async def get_device_by_id(cls, db: AsyncSession, device_id: int):
        result = await db.execute(select(ElectronicDevice).where(ElectronicDevice.id == device_id))
        return result.scalars().first()

    @classmethod
    async def add_device(cls, db: AsyncSession, device: ElectronicDevice):
        db.add(device)
        await db.flush()
        return device

    @classmethod
    async def update_device(cls, db: AsyncSession, device: DeviceUpdate):
        stmt = update(ElectronicDevice).where(ElectronicDevice.id == device.id).values(**device.model_dump(exclude={'id'}, exclude_none=True))
        await db.execute(stmt)

    @classmethod
    async def delete_device(cls, db: AsyncSession, device_ids: list[int]):
        await db.execute(delete(ElectronicDevice).where(ElectronicDevice.id.in_(device_ids)))
