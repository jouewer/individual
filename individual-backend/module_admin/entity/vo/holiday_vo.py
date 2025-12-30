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
    longitude: Optional[float] = None
    
    content: Optional[str] = None
    description: Optional[str] = None
    preparation: Optional[str] = None
    shopping_list: Optional[str] = None
    required_items: Optional[str] = None
    participants: Optional[str] = None
    
    budget: Optional[float] = None
    currency: Optional[str] = None
    actual_cost: Optional[float] = None
    
    cover_image: Optional[str] = None
    images: Optional[str] = None
    videos: Optional[str] = None
    recipes: Optional[str] = None
    documents: Optional[str] = None
    
    status: Optional[str] = None
    reminder_time: Optional[datetime] = None
    is_repeat: Optional[int] = 0
    repeat_rule: Optional[str] = None
    
    rating: Optional[int] = None
    review: Optional[str] = None
    highlights: Optional[str] = None
    lessons_learned: Optional[str] = None
    
    tags: Optional[str] = None
    mood: Optional[str] = None
    energy_level: Optional[int] = None
    satisfaction_level: Optional[int] = None
    
    related_footprint_id: Optional[int] = None
    template_id: Optional[int] = None
    
    privacy_level: Optional[str] = '仅自己'
    share_with: Optional[str] = None
    is_active: Optional[int] = 1
    
    checklist: Optional[str] = None
    visibility: Optional[str] = None
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
    longitude: Optional[float] = None
    
    content: Optional[str] = None
    description: Optional[str] = None
    preparation: Optional[str] = None
    shopping_list: Optional[str] = None
    required_items: Optional[str] = None
    participants: Optional[str] = None
    
    budget: Optional[float] = None
    currency: Optional[str] = None
    actual_cost: Optional[float] = None
    
    cover_image: Optional[str] = None
    images: Optional[str] = None
    videos: Optional[str] = None
    recipes: Optional[str] = None
    documents: Optional[str] = None
    
    status: Optional[str] = None
    reminder_time: Optional[datetime] = None
    is_repeat: Optional[int] = 0
    repeat_rule: Optional[str] = None
    
    rating: Optional[int] = None
    review: Optional[str] = None
    highlights: Optional[str] = None
    lessons_learned: Optional[str] = None
    
    tags: Optional[str] = None
    mood: Optional[str] = None
    energy_level: Optional[int] = None
    satisfaction_level: Optional[int] = None
    
    related_footprint_id: Optional[int] = None
    template_id: Optional[int] = None
    
    privacy_level: Optional[str] = '仅自己'
    share_with: Optional[str] = None
    is_active: Optional[int] = 1
    
    checklist: Optional[str] = None
    visibility: Optional[str] = None

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
    longitude: Optional[float] = None
    
    content: Optional[str] = None
    description: Optional[str] = None
    preparation: Optional[str] = None
    shopping_list: Optional[str] = None
    required_items: Optional[str] = None
    participants: Optional[str] = None
    
    budget: Optional[float] = None
    currency: Optional[str] = None
    actual_cost: Optional[float] = None
    
    cover_image: Optional[str] = None
    images: Optional[str] = None
    videos: Optional[str] = None
    recipes: Optional[str] = None
    documents: Optional[str] = None
    
    status: Optional[str] = None
    reminder_time: Optional[datetime] = None
    is_repeat: Optional[int] = 0
    repeat_rule: Optional[str] = None
    
    rating: Optional[int] = None
    review: Optional[str] = None
    highlights: Optional[str] = None
    lessons_learned: Optional[str] = None
    
    tags: Optional[str] = None
    mood: Optional[str] = None
    energy_level: Optional[int] = None
    satisfaction_level: Optional[int] = None
    
    related_footprint_id: Optional[int] = None
    template_id: Optional[int] = None
    
    privacy_level: Optional[str] = '仅自己'
    share_with: Optional[str] = None
    is_active: Optional[int] = 1
    
    checklist: Optional[str] = None
    visibility: Optional[str] = None

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
