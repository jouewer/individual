from pydantic import BaseModel, Field, ConfigDict
from pydantic.alias_generators import to_camel
from datetime import datetime, date, time
from typing import Optional, Any
from module_admin.annotation.pydantic_annotation import as_query

@as_query
class LearningTaskQuery(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    task_name: Optional[str] = Field(default=None, description='任务名称')
    learning_area: Optional[str] = Field(default=None, description='学习领域')
    task_status: Optional[str] = Field(default=None, description='任务状态')
    is_active: Optional[bool] = Field(default=None, description='是否有效')
    page_num: int = Field(default=1, description='当前页码')
    page_size: int = Field(default=10, description='每页数量')

class LearningTaskBase(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    
    user_id: Optional[int] = None
    task_name: Optional[str] = None
    learning_area: Optional[str] = None
    learning_type: Optional[str] = None
    learning_content: Optional[str] = None
    learning_url: Optional[str] = None
    learning_resources: Optional[Any] = None
    
    create_date: Optional[date] = None
    planned_start_date: Optional[date] = None
    planned_end_date: Optional[date] = None
    actual_start_date: Optional[date] = None
    actual_end_date: Optional[date] = None
    
    estimated_hours: Optional[float] = None
    actual_hours: Optional[float] = None
    progress_percent: Optional[int] = None
    
    current_chapter: Optional[str] = None
    next_step: Optional[str] = None
    
    difficulty_level: Optional[str] = None
    priority_level: Optional[str] = None
    importance_level: Optional[int] = None
    
    learning_method: Optional[str] = None
    learning_schedule: Optional[Any] = None
    daily_goal: Optional[str] = None
    
    cover_image: Optional[str] = None
    learning_images: Optional[Any] = None
    screenshots: Optional[Any] = None
    notes_document: Optional[str] = None
    
    reminder_enabled: Optional[bool] = None
    reminder_time: Optional[time] = None
    reminder_days: Optional[Any] = None
    repeat_pattern: Optional[str] = None
    repeat_config: Optional[Any] = None
    
    learning_effectiveness: Optional[int] = None
    key_points: Optional[str] = None
    difficulties_encountered: Optional[str] = None
    solutions: Optional[str] = None
    achievements: Optional[str] = None
    
    task_status: Optional[str] = None
    is_active: Optional[bool] = True
    completion_notes: Optional[str] = None
    reward_description: Optional[str] = None
    self_assessment: Optional[str] = None
    
    days_spent: Optional[int] = None
    days_remaining: Optional[int] = None
    streak_days: Optional[int] = None
    last_study_date: Optional[date] = None
    
    related_tasks: Optional[Any] = None
    study_group: Optional[str] = None
    mentor_name: Optional[str] = None
    tags: Optional[Any] = None
    notes: Optional[str] = None

class LearningTaskModel(LearningTaskBase):
    model_config = ConfigDict(from_attributes=True, alias_generator=to_camel, populate_by_name=True)
    
    id: Optional[int] = None
    create_time: Optional[datetime] = None
    update_time: Optional[datetime] = None

class LearningTaskCreate(LearningTaskBase):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    pass

class LearningTaskUpdate(LearningTaskBase):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    id: int
