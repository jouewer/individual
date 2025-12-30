from sqlalchemy import select, delete, update
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.food_do import FoodDiaries
from module_admin.entity.vo.food_vo import FoodDiariesQuery
from utils.page_util import PageUtil

class FoodDao:
    @classmethod
    async def get_food_list(cls, db: AsyncSession, query_object: FoodDiariesQuery, is_page: bool = False):
        query = select(FoodDiaries)
        
        if query_object.food_name:
            query = query.where(FoodDiaries.food_name.like(f'%{query_object.food_name}%'))
        if query_object.food_category:
            query = query.where(FoodDiaries.food_category == query_object.food_category)
        if query_object.meal_time:
            query = query.where(FoodDiaries.meal_time == query_object.meal_time)
        if query_object.record_date:
            query = query.where(FoodDiaries.record_date == query_object.record_date)
            
        query = query.order_by(FoodDiaries.record_date.desc(), FoodDiaries.id.desc())
            
        return await PageUtil.paginate(db, query, query_object.pageNum, query_object.pageSize, is_page)

    @classmethod
    async def get_food_detail_by_id(cls, db: AsyncSession, food_id: int):
        query = select(FoodDiaries).where(FoodDiaries.id == food_id)
        result = await db.execute(query)
        return result.scalars().first()

    @classmethod
    async def add_food(cls, db: AsyncSession, food: FoodDiaries):
        db.add(food)
        await db.flush()
        return food

    @classmethod
    async def delete_food_by_ids(cls, db: AsyncSession, food_ids: list[int]):
        query = delete(FoodDiaries).where(FoodDiaries.id.in_(food_ids))
        await db.execute(query)
        await db.flush()

    @classmethod
    async def update_food(cls, db: AsyncSession, food_id: int, food_data: dict):
        data_to_update = {k: v for k, v in food_data.items() if k not in ['id', 'create_time', 'user_id']}
        query = update(FoodDiaries).where(FoodDiaries.id == food_id).values(**data_to_update)
        await db.execute(query)
        await db.flush()
