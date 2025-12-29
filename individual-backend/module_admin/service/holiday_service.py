from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.holiday_dao import HolidayDao
from module_admin.entity.do.holiday_do import HolidaySchedule
from module_admin.entity.vo.holiday_vo import HolidayScheduleQuery, HolidayScheduleCreate, HolidayScheduleUpdate
from utils.response_util import ResponseUtil
from datetime import datetime

class HolidayService:
    @classmethod
    async def get_holiday_list(cls, query: HolidayScheduleQuery, db: AsyncSession):
        result = await HolidayDao.get_holiday_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_holiday_detail(cls, holiday_id: int, db: AsyncSession):
        holiday = await HolidayDao.get_holiday_detail_by_id(db, holiday_id)
        if holiday:
            return ResponseUtil.success(data=holiday)
        return ResponseUtil.failure(msg="Holiday schedule not found")

    @classmethod
    async def add_holiday(cls, holiday_create: HolidayScheduleCreate, db: AsyncSession, current_user):
        new_holiday = HolidaySchedule(
            user_id=current_user.user.user_id,
            holiday_name=holiday_create.holiday_name,
            schedule_title=holiday_create.schedule_title,
            holiday_date=holiday_create.holiday_date,
            start_time=holiday_create.start_time,
            end_time=holiday_create.end_time,
            holiday_type=holiday_create.holiday_type,
            schedule_type=holiday_create.schedule_type,
            location_name=holiday_create.location_name,
            address=holiday_create.address,
            latitude=holiday_create.latitude,
            all_day=holiday_create.all_day,
            duration_minutes=holiday_create.duration_minutes,
            create_time=datetime.now(),
            update_time=datetime.now()
        )
        
        try:
            await HolidayDao.add_holiday(db, new_holiday)
            await db.commit()
            return ResponseUtil.success(msg="Added successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def update_holiday(cls, holiday_update: HolidayScheduleUpdate, db: AsyncSession):
        try:
            await HolidayDao.update_holiday(db, holiday_update.id, holiday_update.model_dump(exclude_unset=True))
            await db.commit()
            return ResponseUtil.success(msg="Updated successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def delete_holiday(cls, holiday_ids: str, db: AsyncSession):
        ids = [int(i) for i in holiday_ids.split(',')]
        try:
            await HolidayDao.delete_holiday_by_ids(db, ids)
            await db.commit()
            return ResponseUtil.success(msg="Deleted successfully")
        except Exception as e:
            await db.rollback()
            raise e
