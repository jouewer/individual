from pydantic import BaseModel, Field, ConfigDict
from pydantic.alias_generators import to_camel
from datetime import datetime
from typing import Optional, Any
from module_admin.annotation.pydantic_annotation import as_query

@as_query
class ExamQuery(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    exam_name: Optional[str] = Field(default=None, description='考试名称')
    exam_subject: Optional[str] = Field(default=None, description='考试科目')
    record_type: Optional[str] = Field(default=None, description='记录类型')
    is_active: Optional[bool] = Field(default=None, description='是否有效')
    page_num: int = Field(default=1, description='当前页码')
    page_size: int = Field(default=10, description='每页数量')

class ExamBase(BaseModel):
    """
    Base model with all fields
    """
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    
    user_id: Optional[int] = None
    record_type: Optional[str] = None
    parent_id: Optional[int] = None
    is_active: Optional[bool] = True
    
    # Exam
    exam_name: Optional[str] = None
    exam_subject: Optional[str] = None
    exam_level: Optional[str] = None
    total_score: Optional[float] = None
    pass_score: Optional[float] = None
    time_limit: Optional[int] = None
    question_count: Optional[int] = None
    word_file_path: Optional[str] = None
    word_file_name: Optional[str] = None
    import_time: Optional[datetime] = None
    import_status: Optional[str] = None
    import_log: Optional[str] = None
    parsing_rules: Optional[Any] = None
    exam_status: Optional[str] = None
    publish_time: Optional[datetime] = None
    start_time: Optional[datetime] = None
    end_time: Optional[datetime] = None
    allow_retake: Optional[bool] = None
    max_retakes: Optional[int] = None
    shuffle_questions: Optional[bool] = None
    shuffle_options: Optional[bool] = None
    average_score: Optional[float] = None
    highest_score: Optional[float] = None
    lowest_score: Optional[float] = None
    pass_rate: Optional[float] = None
    participation_count: Optional[int] = None
    instructions: Optional[str] = None
    notes: Optional[str] = None
    tags: Optional[Any] = None

    # Question
    question_number: Optional[int] = None
    question_type: Optional[str] = None
    question_content: Optional[str] = None
    parsed_from_word: Optional[bool] = None
    original_content: Optional[str] = None
    parsing_confidence: Optional[float] = None
    parsing_notes: Optional[str] = None
    points: Optional[float] = None
    difficulty_level: Optional[str] = None
    correct_answer: Optional[str] = None
    answer_format: Optional[str] = None
    answer_hints: Optional[str] = None
    explanation: Optional[str] = None
    options: Optional[Any] = None
    correct_options: Optional[Any] = None
    blank_count: Optional[int] = None
    blank_positions: Optional[Any] = None
    blank_answers: Optional[Any] = None
    question_images: Optional[Any] = None
    answer_images: Optional[Any] = None
    attachments: Optional[Any] = None
    knowledge_point: Optional[str] = None
    chapter: Optional[str] = None
    section: Optional[str] = None
    correct_rate: Optional[float] = None
    average_time_spent: Optional[int] = None
    discrimination_index: Optional[float] = None
    is_randomized: Optional[bool] = None

    # Rule
    rule_name: Optional[str] = None
    rule_type: Optional[str] = None
    detection_pattern: Optional[str] = None
    pattern_type: Optional[str] = None
    mapped_question_type: Optional[str] = None
    priority: Optional[int] = None
    is_regex: Optional[bool] = None
    case_sensitive: Optional[bool] = None
    action_type: Optional[str] = None
    action_params: Optional[Any] = None
    example_text: Optional[str] = None
    parsing_result: Optional[str] = None
    is_default: Optional[bool] = None

    # Exam Record
    examinee_user_id: Optional[int] = None
    exam_start_time: Optional[datetime] = None
    exam_end_time: Optional[datetime] = None
    exam_time_spent: Optional[int] = None
    obtained_score: Optional[float] = None
    score_percentage: Optional[float] = None
    answers: Optional[Any] = None
    correct_answers_record: Optional[Any] = None
    scoring_details: Optional[Any] = None
    exam_record_status: Optional[str] = None
    is_passed: Optional[bool] = None
    is_cheating: Optional[bool] = None
    cheating_reason: Optional[str] = None
    correct_count: Optional[int] = None
    wrong_count: Optional[int] = None
    unanswered_count: Optional[int] = None

    # Answer Detail
    question_id: Optional[int] = None
    user_answer: Optional[str] = None
    answer_time: Optional[datetime] = None
    time_spent_on_question: Optional[int] = None
    points_obtained: Optional[float] = None
    max_points: Optional[float] = None
    scoring_method: Optional[str] = None
    scoring_notes: Optional[str] = None
    scoring_by: Optional[int] = None
    is_correct: Optional[bool] = None
    is_reviewed: Optional[bool] = None

class ExamModel(ExamBase):
    model_config = ConfigDict(from_attributes=True, alias_generator=to_camel, populate_by_name=True)
    
    id: Optional[int] = None
    create_time: Optional[datetime] = None
    update_time: Optional[datetime] = None

class ExamCreate(ExamBase):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    pass

class ExamUpdate(ExamBase):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
    id: int
