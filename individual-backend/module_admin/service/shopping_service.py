from datetime import datetime
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.shopping_dao import ShoppingDao
from module_admin.entity.do.shopping_do import HolidayShopping
from module_admin.entity.vo.shopping_vo import HolidayShoppingModel, HolidayShoppingCreate, HolidayShoppingUpdate, HolidayShoppingQuery
from utils.response_util import ResponseUtil

class ShoppingService:
    @classmethod
    async def get_shopping_list(cls, query: HolidayShoppingQuery, db: AsyncSession):
        result = await ShoppingDao.get_shopping_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_shopping_detail(cls, shopping_id: int, db: AsyncSession):
        shopping = await ShoppingDao.get_shopping_detail_by_id(db, shopping_id)
        if shopping:
            return ResponseUtil.success(data=HolidayShoppingModel.model_validate(shopping))
        return ResponseUtil.failure(msg="Shopping item not found")

    @classmethod
    async def add_shopping(cls, shopping_create: HolidayShoppingCreate, db: AsyncSession, current_user):
        data = shopping_create.model_dump()
        data['user_id'] = current_user.user.user_id
        
        # Calculate total spent if not provided
        if not data.get('total_spent'):
             price = data.get('actual_price') or data.get('expected_price')
             quantity = data.get('quantity')
             if price is not None and quantity is not None:
                 data['total_spent'] = price * quantity
            
        new_shopping = HolidayShopping(**data)
        
        try:
            await ShoppingDao.add_shopping(db, new_shopping)
            await db.commit()
            return ResponseUtil.success(msg="Added successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def update_shopping(cls, shopping_update: HolidayShoppingUpdate, db: AsyncSession):
        update_data = shopping_update.model_dump(exclude_unset=True)
        
        # Recalculate total spent if price or quantity changes
        if 'actual_price' in update_data or 'quantity' in update_data:
            # We might need to fetch existing values if one is missing, but for now let's assume if they want to update calculation they send both or we trust client's total_spent
            # If total_spent is not in update_data, we try to calculate
            if 'total_spent' not in update_data:
                price = update_data.get('actual_price')
                quantity = update_data.get('quantity')
                if price is not None and quantity is not None:
                     update_data['total_spent'] = price * quantity

        try:
            await ShoppingDao.update_shopping(db, shopping_update.id, update_data)
            await db.commit()
            return ResponseUtil.success(msg="Updated successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def delete_shopping(cls, shopping_id: int, db: AsyncSession):
        try:
            await ShoppingDao.delete_shopping(db, shopping_id)
            await db.commit()
            return ResponseUtil.success(msg="Deleted successfully")
        except Exception as e:
            await db.rollback()
            raise e
