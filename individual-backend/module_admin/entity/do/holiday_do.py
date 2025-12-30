from datetime import datetime, date, time
from sqlalchemy import Column, Integer, String, DateTime, Text, Date, Time, Float
from sqlalchemy.dialects.mysql import BIGINT
from config.database import Base

class HolidaySchedule(Base):
    """
    节假快乐表
    """
    __tablename__ = 'holiday_schedules'
    __table_args__ = {'comment': '节假快乐表'}

    id = Column(BIGINT(20, unsigned=True), primary_key=True, autoincrement=True, comment='主键')
    user_id = Column(BIGINT(20, unsigned=True), nullable=True, comment='用户ID')
    holiday_date = Column(Date, nullable=False, comment='节日日期')
    holiday_name = Column(String(255), nullable=True, comment='节日名称')
    holiday_type = Column(String(50), nullable=True, comment='假期类型')
    schedule_title = Column(String(255), nullable=True, comment='日程标题')
    schedule_type = Column(String(50), nullable=True, comment='日程类型')
    start_time = Column(Time, nullable=True, comment='开始时间')
    end_time = Column(Time, nullable=True, comment='结束时间')
    all_day = Column(Integer, default=0, comment='全天')
    duration_minutes = Column(Integer, nullable=True, comment='持续时长(分)')
    location_name = Column(String(255), nullable=True, comment='地点名称')
    address = Column(String(255), nullable=True, comment='详细地址')
    latitude = Column(Float, nullable=True, comment='纬度')
    longitude = Column(Float, nullable=True, comment='经度')
    
    # 详细内容
    content = Column(Text, nullable=True, comment='具体内容/做什么')
    description = Column(Text, nullable=True, comment='描述') # Kept for compatibility if needed, or alias to content
    preparation = Column(Text, nullable=True, comment='准备工作')
    shopping_list = Column(Text, nullable=True, comment='购物清单') # Stored as JSON string or use JSON type
    required_items = Column(Text, nullable=True, comment='所需物品')
    participants = Column(Text, nullable=True, comment='参与人员')
    
    # 预算和成本
    budget = Column(Float, nullable=True, comment='预算金额')
    currency = Column(String(10), nullable=True, comment='币种')
    actual_cost = Column(Float, nullable=True, comment='实际花费')
    
    # 多媒体
    cover_image = Column(String(500), nullable=True, comment='封面图片')
    images = Column(Text, nullable=True, comment='图片数组')
    videos = Column(Text, nullable=True, comment='视频链接')
    recipes = Column(Text, nullable=True, comment='菜谱')
    documents = Column(Text, nullable=True, comment='相关文档链接')
    
    # 状态和提醒
    status = Column(String(50), nullable=True, comment='状态')
    reminder_time = Column(DateTime, nullable=True, comment='提醒时间')
    is_repeat = Column(Integer, default=0, comment='是否重复')
    repeat_rule = Column(String(100), nullable=True, comment='重复规则')
    
    # 评价和回顾
    rating = Column(Integer, nullable=True, comment='评分')
    review = Column(Text, nullable=True, comment='回顾/总结')
    highlights = Column(Text, nullable=True, comment='亮点')
    lessons_learned = Column(Text, nullable=True, comment='经验教训')
    
    # 标签和分类
    tags = Column(Text, nullable=True, comment='标签')
    mood = Column(String(50), nullable=True, comment='心情')
    energy_level = Column(Integer, nullable=True, comment='精力消耗程度')
    satisfaction_level = Column(Integer, nullable=True, comment='满意度')
    
    # 关联信息
    related_footprint_id = Column(BIGINT(20, unsigned=True), nullable=True, comment='关联足迹ID')
    template_id = Column(BIGINT(20, unsigned=True), nullable=True, comment='模板ID')
    
    # 隐私设置
    privacy_level = Column(String(50), default='仅自己', comment='隐私级别')
    share_with = Column(Text, nullable=True, comment='分享给的用户列表')
    
    checklist = Column(Text, nullable=True, comment='清单') # Kept as per previous add
    visibility = Column(String(50), nullable=True, comment='可见性') # Kept as per previous add
    is_active = Column(Integer, default=1, comment='是否有效')
    
    create_time = Column(DateTime, nullable=False, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, nullable=False, default=datetime.now, onupdate=datetime.now, comment='更新时间')
