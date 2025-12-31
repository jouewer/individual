from datetime import datetime, date
from sqlalchemy import Column, Integer, String, DateTime, Text, Float, Date, DECIMAL, JSON
from sqlalchemy.dialects.mysql import BIGINT, TINYINT
from config.database import Base

class HolidayShopping(Base):
    """
    节日购物表
    """
    __tablename__ = 'holiday_shopping'
    __table_args__ = {'comment': '节日购物表'}

    id = Column(BIGINT(20, unsigned=True), primary_key=True, autoincrement=True, comment='主键')
    user_id = Column(BIGINT(20, unsigned=True), nullable=False, comment='用户ID')
    shopping_name = Column(String(200), nullable=False, comment='商品名称')
    holiday_name = Column(String(100), nullable=False, comment='节日名称')
    holiday_date = Column(Date, nullable=False, comment='节日日期')
    item_category = Column(String(50), nullable=False, comment='商品分类')
    item_type = Column(String(50), nullable=False, comment='商品类型')
    item_for_whom = Column(String(100), nullable=True, comment='送给谁')
    purchase_timing = Column(String(50), nullable=False, default='提前1周', comment='购买时机')
    purchase_method = Column(String(50), nullable=False, default='线上', comment='购买方式')
    store_name = Column(String(200), nullable=True, comment='店铺名称')
    store_type = Column(String(50), nullable=True, comment='店铺类型')
    purchase_link = Column(String(500), nullable=True, comment='购买链接')
    quantity = Column(Integer, nullable=False, default=1, comment='数量')
    unit = Column(String(20), nullable=True, comment='单位')
    expected_price = Column(DECIMAL(10, 2), nullable=True, comment='预期价格')
    actual_price = Column(DECIMAL(10, 2), nullable=True, comment='实际价格')
    currency = Column(String(3), nullable=True, default='CNY', comment='货币')
    purchase_status = Column(String(50), nullable=False, default='计划中', comment='购买状态')
    order_date = Column(Date, nullable=True, comment='下单日期')
    receive_date = Column(Date, nullable=True, comment='收货日期')
    purchase_experience = Column(String(50), nullable=True, comment='购买体验')
    delivery_speed = Column(String(50), nullable=True, comment='物流速度')
    packaging_quality = Column(String(50), nullable=True, comment='包装质量')
    item_quality = Column(String(50), nullable=True, comment='商品质量')
    liking_level = Column(String(50), nullable=True, comment='喜爱程度')
    usage_frequency = Column(String(50), nullable=True, comment='使用频率')
    pros = Column(Text, nullable=True, comment='优点')
    cons = Column(Text, nullable=True, comment='缺点')
    suggestions = Column(Text, nullable=True, comment='建议')
    memorable_story = Column(Text, nullable=True, comment='难忘故事')
    cultural_significance = Column(Text, nullable=True, comment='文化意义')
    holiday_tradition = Column(Text, nullable=True, comment='节日传统')
    shopping_reason = Column(Text, nullable=True, comment='购买理由')
    cover_image = Column(String(500), nullable=True, comment='封面图片')
    item_images = Column(JSON, nullable=True, comment='商品图片')
    shopping_screenshots = Column(JSON, nullable=True, comment='购物截图')
    unboxing_videos = Column(String(500), nullable=True, comment='开箱视频')
    is_in_budget = Column(TINYINT(1), nullable=True, default=1, comment='是否在预算内')
    budget_category = Column(String(50), nullable=True, comment='预算分类')
    total_spent = Column(DECIMAL(10, 2), nullable=True, comment='总花费')
    reminder_date = Column(Date, nullable=True, comment='提醒日期')
    is_repeat_purchase = Column(TINYINT(1), nullable=True, default=0, comment='是否重复购买')
    repeat_frequency = Column(String(50), nullable=True, comment='重复频率')
    share_with_family = Column(TINYINT(1), nullable=True, default=0, comment='分享给家人')
    share_with_friends = Column(TINYINT(1), nullable=True, default=0, comment='分享给朋友')
    is_active = Column(TINYINT(1), nullable=True, default=1, comment='是否有效')
    create_time = Column(DateTime, nullable=False, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, nullable=False, default=datetime.now, onupdate=datetime.now, comment='更新时间')
