from sqlalchemy import select, delete, update
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.shopping_do import HolidayShopping
from module_admin.entity.vo.shopping_vo import HolidayShoppingQuery
from utils.page_util import PageUtil

class ShoppingDao:
    @classmethod
    async def get_shopping_list(cls, db: AsyncSession, query_object: HolidayShoppingQuery, is_page: bool = False):
        query = select(HolidayShopping)
        
        if query_object.shopping_name:
            query = query.where(HolidayShopping.shopping_name.like(f'%{query_object.shopping_name}%'))
        if query_object.holiday_name:
            query = query.where(HolidayShopping.holiday_name.like(f'%{query_object.holiday_name}%'))
        if query_object.item_category:
            query = query.where(HolidayShopping.item_category == query_object.item_category)
        if query_object.purchase_status:
            query = query.where(HolidayShopping.purchase_status == query_object.purchase_status)
            
        # Order by create_time desc
        query = query.order_by(HolidayShopping.create_time.desc())
            
        return await PageUtil.paginate(db, query, query_object.page_num, query_object.page_size, is_page)

    @classmethod
    async def get_shopping_detail_by_id(cls, db: AsyncSession, shopping_id: int):
        query = select(HolidayShopping).where(HolidayShopping.id == shopping_id)
        result = await db.execute(query)
        return result.scalars().first()

    @classmethod
    async def add_shopping(cls, db: AsyncSession, shopping: HolidayShopping):
        db.add(shopping)
        await db.flush()
        return shopping

    @classmethod
    async def update_shopping(cls, db: AsyncSession, shopping_id: int, update_data: dict):
        query = update(HolidayShopping).where(HolidayShopping.id == shopping_id).values(**update_data)
        await db.execute(query)
        await db.flush()

    @classmethod
    async def delete_shopping(cls, db: AsyncSession, shopping_id: int):
        query = delete(HolidayShopping).where(HolidayShopping.id == shopping_id)
        await db.execute(query)
        await db.flush()
