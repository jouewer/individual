from datetime import date, time, datetime
from sqlalchemy import Column, Integer, String, DateTime, Float, Text, Date, Time, DECIMAL, JSON
from sqlalchemy.dialects.mysql import BIGINT, TINYINT
from config.database import Base

class TravelFootprint(Base):
    """
    足迹旅行表
    """
    __tablename__ = 'travel_footprints'
    __table_args__ = {'comment': '足迹旅行表'}

    id = Column(BIGINT(20, unsigned=True), primary_key=True, autoincrement=True, comment='主键')
    user_id = Column(BIGINT(20, unsigned=True), nullable=False, comment='用户ID')
    title = Column(String(200), nullable=False, comment='标题')
    description = Column(Text, nullable=True, comment='描述')
    location_name = Column(String(100), nullable=False, comment='地点名称')
    address = Column(String(500), nullable=False, comment='详细地址')
    country = Column(String(50), nullable=False, comment='国家')
    province = Column(String(50), nullable=False, comment='省份')
    city = Column(String(50), nullable=False, comment='城市')
    district = Column(String(50), nullable=False, comment='区县')
    latitude = Column(DECIMAL(10, 8), nullable=True, comment='纬度')
    longitude = Column(DECIMAL(11, 8), nullable=True, comment='经度')
    visit_date = Column(Date, nullable=False, comment='访问日期')
    cover_image = Column(String(500), nullable=True, comment='封面图片')
    
    geohash = Column(String(12), nullable=True, comment='地理编码')
    # coordinate is skipped to avoid dependency issues, use latitude/longitude
    start_time = Column(Time, nullable=True, comment='开始时间')
    end_time = Column(Time, nullable=True, comment='结束时间')
    duration = Column(Integer, nullable=True, comment='停留时长')
    timezone = Column(String(50), nullable=True, comment='时区信息')
    
    images = Column(JSON, nullable=True, comment='图片URL数组')
    videos = Column(JSON, nullable=True, comment='视频链接数组')
    audio_notes = Column(JSON, nullable=True, comment='语音备注数组')
    
    travel_type = Column(String(20), nullable=False, default='自由行', comment='旅行类型')
    tags = Column(JSON, nullable=True, comment='标签数组')
    season = Column(String(10), nullable=False, default='未知', comment='季节')
    weather = Column(String(50), nullable=True, comment='天气情况')
    
    rating = Column(TINYINT, nullable=True, comment='评分')
    mood = Column(String(20), nullable=True, comment='心情状态')
    recommend_level = Column(TINYINT, nullable=True, comment='推荐程度')
    cost_level = Column(TINYINT, nullable=True, comment='消费水平')
    
    companions = Column(JSON, nullable=True, comment='同行人员数组')
    transportation = Column(String(200), nullable=True, comment='交通工具')
    accommodation = Column(String(200), nullable=True, comment='住宿信息')
    notes = Column(Text, nullable=True, comment='注意事项')
    
    is_public = Column(TINYINT, nullable=False, default=1, comment='是否公开')
    status = Column(String(20), nullable=False, default='已完成', comment='状态')
    privacy_level = Column(TINYINT, nullable=False, default=1, comment='隐私级别')
    
    favorite_count = Column(Integer, nullable=False, default=0, comment='收藏数')
    view_count = Column(Integer, nullable=False, default=0, comment='浏览数')

    create_time = Column(DateTime, nullable=False, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, nullable=False, default=datetime.now, onupdate=datetime.now, comment='更新时间')
    
    # Other fields can be added as needed, keeping it minimal for now to match current usage
    # but mapping the table correctly is important.

