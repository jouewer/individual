from datetime import date, time, datetime
from sqlalchemy import Column, Integer, String, DateTime, Float, Text, Date, Time, DECIMAL, JSON
from sqlalchemy.dialects.mysql import BIGINT, TINYINT
from config.database import Base

class FoodDiaries(Base):
    """
    美食日记表
    """
    __tablename__ = 'food_diaries'
    __table_args__ = {'comment': '美食日记表'}

    id = Column(BIGINT(20, unsigned=True), primary_key=True, autoincrement=True, comment='主键ID')
    user_id = Column(BIGINT(20, unsigned=True), nullable=False, comment='用户ID')
    record_date = Column(Date, nullable=False, comment='记录日期')
    meal_time = Column(String(20), nullable=False, comment='用餐时段')
    meal_time_detail = Column(Time, nullable=True, comment='具体用餐时间')
    food_name = Column(String(200), nullable=False, comment='食物名称')
    food_category = Column(String(20), nullable=False, comment='食物类别')
    food_tags = Column(JSON, nullable=True, comment='标签')
    cooking_method = Column(String(50), nullable=True, comment='烹饪方式')
    location_type = Column(String(20), nullable=False, default='家里', comment='用餐地点类型')
    location_name = Column(String(100), nullable=True, comment='具体地点')
    address = Column(String(500), nullable=True, comment='详细地址')
    companion_type = Column(String(20), nullable=False, default='独自', comment='用餐同伴')
    companions = Column(JSON, nullable=True, comment='同伴姓名/ID')
    portion_size = Column(String(50), nullable=True, comment='分量描述')
    estimated_calories = Column(DECIMAL(6, 1), nullable=True, comment='预估卡路里')
    nutrition_tags = Column(JSON, nullable=True, comment='营养标签')
    is_homemade = Column(TINYINT, nullable=True, default=0, comment='是否自制')
    recipe_id = Column(BIGINT(20, unsigned=True), nullable=True, comment='关联菜谱ID')
    taste_rating = Column(TINYINT, nullable=True, comment='口味评分')
    health_rating = Column(TINYINT, nullable=True, comment='健康评分')
    satisfaction_level = Column(TINYINT, nullable=True, comment='满意度')
    
    mood_during_meal = Column(String(20), nullable=True, comment='用餐时心情')
    feeling_after_meal = Column(String(100), nullable=True, comment='用餐后感受')
    special_notes = Column(Text, nullable=True, comment='特别备注')
    food_images = Column(String(500), nullable=True, comment='食物封面')
    images = Column(JSON, nullable=True, comment='食物图片集合')
    recipe_steps = Column(Text, nullable=True, comment='制作步骤')
    ingredients = Column(JSON, nullable=True, comment='主要食材')
    ingredients_text = Column(Text, nullable=True, comment='食材文本')
    
    cost = Column(DECIMAL(8, 2), nullable=True, comment='花费金额')
    currency = Column(String(3), nullable=True, default='CNY', comment='货币')
    is_shared_cost = Column(TINYINT, nullable=True, default=0, comment='是否分摊')
    shared_with = Column(JSON, nullable=True, comment='分摊人员')
    repeat_frequency = Column(String(20), nullable=True, comment='重复频率')
    last_eaten_date = Column(Date, nullable=True, comment='上次食用日期')
    times_eaten = Column(Integer, nullable=True, default=1, comment='累计食用次数')
    similar_food_ids = Column(JSON, nullable=True, comment='类似食物记录ID')
    
    is_favorite = Column(TINYINT, nullable=True, default=0, comment='是否收藏')
    want_to_repeat = Column(TINYINT, nullable=True, default=1, comment='是否想再吃')
    privacy_level = Column(String(20), nullable=False, default='仅自己', comment='隐私级别')
    
    create_time = Column(DateTime, nullable=False, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, nullable=False, default=datetime.now, onupdate=datetime.now, comment='更新时间')
