from sqlalchemy import create_engine, text
from config.env import DataBaseSettings

db_config = DataBaseSettings()
SYNC_DATABASE_URL = f"mysql+pymysql://{db_config.db_username}:{db_config.db_password}@{db_config.db_host}:{db_config.db_port}/{db_config.db_database}"

engine = create_engine(SYNC_DATABASE_URL)

with engine.connect() as connection:
    # Check ID 1 specifically
    result = connection.execute(text("SELECT * FROM plant_growth WHERE id = 1"))
    row = result.first()
    if row:
        print(f"ID: {row.id}, Name: {row.plant_name}, Cover: {row.cover_image}, Active: {row.is_active}")
    else:
        print("ID 1 not found")

    print("-" * 20)
    result = connection.execute(text("SELECT * FROM plant_growth"))
    for row in result:
        print(f"ID: {row.id}, Name: {row.plant_name}, Cover: {row.cover_image}, Active: {row.is_active}")
