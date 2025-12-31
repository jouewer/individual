from sqlalchemy import create_engine, inspect
from config.env import DataBaseSettings

db_config = DataBaseSettings()

# Sync engine for inspection
SYNC_DATABASE_URL = f"mysql+pymysql://{db_config.db_username}:{db_config.db_password}@{db_config.db_host}:{db_config.db_port}/{db_config.db_database}"

engine = create_engine(SYNC_DATABASE_URL)
inspector = inspect(engine)
from sqlalchemy import text

columns = inspector.get_columns('plant_growth')
pk = inspector.get_pk_constraint('plant_growth')
print(f"PK: {pk}")
for col in columns:
    print(f"Column: {col['name']}, Type: {col['type']}")
