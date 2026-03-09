from sqlalchemy import Column, String, Integer, DateTime, Boolean, DECIMAL, Enum, Text, JSON
from config.database import Base
from datetime import datetime

class ComprehensiveExam(Base):
    """
    综合考试表
    """
    __tablename__ = 'comprehensive_exams'
    
    # 主键
    id = Column(Integer, primary_key=True, autoincrement=True, comment='主键ID')
    user_id = Column(Integer, nullable=False, comment='用户ID')
    
    # 记录类型标识
    record_type = Column(String(50), nullable=False, comment='记录类型')
    
    # ========== 通用字段 ==========
    parent_id = Column(Integer, nullable=True, comment='父记录ID')
    is_active = Column(Boolean, default=True, comment='是否有效')
    create_time = Column(DateTime, default=datetime.now, comment='创建时间')
    update_time = Column(DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')
    
    # ========== 考试相关字段（当 record_type = '考试' 时使用） ==========
    exam_name = Column(String(200), comment='考试名称')
    exam_subject = Column(String(100), comment='考试科目')
    exam_level = Column(String(50), comment='考试等级')
    total_score = Column(DECIMAL(5, 1), default=100.0, comment='总分')
    pass_score = Column(DECIMAL(5, 1), comment='及格分数')
    time_limit = Column(Integer, comment='考试时长（分钟）')
    question_count = Column(Integer, comment='题目总数')
    
    # Word导入信息
    word_file_path = Column(String(500), comment='Word文件路径')
    word_file_name = Column(String(200), comment='Word文件名')
    import_time = Column(DateTime, comment='导入时间')
    import_status = Column(String(50), comment='导入状态')
    import_log = Column(Text, comment='导入日志')
    parsing_rules = Column(JSON, comment='解析规则')
    
    # 考试状态
    exam_status = Column(String(50), default='草稿', comment='考试状态')
    publish_time = Column(DateTime, comment='发布时间')
    start_time = Column(DateTime, comment='开始时间')
    end_time = Column(DateTime, comment='结束时间')
    
    # 防作弊设置
    allow_retake = Column(Boolean, default=False, comment='允许重考')
    max_retakes = Column(Integer, default=0, comment='最大重考次数')
    shuffle_questions = Column(Boolean, default=True, comment='随机题目顺序')
    shuffle_options = Column(Boolean, default=True, comment='随机选项顺序')
    
    # 统计分析
    average_score = Column(DECIMAL(5, 1), comment='平均分')
    highest_score = Column(DECIMAL(5, 1), comment='最高分')
    lowest_score = Column(DECIMAL(5, 1), comment='最低分')
    pass_rate = Column(DECIMAL(5, 2), comment='及格率')
    participation_count = Column(Integer, default=0, comment='参与人数')
    
    # 考试说明
    instructions = Column(Text, comment='考试说明')
    notes = Column(Text, comment='备注')
    tags = Column(JSON, comment='标签')

    # ========== 题目相关字段（当 record_type = '题目' 时使用） ========== 
    question_number = Column(Integer, comment='题号')
    question_type = Column(String(50), comment='题型')
    question_content = Column(Text, comment='题目内容')
    
    # 题目解析信息
    parsed_from_word = Column(Boolean, default=False, comment='是否从Word解析')
    original_content = Column(Text, comment='原始内容')
    parsing_confidence = Column(DECIMAL(4, 3), comment='解析置信度')
    parsing_notes = Column(Text, comment='解析备注')
    
    # 分值设置
    points = Column(DECIMAL(5, 1), default=1.0, comment='分值')
    difficulty_level = Column(String(50), default='中等', comment='难度级别')
    
    # 答案设置
    correct_answer = Column(Text, comment='正确答案')
    answer_format = Column(String(100), comment='答案格式')
    answer_hints = Column(Text, comment='答题提示')
    explanation = Column(Text, comment='答案解析')
    
    # 选项设置（用于选择题）
    options = Column(JSON, comment='选项列表')
    correct_options = Column(JSON, comment='正确选项索引')
    
    # 填空题设置
    blank_count = Column(Integer, comment='填空数量')
    blank_positions = Column(JSON, comment='填空位置')
    blank_answers = Column(JSON, comment='填空答案')
    
    # 图片和附件
    question_images = Column(JSON, comment='题目图片')
    answer_images = Column(JSON, comment='答案图片')
    attachments = Column(JSON, comment='附件')
    
    # 分类信息
    knowledge_point = Column(String(200), comment='知识点')
    chapter = Column(String(100), comment='章节')
    section = Column(String(100), comment='小节')
    
    # 统计信息
    correct_rate = Column(DECIMAL(5, 2), comment='正确率')
    average_time_spent = Column(Integer, comment='平均答题时间（秒）')
    discrimination_index = Column(DECIMAL(4, 3), comment='区分度')
    is_randomized = Column(Boolean, default=True, comment='是否参与随机')

    # ========== 解析规则字段（当 record_type = '解析规则' 时使用） ==========
    rule_name = Column(String(100), comment='规则名称')
    rule_type = Column(String(50), comment='规则类型')
    detection_pattern = Column(String(200), comment='检测模式')
    pattern_type = Column(String(50), comment='模式类型')
    mapped_question_type = Column(String(50), comment='对应题型')
    priority = Column(Integer, default=1, comment='优先级')
    is_regex = Column(Boolean, default=False, comment='是否正则表达式')
    case_sensitive = Column(Boolean, default=False, comment='是否区分大小写')
    action_type = Column(String(50), comment='动作类型')
    action_params = Column(JSON, comment='动作参数')
    example_text = Column(Text, comment='示例文本')
    parsing_result = Column(Text, comment='解析结果示例')
    is_default = Column(Boolean, default=False, comment='是否默认规则')

    # ========== 考试记录字段（当 record_type = '考试记录' 时使用） ==========
    examinee_user_id = Column(Integer, comment='考生用户ID')
    exam_start_time = Column(DateTime, comment='开始考试时间')
    exam_end_time = Column(DateTime, comment='结束考试时间')
    exam_time_spent = Column(Integer, comment='用时（秒）')
    obtained_score = Column(DECIMAL(5, 1), comment='得分')
    score_percentage = Column(DECIMAL(5, 2), comment='得分百分比')
    answers = Column(JSON, comment='考生答案')
    correct_answers_record = Column(JSON, comment='正确答案')
    scoring_details = Column(JSON, comment='评分详情')
    exam_record_status = Column(String(50), default='未开始', comment='考试状态')
    is_passed = Column(Boolean, comment='是否通过')
    is_cheating = Column(Boolean, default=False, comment='是否作弊')
    cheating_reason = Column(Text, comment='作弊原因')
    correct_count = Column(Integer, comment='答对题数')
    wrong_count = Column(Integer, comment='答错题数')
    unanswered_count = Column(Integer, comment='未答题数')

    # ========== 答题详情字段（当 record_type = '答题详情' 时使用） ==========
    question_id = Column(Integer, comment='题目ID')
    user_answer = Column(Text, comment='考生答案')
    answer_time = Column(DateTime, comment='答题时间')
    time_spent_on_question = Column(Integer, comment='本题用时（秒）')
    points_obtained = Column(DECIMAL(5, 1), comment='得分')
    max_points = Column(DECIMAL(5, 1), comment='满分')
    scoring_method = Column(String(50), default='自动', comment='评分方式')
    scoring_notes = Column(Text, comment='评分备注')
    scoring_by = Column(Integer, comment='评分人')
    is_correct = Column(Boolean, comment='是否正确')
    is_reviewed = Column(Boolean, default=False, comment='是否已复核')
