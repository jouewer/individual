from datetime import datetime, date, time
from typing import Optional, List, Any
from pydantic import BaseModel, ConfigDict, model_validator
from pydantic.alias_generators import to_camel

class TravelFootprintModel(BaseModel):
    """
    足迹旅行对应模型
    """
    model_config = ConfigDict(from_attributes=True, alias_generator=to_camel, populate_by_name=True)

    id: Optional[int] = None
    user_id: Optional[int] = None
    city: Optional[str] = None
    country: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    visit_date: Optional[date] = None
    description: Optional[str] = None
    cover_image: Optional[str] = None
    create_time: Optional[datetime] = None
    update_time: Optional[datetime] = None
    title: Optional[str] = None
    location_name: Optional[str] = None
    address: Optional[str] = None
    province: Optional[str] = None
    district: Optional[str] = None
    
    geohash: Optional[str] = None
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    duration: Optional[int] = None
    timezone: Optional[str] = None
    images: Optional[List[Any]] = None
    videos: Optional[List[Any]] = None
    audio_notes: Optional[List[Any]] = None
    travel_type: Optional[str] = None
    tags: Optional[List[str]] = None
    season: Optional[str] = None
    weather: Optional[str] = None
    rating: Optional[int] = None
    mood: Optional[str] = None
    recommend_level: Optional[int] = None
    cost_level: Optional[int] = None
    companions: Optional[List[str]] = None
    transportation: Optional[str] = None
    accommodation: Optional[str] = None
    notes: Optional[str] = None
    is_public: Optional[int] = None
    status: Optional[str] = None
    privacy_level: Optional[int] = None
    favorite_count: Optional[int] = None
    view_count: Optional[int] = None

class TravelFootprintCreate(BaseModel):
    """
    足迹旅行创建参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    @model_validator(mode='before')
    @classmethod
    def empty_str_to_none(cls, data: Any) -> Any:
        if isinstance(data, dict):
            # Define mapping for list fields (snake_case and camelCase)
            list_fields_map = {
                'images': 'images',
                'videos': 'videos',
                'audio_notes': 'audioNotes',
                'tags': 'tags',
                'companions': 'companions'
            }
            
            for snake_key, camel_key in list_fields_map.items():
                # Check snake_key
                if snake_key in data and isinstance(data[snake_key], str):
                    if not data[snake_key] or not data[snake_key].strip():
                        data[snake_key] = None
                    else:
                        data[snake_key] = data[snake_key].split(',')
                
                # Check camel_key (if different)
                if camel_key != snake_key and camel_key in data and isinstance(data[camel_key], str):
                    if not data[camel_key] or not data[camel_key].strip():
                        data[camel_key] = None
                    else:
                        data[camel_key] = data[camel_key].split(',')

            # Then handle other empty strings
            return {
                k: (None if (isinstance(v, str) and v == "") else v)
                for k, v in data.items()
            }
        return data

    city: str
    country: str
    visit_date: date
    description: Optional[str] = None
    cover_image: Optional[str] = None
    # Optional fields that can be provided or defaulted
    title: Optional[str] = None
    location_name: Optional[str] = None
    address: Optional[str] = None
    province: Optional[str] = None
    district: Optional[str] = None
    
    geohash: Optional[str] = None
    start_time: Optional[time] = None
    end_time: Optional[time] = None
    duration: Optional[int] = None
    timezone: Optional[str] = None
    images: Optional[List[Any]] = None
    videos: Optional[List[Any]] = None
    audio_notes: Optional[List[Any]] = None
    travel_type: Optional[str] = None
    tags: Optional[List[str]] = None
    season: Optional[str] = None
    weather: Optional[str] = None
    rating: Optional[int] = None
    mood: Optional[str] = None
    recommend_level: Optional[int] = None
    cost_level: Optional[int] = None
    companions: Optional[List[str]] = None
    transportation: Optional[str] = None
    accommodation: Optional[str] = None
    notes: Optional[str] = None
    is_public: Optional[int] = None
    status: Optional[str] = None
    privacy_level: Optional[int] = None
    favorite_count: Optional[int] = None
    view_count: Optional[int] = None

class TravelFootprintUpdate(TravelFootprintCreate):
    """
    足迹旅行更新参数
    """
    id: int

class TravelFootprintQuery(BaseModel):
    """
    足迹旅行查询参数
    """
    city: Optional[str] = None
    country: Optional[str] = None
    begin_time: Optional[str] = None
    end_time: Optional[str] = None
    page_num: int = 1
    page_size: int = 10
