import asyncio
from config.get_db import get_db
from module_admin.service.plant_service import PlantService
from module_admin.entity.vo.plant_vo import PlantModel

async def test_add_and_update():
    async for db in get_db():
        print("Got DB session")
        
        # 1. Add
        plant = PlantModel(
            plant_name="Test Plant",
            plant_type="Flower",
            plant_date="2025-01-01",
            cover_image="/images/test.jpg",
            user_id=1
        )
        await PlantService.add_plant(db, plant)
        await db.commit()
        print("Added plant")
        
        # Find it (assuming last inserted or search by name)
        # We need to query by name to get ID
        # But PlantDao doesn't have get_by_name easily exposed in service?
        # get_plant_list filters by name
        from module_admin.entity.vo.plant_vo import PlantQuery
        query = PlantQuery(plant_name="Test Plant")
        result = await PlantService.get_plant_list(db, query)
        
        if not result:
            print("Failed to find added plant")
            return
            
        added_plant = result[0]
        plant_id = added_plant['id']
        print(f"Added Plant ID: {plant_id}, Cover: {added_plant['coverImage']}")
        
        # 2. Update
        new_cover = "/profile/upload/2025/12/31/test_update.jpg"
        update_model = PlantModel(
            id=plant_id,
            plant_name="Test Plant Updated",
            cover_image=new_cover
        )
        
        await PlantService.update_plant(db, update_model)
        await db.commit()
        print("Updated plant")
        
        # 3. Verify
        updated_plant_data = await PlantService.get_plant_detail(db, plant_id)
        print(f"Updated Plant ID: {updated_plant_data['id']}, Cover: {updated_plant_data['coverImage']}")
        
        break

if __name__ == "__main__":
    asyncio.run(test_add_and_update())
