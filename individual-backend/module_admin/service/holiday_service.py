from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.holiday_dao import HolidayDao
from module_admin.entity.do.holiday_do import HolidaySchedule
from module_admin.entity.vo.holiday_vo import HolidayScheduleQuery, HolidayScheduleCreate, HolidayScheduleUpdate, HolidayScheduleModel
from utils.response_util import ResponseUtil
from datetime import datetime
import json

class HolidayService:
    @staticmethod
    def _ensure_json_list(value):
        """
        Ensure the value is a valid JSON list string.
        If it's a comma-separated string, convert to JSON list.
        """
        if not value:
            return None
        try:
            # Try parsing as JSON first
            parsed = json.loads(value)
            if isinstance(parsed, list):
                return value
            # If valid JSON but not a list (e.g. quoted string), wrap in list?
            # Or assume it's just a value that should be in a list?
            return json.dumps([parsed], ensure_ascii=False)
        except (json.JSONDecodeError, TypeError):
            # Not valid JSON, assume comma-separated string
            if isinstance(value, str):
                items = [item.strip() for item in value.split(',') if item.strip()]
                return json.dumps(items, ensure_ascii=False)
            return value

    @classmethod
    async def get_holiday_list(cls, query: HolidayScheduleQuery, db: AsyncSession):
        result = await HolidayDao.get_holiday_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_holiday_detail(cls, holiday_id: int, db: AsyncSession):
        holiday = await HolidayDao.get_holiday_detail_by_id(db, holiday_id)
        if holiday:
            return ResponseUtil.success(data=HolidayScheduleModel.model_validate(holiday))
        return ResponseUtil.failure(msg="Holiday schedule not found")

    @classmethod
    async def add_holiday(cls, holiday_create: HolidayScheduleCreate, db: AsyncSession, current_user):
        data = holiday_create.model_dump()
        json_fields = ['shopping_list', 'required_items', 'participants', 'images', 'videos', 'recipes', 'documents', 'highlights', 'tags', 'share_with', 'checklist']
        
        for field in json_fields:
            if field in data:
                data[field] = cls._ensure_json_list(data[field])

        data['user_id'] = current_user.user.user_id
        data['create_time'] = datetime.now()
        data['update_time'] = datetime.now()
        
        new_holiday = HolidaySchedule(**data)
        
        try:
            await HolidayDao.add_holiday(db, new_holiday)
            await db.commit()
            return ResponseUtil.success(msg="Added successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def update_holiday(cls, holiday_update: HolidayScheduleUpdate, db: AsyncSession):
        update_data = holiday_update.model_dump(exclude_unset=True)
        json_fields = ['shopping_list', 'required_items', 'participants', 'images', 'videos', 'recipes', 'documents', 'highlights', 'tags', 'share_with', 'checklist']
        
        for field in json_fields:
            if field in update_data:
                update_data[field] = cls._ensure_json_list(update_data[field])

        try:
            await HolidayDao.update_holiday(db, holiday_update.id, update_data)
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
