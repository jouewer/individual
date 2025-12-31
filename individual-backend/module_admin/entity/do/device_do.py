from sqlalchemy import Column, String, Date, DateTime, DECIMAL, Text, BigInteger, Integer, JSON, Boolean
from config.database import Base
from datetime import datetime

class ElectronicDevice(Base):
    """
    电子设备表
    """
    __tablename__ = 'electronic_devices'

    id = Column(BigInteger, primary_key=True, autoincrement=True, comment='主键ID')
    user_id = Column(BigInteger, nullable=False, comment='用户ID')
    device_name = Column(String(200), nullable=False, comment='设备名称')
    device_type = Column(String(50), nullable=False, comment='设备类型') # Enum in DB, mapped to String here for simplicity or use Enum if strict
    brand = Column(String(100), nullable=False, comment='品牌')
    model = Column(String(100), nullable=False, comment='型号')
    serial_number = Column(String(100), nullable=True, comment='序列号')
    color = Column(String(50), nullable=True, comment='颜色')
    device_status = Column(String(50), nullable=False, default='已使用', comment='设备状态')
    purchase_status = Column(String(50), nullable=False, default='已拥有', comment='购买状态')
    storage_location = Column(String(100), nullable=False, comment='存放位置')
    location_type = Column(String(50), nullable=False, comment='位置类型')
    specific_spot = Column(String(200), nullable=True, comment='具体位置')
    quantity = Column(Integer, nullable=False, default=1, comment='数量')
    unit_price = Column(DECIMAL(10, 2), nullable=True, comment='单价')
    total_value = Column(DECIMAL(10, 2), nullable=True, comment='总价值')
    currency = Column(String(3), default='CNY', comment='货币')
    purchase_date = Column(Date, nullable=True, comment='购买日期')
    purchase_from = Column(String(200), nullable=True, comment='购买渠道')
    warranty_period = Column(Integer, nullable=True, comment='保修期(月)')
    warranty_end_date = Column(Date, nullable=True, comment='保修截止日期')
    invoice_number = Column(String(100), nullable=True, comment='发票号码')
    start_use_date = Column(Date, nullable=True, comment='启用日期')
    estimated_lifespan = Column(Integer, nullable=True, comment='预计寿命(月)')
    usage_frequency = Column(String(50), nullable=True, comment='使用频率')
    last_used_date = Column(Date, nullable=True, comment='最后使用日期')
    specifications = Column(JSON, nullable=True, comment='规格参数')
    accessories = Column(JSON, nullable=True, comment='配件列表')
    maintenance_records = Column(JSON, nullable=True, comment='维护记录')
    repair_history = Column(JSON, nullable=True, comment='维修历史')
    next_maintenance_date = Column(Date, nullable=True, comment='下次维护日期')
    device_images = Column(JSON, nullable=True, comment='设备图片')
    manual_path = Column(String(500), nullable=True, comment='说明书路径')
    warranty_card_image = Column(String(500), nullable=True, comment='保修卡图片')
    invoice_image = Column(String(500), nullable=True, comment='发票图片')
    tags = Column(JSON, nullable=True, comment='标签')
    notes = Column(Text, nullable=True, comment='备注')
    important_level = Column(String(20), default='一般', comment='重要程度')
    is_shared = Column(Boolean, default=False, comment='是否共享')
    shared_with = Column(JSON, nullable=True, comment='共享给谁')
    low_battery_reminder = Column(Boolean, default=False, comment='低电量提醒')
    warranty_expire_reminder = Column(Boolean, default=False, comment='保修过期提醒')
    is_active = Column(Boolean, default=True, comment='是否有效')
    create_time = Column(DateTime, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
