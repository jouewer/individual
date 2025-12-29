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
    
    create_time = Column(DateTime, nullable=False, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, nullable=False, default=datetime.now, onupdate=datetime.now, comment='更新时间')
