from sqlalchemy import select, delete, update
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.holiday_do import HolidaySchedule
from module_admin.entity.vo.holiday_vo import HolidayScheduleQuery
from utils.page_util import PageUtil

class HolidayDao:
    @classmethod
    async def get_holiday_list(cls, db: AsyncSession, query_object: HolidayScheduleQuery, is_page: bool = False):
        query = select(HolidaySchedule)
        
        if query_object.holiday_name:
            query = query.where(HolidaySchedule.holiday_name.like(f'%{query_object.holiday_name}%'))
        if query_object.holiday_type:
            query = query.where(HolidaySchedule.holiday_type == query_object.holiday_type)
            
        # Order by holiday_date desc
        query = query.order_by(HolidaySchedule.holiday_date.desc())
            
        return await PageUtil.paginate(db, query, query_object.page_num, query_object.page_size, is_page)

    @classmethod
    async def get_holiday_detail_by_id(cls, db: AsyncSession, holiday_id: int):
        query = select(HolidaySchedule).where(HolidaySchedule.id == holiday_id)
        result = await db.execute(query)
        return result.scalars().first()

    @classmethod
    async def add_holiday(cls, db: AsyncSession, holiday: HolidaySchedule):
        db.add(holiday)
        await db.flush()
        return holiday

    @classmethod
    async def delete_holiday_by_ids(cls, db: AsyncSession, holiday_ids: list[int]):
        query = delete(HolidaySchedule).where(HolidaySchedule.id.in_(holiday_ids))
        await db.execute(query)
        await db.flush()

    @classmethod
    async def update_holiday(cls, db: AsyncSession, holiday_id: int, holiday_data: dict):
        data_to_update = {k: v for k, v in holiday_data.items() if k not in ['id', 'create_time', 'user_id'] and v is not None}
        
        query = update(HolidaySchedule).where(HolidaySchedule.id == holiday_id).values(**data_to_update)
        await db.execute(query)
        await db.flush()
