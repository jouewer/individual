from pydantic import BaseModel, ConfigDict
from datetime import date, time, datetime
from typing import Optional, List, Union, Any

class FoodDiariesBase(BaseModel):
    record_date: date
    meal_time: str
    meal_time_detail: Optional[time] = None
    food_name: str
    food_category: str
    food_tags: Optional[Union[List[str], str]] = None
    cooking_method: Optional[str] = None
    location_type: str = '家里'
    location_name: Optional[str] = None
    address: Optional[str] = None
    companion_type: str = '独自'
    companions: Optional[Union[List[str], str]] = None
    portion_size: Optional[str] = None
    estimated_calories: Optional[float] = None
    nutrition_tags: Optional[Union[List[str], str]] = None
    is_homemade: Optional[int] = 0
    recipe_id: Optional[int] = None
    taste_rating: Optional[int] = None
    health_rating: Optional[int] = None
    satisfaction_level: Optional[int] = None
    
    mood_during_meal: Optional[str] = None
    feeling_after_meal: Optional[str] = None
    special_notes: Optional[str] = None
    food_images: Optional[str] = None
    images: Optional[Union[List[str], str]] = None
    recipe_steps: Optional[str] = None
    ingredients: Optional[Union[List[str], str]] = None
    ingredients_text: Optional[str] = None
    
    cost: Optional[float] = None
    currency: Optional[str] = 'CNY'
    is_shared_cost: Optional[int] = 0
    shared_with: Optional[Union[List[str], str]] = None
    repeat_frequency: Optional[str] = None
    last_eaten_date: Optional[date] = None
    times_eaten: Optional[int] = 1
    similar_food_ids: Optional[Union[List[str], str]] = None
    
    is_favorite: Optional[int] = 0
    want_to_repeat: Optional[int] = 1
    privacy_level: str = '仅自己'

class FoodDiariesCreate(FoodDiariesBase):
    pass

class FoodDiariesUpdate(FoodDiariesBase):
    id: int
    user_id: Optional[int] = None

class FoodDiariesQuery(BaseModel):
    pageNum: int = 1
    pageSize: int = 10
    food_name: Optional[str] = None
    food_category: Optional[str] = None
    meal_time: Optional[str] = None
    record_date: Optional[date] = None

class FoodDiariesModel(FoodDiariesBase):
    id: int
    user_id: int
    create_time: datetime
    update_time: datetime

    model_config = ConfigDict(from_attributes=True)
