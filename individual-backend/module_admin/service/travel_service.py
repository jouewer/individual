from sqlalchemy.ext.asyncio import AsyncSession
from module_admin.dao.travel_dao import TravelDao
from module_admin.entity.do.travel_do import TravelFootprint
from module_admin.entity.vo.travel_vo import TravelFootprintQuery, TravelFootprintCreate, TravelFootprintUpdate
from utils.response_util import ResponseUtil
from datetime import datetime

class TravelService:
    @classmethod
    async def get_travel_list(cls, query: TravelFootprintQuery, db: AsyncSession):
        result = await TravelDao.get_travel_list(db, query, is_page=True)
        return ResponseUtil.success(model_content=result)

    @classmethod
    async def get_travel_detail(cls, travel_id: int, db: AsyncSession):
        travel = await TravelDao.get_travel_detail_by_id(db, travel_id)
        if travel:
            return ResponseUtil.success(data=travel)
        return ResponseUtil.failure(msg="Travel footprint not found")

    @classmethod
    async def add_travel(cls, travel_create: TravelFootprintCreate, db: AsyncSession, current_user):
        # Default logic for required fields
        new_travel = TravelFootprint(
            user_id=current_user.user.user_id,
            city=travel_create.city,
            country=travel_create.country,
            visit_date=travel_create.visit_date,
            description=travel_create.description,
            cover_image=travel_create.cover_image,
            # Defaults
            title=travel_create.title or f"{travel_create.city} Trip",
            location_name=travel_create.location_name or travel_create.city,
            address=travel_create.address or travel_create.city,
            province=travel_create.province or travel_create.city,
            district=travel_create.district or travel_create.city,
            # Full fields
            geohash=travel_create.geohash,
            start_time=travel_create.start_time,
            end_time=travel_create.end_time,
            duration=travel_create.duration,
            timezone=travel_create.timezone,
            images=travel_create.images,
            videos=travel_create.videos,
            audio_notes=travel_create.audio_notes,
            travel_type=travel_create.travel_type or '自由行',
            tags=travel_create.tags,
            season=travel_create.season or '未知',
            weather=travel_create.weather,
            rating=travel_create.rating,
            mood=travel_create.mood,
            recommend_level=travel_create.recommend_level,
            cost_level=travel_create.cost_level,
            companions=travel_create.companions,
            transportation=travel_create.transportation,
            accommodation=travel_create.accommodation,
            notes=travel_create.notes,
            is_public=travel_create.is_public if travel_create.is_public is not None else 1,
            status=travel_create.status or '已完成',
            privacy_level=travel_create.privacy_level if travel_create.privacy_level is not None else 1,
            favorite_count=travel_create.favorite_count or 0,
            view_count=travel_create.view_count or 0,
            
            create_time=datetime.now(),
            update_time=datetime.now()
        )
        
        try:
            await TravelDao.add_travel(db, new_travel)
            await db.commit()
            return ResponseUtil.success(msg="Added successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def update_travel(cls, travel_update: TravelFootprintUpdate, db: AsyncSession):
        try:
            await TravelDao.update_travel(db, travel_update.id, travel_update.model_dump(exclude_unset=True))
            await db.commit()
            return ResponseUtil.success(msg="Updated successfully")
        except Exception as e:
            await db.rollback()
            raise e

    @classmethod
    async def delete_travel(cls, travel_ids: str, db: AsyncSession):
        ids = [int(i) for i in travel_ids.split(',')]
        try:
            await TravelDao.delete_travel_by_ids(db, ids)
            await db.commit()
            return ResponseUtil.success(msg="Deleted successfully")
        except Exception as e:
            await db.rollback()
            raise e
