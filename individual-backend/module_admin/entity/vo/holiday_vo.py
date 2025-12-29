from datetime import datetime, date, time
from typing import Optional, Any
from pydantic import BaseModel, ConfigDict, model_validator
from pydantic.alias_generators import to_camel

class HolidayScheduleModel(BaseModel):
    """
    节假快乐对应模型
    """
    model_config = ConfigDict(from_attributes=True, alias_generator=to_camel, populate_by_name=True)

    id: Optional[int] = None
    user_id: Optional[int] = None
    holiday_date: Optional[date] = None
    holiday_name: Optional[str] = None
    holiday_type: Optional[str] = None
    schedule_title: Optional[str] = None
    schedule_type: Optional[str] = None
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    all_day: Optional[int] = 0
    duration_minutes: Optional[int] = None
    location_name: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[float] = None
    create_time: Optional[datetime] = None
    update_time: Optional[datetime] = None

    @model_validator(mode='before')
    @classmethod
    def empty_str_to_none(cls, data: Any) -> Any:
        if isinstance(data, dict):
            return {
                k: (None if (isinstance(v, str) and v == "") else v)
                for k, v in data.items()
            }
        return data

class HolidayScheduleCreate(BaseModel):
    """
    节假快乐创建参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    
    holiday_date: date
    holiday_name: Optional[str] = None
    holiday_type: Optional[str] = None
    schedule_title: Optional[str] = None
    schedule_type: Optional[str] = None
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    all_day: Optional[int] = 0
    duration_minutes: Optional[int] = None
    location_name: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[float] = None

    @model_validator(mode='before')
    @classmethod
    def empty_str_to_none(cls, data: Any) -> Any:
        if isinstance(data, dict):
            return {
                k: (None if (isinstance(v, str) and v == "") else v)
                for k, v in data.items()
            }
        return data

class HolidayScheduleUpdate(BaseModel):
    """
    节假快乐更新参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    
    id: int
    holiday_date: Optional[date] = None
    holiday_name: Optional[str] = None
    holiday_type: Optional[str] = None
    schedule_title: Optional[str] = None
    schedule_type: Optional[str] = None
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    all_day: Optional[int] = None
    duration_minutes: Optional[int] = None
    location_name: Optional[str] = None
    address: Optional[str] = None
    latitude: Optional[float] = None

    @model_validator(mode='before')
    @classmethod
    def empty_str_to_none(cls, data: Any) -> Any:
        if isinstance(data, dict):
            return {
                k: (None if (isinstance(v, str) and v == "") else v)
                for k, v in data.items()
            }
        return data

class HolidayScheduleQuery(BaseModel):
    """
    节假快乐查询参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    holiday_name: Optional[str] = None
    holiday_type: Optional[str] = None
    page_num: int = 1
    page_size: int = 10
