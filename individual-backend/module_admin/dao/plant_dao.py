from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete, func
from module_admin.entity.do.plant_do import PlantGrowth
from module_admin.entity.vo.plant_vo import PlantModel, PlantQuery
from utils.page_util import PageUtil

class PlantDao:
    @classmethod
    async def get_plant_by_id(cls, db: AsyncSession, plant_id: int):
        query = select(PlantGrowth).where(PlantGrowth.id == plant_id)
        result = await db.execute(query)
        return result.scalars().first()

    @classmethod
    async def get_plant_list(cls, db: AsyncSession, query_object: PlantQuery, is_page: bool = False):
        query = select(PlantGrowth)
        
        if query_object.plant_name:
            query = query.where(PlantGrowth.plant_name.like(f'%{query_object.plant_name}%'))
        if query_object.plant_type:
            query = query.where(PlantGrowth.plant_type == query_object.plant_type)
        if query_object.growth_stage:
            query = query.where(PlantGrowth.growth_stage == query_object.growth_stage)
        if query_object.health_status:
            query = query.where(PlantGrowth.health_status == query_object.health_status)
        
        query = query.order_by(PlantGrowth.create_time.desc())
        
        return await PageUtil.paginate(db, query, query_object.page_num, query_object.page_size, is_page)

    @classmethod
    async def add_plant(cls, db: AsyncSession, plant: PlantModel):
        db_plant = PlantGrowth(**plant.model_dump(exclude={'id', 'create_time', 'update_time'}))
        db.add(db_plant)
        await db.flush()
        return db_plant

    @classmethod
    async def update_plant(cls, db: AsyncSession, plant: PlantModel):
        plant_dict = plant.model_dump(exclude={'create_time', 'update_time'}, exclude_unset=True)
        query = update(PlantGrowth).where(PlantGrowth.id == plant.id).values(**plant_dict)
        await db.execute(query)
        await db.flush()

    @classmethod
    async def delete_plant(cls, db: AsyncSession, plant_id: int):
        query = delete(PlantGrowth).where(PlantGrowth.id == plant_id)
        await db.execute(query)
        await db.flush()
