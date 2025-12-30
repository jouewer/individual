from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel
from typing import Optional
from datetime import datetime

class CameraModel(BaseModel):
    """
    摄像头模型
    """
    model_config = ConfigDict(alias_generator=to_camel, from_attributes=True)

    id: Optional[str] = None
    lift_name: Optional[str] = None
    dept_id: Optional[str] = None
    camera_status: Optional[str] = None
    del_flag: Optional[str] = None
    camera_name: Optional[str] = None
    camera_password: Optional[str] = None
    camera_ip: Optional[str] = None
    camera_port: Optional[str] = None
    camera_rtsp_port: Optional[str] = None
    protocol: Optional[str] = None
    brand: Optional[str] = None
    line: Optional[str] = None
    create_time: Optional[datetime] = None
    update_time: Optional[datetime] = None

class CameraQuery(BaseModel):
    """
    摄像头查询模型
    """
    page_num: int = 1
    page_size: int = 10
    keyword: Optional[str] = None
    camera_status: Optional[str] = None
