from datetime import datetime, date
from typing import Optional, Any
from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel

class HolidayShoppingModel(BaseModel):
    """
    节日购物模型
    """
    model_config = ConfigDict(from_attributes=True, alias_generator=to_camel, populate_by_name=True)

    id: Optional[int] = None
    user_id: Optional[int] = None
    shopping_name: Optional[str] = None
    holiday_name: Optional[str] = None
    holiday_date: Optional[date] = None
    item_category: Optional[str] = None
    item_type: Optional[str] = None
    item_for_whom: Optional[str] = None
    purchase_timing: Optional[str] = None
    purchase_method: Optional[str] = None
    store_name: Optional[str] = None
    store_type: Optional[str] = None
    purchase_link: Optional[str] = None
    quantity: Optional[int] = None
    unit: Optional[str] = None
    expected_price: Optional[float] = None
    actual_price: Optional[float] = None
    currency: Optional[str] = None
    purchase_status: Optional[str] = None
    order_date: Optional[date] = None
    receive_date: Optional[date] = None
    purchase_experience: Optional[str] = None
    delivery_speed: Optional[str] = None
    packaging_quality: Optional[str] = None
    item_quality: Optional[str] = None
    liking_level: Optional[str] = None
    usage_frequency: Optional[str] = None
    pros: Optional[str] = None
    cons: Optional[str] = None
    suggestions: Optional[str] = None
    memorable_story: Optional[str] = None
    cultural_significance: Optional[str] = None
    holiday_tradition: Optional[str] = None
    shopping_reason: Optional[str] = None
    cover_image: Optional[str] = None
    item_images: Optional[Any] = None
    shopping_screenshots: Optional[Any] = None
    unboxing_videos: Optional[str] = None
    is_in_budget: Optional[int] = None
    budget_category: Optional[str] = None
    total_spent: Optional[float] = None
    reminder_date: Optional[date] = None
    is_repeat_purchase: Optional[int] = None
    repeat_frequency: Optional[str] = None
    share_with_family: Optional[int] = None
    share_with_friends: Optional[int] = None
    is_active: Optional[int] = None
    create_time: Optional[datetime] = None
    update_time: Optional[datetime] = None

class HolidayShoppingCreate(BaseModel):
    """
    节日购物创建参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    
    shopping_name: str
    holiday_name: str
    holiday_date: date
    item_category: str
    item_type: str
    item_for_whom: Optional[str] = None
    purchase_timing: Optional[str] = '提前1周'
    purchase_method: Optional[str] = '线上'
    store_name: Optional[str] = None
    store_type: Optional[str] = None
    purchase_link: Optional[str] = None
    quantity: int = 1
    unit: Optional[str] = None
    expected_price: Optional[float] = None
    actual_price: Optional[float] = None
    currency: Optional[str] = 'CNY'
    purchase_status: Optional[str] = '计划中'
    order_date: Optional[date] = None
    receive_date: Optional[date] = None
    purchase_experience: Optional[str] = None
    delivery_speed: Optional[str] = None
    packaging_quality: Optional[str] = None
    item_quality: Optional[str] = None
    liking_level: Optional[str] = None
    usage_frequency: Optional[str] = None
    pros: Optional[str] = None
    cons: Optional[str] = None
    suggestions: Optional[str] = None
    memorable_story: Optional[str] = None
    cultural_significance: Optional[str] = None
    holiday_tradition: Optional[str] = None
    shopping_reason: Optional[str] = None
    cover_image: Optional[str] = None
    item_images: Optional[Any] = None
    shopping_screenshots: Optional[Any] = None
    unboxing_videos: Optional[str] = None
    is_in_budget: Optional[int] = 1
    budget_category: Optional[str] = None
    total_spent: Optional[float] = None
    reminder_date: Optional[date] = None
    is_repeat_purchase: Optional[int] = 0
    repeat_frequency: Optional[str] = None
    share_with_family: Optional[int] = 0
    share_with_friends: Optional[int] = 0
    is_active: Optional[int] = 1

class HolidayShoppingUpdate(BaseModel):
    """
    节日购物更新参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    
    id: int
    shopping_name: Optional[str] = None
    holiday_name: Optional[str] = None
    holiday_date: Optional[date] = None
    item_category: Optional[str] = None
    item_type: Optional[str] = None
    item_for_whom: Optional[str] = None
    purchase_timing: Optional[str] = None
    purchase_method: Optional[str] = None
    store_name: Optional[str] = None
    store_type: Optional[str] = None
    purchase_link: Optional[str] = None
    quantity: Optional[int] = None
    unit: Optional[str] = None
    expected_price: Optional[float] = None
    actual_price: Optional[float] = None
    currency: Optional[str] = None
    purchase_status: Optional[str] = None
    order_date: Optional[date] = None
    receive_date: Optional[date] = None
    purchase_experience: Optional[str] = None
    delivery_speed: Optional[str] = None
    packaging_quality: Optional[str] = None
    item_quality: Optional[str] = None
    liking_level: Optional[str] = None
    usage_frequency: Optional[str] = None
    pros: Optional[str] = None
    cons: Optional[str] = None
    suggestions: Optional[str] = None
    memorable_story: Optional[str] = None
    cultural_significance: Optional[str] = None
    holiday_tradition: Optional[str] = None
    shopping_reason: Optional[str] = None
    cover_image: Optional[str] = None
    item_images: Optional[Any] = None
    shopping_screenshots: Optional[Any] = None
    unboxing_videos: Optional[str] = None
    is_in_budget: Optional[int] = None
    budget_category: Optional[str] = None
    total_spent: Optional[float] = None
    reminder_date: Optional[date] = None
    is_repeat_purchase: Optional[int] = None
    repeat_frequency: Optional[str] = None
    share_with_family: Optional[int] = None
    share_with_friends: Optional[int] = None
    is_active: Optional[int] = None

class HolidayShoppingQuery(BaseModel):
    """
    节日购物查询参数
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    shopping_name: Optional[str] = None
    holiday_name: Optional[str] = None
    item_category: Optional[str] = None
    purchase_status: Optional[str] = None
    page_num: int = 1
    page_size: int = 10
