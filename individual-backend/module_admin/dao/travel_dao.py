from sqlalchemy import select, delete
from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.entity.do.travel_do import TravelFootprint
from module_admin.entity.vo.travel_vo import TravelFootprintQuery
from utils.page_util import PageUtil

class TravelDao:
    @classmethod
    async def get_travel_list(cls, db: AsyncSession, query_object: TravelFootprintQuery, is_page: bool = False):
        query = select(TravelFootprint)
        
        if query_object.city:
            query = query.where(TravelFootprint.city.like(f'%{query_object.city}%'))
        if query_object.country:
            query = query.where(TravelFootprint.country.like(f'%{query_object.country}%'))
            
        # Order by id desc to show newest created first
        query = query.order_by(TravelFootprint.id.desc())
            
        return await PageUtil.paginate(db, query, query_object.page_num, query_object.page_size, is_page)

    @classmethod
    async def get_travel_detail_by_id(cls, db: AsyncSession, travel_id: int):
        query = select(TravelFootprint).where(TravelFootprint.id == travel_id)
        result = await db.execute(query)
        return result.scalars().first()

    @classmethod
    async def add_travel(cls, db: AsyncSession, travel: TravelFootprint):
        db.add(travel)
        await db.flush()
        return travel

    @classmethod
    async def delete_travel_by_ids(cls, db: AsyncSession, travel_ids: list[int]):
        query = delete(TravelFootprint).where(TravelFootprint.id.in_(travel_ids))
        await db.execute(query)
        await db.flush()

    @classmethod
    async def update_travel(cls, db: AsyncSession, travel_id: int, travel_data: dict):
        # Exclude None values to allow partial updates if needed, though usually we pass full object
        # But here we want to update what's passed
        # Ensure update_time is updated
        # SQLAlchemy model onupdate handles update_time usually, but let's be safe or rely on model
        
        # We need to fetch the object first to update it or use update statement
        # Using update statement for efficiency
        # Filter out 'id', 'create_time', 'user_id' from travel_data to prevent changing them if passed
        
        from sqlalchemy import update
        
        data_to_update = {k: v for k, v in travel_data.items() if k not in ['id', 'create_time', 'user_id']}
        
        query = update(TravelFootprint).where(TravelFootprint.id == travel_id).values(**data_to_update)
        await db.execute(query)
        await db.flush()
