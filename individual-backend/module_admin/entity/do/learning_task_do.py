from sqlalchemy import Column, String, Integer, DateTime, Date, Time, Boolean, DECIMAL, Text, JSON
from config.database import Base
from datetime import datetime

class LearningTask(Base):
    """
    学习任务表
    """
    __tablename__ = 'learning_tasks'
    
    id = Column(Integer, primary_key=True, autoincrement=True, comment='主键ID')
    user_id = Column(Integer, nullable=False, comment='用户ID')
    task_name = Column(String(200), nullable=False, comment='任务名称')
    learning_area = Column(String(100), comment='学习领域')
    learning_type = Column(String(50), comment='学习类型')
    learning_content = Column(Text, comment='学习内容')
    learning_url = Column(String(500), comment='学习链接')
    learning_resources = Column(JSON, comment='学习资源')
    
    create_date = Column(Date, comment='创建日期')
    planned_start_date = Column(Date, comment='计划开始日期')
    planned_end_date = Column(Date, comment='计划结束日期')
    actual_start_date = Column(Date, comment='实际开始日期')
    actual_end_date = Column(Date, comment='实际结束日期')
    
    estimated_hours = Column(DECIMAL(5, 1), comment='预计耗时(小时)')
    actual_hours = Column(DECIMAL(5, 1), comment='实际耗时(小时)')
    progress_percent = Column(Integer, default=0, comment='进度百分比')
    
    current_chapter = Column(String(200), comment='当前章节')
    next_step = Column(String(500), comment='下一步计划')
    
    difficulty_level = Column(String(50), comment='难度等级')
    priority_level = Column(String(50), comment='优先级')
    importance_level = Column(Integer, comment='重要程度(1-5)')
    
    learning_method = Column(String(100), comment='学习方法')
    learning_schedule = Column(JSON, comment='学习计划表')
    daily_goal = Column(String(500), comment='每日目标')
    
    cover_image = Column(String(500), comment='封面图片')
    learning_images = Column(JSON, comment='学习图片')
    screenshots = Column(JSON, comment='截图')
    notes_document = Column(String(500), comment='笔记文档')
    
    reminder_enabled = Column(Boolean, default=False, comment='是否开启提醒')
    reminder_time = Column(Time, comment='提醒时间')
    reminder_days = Column(JSON, comment='提醒日期')
    repeat_pattern = Column(String(50), comment='重复模式')
    repeat_config = Column(JSON, comment='重复配置')
    
    learning_effectiveness = Column(Integer, comment='学习效果(1-10)')
    key_points = Column(Text, comment='关键点')
    difficulties_encountered = Column(Text, comment='遇到的困难')
    solutions = Column(Text, comment='解决方案')
    achievements = Column(Text, comment='成就')
    
    task_status = Column(String(50), default='待开始', comment='任务状态')
    is_active = Column(Boolean, default=True, comment='是否有效')
    completion_notes = Column(Text, comment='完成备注')
    reward_description = Column(String(200), comment='奖励描述')
    self_assessment = Column(Text, comment='自我评价')
    
    days_spent = Column(Integer, default=0, comment='已用天数')
    days_remaining = Column(Integer, default=0, comment='剩余天数')
    streak_days = Column(Integer, default=0, comment='连续打卡天数')
    last_study_date = Column(Date, comment='最后学习日期')
    
    related_tasks = Column(JSON, comment='关联任务')
    study_group = Column(String(100), comment='学习小组')
    mentor_name = Column(String(100), comment='导师姓名')
    tags = Column(JSON, comment='标签')
    notes = Column(Text, comment='备注')
    
    create_time = Column(DateTime, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
