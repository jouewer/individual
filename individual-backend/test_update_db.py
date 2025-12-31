import asyncio
from config.get_db import get_db
from module_admin.service.plant_service import PlantService
from module_admin.entity.vo.plant_vo import PlantModel

async def test_update():
    # Manually get a session
    # get_db is a generator, so we need to iterate it
    async for db in get_db():
        print("Got DB session")
        
        # 1. Get ID 1
        plant = await PlantService.get_plant_detail(db, 1)
        if not plant:
            print("Plant ID 1 not found")
            return

        print(f"Original Cover: {plant.get('coverImage')}")

        # 2. Update
        new_cover = "/profile/upload/2025/12/31/ns4_20251231090922A625.jpg"
        plant_model = PlantModel(
            id=1,
            plant_name=plant.get('plantName'), 
            cover_image=new_cover
        )
        
        await PlantService.update_plant(db, plant_model)
        print("Update called")

        await db.commit()
        
        # Re-fetch
        updated_plant = await PlantService.get_plant_detail(db, 1)
        print(f"New Cover: {updated_plant.get('coverImage')}")
        
        break

if __name__ == "__main__":
    asyncio.run(test_update())
