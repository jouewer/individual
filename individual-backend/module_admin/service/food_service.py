from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.food_dao import FoodDao
from module_admin.entity.do.food_do import FoodDiaries
from module_admin.entity.vo.food_vo import FoodDiariesQuery, FoodDiariesCreate, FoodDiariesUpdate
from utils.response_util import ResponseUtil
from datetime import datetime

class FoodService:
    @classmethod
    async def get_food_list(cls, query: FoodDiariesQuery, db: AsyncSession):
        result = await FoodDao.get_food_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_food_detail(cls, food_id: int, db: AsyncSession):
        food = await FoodDao.get_food_detail_by_id(db, food_id)
        if food:
            return ResponseUtil.success(data=food)
        return ResponseUtil.failure(msg="Food diary not found")

    @classmethod
    async def add_food(cls, food_create: FoodDiariesCreate, db: AsyncSession, current_user):
        new_food = FoodDiaries(
            user_id=current_user.user.user_id,
            **food_create.model_dump(),
            create_time=datetime.now(),
            update_time=datetime.now()
        )
        
        try:
            await FoodDao.add_food(db, new_food)
            await db.commit()
            return ResponseUtil.success(msg="Added successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def update_food(cls, food_update: FoodDiariesUpdate, db: AsyncSession):
        try:
            await FoodDao.update_food(db, food_update.id, food_update.model_dump(exclude_unset=True))
            await db.commit()
            return ResponseUtil.success(msg="Updated successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def delete_food(cls, food_ids: str, db: AsyncSession):
        ids = [int(i) for i in food_ids.split(',')]
        try:
            await FoodDao.delete_food_by_ids(db, ids)
            await db.commit()
            return ResponseUtil.success(msg="Deleted successfully")
        except Exception as e:
            await db.rollback()
            raise e
