from sqlalchemy import Column, String, DateTime
from config.database import Base
from datetime import datetime

class SxtCamera(Base):
    __tablename__ = 'sxt_camera'

    id = Column(String(255), primary_key=True, comment='主键ID')
    lift_name = Column(String(255), comment='摄像头名称')
    dept_id = Column(String(255), comment='部门ID')
    camera_status = Column(String(2), comment='摄像头状态')
    del_flag = Column('del', String(2), default='0', comment='删除标志')
    camera_name = Column(String(50), comment='登录用户名')
    camera_password = Column(String(50), comment='登录密码')
    camera_ip = Column(String(50), comment='IP地址')
    camera_port = Column(String(50), comment='摄像头端口')
    camera_rtsp_port = Column(String(50), comment='RTSP端口')
    protocol = Column(String(255), comment='协议')
    brand = Column(String(255), comment='品牌')
    line = Column(String(2), comment='在线状态')
    create_time = Column(DateTime, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
