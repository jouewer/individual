from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.plant_dao import PlantDao
from module_admin.entity.vo.plant_vo import PlantModel, PlantQuery
from utils.common_util import CamelCaseUtil

class PlantService:
    @classmethod
    async def get_plant_list(cls, db: AsyncSession, query_object: PlantQuery, is_page: bool = False):
        plant_list = await PlantDao.get_plant_list(db, query_object, is_page)
        return CamelCaseUtil.transform_result(plant_list)

    @classmethod
    async def get_plant_detail(cls, db: AsyncSession, plant_id: int):
        plant = await PlantDao.get_plant_by_id(db, plant_id)
        return CamelCaseUtil.transform_result(plant)

    @classmethod
    async def add_plant(cls, db: AsyncSession, plant: PlantModel):
        await PlantDao.add_plant(db, plant)
        await db.commit()
        return True

    @classmethod
    async def update_plant(cls, db: AsyncSession, plant: PlantModel):
        await PlantDao.update_plant(db, plant)
        await db.commit()
        return True

    @classmethod
    async def delete_plant(cls, db: AsyncSession, plant_id: int):
        await PlantDao.delete_plant(db, plant_id)
        await db.commit()
        return True
