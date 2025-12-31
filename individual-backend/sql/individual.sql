/*
 Navicat Premium Data Transfer

 Source Server         : 本机
 Source Server Type    : MySQL
 Source Server Version : 50730
 Source Host           : localhost:3306
 Source Schema         : individual

 Target Server Type    : MySQL
 Target Server Version : 50730
 File Encoding         : 65001

 Date: 31/12/2025 18:16:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for apscheduler_jobs
-- ----------------------------
DROP TABLE IF EXISTS `apscheduler_jobs`;
CREATE TABLE `apscheduler_jobs`  (
  `id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `next_run_time` double NULL DEFAULT NULL,
  `job_state` blob NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ix_apscheduler_jobs_next_run_time`(`next_run_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comprehensive_detections
-- ----------------------------
DROP TABLE IF EXISTS `comprehensive_detections`;
CREATE TABLE `comprehensive_detections`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `detection_time` datetime(0) NOT NULL COMMENT '检测时间',
  `media_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '媒体文件路径',
  `media_type` enum('图片','视频','实时流') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '图片' COMMENT '媒体类型',
  `detection_type` enum('表情检测','动作检测','人物检测','综合检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '检测类型',
  `emotion_type` enum('高兴','悲伤','愤怒','惊讶','恐惧','厌恶','平静','未检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未检测' COMMENT '表情类型',
  `emotion_confidence` decimal(4, 3) NULL DEFAULT NULL COMMENT '表情置信度',
  `emotion_bbox` json NULL COMMENT '表情检测边界框',
  `action_type` enum('正常','摔倒','跌倒','躺倒','坐地','站立','行走','奔跑','未检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未检测' COMMENT '动作类型',
  `action_confidence` decimal(4, 3) NULL DEFAULT NULL COMMENT '动作置信度',
  `action_bbox` json NULL COMMENT '动作检测边界框',
  `fall_direction` enum('向前','向后','向左','向右','直倒','未检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摔倒方向',
  `fall_severity` enum('轻微','中度','严重','未检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摔倒严重程度',
  `recovery_time_seconds` int(11) NULL DEFAULT NULL COMMENT '恢复时间(秒)',
  `is_getting_up` tinyint(1) NULL DEFAULT NULL COMMENT '是否正在起身',
  `person_type` enum('本人','家人','朋友','陌生人','服务人员','其他','未检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未检测' COMMENT '人员类型',
  `person_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '人员姓名',
  `person_identifier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '人员标识符',
  `person_confidence` decimal(4, 3) NULL DEFAULT NULL COMMENT '人物识别置信度',
  `estimated_age` int(11) NULL DEFAULT NULL COMMENT '估计年龄',
  `estimated_gender` enum('男','女','未知') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '估计性别',
  `clothing_color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '服装主色',
  `accessories` json NULL COMMENT '配饰',
  `is_self` tinyint(1) NULL DEFAULT 0 COMMENT '是否本人',
  `relationship_level` enum('亲密','熟悉','一般','陌生','未知') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未知' COMMENT '关系程度',
  `is_trusted` tinyint(1) NULL DEFAULT 0 COMMENT '是否可信人员',
  `is_blacklist` tinyint(1) NULL DEFAULT 0 COMMENT '是否黑名单',
  `location_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '检测地点',
  `environment` enum('客厅','卧室','厨房','浴室','走廊','阳台','室外','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '环境类型',
  `scene_context` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '场景描述',
  `safety_level` enum('安全','注意','警告','危险','紧急') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '安全' COMMENT '安全等级',
  `anomaly_score` decimal(3, 2) NULL DEFAULT 0.00 COMMENT '异常分数(0-1)',
  `event_type` enum('正常','摔倒事件','异常表情','陌生人出现','紧急情况','其他事件') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '正常' COMMENT '事件类型',
  `event_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '事件描述',
  `detection_count` int(11) NULL DEFAULT 1 COMMENT '该人员检测次数',
  `first_detected_time` datetime(0) NULL DEFAULT NULL COMMENT '首次检测时间',
  `last_detected_time` datetime(0) NULL DEFAULT NULL COMMENT '最后检测时间',
  `detector_model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '检测模型',
  `detector_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '检测器版本',
  `raw_data` json NULL COMMENT '原始检测数据',
  `requires_attention` tinyint(1) NULL DEFAULT 0 COMMENT '需要人工关注',
  `is_verified` tinyint(1) NULL DEFAULT 0 COMMENT '是否已验证',
  `verification_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '验证备注',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id`, `detection_time`) USING BTREE,
  INDEX `idx_detection_type`(`detection_type`) USING BTREE,
  INDEX `idx_emotion_type`(`emotion_type`) USING BTREE,
  INDEX `idx_action_type`(`action_type`) USING BTREE,
  INDEX `idx_person_type`(`person_type`) USING BTREE,
  INDEX `idx_safety_level`(`safety_level`) USING BTREE,
  INDEX `idx_event_type`(`event_type`) USING BTREE,
  INDEX `idx_requires_attention`(`requires_attention`) USING BTREE,
  INDEX `idx_is_self`(`is_self`) USING BTREE,
  INDEX `idx_location`(`location_name`) USING BTREE,
  INDEX `idx_environment`(`environment`) USING BTREE,
  INDEX `idx_person_identifier`(`person_identifier`) USING BTREE,
  INDEX `idx_anomaly_score`(`anomaly_score`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '综合检测表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comprehensive_detections
-- ----------------------------
INSERT INTO `comprehensive_detections` VALUES (1, 1, '2024-01-15 10:30:25', '/videos/living_room/20240115_1030.mp4', '视频', '综合检测', '恐惧', 0.850, '{\"x\": 120, \"y\": 80, \"width\": 180, \"height\": 220}', '摔倒', 0.920, '{\"x\": 100, \"y\": 150, \"width\": 200, \"height\": 350}', '向后', '中度', 8, 0, '本人', '张爷爷', 'person_001', 0.950, 72, '男', '蓝色', '[\"老花镜\"]', 1, '亲密', 1, 0, '客厅', '客厅', '老人在看电视时起身摔倒', '紧急', 0.85, '摔倒事件', '72岁老人在客厅向后摔倒，需要立即检查', 1, NULL, NULL, 'YOLOv8-Fall', 'v2.1', NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (2, 1, '2024-01-15 14:45:30', '/images/door_camera/20240115_1445.jpg', '图片', '人物检测', '未检测', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '陌生人', NULL, 'unknown_001', 0.780, 35, '男', '黑色', '[\"帽子\", \"口罩\", \"背包\"]', 0, '陌生', 0, 1, '家门口', '室外', '陌生男子在门口长时间停留', '危险', 0.75, '陌生人出现', '可疑人员在门口徘徊5分钟以上', 1, NULL, NULL, 'FaceNet', 'v1.5', NULL, 1, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (3, 1, '2024-01-15 16:20:15', '/images/nursery/20240115_1620.jpg', '图片', '表情检测', '悲伤', 0.910, '{\"x\": 150, \"y\": 100, \"width\": 120, \"height\": 150}', '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '家人', '小宝', 'person_003', 0.960, 5, '女', '粉色', NULL, 0, '亲密', 0, 0, '儿童房', '卧室', '孩子在房间独自哭泣', '注意', 0.65, '异常表情', '5岁孩子独自在房间哭泣，需要关注', 1, NULL, NULL, 'EmotionNet', 'v3.0', NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (4, 1, '2024-01-15 08:15:40', '/videos/kitchen/20240115_0815.mp4', '视频', '动作检测', '未检测', NULL, NULL, '行走', 0.880, '{\"x\": 200, \"y\": 180, \"width\": 80, \"height\": 200}', NULL, NULL, NULL, NULL, '家人', '李奶奶', 'person_002', 0.920, 68, '女', '红色', NULL, 0, '未知', 0, 0, '厨房', '厨房', NULL, '安全', 0.10, '正常', NULL, 1, NULL, NULL, 'OpenPose', 'v1.8', NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (5, 1, '2024-01-15 19:30:10', '/videos/bathroom/20240115_1930.mp4', '视频', '动作检测', '未检测', NULL, NULL, '摔倒', 0.870, '{\"x\": 180, \"y\": 200, \"width\": 90, \"height\": 180}', '向左', '轻微', 2, 1, '本人', '王爷爷', 'person_004', 0.940, 70, '男', '灰色', NULL, 1, '未知', 0, 0, '浴室', '浴室', NULL, '警告', 0.45, '摔倒事件', '老人在浴室轻微滑倒，2秒后自行起身', 1, NULL, NULL, 'FallDetect-Pro', 'v2.3', NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (6, 1, '2024-01-14 18:45:20', '/images/living_room/20240114_1845.jpg', '图片', '表情检测', '高兴', 0.930, '{\"x\": 160, \"y\": 90, \"width\": 140, \"height\": 170}', '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '朋友', '老张', 'person_005', 0.890, 45, '男', '白色', NULL, 0, '未知', 0, 0, '客厅', '客厅', '家庭聚会，朋友来访', '安全', 0.05, '正常', NULL, 1, NULL, NULL, 'EmotionNet', 'v3.0', NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (7, 1, '2024-01-14 21:30:45', '/videos/living_room/20240114_2130.mp4', '视频', '表情检测', '愤怒', 0.880, '{\"x\": 140, \"y\": 110, \"width\": 130, \"height\": 160}', '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '家人', '妻子', 'person_006', 0.970, 38, '女', '紫色', NULL, 0, '未知', 0, 0, '客厅', '客厅', '夫妻发生争执', '注意', 0.60, '异常表情', '检测到愤怒表情，可能有家庭矛盾', 1, NULL, NULL, 'EmotionNet', 'v3.0', NULL, 1, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (8, 1, '2024-01-14 15:20:30', '/videos/bedroom/20240114_1520.mp4', '视频', '动作检测', '未检测', NULL, NULL, '躺倒', 0.910, '{\"x\": 300, \"y\": 250, \"width\": 150, \"height\": 100}', '直倒', '未检测', 300, 0, '本人', '刘爷爷', 'person_007', 0.930, 75, '男', '蓝色', NULL, 1, '未知', 0, 0, '卧室', '卧室', NULL, '警告', 0.70, '其他事件', '老人长时间躺在地上未起身', 1, NULL, NULL, 'FallDetect-Pro', 'v2.3', NULL, 1, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (9, 1, '2024-01-14 09:15:00', '/images/door_camera/20240114_0915.jpg', '图片', '人物检测', '未检测', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '服务人员', '快递员小李', 'person_008', 0.820, 28, '男', '绿色', '[\"工作服\", \"帽子\"]', 0, '一般', 1, 0, '家门口', '室外', '快递员正常送货', '安全', 0.15, '正常', NULL, 1, NULL, NULL, 'FaceNet', 'v1.5', NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (10, 1, '2024-01-13 23:10:15', '/videos/corridor/20240113_2310.mp4', '视频', '表情检测', '恐惧', 0.940, '{\"x\": 130, \"y\": 100, \"width\": 140, \"height\": 180}', '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '家人', '女儿', 'person_009', 0.960, 12, '女', '粉色', NULL, 0, '未知', 0, 0, '走廊', '走廊', NULL, '警告', 0.80, '异常表情', '孩子在走廊出现惊恐表情，可能有突发情况', 1, NULL, NULL, 'EmotionNet', 'v3.0', NULL, 1, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (11, 1, '2024-01-13 07:30:00', '/images/kitchen/20240113_0730.jpg', '图片', '综合检测', '平静', NULL, NULL, '站立', NULL, NULL, NULL, NULL, NULL, NULL, '本人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (12, 1, '2024-01-13 12:45:00', '/videos/living_room/20240113_1245.mp4', '视频', '动作检测', '未检测', NULL, NULL, '坐地', NULL, NULL, NULL, NULL, NULL, NULL, '家人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '注意', 0.00, '其他事件', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (13, 1, '2024-01-12 16:20:00', '/images/door_camera/20240112_1620.jpg', '图片', '人物检测', '未检测', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '陌生人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '危险', 0.00, '陌生人出现', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (14, 1, '2024-01-12 20:15:00', '/videos/bedroom/20240112_2015.mp4', '视频', '表情检测', '高兴', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '本人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (15, 1, '2024-01-11 11:30:00', '/videos/bathroom/20240111_1130.mp4', '视频', '动作检测', '未检测', NULL, NULL, '正常', NULL, NULL, NULL, NULL, NULL, NULL, '家人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (16, 1, '2024-01-11 14:40:00', '/images/living_room/20240111_1440.jpg', '图片', '综合检测', '惊讶', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '朋友', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (17, 1, '2024-01-10 09:00:00', '/videos/kitchen/20240110_0900.mp4', '视频', '动作检测', '未检测', NULL, NULL, '行走', NULL, NULL, NULL, NULL, NULL, NULL, '本人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (18, 1, '2024-01-10 17:50:00', '/images/door_camera/20240110_1750.jpg', '图片', '人物检测', '未检测', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '服务人员', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (19, 1, '2024-01-09 13:20:00', '/videos/living_room/20240109_1320.mp4', '视频', '表情检测', '厌恶', NULL, NULL, '未检测', NULL, NULL, NULL, NULL, NULL, NULL, '本人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '注意', 0.00, '异常表情', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');
INSERT INTO `comprehensive_detections` VALUES (20, 1, '2024-01-08 19:30:00', '/videos/balcony/20240108_1930.mp4', '视频', '综合检测', '平静', NULL, NULL, '奔跑', NULL, NULL, NULL, NULL, NULL, NULL, '家人', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '未知', 0, 0, NULL, NULL, NULL, '安全', 0.00, '正常', NULL, 1, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '2025-12-29 15:42:24', '2025-12-29 15:42:24');

-- ----------------------------
-- Table structure for comprehensive_exams
-- ----------------------------
DROP TABLE IF EXISTS `comprehensive_exams`;
CREATE TABLE `comprehensive_exams`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `record_type` enum('考试','题目','解析规则','考试记录','答题详情') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '记录类型',
  `parent_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '父记录ID（用于关联）',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `exam_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '考试名称',
  `exam_subject` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '考试科目',
  `exam_level` enum('初级','中级','高级','专业','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '考试等级',
  `total_score` decimal(5, 1) NULL DEFAULT 100.0 COMMENT '总分',
  `pass_score` decimal(5, 1) NULL DEFAULT NULL COMMENT '及格分数',
  `time_limit` int(11) NULL DEFAULT NULL COMMENT '考试时长（分钟）',
  `question_count` int(11) NULL DEFAULT NULL COMMENT '题目总数',
  `word_file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Word文件路径',
  `word_file_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Word文件名',
  `import_time` datetime(0) NULL DEFAULT NULL COMMENT '导入时间',
  `import_status` enum('待导入','导入中','导入成功','导入失败','部分成功') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '导入状态',
  `import_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '导入日志',
  `parsing_rules` json NULL COMMENT '解析规则',
  `exam_status` enum('草稿','已发布','进行中','已结束','已归档') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '草稿' COMMENT '考试状态',
  `publish_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `allow_retake` tinyint(1) NULL DEFAULT 0 COMMENT '允许重考',
  `max_retakes` int(11) NULL DEFAULT 0 COMMENT '最大重考次数',
  `shuffle_questions` tinyint(1) NULL DEFAULT 1 COMMENT '随机题目顺序',
  `shuffle_options` tinyint(1) NULL DEFAULT 1 COMMENT '随机选项顺序',
  `average_score` decimal(5, 1) NULL DEFAULT NULL COMMENT '平均分',
  `highest_score` decimal(5, 1) NULL DEFAULT NULL COMMENT '最高分',
  `lowest_score` decimal(5, 1) NULL DEFAULT NULL COMMENT '最低分',
  `pass_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '及格率',
  `participation_count` int(11) NULL DEFAULT 0 COMMENT '参与人数',
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '考试说明',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `tags` json NULL COMMENT '标签',
  `question_number` int(11) NULL DEFAULT NULL COMMENT '题号',
  `question_type` enum('单选题','多选题','判断题','填空题','简答题','论述题','计算题','案例分析') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '题型',
  `question_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '题目内容',
  `parsed_from_word` tinyint(1) NULL DEFAULT 0 COMMENT '是否从Word解析',
  `original_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '原始内容',
  `parsing_confidence` decimal(4, 3) NULL DEFAULT NULL COMMENT '解析置信度',
  `parsing_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解析备注',
  `points` decimal(5, 1) NULL DEFAULT 1.0 COMMENT '分值',
  `difficulty_level` enum('简单','中等','困难','非常困难') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '中等' COMMENT '难度级别',
  `correct_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '正确答案',
  `answer_format` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '答案格式',
  `answer_hints` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '答题提示',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '答案解析',
  `options` json NULL COMMENT '选项列表',
  `correct_options` json NULL COMMENT '正确选项索引',
  `blank_count` int(11) NULL DEFAULT NULL COMMENT '填空数量',
  `blank_positions` json NULL COMMENT '填空位置',
  `blank_answers` json NULL COMMENT '填空答案',
  `question_images` json NULL COMMENT '题目图片',
  `answer_images` json NULL COMMENT '答案图片',
  `attachments` json NULL COMMENT '附件',
  `knowledge_point` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '知识点',
  `chapter` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '章节',
  `section` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '小节',
  `correct_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '正确率',
  `average_time_spent` int(11) NULL DEFAULT NULL COMMENT '平均答题时间（秒）',
  `discrimination_index` decimal(4, 3) NULL DEFAULT NULL COMMENT '区分度',
  `is_randomized` tinyint(1) NULL DEFAULT 1 COMMENT '是否参与随机',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则名称',
  `rule_type` enum('题目检测','选项检测','答案检测','格式检测') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规则类型',
  `detection_pattern` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '检测模式',
  `pattern_type` enum('正则表达式','关键词','数字序号','字母序号') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '模式类型',
  `mapped_question_type` enum('单选题','多选题','判断题','填空题','简答题','所有题型') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '对应题型',
  `priority` int(11) NULL DEFAULT 1 COMMENT '优先级',
  `is_regex` tinyint(1) NULL DEFAULT 0 COMMENT '是否正则表达式',
  `case_sensitive` tinyint(1) NULL DEFAULT 0 COMMENT '是否区分大小写',
  `action_type` enum('开始题目','结束题目','标记选项','标记答案','提取分值') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '动作类型',
  `action_params` json NULL COMMENT '动作参数',
  `example_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '示例文本',
  `parsing_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解析结果示例',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '是否默认规则',
  `examinee_user_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '考生用户ID',
  `exam_start_time` datetime(0) NULL DEFAULT NULL COMMENT '开始考试时间',
  `exam_end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束考试时间',
  `exam_time_spent` int(11) NULL DEFAULT NULL COMMENT '用时（秒）',
  `obtained_score` decimal(5, 1) NULL DEFAULT NULL COMMENT '得分',
  `score_percentage` decimal(5, 2) NULL DEFAULT NULL COMMENT '得分百分比',
  `answers` json NULL COMMENT '考生答案',
  `correct_answers_record` json NULL COMMENT '正确答案',
  `scoring_details` json NULL COMMENT '评分详情',
  `exam_record_status` enum('未开始','进行中','已提交','已评分','已审核') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '未开始' COMMENT '考试状态',
  `is_passed` tinyint(1) NULL DEFAULT NULL COMMENT '是否通过',
  `is_cheating` tinyint(1) NULL DEFAULT 0 COMMENT '是否作弊',
  `cheating_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '作弊原因',
  `correct_count` int(11) NULL DEFAULT NULL COMMENT '答对题数',
  `wrong_count` int(11) NULL DEFAULT NULL COMMENT '答错题数',
  `unanswered_count` int(11) NULL DEFAULT NULL COMMENT '未答题数',
  `question_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '题目ID（指向题目记录）',
  `user_answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '考生答案',
  `answer_time` datetime(0) NULL DEFAULT NULL COMMENT '答题时间',
  `time_spent_on_question` int(11) NULL DEFAULT NULL COMMENT '本题用时（秒）',
  `points_obtained` decimal(5, 1) NULL DEFAULT NULL COMMENT '得分',
  `max_points` decimal(5, 1) NULL DEFAULT NULL COMMENT '满分',
  `scoring_method` enum('自动','人工','半自动') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '自动' COMMENT '评分方式',
  `scoring_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '评分备注',
  `scoring_by` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '评分人',
  `is_correct` tinyint(1) NULL DEFAULT NULL COMMENT '是否正确',
  `is_reviewed` tinyint(1) NULL DEFAULT 0 COMMENT '是否已复核',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_type`(`user_id`, `record_type`) USING BTREE,
  INDEX `idx_parent`(`parent_id`) USING BTREE,
  INDEX `idx_exam_name`(`exam_name`) USING BTREE,
  INDEX `idx_exam_status`(`exam_status`) USING BTREE,
  INDEX `idx_question_type`(`question_type`) USING BTREE,
  INDEX `idx_difficulty_level`(`difficulty_level`) USING BTREE,
  INDEX `idx_rule_type`(`rule_type`) USING BTREE,
  INDEX `idx_exam_record_status`(`exam_record_status`) USING BTREE,
  INDEX `idx_examinee`(`examinee_user_id`) USING BTREE,
  INDEX `idx_question_id`(`question_id`) USING BTREE,
  INDEX `idx_import_status`(`import_status`) USING BTREE,
  INDEX `idx_is_default`(`is_default`) USING BTREE,
  INDEX `idx_publish_time`(`publish_time`) USING BTREE,
  INDEX `idx_start_time`(`start_time`) USING BTREE,
  INDEX `idx_exam_start_time`(`exam_start_time`) USING BTREE,
  INDEX `idx_answer_time`(`answer_time`) USING BTREE,
  INDEX `idx_is_correct`(`is_correct`) USING BTREE,
  INDEX `idx_is_passed`(`is_passed`) USING BTREE,
  FULLTEXT INDEX `idx_search_content`(`exam_name`, `question_content`, `instructions`)
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '综合考试表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comprehensive_exams
-- ----------------------------
INSERT INTO `comprehensive_exams` VALUES (1, 1, '考试', NULL, 1, '2024-01-15 09:00:00', '2024-01-20 17:00:00', '2024年度数学期末考试', '数学', '中级', 100.0, 60.0, 120, 10, '/uploads/exams/2024_math_final.docx', '2024数学期末试卷.docx', '2024-01-15 10:30:00', '导入成功', '成功导入10题，其中：单选题5题，多选题2题，判断题2题，填空题1题。解析置信度平均0.92。', '{\"detect_answer\": \"答案[：:]\", \"detect_option\": \"^[A-D][\\\\.、．]\", \"detect_question\": \"^\\\\d+[\\\\.、．]\"}', '已发布', '2024-01-15 14:00:00', '2024-01-20 09:00:00', '2024-01-20 11:00:00', 1, 2, 1, 1, 78.5, 95.0, 42.0, 85.60, 50, '1. 考试时间120分钟，总分100分，及格线60分。\r\n2. 请诚信考试，严禁作弊，违者取消成绩。\r\n3. 选择题请用2B铅笔填涂答题卡，填空题和简答题请在指定位置作答。\r\n4. 考试结束前10分钟请检查个人信息和答题卡。\r\n5. 允许携带计算器，但必须是无声、无编程功能的普通计算器。', '本次期末考试覆盖教材第1-8章内容，重点考察函数、几何和概率统计。难度系数0.65。', '[\"期末考试\", \"数学\", \"2024年度\", \"中级难度\", \"闭卷考试\"]', NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (2, 1, '题目', 1, 1, '2024-01-15 10:35:00', '2024-01-15 10:35:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, '单选题', '已知函数 f(x) = x² - 4x + 3，求该函数的最小值。', 1, '1. 已知函数 f(x) = x² - 4x + 3，求该函数的最小值。\nA. -1\nB. 0\nC. 1\nD. 3\n答案：A', 0.950, '成功解析题目、选项和答案', 5.0, '中等', 'A. -1', '单选字母', '可以通过配方法或求导法求解', '首先将函数配方：f(x) = (x-2)² - 1，由于平方项非负，所以当x=2时取得最小值-1。或者求导：f\'(x)=2x-4，令f\'(x)=0得x=2，代入原函数得f(2)=-1。', '[\"A. -1\", \"B. 0\", \"C. 1\", \"D. 3\"]', '[0]', NULL, NULL, NULL, NULL, NULL, NULL, '二次函数最值', '第二章 函数与方程', '2.3 二次函数的性质', 72.50, 90, 0.650, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (3, 1, '题目', 1, 1, '2024-01-15 10:40:00', '2024-01-15 10:40:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 2, '填空题', '圆的面积公式是______，其中r表示______。', 1, '2. 圆的面积公式是______，其中r表示______。（每空2分）\n答案：πr² 半径', 0.880, '成功识别两个填空位置，但答案格式需要人工确认', 4.0, '简单', 'πr², 半径', '逗号分隔', '第一个空填面积公式，第二个空填r的含义', '圆的面积公式为πr²，其中π是圆周率（约等于3.14159），r是圆的半径。', NULL, NULL, 2, '[15, 28]', '[\"πr²\", \"半径\"]', NULL, NULL, NULL, '圆的面积计算', '第三章 几何图形', '3.2 圆的性质', 89.20, 45, 0.350, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (4, 1, '解析规则', NULL, 1, '2024-01-10 14:25:00', '2024-01-15 11:00:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '数字序号题目检测', '题目检测', '^\\d+[\\.、．\\s]', '数字序号', '所有题型', 1, 1, 0, '开始题目', '{\"position\": \"start\", \"extract_number\": true}', '1. 下列哪个数是质数？', '检测到题目开始，提取题号：1', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (5, 1, '解析规则', NULL, 1, '2024-01-10 14:30:00', '2024-01-15 11:00:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '单选题选项检测', '选项检测', '^[A-D][\\.、．\\s]', '字母序号', '单选题', 2, 1, 0, '标记选项', '{\"max_options\": 4, \"option_index_offset\": 0}', 'A. 4\nB. 9\nC. 11\nD. 15', '检测到选项A、B、C、D', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (6, 1, '解析规则', NULL, 1, '2024-01-10 14:35:00', '2024-01-15 11:00:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '填空题下划线检测', '题目检测', '_{3,}', '正则表达式', '填空题', 3, 1, 0, '开始题目', '{\"blank_marker\": \"_\", \"count_blanks\": true}', '圆的面积公式是______。', '检测到填空题，有1个填空位置', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (7, 1, '解析规则', NULL, 1, '2024-01-10 14:40:00', '2024-01-15 11:00:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '答案关键字检测', '答案检测', '答案[：:\\s]', '关键词', '所有题型', 4, 0, 0, '标记答案', '{\"position\": \"after\", \"strip_prefix\": true}', '答案：A', '检测到答案部分，提取答案：A', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (8, 1, '解析规则', NULL, 1, '2024-01-10 14:45:00', '2024-01-15 11:00:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '分值提取规则', '格式检测', '\\(\\s*\\d+(\\.\\d+)?\\s*分\\s*\\)', '正则表达式', '所有题型', 5, 1, 0, '提取分值', '{\"default_points\": 1, \"extract_number\": true}', '（5分）', '提取到分值：5.0', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (9, 1, '考试记录', 1, 1, '2024-01-20 11:05:00', '2024-01-20 16:30:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, 2, '2024-01-20 09:05:00', '2024-01-20 10:50:00', 6300, 87.0, 87.00, '{\"1\": \"A\", \"2\": [\"πr²\", \"半径\"], \"3\": [\"A\", \"C\"], \"4\": \"错误\", \"5\": \"北京\", \"6\": \"1921,103\", \"7\": \"光合作用\", \"8\": \"牛顿第一定律\", \"9\": \"解：设边长为x，则x²=25，解得x=5\", \"10\": \"中国特色社会主义最本质的特征是中国共产党领导。\"}', '{\"1\": \"A\", \"2\": [\"πr²\", \"半径\"], \"3\": [\"A\", \"C\"], \"4\": \"错误\", \"5\": \"北京\", \"6\": \"1921,103\", \"7\": \"光合作用\", \"8\": \"牛顿第一定律\", \"9\": \"5\", \"10\": \"中国共产党领导\"}', '{\"1\": {\"correct\": true, \"scoring_method\": \"自动\", \"points_obtained\": 5}, \"2\": {\"correct\": true, \"scoring_method\": \"自动\", \"points_obtained\": 4}, \"3\": {\"correct\": true, \"scoring_method\": \"自动\", \"points_obtained\": 6}, \"4\": {\"correct\": true, \"scoring_method\": \"自动\", \"points_obtained\": 2}, \"5\": {\"correct\": true, \"scoring_method\": \"自动\", \"points_obtained\": 2}, \"6\": {\"correct\": true, \"scoring_method\": \"自动\", \"points_obtained\": 4}, \"7\": {\"correct\": true, \"scoring_method\": \"人工\", \"points_obtained\": 10}, \"8\": {\"correct\": true, \"scoring_method\": \"人工\", \"points_obtained\": 10}, \"9\": {\"correct\": true, \"scoring_method\": \"人工\", \"points_obtained\": 15}, \"10\": {\"correct\": true, \"scoring_method\": \"人工\", \"points_obtained\": 29}}', '已评分', 1, 0, NULL, 10, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, '自动', NULL, NULL, NULL, 0);
INSERT INTO `comprehensive_exams` VALUES (10, 1, '答题详情', 9, 1, '2024-01-20 16:30:00', '2024-01-20 16:30:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, 2, 'A', '2024-01-20 09:10:00', 180, 5.0, 5.0, '自动', '答案正确，使用配方法求解，步骤完整', NULL, 1, 1);
INSERT INTO `comprehensive_exams` VALUES (11, 1, '答题详情', 9, 1, '2024-01-20 16:30:00', '2024-01-20 16:30:00', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, 3, '[\"πr²\", \"半径\"]', '2024-01-20 09:12:00', 120, 4.0, 4.0, '自动', '两个填空都正确，第一空写πr²（允许写π*r²或π×r²），第二空写半径（允许写圆的半径）', NULL, 1, 1);
INSERT INTO `comprehensive_exams` VALUES (18, 1, '答题详情', 9, 1, '2024-01-20 16:30:00', '2025-12-31 17:13:34', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, '[\"A\", \"C\"]', '2024-01-20 09:15:00', 150, 6.0, 6.0, '自动', NULL, NULL, 1, 0);
INSERT INTO `comprehensive_exams` VALUES (19, 1, '答题详情', 9, 1, '2024-01-20 16:30:00', '2025-12-31 17:13:34', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, '错误', '2024-01-20 09:18:00', 60, 2.0, 2.0, '自动', NULL, NULL, 1, 0);
INSERT INTO `comprehensive_exams` VALUES (20, 1, '答题详情', 9, 1, '2024-01-20 16:30:00', '2025-12-31 17:13:34', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '草稿', NULL, NULL, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1.0, '中等', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '未开始', NULL, 0, NULL, NULL, NULL, NULL, NULL, '北京', '2024-01-20 09:20:00', 90, 2.0, 2.0, '自动', NULL, NULL, 1, 0);

-- ----------------------------
-- Table structure for electronic_devices
-- ----------------------------
DROP TABLE IF EXISTS `electronic_devices`;
CREATE TABLE `electronic_devices`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `device_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备名称',
  `device_type` enum('手机','电脑','平板','相机','电视','音响','游戏机','智能家居','小家电','办公设备','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设备类型',
  `brand` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '品牌',
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '型号',
  `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '序列号',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '颜色',
  `device_status` enum('全新','已使用','已损坏','待维修','已闲置','已丢弃') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '已使用' COMMENT '设备状态',
  `purchase_status` enum('已拥有','待购买','购买中','运输中','退货中') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '已拥有' COMMENT '购买状态',
  `storage_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存放位置',
  `location_type` enum('客厅','卧室','书房','厨房','办公室','仓库','车上','随身携带','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '位置类型',
  `specific_spot` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '具体位置（如：书桌抽屉、床头柜等）',
  `quantity` int(11) NOT NULL DEFAULT 1 COMMENT '数量',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `total_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '总价值',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '货币',
  `purchase_date` date NULL DEFAULT NULL COMMENT '购买日期',
  `purchase_from` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '购买渠道',
  `warranty_period` int(11) NULL DEFAULT NULL COMMENT '保修期（月）',
  `warranty_end_date` date NULL DEFAULT NULL COMMENT '保修截止日期',
  `invoice_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发票号码',
  `start_use_date` date NULL DEFAULT NULL COMMENT '开始使用日期',
  `estimated_lifespan` int(11) NULL DEFAULT NULL COMMENT '预计寿命（月）',
  `usage_frequency` enum('每天使用','经常使用','偶尔使用','很少使用','基本不用') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '使用频率',
  `last_used_date` date NULL DEFAULT NULL COMMENT '最后使用日期',
  `specifications` json NULL COMMENT '技术规格',
  `accessories` json NULL COMMENT '配件清单',
  `software_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '软件信息',
  `maintenance_records` json NULL COMMENT '维护记录',
  `repair_history` json NULL COMMENT '维修历史',
  `next_maintenance_date` date NULL DEFAULT NULL COMMENT '下次维护日期',
  `device_images` json NULL COMMENT '设备图片',
  `manual_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '说明书路径',
  `warranty_card_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '保修卡图片',
  `invoice_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发票图片',
  `tags` json NULL COMMENT '标签',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `important_level` enum('非常重要','重要','一般','不重要') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '一般' COMMENT '重要程度',
  `is_shared` tinyint(1) NULL DEFAULT 0 COMMENT '是否共享设备',
  `shared_with` json NULL COMMENT '共享给谁',
  `low_battery_reminder` tinyint(1) NULL DEFAULT 0 COMMENT '低电量提醒',
  `warranty_expire_reminder` tinyint(1) NULL DEFAULT 0 COMMENT '保修到期提醒',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_device_serial`(`user_id`, `serial_number`) USING BTREE,
  INDEX `idx_user_device`(`user_id`, `device_type`) USING BTREE,
  INDEX `idx_device_status`(`device_status`) USING BTREE,
  INDEX `idx_purchase_status`(`purchase_status`) USING BTREE,
  INDEX `idx_storage_location`(`storage_location`) USING BTREE,
  INDEX `idx_location_type`(`location_type`) USING BTREE,
  INDEX `idx_brand_model`(`brand`, `model`) USING BTREE,
  INDEX `idx_purchase_date`(`purchase_date`) USING BTREE,
  INDEX `idx_warranty_end`(`warranty_end_date`) USING BTREE,
  INDEX `idx_next_maintenance`(`next_maintenance_date`) USING BTREE,
  INDEX `idx_important_level`(`important_level`) USING BTREE,
  FULLTEXT INDEX `idx_device_search`(`device_name`, `brand`, `model`, `notes`)
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '电子设备管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of electronic_devices
-- ----------------------------
INSERT INTO `electronic_devices` VALUES (1, 1, 'iPhone 14 Pro Max', '手机', '苹果', 'iPhone 14 Pro Max', 'SN123456789APPLE', '深空黑', '已使用', '已拥有', '随身携带', '随身携带', '裤袋或手中', 1, 8999.00, 8999.00, 'CNY', '2023-03-15', '苹果官网', 12, '2024-03-14', 'INV202303151234', '2023-03-16', 36, '每天使用', '2025-12-31', '{\"内存\": \"256GB\", \"处理器\": \"A16仿生\", \"摄像头\": \"4800万像素主摄\", \"屏幕尺寸\": \"6.7英寸\", \"操作系统\": \"iOS 17\", \"电池容量\": \"4323mAh\"}', '[\"20W充电器\", \"USB-C数据线\", \"SIM卡针\", \"苹果贴纸\"]', 'iOS 17.2.1, 微信8.0.40, 支付宝10.5.0, 淘宝11.10.0', '[{\"cost\": 29.9, \"date\": \"2023-09-15\", \"action\": \"更换钢化膜\"}, {\"cost\": 0, \"date\": \"2024-01-10\", \"action\": \"清洁充电口\"}]', '[{\"cost\": 0, \"date\": \"2023-12-20\", \"problem\": \"电池健康度降至89%\", \"solution\": \"优化充电习惯\"}]', '2024-06-15', '[\"/images/iphone_front.jpg\", \"/images/iphone_back.jpg\", \"/images/iphone_box.jpg\"]', '/manuals/iphone14pro_manual.pdf', '/images/warranty_iphone.jpg', '/images/invoice_iphone.jpg', '[\"主力机\", \"工作\", \"个人\", \"贵重物品\"]', '主力工作手机，使用频率极高，电池健康度目前92%。贴了防窥膜，戴了保护壳。建议每半年备份一次数据。', '非常重要', 0, '[]', 1, 1, 1, '2023-03-16 10:30:00', '2024-01-15 09:20:00');
INSERT INTO `electronic_devices` VALUES (2, 1, 'MacBook Pro 14寸', '电脑', '苹果', 'MacBook Pro 14寸 M2 Pro', 'SN987654321MAC', '深空灰', '已使用', '已拥有', '书房书桌', '书房', '书桌中央，外接显示器旁', 1, 14999.00, 14999.00, 'CNY', '2022-11-20', '京东苹果旗舰店', 24, '2024-11-19', 'INV202211209876', '2022-11-21', 60, '每天使用', '2025-12-31', '{\"内存\": \"16GB\", \"存储\": \"512GB SSD\", \"屏幕\": \"14.2英寸 Liquid Retina XDR\", \"电池\": \"70瓦时\", \"重量\": \"1.6kg\", \"处理器\": \"M2 Pro 10核\"}', '[\"67W USB-C充电器\", \"USB-C充电线\", \"保护套\", \"屏幕清洁布\"]', 'macOS Sonoma 14.2.1, Visual Studio Code 1.85.2, Google Chrome 120.0.6099.216, Microsoft Office 16.78, Adobe Creative Cloud 2024', '[{\"cost\": 0, \"date\": \"2023-06-15\", \"action\": \"清洁键盘和屏幕\"}, {\"cost\": 0, \"date\": \"2023-12-10\", \"action\": \"升级系统备份\"}]', '[{\"cost\": 580, \"date\": \"2023-08-05\", \"problem\": \"左侧USB-C接口松动\", \"solution\": \"苹果授权店维修\"}]', '2024-05-20', '[\"/images/macbook_open.jpg\", \"/images/macbook_closed.jpg\", \"/images/macbook_setup.jpg\"]', '/manuals/macbookpro_manual.pdf', '/images/warranty_macbook.jpg', '/images/invoice_macbook.jpg', '[\"工作电脑\", \"开发\", \"设计\", \"生产力工具\"]', '主力开发电脑，配置满足日常开发和设计需求。连接一个27寸4K显示器使用。键盘贴了键盘膜，屏幕贴了AR膜。定期使用Time Machine备份。', '非常重要', 0, '[]', 0, 1, 1, '2022-11-21 09:15:00', '2024-01-14 16:30:00');
INSERT INTO `electronic_devices` VALUES (3, 1, 'Sony A7M3全画幅微单相机', '相机', '索尼', 'ILCE-7M3', 'SN555555555SONY', '黑色', '已损坏', '已拥有', '书房相机柜', '书房', '防潮箱上层右侧', 1, 11500.00, 11500.00, 'CNY', '2021-05-10', '索尼官方体验店', 24, '2023-05-09', 'INV202105105555', '2021-05-11', 48, '偶尔使用', '2023-12-20', '{\"视频\": \"4K 30p\", \"ISO范围\": \"100-51200\", \"传感器\": \"全画幅35mm Exmor R CMOS\", \"对焦点\": \"693点相位检测\", \"快门速度\": \"1/8000-30秒\", \"有效像素\": \"2420万\"}', '[\"FE 24-70mm f/2.8 GM镜头\", \"FE 85mm f/1.8定焦镜头\", \"3块NP-FZ100电池\", \"双槽充电器\", \"相机包\", \"UV镜\", \"清洁套装\", \"三脚架\"]', 'Imaging Edge Mobile 7.7.1, Capture One 23', '[{\"cost\": 150, \"date\": \"2022-03-15\", \"action\": \"CMOS传感器清洁\"}, {\"cost\": 800, \"date\": \"2022-10-20\", \"action\": \"更换快门\"}]', '[{\"cost\": null, \"date\": \"2023-12-21\", \"status\": \"待维修\", \"problem\": \"CMOS传感器出现坏点\", \"solution\": \"待送修检测\"}, {\"cost\": 120, \"date\": \"2023-08-10\", \"problem\": \"快门按钮卡顿\", \"solution\": \"清理灰尘\"}]', '2024-02-01', '[\"/images/sony_camera_front.jpg\", \"/images/sony_camera_back.jpg\", \"/images/sony_lenses.jpg\"]', '/manuals/sony_a7m3_manual.pdf', '/images/warranty_sony.jpg', '/images/invoice_sony.jpg', '[\"摄影\", \"爱好\", \"全画幅\", \"微单\"]', '摄影爱好设备，主要用于人像和风景摄影。2023年12月发现CMOS出现坏点，需要送修。镜头保存完好，定期清洁。建议放在防潮箱保存。', '重要', 0, '[]', 0, 0, 1, '2021-05-11 14:45:00', '2023-12-22 11:20:00');
INSERT INTO `electronic_devices` VALUES (4, 1, 'PlayStation 5游戏主机', '游戏机', '索尼', 'PS5标准版', NULL, '白色', '全新', '待购买', '客厅电视柜', '客厅', '电视左侧预留位置', 1, 3899.00, 3899.00, 'CNY', NULL, '索尼官方商城', 24, NULL, NULL, NULL, 60, '偶尔使用', NULL, '{\"GPU\": \"AMD RDNA 2 10.28 TFLOPS\", \"光驱\": \"4K UHD蓝光\", \"内存\": \"16GB GDDR6\", \"存储\": \"825GB SSD\", \"输出\": \"4K 120Hz, 8K\", \"处理器\": \"AMD Zen 2 8核\"}', '[\"DualSense无线控制器\", \"HDMI线\", \"电源线\", \"底座\", \"USB数据线\"]', 'PlayStation 5系统软件, PlayStation Store', NULL, NULL, NULL, '[\"/images/ps5_product.jpg\", \"/images/ps5_setup.jpg\"]', NULL, NULL, NULL, '[\"游戏\", \"娱乐\", \"4K\", \"次世代\"]', '计划2024年618期间购买，主要想玩《最终幻想7重生》、《漫威蜘蛛侠2》等独占游戏。需要预留电视HDMI接口和足够散热空间。', '一般', 1, '[\"家人\", \"好友\"]', 0, 0, 1, '2024-01-10 09:30:00', '2024-01-15 10:15:00');
INSERT INTO `electronic_devices` VALUES (5, 1, 'iPad Air 4', '平板', '苹果', 'iPad Air (第4代)', 'SN444444444IPAD', '天蓝色', '已闲置', '已拥有', '卧室床头柜', '卧室', '抽屉内层', 1, 4799.00, 4799.00, 'CNY', '2020-10-05', '苹果官方零售店', 12, '2021-10-04', 'INV202010054444', '2020-10-06', 36, '很少使用', '2023-06-15', '{\"存储\": \"64GB\", \"屏幕\": \"10.9英寸 Liquid Retina\", \"接口\": \"USB-C\", \"电池\": \"28.6瓦时\", \"处理器\": \"A14仿生\", \"摄像头\": \"700万像素前置, 1200万像素后置\"}', '[\"Apple Pencil (第2代)\", \"智能键盘夹\", \"保护套\", \"20W充电器\"]', 'iPadOS 17.1.2, GoodNotes 6, Procreate 5.3, Netflix 14.11.0', '[{\"cost\": 799, \"date\": \"2021-12-20\", \"action\": \"更换电池\"}, {\"cost\": 0, \"date\": \"2022-08-15\", \"action\": \"屏幕清洁\"}]', '[{\"cost\": 799, \"date\": \"2022-05-10\", \"problem\": \"电池膨胀\", \"solution\": \"官方更换电池\"}, {\"cost\": 0, \"date\": \"2023-03-20\", \"problem\": \"充电口接触不良\", \"solution\": \"清洁充电口\"}]', NULL, '[\"/images/ipad_front.jpg\", \"/images/ipad_with_pencil.jpg\", \"/images/ipad_box.jpg\"]', '/manuals/ipadair_manual.pdf', '/images/warranty_ipad.jpg', '/images/invoice_ipad.jpg', '[\"旧设备\", \"绘画\", \"笔记\", \"备用\"]', '旧款iPad，主要用于笔记和绘画，但现在有了新iPad Pro后很少使用。电池健康度78%，充电较慢。考虑出售或给家人使用。Apple Pencil还能正常使用。', '不重要', 1, '[\"配偶\"]', 0, 0, 1, '2020-10-06 16:20:00', '2023-12-28 14:10:00');

-- ----------------------------
-- Table structure for food_diaries
-- ----------------------------
DROP TABLE IF EXISTS `food_diaries`;
CREATE TABLE `food_diaries`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `record_date` date NOT NULL COMMENT '记录日期',
  `meal_time` enum('早餐','午餐','晚餐','上午加餐','下午加餐','夜宵','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用餐时段',
  `meal_time_detail` time(0) NULL DEFAULT NULL COMMENT '具体用餐时间',
  `food_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '食物名称',
  `food_category` enum('主食','蔬菜','水果','蛋白质','零食','饮料','甜品','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '食物类别',
  `food_tags` json NULL COMMENT '标签（辣/甜/咸/酸/苦/鲜等）',
  `cooking_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '烹饪方式（炒/煮/蒸/烤/炸/生食等）',
  `location_type` enum('家里','餐厅','外卖','公司','学校','朋友家','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '家里' COMMENT '用餐地点类型',
  `location_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '具体地点',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `companion_type` enum('独自','家人','朋友','同事','客户','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '独自' COMMENT '用餐同伴',
  `companions` json NULL COMMENT '同伴姓名/ID',
  `portion_size` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分量描述（一碗/一份/200克等）',
  `estimated_calories` decimal(6, 1) NULL DEFAULT NULL COMMENT '预估卡路里',
  `nutrition_tags` json NULL COMMENT '营养标签（高蛋白/低脂/高纤维/低碳水等）',
  `is_homemade` tinyint(1) NULL DEFAULT 0 COMMENT '是否自制',
  `recipe_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '关联菜谱ID',
  `taste_rating` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '口味评分（1-5星）',
  `health_rating` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '健康评分（1-5星）',
  `satisfaction_level` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '满意度（1-5）',
  `mood_during_meal` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用餐时心情',
  `feeling_after_meal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用餐后感受（饱腹/满足/腻等）',
  `special_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '特别备注',
  `food_images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '食物封面',
  `images` json NULL COMMENT '食物图片',
  `recipe_steps` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '制作步骤（如果是自制）',
  `ingredients` json NULL COMMENT '主要食材',
  `ingredients_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '食材文本（用于搜索）',
  `cost` decimal(8, 2) NULL DEFAULT NULL COMMENT '花费金额',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '货币',
  `is_shared_cost` tinyint(1) NULL DEFAULT 0 COMMENT '是否分摊',
  `shared_with` json NULL COMMENT '分摊人员',
  `repeat_frequency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '重复频率（每天/每周/偶尔等）',
  `last_eaten_date` date NULL DEFAULT NULL COMMENT '上次食用日期',
  `times_eaten` int(11) NULL DEFAULT 1 COMMENT '累计食用次数',
  `similar_food_ids` json NULL COMMENT '类似食物记录ID',
  `is_favorite` tinyint(1) NULL DEFAULT 0 COMMENT '是否收藏',
  `want_to_repeat` tinyint(1) NULL DEFAULT 1 COMMENT '是否想再吃',
  `privacy_level` enum('公开','好友可见','仅自己') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '仅自己' COMMENT '隐私级别',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date_meal`(`user_id`, `record_date`, `meal_time`, `food_name`(100)) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `record_date`) USING BTREE,
  INDEX `idx_meal_time`(`meal_time`) USING BTREE,
  INDEX `idx_food_category`(`food_category`) USING BTREE,
  INDEX `idx_location_type`(`location_type`) USING BTREE,
  INDEX `idx_taste_rating`(`taste_rating`) USING BTREE,
  INDEX `idx_is_favorite`(`is_favorite`) USING BTREE,
  INDEX `idx_want_to_repeat`(`want_to_repeat`) USING BTREE,
  INDEX `idx_last_eaten_date`(`last_eaten_date`) USING BTREE,
  FULLTEXT INDEX `idx_food_search`(`food_name`, `ingredients_text`)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '美食日记表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food_diaries
-- ----------------------------
INSERT INTO `food_diaries` VALUES (1, 1, '2024-01-15', '早餐', '08:30:00', '全麦煎蛋三明治+牛奶', '主食', '[\"咸\", \"香\", \"健康\"]', '煎', '家里', '老王烧烤', '北京市海淀区中关村大街1号', '独自', '[\"全家\"]', '1份三明治+250ml牛奶', 450.5, '[\"高蛋白\", \"高纤维\", \"低脂\"]', 1, NULL, 4, 5, 4, '清醒', '饱腹有能量', NULL, '[\"/uploads/food/breakfast_20240115_1.jpg\", /profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', '1. 鸡蛋打散，加少许盐\r\n2. 平底锅少油，煎蛋\r\n3. 面包烤至微黄\r\n4. 依次放生菜、番茄、煎蛋、芝士\r\n5. 搭配牛奶食用', '[\"全麦面包2片\", \"鸡蛋1个\", \"生菜2片\", \"番茄2片\", \"低脂芝士1片\", \"牛奶250ml\"]', '全麦面包 鸡蛋 生菜 番茄 低脂芝士 牛奶', 8.50, 'CNY', 0, NULL, NULL, NULL, 1, NULL, 1, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-30 16:45:39');
INSERT INTO `food_diaries` VALUES (2, 1, '2024-01-15', '午餐', '12:45:00', '番茄牛腩面+凉拌黄瓜', '主食', '[\"酸\", \"鲜\", \"微辣\"]', '煮', '餐厅', '兰州拉面', '北京市朝阳区建国路88号', '同事', '[\"张三\", \"李四\"]', '大碗面+小份凉菜', 650.0, '[\"高蛋白\", \"适中碳水\"]', 0, NULL, 5, 3, 4, '愉快', '满足但稍咸', '牛腩很嫩，汤底浓郁，就是稍微咸了点', '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', NULL, '[\"牛腩\", \"番茄\", \"面条\", \"黄瓜\", \"蒜末\", \"醋\", \"辣椒油\"]', '牛腩 番茄 面条 黄瓜 蒜末 醋 辣椒油', 35.00, 'CNY', 1, '[\"张三\", \"李四\"]', NULL, NULL, 1, NULL, 0, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-30 16:45:33');
INSERT INTO `food_diaries` VALUES (3, 1, '2024-01-15', '晚餐', '19:00:00', '红烧排骨+蒜蓉西兰花+米饭', '主食', '[\"甜\", \"咸\", \"鲜\"]', '炖', '家里', '老王烧烤', '北京市海淀区中关村大街1号', '家人', '[\"妻子\", \"儿子\"]', '排骨200g+西兰花150g+米饭1碗', 580.0, '[\"高蛋白\", \"适中脂肪\", \"蔬菜纤维\"]', 1, NULL, 5, 3, 5, '温馨', '满足舒适', NULL, '/profile/upload/2025/12/30/image-20251103190910884_20251230175848A961.png', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', '1. 排骨焯水去血沫\r\n2. 炒糖色，加入排骨翻炒\r\n3. 加生抽、老抽、料酒、水，炖40分钟\r\n4. 西兰花焯水，蒜末爆香后翻炒\r\n5. 搭配米饭食用', '[\"排骨500g\", \"西兰花1颗\", \"蒜5瓣\", \"生姜\", \"冰糖\", \"生抽\", \"老抽\", \"料酒\", \"米饭\"]', '排骨 西兰花 蒜 生姜 冰糖 生抽 老抽 料酒 米饭', 45.00, 'CNY', 0, 'null', NULL, '2024-01-08', 3, 'null', 1, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-30 17:58:51');
INSERT INTO `food_diaries` VALUES (4, 1, '2024-01-15', '下午加餐', '15:30:00', '拿铁咖啡+提拉米苏', '甜品', '[\"甜\", \"苦\", \"香\"]', '烘焙', '外卖', '星巴克', '北京市海淀区中关村大街1号', '独自', '[\"全家\"]', '中杯拿铁+1块蛋糕', 420.0, '[\"高糖\", \"高脂肪\", \"咖啡因\"]', 0, NULL, 4, 2, 4, '放松', '提神但稍腻', '提拉米苏有点甜，下次试试少糖的', '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', NULL, '[\"咖啡\", \"牛奶\", \"可可粉\", \"马斯卡彭奶酪\", \"手指饼干\", \"咖啡酒\"]', '咖啡 牛奶 可可粉 马斯卡彭奶酪 手指饼干 咖啡酒', 68.00, 'CNY', 0, NULL, '每周2-3次', NULL, 1, NULL, 1, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-30 16:45:29');
INSERT INTO `food_diaries` VALUES (5, 1, '2024-01-14', '晚餐', '19:30:00', '麻辣火锅', '主食', '[\"辣\", \"麻\", \"鲜\"]', '煮', '餐厅', '海底捞', '北京市海淀区中关村大街1号', '朋友', '[\"王五\", \"赵六\", \"钱七\"]', '多人分享', 850.0, '[\"高蛋白\", \"低脂\", \"优质脂肪\", \"高纤维\"]', 0, NULL, 5, 2, 5, '兴奋', '过瘾但有点撑', NULL, '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', NULL, '[\"牛肉\", \"羊肉\", \"毛肚\", \"虾滑\", \"蔬菜拼盘\", \"豆腐\", \"宽粉\", \"麻辣锅底\"]', '牛肉 羊肉 毛肚 虾滑 蔬菜 豆腐 宽粉 麻辣锅底', 280.00, 'CNY', 1, '[\"王五\", \"赵六\", \"钱七\"]', NULL, '2023-12-20', 5, NULL, 1, 1, '好友可见', '2025-12-29 15:26:45', '2025-12-30 16:45:27');
INSERT INTO `food_diaries` VALUES (6, 1, '2024-01-14', '午餐', '14:00:00', '蒸三文鱼+糙米饭+水煮西兰花', '蛋白质', '[\"清淡\", \"健康\", \"原味\"]', '蒸', '家里', '老王烧烤', '北京市海淀区中关村大街1号', '独自', '[\"全家\"]', '三文鱼150g+糙米饭100g+西兰花200g', 520.0, '[\"高蛋白\", \"低脂\", \"优质脂肪\", \"高纤维\"]', 1, NULL, 3, 5, 4, '自律', '健康饱腹', NULL, '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', '1. 三文鱼用盐、黑胡椒、柠檬汁腌制\r\n2. 上锅蒸8-10分钟\r\n3. 糙米提前浸泡，煮熟\r\n4. 西兰花焯水\r\n5. 摆盘食用', '[\"三文鱼150g\", \"糙米50g\", \"西兰花200g\", \"柠檬\", \"盐\", \"黑胡椒\"]', '三文鱼 糙米 西兰花 柠檬 盐 黑胡椒', 35.00, 'CNY', 0, 'null', '健身日', NULL, 1, 'null', 1, 1, '仅自己', '2025-12-29 15:26:46', '2025-12-30 18:07:50');
INSERT INTO `food_diaries` VALUES (7, 1, '2024-01-13', '晚餐', '18:30:00', '韭菜猪肉饺子', '主食', '[\"鲜\", \"香\", \"家常\"]', '煮', '家里', '老王烧烤', '北京市海淀区中关村大街1号', '家人', '[\"全家\"]', '20个', 550.0, '[\"高蛋白\", \"低脂\", \"优质脂肪\", \"高纤维\"]', 1, NULL, 5, 3, 5, '温馨', '满足幸福', NULL, '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', '1. 和面，醒面30分钟\r\n2. 韭菜切碎，猪肉剁馅\r\n3. 调馅：肉馅加姜末、葱花、酱油、盐、香油\r\n4. 加入韭菜拌匀\r\n5. 擀皮包饺子\r\n6. 水开下饺子，煮三开', '[\"面粉\", \"猪肉馅\", \"韭菜\", \"生姜\", \"葱\", \"酱油\", \"盐\", \"香油\"]', '面粉 猪肉馅 韭菜 生姜 葱 酱油 盐 香油', 25.00, 'CNY', 0, NULL, NULL, '2024-01-01', 2, NULL, 1, 1, '好友可见', '2025-12-29 15:26:46', '2025-12-30 16:45:24');
INSERT INTO `food_diaries` VALUES (8, 1, '2024-01-12', '夜宵', '23:15:00', '羊肉串+烤韭菜+烤馒头片', '零食', '[\"辣\", \"咸\", \"香\"]', '烤', '外卖', '老王烧烤', '北京市海淀区中关村大街1号', '独自', '[\"全家\"]', '中份', 520.0, '[\"高蛋白\", \"低脂\", \"优质脂肪\", \"高纤维\"]', 0, NULL, 4, 1, 3, '罪恶但快乐', '满足但有点咸渴', '不应该吃夜宵的，但实在忍不住', '[\"/uploads/food/night_snack_20240112.jpg\"]', '[\"/uploads/food/night_snack_20240112.jpg\"]', '1. 和面，醒面30分钟\r\n2. 韭菜切碎，猪肉剁馅\r\n3. 调馅：肉馅加姜末、葱花、酱油、盐、香油\r\n4. 加入韭菜拌匀\r\n5. 擀皮包饺子\r\n6. 水开下饺子，煮三开', '[\"羊肉\", \"韭菜\", \"馒头\", \"孜然\", \"辣椒粉\", \"盐\"]', '羊肉 韭菜 馒头 孜然 辣椒粉 盐', 48.00, 'CNY', 0, '[\"王五\", \"赵六\", \"钱七\"]', '健身日', NULL, 1, NULL, 0, 1, '仅自己', '2025-12-29 15:26:46', '2025-12-30 16:43:36');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `python_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'PYTHON类型',
  `python_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'PYTHON字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_unique` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否唯一（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE,
  INDEX `table_id`(`table_id`) USING BTREE,
  CONSTRAINT `gen_table_column_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `gen_table` (`table_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for holiday_schedules
-- ----------------------------
DROP TABLE IF EXISTS `holiday_schedules`;
CREATE TABLE `holiday_schedules`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `holiday_date` date NOT NULL COMMENT '节假日日期',
  `holiday_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节假日名称',
  `holiday_type` enum('法定节假日','传统节日','纪念日','个人纪念日','特殊日','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '其他' COMMENT '节假日类型',
  `schedule_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日程标题',
  `schedule_type` enum('家庭聚会','朋友聚会','旅行计划','学习安排','休息放松','购物计划','美食计划','健身运动','文化活动','其他活动') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '其他活动' COMMENT '日程类型',
  `start_time` time(0) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` time(0) NULL DEFAULT NULL COMMENT '结束时间',
  `all_day` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否全天',
  `duration_minutes` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '持续时间（分钟）',
  `location_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地点名称',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '详细地址',
  `latitude` decimal(10, 8) NULL DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(11, 8) NULL DEFAULT NULL COMMENT '经度',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '具体内容/做什么',
  `preparation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '准备工作/怎么做',
  `shopping_list` json NULL COMMENT '购物清单',
  `required_items` json NULL COMMENT '所需物品',
  `participants` json NULL COMMENT '参与人员',
  `budget` decimal(10, 2) NULL DEFAULT NULL COMMENT '预算金额',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '货币',
  `actual_cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '实际花费',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片',
  `images` json NULL COMMENT '图片数组（记录图片）',
  `videos` json NULL COMMENT '视频链接',
  `recipes` json NULL COMMENT '菜谱/制作步骤（JSON格式）',
  `documents` json NULL COMMENT '相关文档链接',
  `status` enum('计划中','进行中','已完成','取消','延期') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '计划中' COMMENT '状态',
  `reminder_time` datetime(0) NULL DEFAULT NULL COMMENT '提醒时间',
  `is_repeat` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否重复',
  `repeat_rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '重复规则',
  `rating` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '评价（1-5星）',
  `review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '回顾/总结',
  `highlights` json NULL COMMENT '亮点/精彩时刻',
  `lessons_learned` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '经验教训',
  `tags` json NULL COMMENT '标签',
  `mood` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '心情',
  `energy_level` tinyint(4) NULL DEFAULT NULL COMMENT '精力消耗程度（1-5）',
  `satisfaction_level` tinyint(4) NULL DEFAULT NULL COMMENT '满意度（1-5）',
  `related_footprint_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '关联的旅行足迹ID',
  `template_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '使用的模板ID',
  `privacy_level` enum('公开','好友可见','仅自己') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '仅自己' COMMENT '隐私级别',
  `share_with` json NULL COMMENT '分享给的用户列表',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '描述',
  `checklist` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '清单',
  `visibility` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '可见性',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `holiday_date`) USING BTREE,
  INDEX `idx_holiday_date`(`holiday_date`) USING BTREE,
  INDEX `idx_schedule_type`(`schedule_type`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_user_status`(`user_id`, `status`) USING BTREE,
  INDEX `idx_reminder`(`reminder_time`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  FULLTEXT INDEX `idx_content_search`(`schedule_title`, `content`)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '节假日日程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of holiday_schedules
-- ----------------------------
INSERT INTO `holiday_schedules` VALUES (1, 1, '2024-02-10', '春节', '传统节日', '除夕夜团圆饭', '家庭聚会', '17:30:00', '21:00:00', 0, 210, '家里', '北京市朝阳区某小区', 39.90420000, 116.40740000, '1. 准备年夜饭（12道菜）\r\n2. 包饺子（韭菜猪肉馅）\r\n3. 贴春联和窗花\r\n4. 看春晚\r\n5. 发红包给小朋友\r\n6. 午夜放鞭炮', '提前一周：\r\n- 大扫除\r\n- 采购年货\r\n- 准备红包\r\n当天上午：\r\n- 贴春联窗花\r\n- 准备食材\r\n下午：\r\n- 开始准备年夜饭', '[\"猪肉5斤\", \"牛肉3斤\", \"鱼2条\", \"鸡1只\", \"蔬菜若干\", \"水果\", \"饮料\", \"春联\", \"红包\"]', '[\"厨具\", \"餐具\", \"红包袋\", \"鞭炮\", \"春晚节目单\"]', '[\"爸爸\", \"妈妈\", \"妻子\", \"儿子\", \"女儿\", \"爷爷奶奶\"]', 2000.00, 'CNY', 1850.50, 'https://example.com/images/spring_festival_cover.jpg', '[\"https://example.com/images/sf1.jpg\", \"https://example.com/images/sf2.jpg\", \"https://example.com/images/sf3.jpg\"]', NULL, '{\"年夜饭菜谱\": [\"红烧肉\", \"清蒸鱼\", \"白切鸡\", \"四喜丸子\", \"蒜蓉粉丝蒸虾\", \"蚝油生菜\", \"八宝饭\", \"饺子\"]}', NULL, '已完成', NULL, 0, NULL, 5, '今年的团圆饭非常成功，家人都很开心。特别是新学的红烧肉做法很受欢迎。春晚虽然一般，但家人一起看的氛围很好。', '[\"儿子拿到了大红包\", \"女儿学会了包饺子\", \"爷爷讲了过去的故事\", \"一起放烟花\"]', '1. 食材要提前准备，当天买会很贵\r\n2. 年夜饭不用做太多，吃不完浪费\r\n3. 红包要提前准备好新钞票', '[\"家庭\", \"传统\", \"美食\", \"团圆\"]', '温馨', 4, 5, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:34', '2025-12-29 17:58:34', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (2, 1, '2024-10-01', '国庆节', '法定节假日', '桂林阳朔三日游', '旅行计划', '08:00:00', '20:00:00', 0, 726, '桂林阳朔', '广西桂林市阳朔县', 24.77850000, 110.49660000, '第一天：抵达桂林，入住酒店，晚上两江四湖夜游\r\n第二天：漓江竹筏漂流，游览阳朔西街\r\n第三天：骑自行车游览十里画廊，参观银子岩，下午返程', '提前一个月：\n- 预订机票和酒店- 查看天气预报- 制定详细行程- 办理请假\n出发前一周：\n- 打包行李- 购买旅游保险- 下载离线地图\n出发前一天：\n- 确认航班信息- 准备证件- 通知家人', '[\"防晒霜\", \"雨伞\", \"晕车药\", \"充电宝\", \"相机\", \"零食\"]', '[\"身份证\", \"信用卡\", \"现金\", \"手机充电器\", \"换洗衣物\", \"洗漱用品\", \"游泳衣\"]', '[\"妻子\", \"儿子\"]', 8000.00, 'CNY', NULL, '/profile/upload/2025/12/29/ns7_20251229193313A841.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229193322A541.jpg\", \"/profile/upload/2025/12/29/ns6_20251229193322A633.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229193326A756.mp4\"]', NULL, NULL, '计划中', '2024-09-25 10:00:00', 0, NULL, 5, NULL, NULL, NULL, '[\"旅行\", \"自然风光\", \"摄影\", \"亲子\"]', '期待', 3, NULL, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:34', '2025-12-30 11:41:26', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (3, 1, '2024-02-14', '情人节', '特殊日', '浪漫烛光晚餐', '美食计划', '19:00:00', '21:30:00', 0, 150, '法式餐厅', '上海市黄浦区南京西路某餐厅', NULL, NULL, '1. 开胃菜：法式鹅肝\r\n2. 汤：奶油蘑菇汤\r\n3. 主菜：惠灵顿牛排\r\n4. 甜点：心形巧克力蛋糕\r\n5. 红酒：法国波尔多', '提前一周预订餐厅\r\n当天：\r\n- 购买玫瑰花\r\n- 准备小礼物（项链）\r\n- 穿戴正式服装', NULL, NULL, '[\"妻子\"]', 1500.00, 'CNY', 1680.00, NULL, '[\"https://example.com/images/valentine1.jpg\", \"https://example.com/images/valentine2.jpg\"]', NULL, NULL, NULL, '已完成', NULL, 0, NULL, 5, '餐厅环境很好，服务周到。惠灵顿牛排做得非常地道，红酒配得恰到好处。妻子很喜欢项链礼物。', NULL, NULL, '[\"浪漫\", \"约会\", \"西餐\", \"庆祝\"]', '浪漫', NULL, 5, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:34', '2025-12-29 17:58:34', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (4, 1, '2024-06-10', '端午节', '传统节日', '家庭包粽子活动', '家庭聚会', '14:00:00', '18:00:00', 0, 240, '妈妈家', NULL, NULL, NULL, '1. 准备粽叶和糯米\r\n2. 准备馅料（红枣、豆沙、咸蛋黄、五花肉）\r\n3. 学习包粽子技巧\r\n4. 煮粽子\r\n5. 品尝成果', '提前一天：\r\n- 浸泡糯米\r\n- 清洗粽叶\r\n- 准备馅料\r\n当天：\r\n- 整理工作台\r\n- 准备锅具', '[\"糯米5斤\", \"粽叶100张\", \"红枣2斤\", \"豆沙1斤\", \"咸蛋黄20个\", \"五花肉2斤\", \"棉线\"]', '[\"大锅\", \"蒸笼\", \"剪刀\", \"绳子\", \"碗盘\"]', '[\"妈妈\", \"姐姐\", \"侄女\"]', 200.00, 'CNY', 180.50, NULL, NULL, NULL, '{\"咸粽子\": [\"五花肉腌制过夜\", \"糯米加酱油拌匀\", \"包入肉和咸蛋黄\", \"煮3小时\"], \"甜粽子\": [\"糯米提前浸泡4小时\", \"粽叶煮软洗净\", \"包入红枣或豆沙\", \"用棉线扎紧\", \"煮2小时\"]}', NULL, '进行中', NULL, 0, NULL, NULL, NULL, NULL, NULL, '[\"传统\", \"手工\", \"美食\", \"亲子\"]', '开心', NULL, NULL, NULL, NULL, '好友可见', '[\"好友1\", \"好友2\", \"家人群\"]', 1, '2025-12-29 17:58:34', '2025-12-29 17:58:34', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (5, 1, '2024-03-15', '生日', '个人纪念日', '30岁生日派对', '朋友聚会', '18:00:00', '23:00:00', 0, 300, 'KTV包厢', '北京市海淀区中关村某KTV', NULL, NULL, '1. 朋友陆续到场\r\n2. 切生日蛋糕\r\n3. 唱生日歌\r\n4. KTV唱歌\r\n5. 玩桌游\r\n6. 拍照留念\r\n7. 夜宵烧烤', '提前一周：\r\n- 预订KTV包厢\r\n- 预订生日蛋糕\r\n- 通知朋友\r\n当天：\r\n- 购买零食饮料\r\n- 布置场地\r\n- 准备游戏道具', NULL, NULL, '[\"张三\", \"李四\", \"王五\", \"赵六\", \"钱七\", \"孙八\", \"周九\", \"吴十\"]', 2000.00, 'CNY', 2350.00, NULL, '[\"https://example.com/images/birthday1.jpg\", \"https://example.com/images/birthday2.jpg\", \"https://example.com/images/birthday3.jpg\"]', '[\"https://example.com/videos/birthday.mp4\"]', NULL, NULL, '已完成', NULL, 0, NULL, 4, '来了很多朋友，玩得很开心。蛋糕很好吃，KTV音响效果不错。就是花费超预算了。', '[\"张三的深情演唱\", \"李四的搞笑舞蹈\", \"切蛋糕时刻\", \"集体大合照\"]', NULL, '[\"生日\", \"朋友\", \"庆祝\", \"KTV\", \"派对\"]', '兴奋', 5, 4, NULL, NULL, '公开', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 17:58:35', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (6, 1, '2024-09-17', '中秋节', '传统节日', '中秋家庭赏月', '家庭聚会', '19:00:00', '22:00:00', 0, NULL, '家里阳台', '上海市浦东新区某小区', 31.23040000, 121.47370000, '1. 准备月饼和茶点\r\n2. 摆放桌椅和灯笼\r\n3. 赏月聊天\r\n4. 分享月饼\r\n5. 讲中秋故事\r\n6. 拍摄月亮照片', '提前购买月饼\r\n当天：\r\n- 打扫阳台\r\n- 准备茶具\r\n- 检查灯笼', '[\"月饼礼盒\", \"茶叶\", \"水果\", \"坚果\", \"灯笼\", \"蜡烛\"]', NULL, '[\"父母\", \"配偶\", \"孩子\"]', 500.00, 'CNY', NULL, NULL, NULL, NULL, NULL, NULL, '计划中', '2024-09-16 18:00:00', 0, NULL, NULL, NULL, NULL, NULL, '[\"家庭\", \"传统\", \"赏月\", \"月饼\"]', '温馨', NULL, NULL, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 17:58:35', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (7, 1, '2023-12-24', '圣诞节', '特殊日', '家庭圣诞装饰', '文化活动', '14:00:00', '17:30:00', 0, 210, '家里', NULL, NULL, NULL, '1. 组装圣诞树\r\n2. 挂装饰品和彩灯\r\n3. 摆放圣诞老人和麋鹿\r\n4. 挂圣诞袜\r\n5. 布置餐桌\r\n6. 制作圣诞贺卡', '提前购买装饰品\r\n当天：\r\n- 清理客厅空间\r\n- 准备工具\r\n- 播放圣诞音乐', '[\"圣诞树\", \"彩灯\", \"装饰球\", \"圣诞老人玩偶\", \"雪花贴纸\", \"贺卡材料\", \"圣诞袜\"]', '[\"梯子\", \"胶带\", \"剪刀\", \"电线\", \"电池\"]', '[\"妻子\", \"儿子\", \"女儿\"]', 800.00, 'CNY', 750.00, NULL, '[\"https://example.com/images/christmas1.jpg\", \"https://example.com/images/christmas2.jpg\"]', NULL, NULL, NULL, '已完成', NULL, 1, '每年12月24日', 5, '孩子们非常开心，装饰过程充满乐趣。圣诞树效果很好，整个家都充满了节日气氛。', NULL, NULL, '[\"节日\", \"装饰\", \"亲子\", \"手工\"]', '快乐', 3, 5, NULL, NULL, '好友可见', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 17:58:35', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (8, 1, '2024-01-01', '元旦', '法定节假日', '新年第一天健身', '健身运动', '09:00:00', '11:00:00', 0, 120, '健身房', '北京市朝阳区某健身中心', 31.23040000, 121.47370000, '1. 热身运动10分钟\r\n2. 跑步机30分钟\r\n3. 力量训练（胸、背、腿）\r\n4. 拉伸放松10分钟\r\n5. 记录训练数据', '准备健身装备\r\n前一天保证充足睡眠\r\n控制饮食', '[\"圣诞树\", \"彩灯\", \"装饰球\", \"圣诞老人玩偶\", \"雪花贴纸\", \"贺卡材料\", \"圣诞袜\"]', '[\"运动服\", \"运动鞋\", \"毛巾\", \"水壶\", \"手套\"]', '[\"妻子\", \"儿子\", \"女儿\"]', 800.00, 'CNY', 750.00, 'https://example.com/images/guilin_cover.jpg', '[\"https://example.com/images/christmas1.jpg\", \"https://example.com/images/christmas2.jpg\"]', '[\"https://example.com/videos/birthday.mp4\"]', '{\"咸粽子\": [\"五花肉腌制过夜\", \"糯米加酱油拌匀\", \"包入肉和咸蛋黄\", \"煮3小时\"], \"甜粽子\": [\"糯米提前浸泡4小时\", \"粽叶煮软洗净\", \"包入红枣或豆沙\", \"用棉线扎紧\", \"煮2小时\"]}', NULL, '进行中', '2024-09-16 18:00:00', 0, NULL, NULL, NULL, NULL, NULL, '[\"健康\", \"健身\", \"新年\", \"自律\"]', '充满活力', 4, NULL, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 18:36:29', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for holiday_shopping
-- ----------------------------
DROP TABLE IF EXISTS `holiday_shopping`;
CREATE TABLE `holiday_shopping`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `shopping_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '购物项目名称',
  `holiday_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '节日名称',
  `holiday_date` date NOT NULL COMMENT '节日日期',
  `item_category` enum('食品','礼品','装饰品','服装','家居用品','电子产品','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物品类别',
  `item_type` enum('用的','吃的','穿的','玩的','送的','装饰的') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物品类型',
  `item_for_whom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '给谁买的',
  `purchase_timing` enum('提前1个月','提前2周','提前1周','节日当天','节日后') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '提前1周' COMMENT '购买时机',
  `purchase_method` enum('线上','线下','海外代购','定制') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '线上' COMMENT '购买方式',
  `store_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '店铺名称',
  `store_type` enum('天猫','京东','淘宝','拼多多','实体店','超市','专卖店','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '店铺类型',
  `purchase_link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '购买链接',
  `quantity` int(11) NOT NULL DEFAULT 1 COMMENT '数量',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位（个/件/盒/套等）',
  `expected_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '预计价格',
  `actual_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '实际价格',
  `currency` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'CNY' COMMENT '货币',
  `purchase_status` enum('计划中','待购买','已下单','运输中','已收到','已退货','已取消') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '计划中' COMMENT '购买状态',
  `order_date` date NULL DEFAULT NULL COMMENT '下单日期',
  `receive_date` date NULL DEFAULT NULL COMMENT '收货日期',
  `purchase_experience` enum('非常满意','满意','一般','不满意','很差') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '购买体验',
  `delivery_speed` enum('很快','正常','较慢','很慢') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配送速度',
  `packaging_quality` enum('很好','一般','简陋','破损') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '包装质量',
  `item_quality` enum('非常好','好','一般','差','很差') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '物品质量',
  `liking_level` enum('非常喜欢','喜欢','一般','不喜欢','讨厌') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '喜爱程度',
  `usage_frequency` enum('每天使用','经常使用','偶尔使用','很少使用','未使用') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '使用频率',
  `pros` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '优点',
  `cons` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '缺点',
  `suggestions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '建议',
  `memorable_story` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '有趣故事',
  `holiday_tradition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '节日传统',
  `cultural_significance` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '文化意义',
  `shopping_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '购买理由',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片',
  `item_images` json NULL COMMENT '物品图片',
  `shopping_screenshots` json NULL COMMENT '购物截图',
  `unboxing_videos` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '开箱视频',
  `is_in_budget` tinyint(1) NULL DEFAULT 1 COMMENT '是否在预算内',
  `budget_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '预算分类',
  `total_spent` decimal(10, 2) NULL DEFAULT NULL COMMENT '节日总花费',
  `reminder_date` date NULL DEFAULT NULL COMMENT '提醒日期',
  `is_repeat_purchase` tinyint(1) NULL DEFAULT 0 COMMENT '是否重复购买',
  `repeat_frequency` enum('每年','每季','每次节日','不重复') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '重复频率',
  `share_with_family` tinyint(1) NULL DEFAULT 0 COMMENT '是否与家人分享',
  `share_with_friends` tinyint(1) NULL DEFAULT 0 COMMENT '是否与朋友分享',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_holiday`(`user_id`, `holiday_date`) USING BTREE,
  INDEX `idx_holiday_name`(`holiday_name`) USING BTREE,
  INDEX `idx_item_category`(`item_category`) USING BTREE,
  INDEX `idx_item_type`(`item_type`) USING BTREE,
  INDEX `idx_purchase_status`(`purchase_status`) USING BTREE,
  INDEX `idx_purchase_timing`(`purchase_timing`) USING BTREE,
  INDEX `idx_purchase_method`(`purchase_method`) USING BTREE,
  INDEX `idx_purchase_status_date`(`purchase_status`, `order_date`) USING BTREE,
  INDEX `idx_liking_level`(`liking_level`) USING BTREE,
  INDEX `idx_reminder`(`reminder_date`) USING BTREE,
  INDEX `idx_budget`(`is_in_budget`) USING BTREE,
  FULLTEXT INDEX `idx_search`(`shopping_name`, `store_name`, `shopping_reason`)
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '节日购物清单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of holiday_shopping
-- ----------------------------
INSERT INTO `holiday_shopping` VALUES (1, 1, '稻香村京八件糕点礼盒', '春节', '2024-02-10', '食品', '吃的', '爷爷奶奶', '提前2周', '线上', '稻香村官方旗舰店', '天猫', 'https://detail.tmall.com/item.htm?id=6688990011', 2, '盒', 158.00, 138.00, 'CNY', '已收到', '2024-01-25', '2024-01-28', '非常满意', '很快', '很好', '非常好', '非常喜欢', '偶尔使用', '包装精美，八种传统糕点，口味正宗，爷爷奶奶特别喜欢吃，尤其是枣花酥和山楂锅盔。', '价格稍贵，保质期只有30天，需要尽快食用。', '建议提前关注店铺活动，经常有满减优惠，可以节省不少钱。', '去年春节爷爷说很久没吃到正宗的京八件了，今年特意买了让他惊喜一下，看到他开心的样子特别温暖。', '春节拜年送礼是传统习俗，糕点象征甜蜜和团圆。', '京八件是北京传统糕点，有百年历史，是春节走亲访友的经典礼品。', '想表达对爷爷奶奶的孝心，让他们尝尝传统味道，也适合招待拜年的客人。', '/images/dxc_cover.jpg', '[\"/images/dxc_box.jpg\", \"/images/dxc_cakes1.jpg\", \"/images/dxc_cakes2.jpg\"]', '[\"/screenshots/dxc_order.jpg\", \"/screenshots/dxc_delivery.jpg\"]', '/videos/dxc_unboxing.mp4', 1, '年货礼品', 276.00, '2024-01-20', 1, '每年', 1, 0, 1, '2024-01-15 09:30:00', '2024-01-30 14:25:00');
INSERT INTO `holiday_shopping` VALUES (2, 1, 'Apple Watch Series 9 GPS版', '情人节', '2024-02-14', '电子产品', '用的', '女朋友', '提前1个月', '线上', '苹果官方旗舰店', '天猫', 'https://detail.tmall.com/item.htm?id=7788990022', 1, '台', 2999.00, 2899.00, 'CNY', '已收到', '2024-01-20', '2024-01-25', '满意', '正常', '很好', '好', '非常喜欢', '每天使用', '功能全面，健康监测准确，续航不错，搭配iPhone使用体验很好，女朋友很喜欢它的健身记录功能。', '价格偏高，需要每天充电，屏幕容易刮花。', '建议购买AC+延保服务，同时搭配屏幕保护膜使用。', '情人节当天给她惊喜，她拆开礼物时眼眶都红了，说这是她收到过最实用的礼物，现在每天戴着记录运动。', '情人节互赠礼物表达爱意是现代年轻人的浪漫方式。', '科技产品作为礼物象征着对未来的期待和共同进步。', '女朋友一直想要个智能手表来记录运动和健康数据，情人节是最好的送礼时机。', '/images/apple_watch_cover.jpg', '[\"/images/watch_box.jpg\", \"/images/watch_wrist.jpg\", \"/images/watch_features.jpg\"]', '[\"/screenshots/watch_order.jpg\", \"/screenshots/watch_payment.jpg\"]', '/videos/watch_unboxing.mp4', 0, '贵重礼物', 2899.00, '2024-01-15', 0, '不重复', 0, 1, 1, '2024-01-10 14:45:00', '2024-02-15 20:30:00');
INSERT INTO `holiday_shopping` VALUES (4, 1, '北欧风圣诞装饰套装', '圣诞节', '2024-12-25', '装饰品', '装饰的', '自己家', '提前2周', '线上', 'IKEA宜家官方店', '淘宝', 'https://item.taobao.com/item.htm?id=9900112233', 1, '套', 399.00, 359.00, 'CNY', '待购买', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '包含圣诞树、彩灯、挂饰、星星等全套装饰，北欧简约风格，可重复使用多年。', '需要自己组装，收纳比较占空间。', '建议提前测量好摆放位置，购买时注意材质是否环保。', '去年和孩子一起装饰圣诞树，他特别兴奋，把每个小挂件都摸了又摸，说是最快乐的圣诞节记忆。', '圣诞节装饰家居是西方传统，在中国也逐渐流行起来。', '圣诞装饰营造节日氛围，给家庭带来欢乐和温暖。', '想给孩子创造节日仪式感，让家里充满圣诞氛围。', '/profile/upload/2025/12/31/ns4_20251231155730A868.jpg', '\"/profile/upload/2025/12/31/ns6_20251231155735A736.jpg\"', '\"/profile/upload/2025/12/31/ns7_20251231155738A175.jpg\"', NULL, 1, '家居装饰', 359.00, '2024-12-10', 1, '每年', 1, 1, 1, '2024-11-25 15:30:00', '2025-12-31 15:57:41');
INSERT INTO `holiday_shopping` VALUES (5, 1, 'SKG颈椎按摩仪K5', '母亲节', '2024-05-12', '家居用品', '用的', '妈妈', '提前1周', '线下', 'SKG专柜', '专卖店', NULL, 1, '台', 599.00, 549.00, 'CNY', '已收到', '2024-05-10', '2024-05-10', '非常满意', '很快', '很好', '非常好', '非常喜欢', '经常使用', '外观时尚，操作简单，按摩力度适中，热敷功能很舒服，妈妈颈椎不舒服时用一下缓解很多。', '续航时间一般，需要经常充电，高档位噪音有点大。', '建议配合官方APP使用，可以定制更多按摩模式。', '妈妈收到后嘴上说浪费钱，但每天都会用，还跟她的姐妹们炫耀，说儿子孝顺知道心疼她了。', '母亲节给妈妈送健康实用的礼物，表达感恩之情。', '孝敬父母是中华民族传统美德，母亲节是表达孝心的好时机。', '妈妈常年颈椎不好，经常酸痛，想买个按摩仪帮她缓解不适。', '/images/massager_cover.jpg', '[\"/images/massager_box.jpg\", \"/images/massager_use.jpg\", \"/images/massager_detail.jpg\"]', '[\"/screenshots/massager_receipt.jpg\"]', '/videos/massager_unboxing.mp4', 1, '健康礼品', 549.00, '2024-05-05', 0, '不重复', 1, 0, 1, '2024-04-28 13:15:00', '2024-05-13 11:20:00');

-- ----------------------------
-- Table structure for learning_tasks
-- ----------------------------
DROP TABLE IF EXISTS `learning_tasks`;
CREATE TABLE `learning_tasks`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `task_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学习任务名称',
  `learning_area` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学习领域',
  `learning_type` enum('在线课程','书籍阅读','视频教程','实践项目','技能练习','考试备考','语言学习','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学习类型',
  `learning_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '学习内容描述',
  `learning_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学习链接/网址',
  `learning_resources` json NULL COMMENT '相关资源链接',
  `create_date` date NOT NULL COMMENT '创建日期',
  `planned_start_date` date NULL DEFAULT NULL COMMENT '计划开始日期',
  `planned_end_date` date NULL DEFAULT NULL COMMENT '计划完成日期',
  `actual_start_date` date NULL DEFAULT NULL COMMENT '实际开始日期',
  `actual_end_date` date NULL DEFAULT NULL COMMENT '实际完成日期',
  `estimated_hours` decimal(5, 1) NULL DEFAULT NULL COMMENT '预计学习时长（小时）',
  `actual_hours` decimal(5, 1) NULL DEFAULT NULL COMMENT '实际学习时长（小时）',
  `progress_percent` int(11) NULL DEFAULT 0 COMMENT '进度百分比',
  `current_chapter` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '当前章节',
  `next_step` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '下一步计划',
  `difficulty_level` enum('入门','初级','中级','高级','专家') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '初级' COMMENT '难度级别',
  `priority_level` enum('紧急重要','重要不紧急','紧急不重要','不重要不紧急') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '重要不紧急' COMMENT '优先级',
  `importance_level` tinyint(4) NULL DEFAULT 3 COMMENT '重要程度（1-5，5最重要）',
  `learning_method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学习方法',
  `learning_schedule` json NULL COMMENT '学习计划安排',
  `daily_goal` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '每日目标',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片',
  `learning_images` json NULL COMMENT '学习过程图片',
  `screenshots` json NULL COMMENT '学习截图',
  `notes_document` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '笔记文档',
  `reminder_enabled` tinyint(1) NULL DEFAULT 0 COMMENT '是否启用提醒',
  `reminder_time` time(0) NULL DEFAULT NULL COMMENT '提醒时间',
  `reminder_days` json NULL COMMENT '提醒日（周几）',
  `repeat_pattern` enum('不重复','每日','每周','每月','自定义') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '不重复' COMMENT '重复模式',
  `repeat_config` json NULL COMMENT '重复配置',
  `learning_effectiveness` tinyint(4) NULL DEFAULT NULL COMMENT '学习效果评分（1-10）',
  `key_points` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '关键知识点',
  `difficulties_encountered` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '遇到的困难',
  `solutions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解决方法',
  `achievements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '学习成果',
  `task_status` enum('待开始','进行中','已暂停','已延期','已完成','已放弃') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '待开始' COMMENT '任务状态',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否活跃',
  `completion_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '完成备注',
  `reward_description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '完成奖励描述',
  `self_assessment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '自我评估',
  `days_spent` int(11) NULL DEFAULT NULL COMMENT '已花费天数',
  `days_remaining` int(11) NULL DEFAULT NULL COMMENT '剩余天数',
  `streak_days` int(11) NULL DEFAULT 0 COMMENT '连续学习天数',
  `last_study_date` date NULL DEFAULT NULL COMMENT '最后学习日期',
  `related_tasks` json NULL COMMENT '关联任务',
  `study_group` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学习小组',
  `mentor_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '导师/指导人',
  `tags` json NULL COMMENT '标签',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '备注',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_status`(`user_id`, `task_status`) USING BTREE,
  INDEX `idx_user_type`(`user_id`, `learning_type`) USING BTREE,
  INDEX `idx_planned_end`(`planned_end_date`) USING BTREE,
  INDEX `idx_priority`(`priority_level`) USING BTREE,
  INDEX `idx_difficulty`(`difficulty_level`) USING BTREE,
  INDEX `idx_reminder`(`reminder_enabled`, `reminder_time`) USING BTREE,
  INDEX `idx_is_active`(`is_active`) USING BTREE,
  INDEX `idx_progress`(`progress_percent`) USING BTREE,
  FULLTEXT INDEX `idx_search`(`task_name`, `learning_content`, `key_points`)
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习任务管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of learning_tasks
-- ----------------------------
INSERT INTO `learning_tasks` VALUES (1, 1, 'Python数据科学与机器学习实战', '编程', '在线课程', '全面学习Python在数据科学和机器学习领域的应用，包括数据处理、可视化、建模和部署。课程覆盖NumPy、Pandas、Matplotlib、Scikit-learn、TensorFlow等核心库。', 'https://www.coursera.org/specializations/python-data-science', '[\"https://pandas.pydata.org/docs/\", \"https://numpy.org/doc/\", \"https://scikit-learn.org/stable/documentation.html\", \"https://www.tensorflow.org/tutorials\"]', '2024-01-10', '2024-01-15', '2024-03-31', '2024-01-16', NULL, 150.0, 68.5, 45, '第4章：数据可视化与探索性分析', '1. 完成Matplotlib高级图表练习 2. 学习Seaborn库的使用 3. 开始第5章：机器学习基础', '中级', '重要不紧急', 4, '视频学习+代码实践+项目驱动', '{\"周一\": \"19:00-21:30\", \"周三\": \"19:00-21:30\", \"周五\": \"20:00-22:00\", \"周日\": \"14:00-17:00\"}', '每天至少完成2小时有效学习，编写50行以上代码', '/images/learning/python_ds_cover.jpg', '[\"/images/learning/python_class1.jpg\", \"/images/learning/python_code.jpg\", \"/images/learning/python_project.jpg\"]', '[\"/screenshots/data_analysis1.png\", \"/screenshots/ml_model_result.png\"]', '/docs/learning/python_notes.docx', 1, '19:00:00', '[1, 3, 5, 0]', '每周', '{\"end_date\": \"2024-03-31\", \"repeat_unit\": \"week\", \"repeat_every\": 1}', 8, '1. Pandas数据清洗与转换技巧\n2. NumPy高效数组运算\n3. Matplotlib定制化图表\n4. 特征工程方法\n5. 监督学习模型选择', '1. Pandas的groupby操作理解不够深入\n2. 机器学习特征选择方法复杂\n3. 模型调参经验不足', '1. 反复观看视频教程并做笔记\n2. 在Kaggle上找相关数据集练习\n3. 参加在线学习社区讨论\n4. 参考官方文档和示例代码', '已完成3个小项目：房价预测、客户分群、情感分析。掌握了基本的数据处理流程。', '进行中', 1, NULL, '完成后奖励自己购买一台高性能笔记本电脑', '基础部分掌握良好，但高级应用还需要更多实践。学习积极性很高，进度符合预期。', 28, 46, 12, '2024-02-12', '[\"SQL数据分析\", \"统计学基础\", \"深度学习入门\"]', '数据科学学习小组', '张明老师', '[\"Python\", \"数据科学\", \"机器学习\", \"在线课程\", \"编程\"]', '这个课程质量很高，理论与实践结合得很好。建议在学习过程中多做一些实际项目来巩固知识。每周学习时间需要保证在12小时以上才能按时完成。', '2024-01-10 09:30:00', '2024-02-12 21:45:00');
INSERT INTO `learning_tasks` VALUES (2, 1, '大学英语六级考试备考', '语言', '考试备考', '系统备考大学英语六级考试，重点提升听力理解、阅读理解、写作表达和翻译能力。覆盖词汇、语法、题型技巧和真题训练。', 'https://cet.neea.edu.cn/', '[\"https://www.51voa.com/\", \"https://www.ted.com/\", \"https://www.bbc.co.uk/learningenglish\", \"https://youzack.com/\"]', '2023-12-01', '2023-12-05', '2024-06-15', '2023-12-06', NULL, 300.0, 185.5, 38, '听力专项训练', '1. 完成5套听力真题 2. 背诵200个高频词汇 3. 开始阅读长难句分析', '中级', '紧急重要', 5, '真题训练+专项突破+模拟考试', '{\"周六\": \"09:00-12:00, 15:00-17:00\", \"周日\": \"复习总结\", \"周一至周五\": \"20:00-22:00\"}', '每日背诵50个单词，完成一套真题的部分题目，每周一次模拟考试', '/images/learning/cet6_cover.jpg', '[\"/images/learning/english_book.jpg\", \"/images/learning/listening_practice.jpg\"]', '[\"/screenshots/listening_score.png\", \"/screenshots/vocabulary_progress.png\"]', '/docs/learning/english_notes.docx', 1, '20:00:00', '[0, 1, 2, 3, 4, 5, 6]', '每日', '{\"end_date\": \"2024-06-14\", \"repeat_unit\": \"day\", \"repeat_every\": 1}', 7, '1. 六级核心词汇3000个\n2. 听力场景词汇和短语\n3. 阅读快速定位技巧\n4. 写作模板和高级表达\n5. 翻译常见句型', '1. 听力长对话反应速度慢\n2. 阅读理解时间不够用\n3. 写作词汇表达单一\n4. 翻译中英思维转换困难', '1. 精听和泛听结合训练\n2. 限时阅读练习提高速度\n3. 积累写作模板和高级词汇\n4. 分析真题翻译参考答案', '词汇量从3500提升到4800，听力正确率从50%提升到65%，完成15套真题训练。', '进行中', 1, NULL, '考试通过后奖励一次出国旅行', '听力进步明显但还需加强，阅读速度有待提高，写作和翻译需要更多练习。整体进度比计划慢了一周，需要调整学习计划。', 68, 123, 45, '2024-02-12', '[\"英语口语练习\", \"商务英语学习\", \"雅思备考\"]', '六级备考冲刺班', '李华老师', '[\"英语\", \"六级\", \"考试\", \"语言学习\", \"备考\"]', '距离考试还有4个月，需要加大听力训练强度，特别是长对话和讲座部分。写作部分要形成自己的模板，避免千篇一律。每周必须进行一次完整的模拟考试。', '2023-12-01 10:00:00', '2024-02-12 22:30:00');
INSERT INTO `learning_tasks` VALUES (3, 1, '人像摄影与后期处理精通', '艺术', '视频教程', '系统学习人像摄影的构图、用光、姿势引导以及后期修图技巧，提升专业摄影水平。包含室内外拍摄、自然光与闪光灯使用、Photoshop和Lightroom后期处理。', 'https://www.bilibili.com/video/BV1gJ41157pZ', '[\"https://www.zhihu.com/column/photography\", \"https://fstoppers.com/\", \"https://phlearn.com/\"]', '2024-01-05', '2024-01-06', '2024-02-29', '2024-01-07', NULL, 80.0, 32.5, 40, '第3章：自然光人像拍摄技巧', '1. 完成逆光人像拍摄练习 2. 学习黄金时段拍摄 3. 开始第4章：闪光灯基础', '初级', '不重要不紧急', 3, '理论学习+实践拍摄+后期处理', '{\"周二\": \"19:00-21:00\", \"周四\": \"19:00-21:00\", \"周六或周日\": \"外出拍摄\"}', '每周至少外出拍摄一次，完成10张以上作品，学习2小时后期处理', '/images/learning/photography_cover.jpg', '[\"/images/learning/photo_shot1.jpg\", \"/images/learning/photo_shot2.jpg\", \"/images/learning/photo_edit.jpg\"]', '[\"/screenshots/photo_before_after1.png\", \"/screenshots/lightroom_settings.png\"]', '/docs/learning/photography_notes.docx', 1, '19:00:00', '[2, 4]', '每周', '{\"skip_weeks\": [], \"repeat_unit\": \"week\", \"repeat_every\": 1}', 9, '1. 三分法构图和黄金分割\n2. 眼神光控制和补光技巧\n3. 人物姿势引导方法\n4. 自然光特性与利用\n5. Lightroom调色流程', '1. 户外拍摄光线变化快\n2. 模特姿势引导不自然\n3. 后期调色风格把握不准\n4. 设备操作不够熟练', '1. 提前考察拍摄场地和光线条件\n2. 学习优秀作品的姿势参考\n3. 建立自己的调色预设库\n4. 多练习设备快速操作', '掌握了基本构图方法，能够拍出清晰的人像照片，学会了Lightroom基础调色，完成了3组人像作品。', '进行中', 1, NULL, '课程完成后奖励自己一个85mm f/1.8镜头', '理论学习效果很好，但实践拍摄经验还需要积累。后期处理进步明显，但创意方面还需要提升。整体学习进度比计划快。', 36, 17, 5, '2024-02-11', '[\"风光摄影学习\", \"手机摄影技巧\", \"Photoshop高级应用\"]', '摄影爱好者交流群', '王摄影师', '[\"摄影\", \"人像\", \"艺术\", \"技能\", \"爱好\", \"后期处理\"]', '摄影是很好的创作方式，可以记录生活美好瞬间。需要更多实践来掌握用光技巧，特别是室内闪光灯的使用。后期处理不要过度，保持自然最重要。', '2024-01-05 15:20:00', '2024-02-11 20:15:00');
INSERT INTO `learning_tasks` VALUES (4, 1, '科学健身与营养管理', '健康', '实践项目', '学习科学的健身训练方法和营养管理知识，制定个性化健身计划，改善体质和健康水平。包括力量训练、有氧运动、饮食计划和恢复策略。', 'https://www.keep.com/course', '[\"https://www.youtube.com/@AthleanX\", \"https://www.bodybuilding.com/\", \"https://www.muscleandstrength.com/\"]', '2024-01-01', '2024-01-02', '2024-03-31', '2024-01-02', NULL, 100.0, 55.5, 55, '第5章：增肌期饮食计划', '1. 计算每日蛋白质需求 2. 制定一周增肌餐单 3. 开始第6章：减脂策略', '初级', '重要不紧急', 4, '理论指导+实践训练+饮食记录', '{\"周日\": \"休息恢复\", \"周一三五\": \"07:00-07:45力量训练\", \"周二四六\": \"19:30-20:15有氧运动\"}', '每天完成30-45分钟训练，记录饮食摄入，保证7-8小时睡眠', '/images/learning/fitness_cover.jpg', '[\"/images/learning/workout1.jpg\", \"/images/learning/workout2.jpg\", \"/images/learning/meal_prep.jpg\"]', '[\"/screenshots/workout_log.png\", \"/screenshots/body_measurements.png\"]', '/docs/learning/fitness_notes.docx', 1, '07:00:00', '[1, 3, 5]', '每周', '{\"exceptions\": [\"2024-02-10\", \"2024-02-11\"], \"repeat_unit\": \"week\", \"repeat_every\": 1}', 8, '1. 三大力量训练动作标准\n2. 训练容量和强度控制\n3. 蛋白质碳水脂肪配比\n4. 训练后恢复方法\n5. 补剂选择和使用', '1. 训练动作不够标准\n2. 饮食控制难以坚持\n3. 训练计划执行不规律\n4. 睡眠质量影响恢复', '1. 拍摄训练视频自我纠正\n2. 提前准备健康餐食\n3. 制定具体可执行的计划\n4. 建立规律的作息时间', '体重从70kg增加到72.5kg，体脂率从18%降到16%，深蹲重量从60kg提升到80kg，养成了规律训练习惯。', '进行中', 1, NULL, '达到目标体型后奖励自己一套新的健身服装', '训练积极性很高，但饮食控制还需要加强。力量增长明显，但柔韧性和有氧能力需要提升。整体进步符合预期。', 42, 48, 42, '2024-02-12', '[\"瑜伽入门\", \"跑步训练计划\", \"运动损伤预防\"]', '健身打卡小组', '陈教练', '[\"健身\", \"健康\", \"营养\", \"运动\", \"生活方式\"]', '健身不仅是锻炼身体，更是培养自律和毅力的过程。饮食控制比训练更难坚持，需要更强的意志力。记录训练和饮食数据很有帮助，可以看到进步和调整方向。', '2024-01-01 08:00:00', '2024-02-12 08:30:00');
INSERT INTO `learning_tasks` VALUES (5, 1, 'SQL数据库从入门到精通', '编程', '书籍阅读', '系统学习SQL语言和数据库管理，包括数据查询、表设计、索引优化、事务处理和存储过程等。基于《SQL必知必会》和《高性能MySQL》两本书。', NULL, '[\"https://www.sqlite.org/docs.html\", \"https://dev.mysql.com/doc/\", \"https://www.postgresql.org/docs/\"]', '2023-09-01', '2023-09-05', '2023-11-30', '2023-09-06', '2023-11-28', 120.0, 135.5, 100, '已全部完成', '无下一步计划', '中级', '重要不紧急', 4, '书籍阅读+在线练习+项目实践', '{\"周末\": \"灵活安排\", \"周一至周五\": \"20:30-22:00\"}', '每天学习1-2小时，完成章节练习，每周一个实践项目', '/images/learning/sql_cover.jpg', '[\"/images/learning/sql_book.jpg\", \"/images/learning/database_design.jpg\"]', '[\"/screenshots/sql_queries.png\", \"/screenshots/database_schema.png\"]', '/docs/learning/sql_notes.pdf', 0, NULL, NULL, '不重复', NULL, 9, '1. SELECT查询的完整语法\n2. JOIN的多种类型和使用场景\n3. 索引原理和优化策略\n4. 事务ACID特性\n5. 存储过程和触发器', '1. 复杂查询逻辑难以理解\n2. 性能优化经验不足\n3. 不同数据库方言差异', '1. 在SQL Fiddle上多练习\n2. 分析执行计划优化查询\n3. 对比学习不同数据库特性', '掌握了SQL核心语法，能够设计规范的数据库表结构，编写高效的查询语句，完成了一个电商数据库设计项目。', '已完成', 1, '按时完成学习计划，掌握了SQL核心技能，项目实践效果很好，达到了预期学习目标。', '已获得奖励：购买了一台NAS服务器用于数据库实践', 'SQL基础掌握扎实，复杂查询和性能优化还需要在实际工作中积累经验。整体学习效果很好，为后续的数据库相关工作打下了坚实基础。', 84, 0, 84, '2023-11-28', '[\"Python数据库编程\", \"大数据技术学习\", \"NoSQL数据库\"]', '数据库学习小组', '刘工程师', '[\"SQL\", \"数据库\", \"编程\", \"已完成的\", \"技能学习\"]', 'SQL是数据领域的核心技能，学习过程比较顺利。建议在学习时多动手实践，理论知识结合实际项目更容易掌握。后续需要学习更多数据库高级特性和优化技巧。', '2023-09-01 14:00:00', '2023-12-01 10:20:00');

-- ----------------------------
-- Table structure for plant_growth
-- ----------------------------
DROP TABLE IF EXISTS `plant_growth`;
CREATE TABLE `plant_growth`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `plant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '植物名称',
  `plant_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '植物类型（花卉/蔬菜/多肉等）',
  `variety` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '品种',
  `plant_date` date NOT NULL COMMENT '种植日期',
  `plant_location` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '种植位置',
  `planting_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '种植方式',
  `soil_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '土壤类型',
  `pot_size` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '花盆尺寸',
  `growth_stage` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '生长阶段',
  `health_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '良好' COMMENT '健康状况',
  `height_cm` decimal(6, 2) NULL DEFAULT NULL COMMENT '高度(cm)',
  `leaf_count` int(11) NULL DEFAULT NULL COMMENT '叶片数量',
  `flower_count` int(11) NULL DEFAULT NULL COMMENT '花朵数量',
  `fruit_count` int(11) NULL DEFAULT NULL COMMENT '果实数量',
  `ideal_temperature` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适宜温度',
  `ideal_humidity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '适宜湿度',
  `light_requirements` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '光照要求',
  `watering_needs` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '浇水需求',
  `fertilizing_needs` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '施肥需求',
  `care_instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '养护说明',
  `watering_guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '浇水教程',
  `fertilizing_guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '施肥教程',
  `pruning_guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '修剪教程',
  `repotting_guide` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '换盆教程',
  `propagation_methods` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '繁殖方法',
  `common_problems` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '常见问题',
  `pest_solutions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '病虫害防治',
  `troubleshooting` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '故障排除',
  `growth_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '生长记录',
  `observations` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '观察记录',
  `challenges` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '遇到的问题',
  `solutions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '解决方案',
  `success_tips` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '成功秘诀',
  `germination_date` date NULL DEFAULT NULL COMMENT '发芽日期',
  `flowering_date` date NULL DEFAULT NULL COMMENT '开花日期',
  `fruiting_date` date NULL DEFAULT NULL COMMENT '结果日期',
  `harvest_date` date NULL DEFAULT NULL COMMENT '收获日期',
  `milestones` json NULL COMMENT '重要里程碑',
  `last_watering` date NULL DEFAULT NULL COMMENT '上次浇水',
  `last_fertilizing` date NULL DEFAULT NULL COMMENT '上次施肥',
  `last_pruning` date NULL DEFAULT NULL COMMENT '上次修剪',
  `next_care_date` date NULL DEFAULT NULL COMMENT '下次养护',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片',
  `growth_images` json NULL COMMENT '生长图片',
  `tutorial_images` json NULL COMMENT '教程图片',
  `care_videos` json NULL COMMENT '养护视频',
  `purchase_price` decimal(8, 2) NULL DEFAULT NULL COMMENT '购买价格',
  `total_cost` decimal(8, 2) NULL DEFAULT NULL COMMENT '总成本',
  `harvest_amount` decimal(8, 2) NULL DEFAULT NULL COMMENT '收获量',
  `harvest_unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收获单位',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否存活',
  `watering_reminder` tinyint(1) NULL DEFAULT 1 COMMENT '浇水提醒',
  `fertilizing_reminder` tinyint(1) NULL DEFAULT 0 COMMENT '施肥提醒',
  `growth_reminder` tinyint(1) NULL DEFAULT 0 COMMENT '生长记录提醒',
  `days_grown` int(11) NULL DEFAULT NULL COMMENT '生长天数',
  `growth_rate` decimal(6, 2) NULL DEFAULT NULL COMMENT '生长速度',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_plant`(`user_id`, `plant_type`) USING BTREE,
  INDEX `idx_plant_date`(`plant_date`) USING BTREE,
  INDEX `idx_health_status`(`health_status`) USING BTREE,
  INDEX `idx_growth_stage`(`growth_stage`) USING BTREE,
  INDEX `idx_next_care`(`next_care_date`) USING BTREE,
  INDEX `idx_is_active`(`is_active`) USING BTREE,
  FULLTEXT INDEX `idx_search`(`plant_name`, `care_instructions`, `growth_notes`)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '植物生长记录与教程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plant_growth
-- ----------------------------
INSERT INTO `plant_growth` VALUES (1, 1, '熊童子', '多肉', '白熊品种', '2024-01-10', '书房窗台', '扦插繁殖', '多肉专用土+珍珠岩', '直径12cm陶瓷盆', '生长期', '良好', 8.20, 24, 0, 0, '15-25℃', '40-50%', '明亮散射光，避免暴晒', '干透浇透，冬季控水', '春秋季每月施一次薄肥', '1. 避免过度浇水\r\n2. 夏季适当遮阴\r\n3. 冬季保持干燥\r\n4. 春秋季节增加光照', '干透浇透原则。用手指插入土壤2cm，干燥再浇水。夏季每月1-2次，冬季每月1次或不浇。', '使用多肉专用肥，稀释1000倍，生长季每月一次。', '修剪底部枯叶，保持植株整洁。剪取过长枝条用于扦插。', '每1-2年换盆一次，春季进行。换盆时修根，晾干后再种。', '1. 叶插：取下健康叶片平放土面\r\n2. 枝插：剪取枝条晾干后扦插\r\n3. 分株：分离侧芽单独种植', '1. 叶片发软：缺水或烂根\r\n2. 徒长：光照不足\r\n3. 叶片化水：浇水过多\r\n4. 介壳虫：常见虫害', '介壳虫：用牙签刮除或酒精擦拭\r\n蚜虫：喷洒肥皂水\r\n烂根：切除腐烂部分，重新扦插', '问题：叶片发黄掉落\r\n解决：减少浇水，增加通风\r\n问题：植株徒长\r\n解决：增加光照，控制水分', '今天发现新长出了3片小叶子，叶缘红色加深，很健康。', '光照充足时叶片肥厚，光照不足时叶片变薄伸长。', '冬季曾出现叶片发软，以为是缺水，结果浇多了差点烂根。', '学习到多肉冬季要控水，宁愿干着也不能多浇。', '1. 配土要疏松透气\r\n2. 宁干勿湿\r\n3. 夏季注意通风\r\n4. 冬季防冻', NULL, NULL, NULL, NULL, '[\"扦插成活\", \"新叶生长\"]', '2024-05-18', '2024-04-15', NULL, '2024-06-01', '/profile/upload/2025/12/31/image-20251103190058636_20251231111941A111.png', '\"/profile/upload/2025/12/31/image-20251103190058636_20251231111952A045.png\"', '\"/profile/upload/2025/12/31/image-20251103190058636_20251231111958A383.png\"', '\"/profile/upload/2025/12/31/wei_20251231112026A794.mp4\"', 25.00, 35.00, NULL, NULL, 1, 0, 0, 0, 130, 0.06, '2024-01-10 14:20:00', '2025-12-31 11:20:29');
INSERT INTO `plant_growth` VALUES (2, 1, '蝴蝶兰', '花卉', '紫红色大花型', '2023-11-20', '客厅茶几', '购买成品苗', '水苔+树皮', '透明塑料盆', '开花期', '优秀', 45.00, 6, 8, 0, '18-28℃', '60-80%', '明亮散射光，避免直射', '保持水苔湿润但不积水', '生长期每周施薄肥一次', '1. 使用透明盆观察根系\r\n2. 保持高湿度环境\r\n3. 避免强光直射\r\n4. 花后及时修剪', '观察根系颜色：绿色不浇，灰白色浇水。通常每周一次，夏季增加，冬季减少。', '专用兰花肥，稀释2000倍，薄肥勤施。开花期停止施肥。', '花后剪掉花梗，保留2-3节以促进二次开花。修剪枯黄叶片。', '水苔变酸或根系长满时换盆，春季进行。保留健康根系，去除烂根。', '1. 花梗繁殖：花梗节点处可发芽\r\n2. 分株繁殖：植株长大后分株\r\n3. 组织培养：专业繁殖方法', '1. 叶片发黄：光照过强或烂根\r\n2. 不开花：光照不足或氮肥过多\r\n3. 根系腐烂：浇水过多\r\n4. 花朵早谢：温度过高', '蚜虫：喷洒肥皂水\r\n红蜘蛛：增加湿度\r\n炭疽病：剪除病叶，喷洒杀菌剂', '问题：叶片起皱\r\n解决：增加浇水频率\r\n问题：花苞掉落\r\n解决：避免移动位置，保持稳定环境', '今天第八朵花完全开放，花期已持续一个月。新根从盆边冒出，生长良好。', '清晨叶片有水珠，说明根系健康。光照充足时叶片挺立。', '冬季曾因浇水过多导致根部腐烂。', '重新换盆，剪除烂根，使用新水苔，控制浇水。', '1. 夏季空调房要增加湿度\r\n2. 花期不要移动位置\r\n3. 定期转动花盆使受光均匀', NULL, '2024-04-01', NULL, NULL, '[\"买回适应\", \"新叶生长\", \"抽花梗\", \"开花\"]', '2024-05-19', '2024-05-12', '2024-03-20', '2024-05-26', '/profile/upload/2025/12/31/684_20251231113109A988.jpeg', '[\"/images/orchid_bud.jpg\", \"/images/orchid_flowering.jpg\", \"/images/orchid_full_bloom.jpg\"]', '[\"/images/orchid_repotting.jpg\", \"/images/orchid_watering.jpg\"]', '[\"/videos/orchid_care.mp4\"]', 80.00, 120.00, NULL, NULL, 1, 1, 1, 1, 180, 0.25, '2023-11-20 09:00:00', '2025-12-31 11:31:11');
INSERT INTO `plant_growth` VALUES (3, 1, '罗马生菜', '蔬菜', '奶油生菜', '2024-04-25', '厨房水培架', '水培种植', '无土栽培', '水培容器', '成熟期', '健康', 20.50, 19, 0, 0, '15-22℃', '50-70%', '每天12-14小时光照', '保持营养液循环', '每周更换营养液', '1. 保持营养液EC值在1.2-1.8\r\n2. 水温保持在18-22℃\r\n3. 保证充足光照\r\n4. 及时采收', '水培系统自动循环，保持营养液充足，水位覆盖根系2/3。', '使用水培专用营养液，A/B液按比例调配，每周更换一次。', '摘除外围老叶，促进中心新叶生长。不要过度修剪。', '不需要换盆，定期清洗水培容器，消毒防藻。', '种子繁殖为主，也可叶插但成功率低。', '1. 叶片发黄：缺氮或光照不足\r\n2. 根部褐变：缺氧或病菌感染\r\n3. 生长缓慢：温度不适或营养不足\r\n4. 藻类滋生：光照过强', '根腐病：添加过氧化氢，清洗根系\r\n藻类：遮光处理，定期清洗容器\r\n缺素症：调整营养液配方', '问题：叶片边缘焦枯\r\n解决：调整营养液pH值至5.5-6.5\r\n问题：生长缓慢\r\n解决：增加光照时间和强度', '今天可以采收了，叶片脆嫩，颜色翠绿。', '光照充足时叶片紧密，光照不足时徒长。', '初期营养液浓度过高导致烧根。', '稀释营养液，清洗根系，重新配制。', '1. LED植物灯效果很好\r\n2. 保持水温稳定\r\n3. 采收时留根可再长一茬', '2024-04-28', NULL, NULL, '2024-05-20', '[\"发芽\", \"真叶展开\", \"快速生长\"]', '2024-05-19', '2024-05-12', NULL, '2024-05-26', '/profile/upload/2025/12/31/image-20251103190058636_20251231111007A484.png', '\"/profile/upload/2025/12/31/684_20251231112120A941.jpeg\"', '\"/profile/upload/2025/12/31/546_20251231112125A460.jpeg\"', '\"/profile/upload/2025/12/31/wei_20251231112130A173.mp4\"', 5.00, 50.00, 0.80, '公斤', 1, 1, 1, 0, 24, 0.85, '2024-04-25 08:30:00', '2025-12-31 11:21:38');
INSERT INTO `plant_growth` VALUES (4, 1, '月季', '花卉', '龙沙宝石', '2023-09-10', '花园南墙', '扦插苗', '园土+腐殖土+河沙', '地栽', '营养生长期', '良好', 120.00, 150, 0, 0, '15-25℃', '50-70%', '全日照，每天至少6小时', '深浇水，见干见湿', '每月施一次复合肥', '1. 选择阳光充足位置\r\n2. 深挖种植穴\r\n3. 定期修剪\r\n4. 冬季保暖', '地栽浇水要深，每次浇透。夏季每周2-3次，春秋每周1-2次，冬季控水。', '春季：氮肥为主\r\n夏季：磷钾肥为主\r\n秋季：平衡肥\r\n冬季：有机肥底肥', '冬季重剪，保留主干。花后轻剪，促进二次开花。剪除病弱枝。', '地栽不需要换盆，每年冬季深翻土壤，施足底肥。', '1. 扦插：春秋季取半木质化枝条\r\n2. 嫁接：芽接或枝接\r\n3. 压条：高空压条法', '1. 黑斑病：雨季常见\r\n2. 白粉病：通风不良\r\n3. 蚜虫：春季多发\r\n4. 红蜘蛛：干燥环境', '黑斑病：及时清除病叶，喷洒多菌灵\r\n白粉病：增加通风，喷洒硫磺粉\r\n蚜虫：喷洒吡虫啉\r\n红蜘蛛：喷洒阿维菌素', '问题：只长叶不开花\r\n解决：增加光照，控制氮肥\r\n问题：叶片黄化\r\n解决：检查土壤pH，补充铁肥', '今天发现有新笋芽冒出，长势很好。叶片油绿，没有病虫害迹象。', '充足光照下花芽分化多，光照不足易徒长。', '去年黑斑病严重，大量落叶。', '冬季彻底清园，喷洒石硫合剂，春季预防性喷药。', '1. 地栽比盆栽长势好\r\n2. 定期预防病虫害\r\n3. 花后及时修剪\r\n4. 冬季适当保暖', NULL, '2024-04-15', NULL, NULL, '[\"定植成活\", \"第一次开花\", \"过冬成功\"]', '2024-05-18', '2024-05-01', '2024-03-10', '2024-06-01', '/profile/upload/2025/12/31/546_20251231113120A153.jpeg', '[\"/images/rose_planting.jpg\", \"/images/rose_first_flower.jpg\", \"/images/rose_pruning.jpg\"]', '[\"/images/rose_pruning_guide.jpg\", \"/images/rose_pest_control.jpg\"]', '[\"/videos/rose_care.mp4\"]', 30.00, 80.00, NULL, NULL, 1, 1, 1, 1, 252, 0.48, '2023-09-10 10:00:00', '2025-12-31 11:31:21');
INSERT INTO `plant_growth` VALUES (6, 1, 'Test Plant Updated', 'Flower', NULL, '2025-01-01', NULL, NULL, NULL, NULL, '发芽期', '良好', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'null', NULL, NULL, NULL, NULL, '/profile/upload/2025/12/31/368_20251231113137A544.jpeg', '[\"/profile/upload/2025/12/31/546_20251231113151A073.jpeg\"]', '[\"/profile/upload/2025/12/31/456_20251231113154A165.jpeg\"]', '[]', NULL, NULL, NULL, NULL, 1, 0, 0, 0, NULL, NULL, '2025-12-31 10:26:45', '2025-12-31 11:31:58');
INSERT INTO `plant_growth` VALUES (8, 1, '啦啦啦', '多肉植物', NULL, '2025-12-10', '阳台', NULL, NULL, NULL, '生长期', '良好', 0.50, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'null', NULL, NULL, NULL, NULL, '/profile/upload/2025/12/31/154_20251231114620A685.jpeg', '[]', '[]', '[]', NULL, NULL, NULL, NULL, 1, 1, 0, 0, NULL, NULL, '2025-12-31 11:47:32', '2025-12-31 11:47:32');

-- ----------------------------
-- Table structure for sxt_camera
-- ----------------------------
DROP TABLE IF EXISTS `sxt_camera`;
CREATE TABLE `sxt_camera`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1' COMMENT 'uuid',
  `lift_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '摄像头名称',
  `dept_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '小区楼栋id',
  `camera_status` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '摄像头状态(0:开启,1:关闭)',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `del` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '删除标志(0:未删除,1:已删除)',
  `camera_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '登录用户名',
  `camera_password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '登录密码',
  `camera_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摄像头IP',
  `camera_port` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摄像头端口',
  `camera_rtsp_port` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摄像头rtsp端口',
  `protocol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摄像头rtsp协议',
  `brand` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '摄像头rtsp品牌',
  `line` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '线路',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '电梯/摄像头表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sxt_camera
-- ----------------------------
INSERT INTO `sxt_camera` VALUES ('3ef31097-4599-4ced-ae58-f4719caea8bf', '2号', '103', '0', '2025-12-23 15:59:01', '2025-12-23 16:12:05', '0', 'admin', 'lanbu@2024', '192.168.10.88', '80', '554', NULL, NULL, '0');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2025-12-29 10:57:42', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '集团总公司', 0, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳分公司', 1, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '年糕', '15888888888', 'niangao@qq.com', '0', '0', 'admin', '2025-12-29 10:57:08', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'default', 'sys_job_group', '', '', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '数据库', 'sqlalchemy', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '数据库分组');
INSERT INTO `sys_dict_data` VALUES (12, 3, 'redis', 'redis', 'sys_job_group', '', '', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, 'reids分组');
INSERT INTO `sys_dict_data` VALUES (13, 1, '默认', 'default', 'sys_job_executor', '', '', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '线程池');
INSERT INTO `sys_dict_data` VALUES (14, 2, '进程池', 'processpool', 'sys_job_executor', '', '', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '进程池');
INSERT INTO `sys_dict_data` VALUES (15, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (16, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (17, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (18, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (19, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (20, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (21, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (22, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (23, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (24, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (25, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (26, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (27, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (28, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (29, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (30, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (31, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (32, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2025-12-29 10:57:39', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '任务执行器', 'sys_job_executor', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '任务执行器列表');
INSERT INTO `sys_dict_type` VALUES (7, '系统是否', 'sys_yes_no', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知类型', 'sys_notice_type', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (9, '通知状态', 'sys_notice_status', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (10, '操作类型', 'sys_oper_type', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (11, '系统状态', 'sys_common_status', '0', 'admin', '2025-12-29 10:57:36', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'default' COMMENT '任务组名',
  `job_executor` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'default' COMMENT '任务执行器',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_args` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '位置参数',
  `job_kwargs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '关键字参数',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'default', 'default', 'module_task.scheduler_test.job', NULL, NULL, '0/10 * * * * ?', '3', '1', '1', 'admin', '2025-12-29 10:57:50', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'default', 'default', 'module_task.scheduler_test.job', 'test', NULL, '0/15 * * * * ?', '3', '1', '1', 'admin', '2025-12-29 10:57:50', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'default', 'default', 'module_task.scheduler_test.job', 'new', '{\"test\": 111}', '0/20 * * * * ?', '3', '1', '1', 'admin', '2025-12-29 10:57:50', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务组名',
  `job_executor` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务执行器',
  `invoke_target` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_args` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '位置参数',
  `job_kwargs` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '关键字参数',
  `job_trigger` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '任务触发器',
  `job_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 116 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-29 18:04:01');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-30 09:05:37');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-30 13:57:32');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-30 15:46:24');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-30 16:46:04');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 09:08:38');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '', '未知', 'Edge 143', 'Windows 10', '1', '验证码已失效', '2025-12-31 10:00:12');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 10:00:16');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 10:33:02');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 10:48:24');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '', '未知', 'Python Requests 2', 'Other', '1', '验证码已失效', '2025-12-31 12:25:30');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 12:29:19');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 14:02:12');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 15:25:48');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-31 16:23:31');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '', '未知', 'Electron 37', 'Windows 10', '0', '登录成功', '2025-12-31 17:27:54');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2000 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2025-12-29 10:57:14', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2025-12-29 10:57:14', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2025-12-29 10:57:14', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2025-12-29 10:57:14', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2025-12-29 10:57:14', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2025-12-29 10:57:14', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2025-12-29 10:57:14', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2025-12-29 10:57:14', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2025-12-29 10:57:14', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2025-12-29 10:57:14', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2025-12-29 10:57:14', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2025-12-29 10:57:14', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2025-12-29 10:57:14', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2025-12-29 10:57:14', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2025-12-29 10:57:14', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2025-12-29 10:57:14', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2025-12-29 10:57:14', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2025-12-29 10:57:14', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2025-12-29 10:57:14', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2025-12-29 10:57:14', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2025-12-29 10:57:14', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2025-12-29 10:57:14', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2025-12-29 10:57:14', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2025-12-29 10:57:14', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2025-12-29 10:57:14', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 vfadmin新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2025-12-29 10:57:54', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 vfadmin系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2025-12-29 10:57:54', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2025-12-29 10:57:11', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2025-12-29 10:57:11', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2025-12-29 10:57:11', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2025-12-29 10:57:11', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2025-12-29 10:57:13', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2025-12-29 10:57:13', '', NULL, '普通角色');

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime(0) NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '超级管理员', '00', 'niangao@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-12-31 17:27:54', '2025-12-29 10:57:10', 'admin', '2025-12-29 10:57:10', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'niangao', '年糕', '00', 'niangao@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-12-29 10:57:10', '2025-12-29 10:57:10', 'admin', '2025-12-29 10:57:10', '', NULL, '测试员');

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);

-- ----------------------------
-- Table structure for travel_footprints
-- ----------------------------
DROP TABLE IF EXISTS `travel_footprints`;
CREATE TABLE `travel_footprints`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '足迹标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '描述/游记',
  `location_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地点名称',
  `address` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '详细地址',
  `country` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '国家',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '省份/州',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '区县',
  `latitude` decimal(10, 8) NULL DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(11, 8) NULL DEFAULT NULL COMMENT '经度',
  `geohash` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地理编码',
  `coordinate` point NULL,
  `visit_date` date NOT NULL COMMENT '到访日期',
  `start_time` time(0) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` time(0) NULL DEFAULT NULL COMMENT '结束时间',
  `duration` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '停留时长（分钟）',
  `timezone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '时区信息',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '封面图片URL',
  `images` json NULL COMMENT '图片URL数组',
  `videos` json NULL COMMENT '视频链接数组',
  `audio_notes` json NULL COMMENT '语音备注数组',
  `travel_type` enum('自由行','跟团游','商务出行','探亲访友','其他') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '自由行' COMMENT '旅行类型',
  `tags` json NULL COMMENT '标签数组',
  `season` enum('春','夏','秋','冬','未知') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '未知' COMMENT '季节',
  `weather` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '天气情况',
  `rating` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '评分（1-5星）',
  `mood` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '心情状态',
  `recommend_level` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '推荐程度（1-5）',
  `cost_level` tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '消费水平（1-5）',
  `companions` json NULL COMMENT '同行人员数组',
  `transportation` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '交通工具',
  `accommodation` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '住宿信息',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '注意事项/贴士',
  `is_public` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否公开',
  `status` enum('计划中','进行中','已完成','取消') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '已完成' COMMENT '状态',
  `privacy_level` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '隐私级别（1-3，1=公开，2=好友可见，3=仅自己）',
  `favorite_count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '收藏数',
  `view_count` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `visit_date`) USING BTREE,
  INDEX `idx_location`(`country`, `province`, `city`, `district`) USING BTREE,
  INDEX `idx_geohash`(`geohash`) USING BTREE,
  INDEX `idx_status_user`(`status`, `user_id`) USING BTREE,
  INDEX `idx_public_create`(`is_public`, `create_time`) USING BTREE,
  INDEX `idx_user_status`(`user_id`, `status`) USING BTREE,
  INDEX `idx_latitude_longitude`(`latitude`, `longitude`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '旅行足迹表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of travel_footprints
-- ----------------------------
INSERT INTO `travel_footprints` VALUES (1, 1, '故宫一日游，感受明清皇家气派', '早上8点到达天安门广场，排队进入故宫。参观了太和殿、中和殿、保和殿三大殿，感受了明清两代的皇家气派。中午在故宫餐厅用餐，下午游览了御花园和钟表馆。', '故宫博物院', '北京市东城区景山前街4号', '中国', '北京', '北京市', '东城区', 39.91634500, 116.39715500, 'wx4g0f', ST_GeomFromText('POINT(116.397155 39.916345)'), '2023-10-15', '08:00:00', '17:30:00', 570, NULL, '2025-12-29 15:13:04', '2025-12-29 16:37:56', '/profile/upload/2025/12/29/020_20251229163104A407.jpg', '[\"https://example.com/images/gugong1.jpg\", \"https://example.com/images/gugong2.jpg\", \"https://example.com/images/gugong3.jpg\"]', NULL, NULL, '自由行', '[\"历史\", \"文化\", \"皇家建筑\", \"世界文化遗产\"]', '秋', '晴天', 5, '兴奋', 5, 3, '[\"张三\", \"李四\"]', '地铁', '北京王府井希尔顿酒店', '建议提前网上购票，避开节假日人流高峰。', 1, '已完成', 1, 0, 0);
INSERT INTO `travel_footprints` VALUES (2, 1, '外滩夜景，东方明珠的璀璨', '傍晚时分来到外滩，看着对岸陆家嘴的灯光逐渐亮起。从外白渡桥一直走到金陵东路，沿途欣赏万国建筑博览群。', '上海外滩', '上海市黄浦区中山东一路', '中国', '上海', '上海市', '黄浦区', 31.23969200, 121.49984000, 'wtw3sj', ST_GeomFromText('POINT(121.49984 31.239692)'), '2023-11-05', '18:30:00', '21:00:00', 150, NULL, '2025-12-29 15:13:04', '2025-12-29 16:37:54', '/profile/upload/2025/12/29/020_20251229163104A407.jpg', '[\"https://example.com/images/bund1.jpg\", \"https://example.com/images/bund2.jpg\"]', NULL, NULL, '商务出行', '[\"夜景\", \"城市风光\", \"地标建筑\", \"摄影\"]', '秋', '多云', 4, '浪漫', 4, 2, '[\"王五\"]', '出租车', NULL, '晚上风大，建议带外套。最佳拍摄点在海关大楼附近。', 1, '已完成', 1, 0, 0);
INSERT INTO `travel_footprints` VALUES (3, 1, '杭州西湖春日游计划', '计划春季去杭州西湖，游览苏堤春晓、断桥残雪、雷峰塔等景点，品尝杭州特色美食。', '西湖风景区', '浙江省杭州市西湖区龙井路1号', '中国', '浙江', '杭州市', '西湖区', 30.24795800, 120.13887800, 'wtm7z2', ST_GeomFromText('POINT(120.138878 30.247958)'), '2024-04-10', NULL, NULL, NULL, NULL, '2025-12-29 15:13:04', '2025-12-29 16:37:52', '/profile/upload/2025/12/29/020_20251229163104A407.jpg', NULL, NULL, NULL, '自由行', NULL, '春', NULL, NULL, NULL, NULL, NULL, '[\"家人\"]', '高铁', '杭州西湖国宾馆', NULL, 0, '计划中', 3, 0, 0);
INSERT INTO `travel_footprints` VALUES (4, 1, '秦始皇兵马俑，震撼的历史遗迹', '亲眼见到兵马俑的震撼无法用语言形容。一号坑的规模最大，二号坑有各种兵种，三号坑是指挥部。建议请讲解员，能了解更多历史背景。', '秦始皇兵马俑博物馆', '陕西省西安市临潼区秦陵北路', '中国', '陕西', '西安市', '临潼区', 34.38520800, 109.27339600, 'wqj6s2', ST_GeomFromText('POINT(109.273396 34.385208)'), '2023-08-20', '09:00:00', '15:00:00', 360, NULL, '2025-12-29 15:13:04', '2025-12-29 16:37:49', '/profile/upload/2025/12/29/020_20251229163104A407.jpg', '[\"https://example.com/images/terracotta1.jpg\", \"https://example.com/images/terracotta2.jpg\"]', '[\"https://example.com/videos/terracotta.mp4\"]', NULL, '跟团游', '[\"历史\", \"考古\", \"世界奇迹\", \"文化遗产\"]', '夏', '晴天', 5, '震撼', 5, 2, '[\"旅行团成员\"]', '旅游大巴', NULL, '馆内禁止使用闪光灯拍照，建议穿舒适的鞋子。', 1, '已完成', 1, 15, 320);
INSERT INTO `travel_footprints` VALUES (5, 1, '成都宽窄巷子美食探索', '从麻辣火锅到串串香，从龙抄手到三大炮，成都的美食让人流连忘返。宽窄巷子既有传统小吃，也有创意餐厅。', '宽窄巷子', '四川省成都市青羊区长顺上街127号', '中国', '四川', '成都市', '青羊区', 30.66534100, 104.06320400, 'wm3vru', ST_GeomFromText('POINT(104.063204 30.665341)'), '2023-12-25', '11:00:00', '19:00:00', 480, NULL, '2025-12-29 15:13:04', '2025-12-29 16:37:50', '/profile/upload/2025/12/29/020_20251229163104A407.jpg', '[\"https://example.com/images/chengdu1.jpg\", \"https://example.com/images/chengdu2.jpg\", \"https://example.com/images/chengdu3.jpg\"]', NULL, NULL, '自由行', '[\"美食\", \"川菜\", \"小吃\", \"文化街区\", \"休闲\"]', '冬', '阴天', 5, '满足', 5, 2, '[\"美食爱好者群\"]', NULL, NULL, '不能吃辣的话要提前告知商家，很多店可以调整辣度。', 1, '已完成', 2, 0, 0);
INSERT INTO `travel_footprints` VALUES (6, 1, '东京浅草寺与天空树', '参观了东京最古老的寺庙浅草寺，抽了签，买了御守。然后去了东京天空树，从450米高的观景台俯瞰整个东京。', '浅草寺', '日本东京都台东区浅草2-3-1', '日本', '关东', '东京都', '台东区', 35.71476500, 139.79661300, 'xn76h', ST_GeomFromText('POINT(139.796613 35.714765)'), '2023-05-10', '10:00:00', '17:00:00', 420, 'Asia/Tokyo', '2025-12-29 15:13:04', '2025-12-29 16:37:47', '/profile/upload/2025/12/29/020_20251229163104A407.jpg', '[\"https://example.com/images/tokyo1.jpg\", \"https://example.com/images/tokyo2.jpg\"]', NULL, NULL, '自由行', '[\"日本\", \"寺庙\", \"观景台\", \"国际旅行\"]', '春', '晴天', 4, '愉快', 4, 4, '[\"配偶\"]', '地铁', '东京站附近酒店', '浅草寺人很多，建议早上早点去。天空树需要提前预订门票。', 1, '已完成', 1, 0, 0);
INSERT INTO `travel_footprints` VALUES (8, 1, '广州', '很好玩', '广州', '广州', '中国', '广州', '广州', '广州', NULL, NULL, NULL, NULL, '2025-12-29', '17:04:19', '17:06:19', 1, NULL, '2025-12-29 16:31:10', '2025-12-29 17:12:36', '/profile/upload/2025/12/29/001_20251229170706A432.jpg', '[\"/profile/upload/2025/12/29/009_20251229171000A516.jpg\", \"/profile/upload/2025/12/29/013_20251229171000A907.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229171229A310.mp4\"]', 'null', '跟团游', '[\"不错\"]', '夏', '很好', 5, '开心', 5, 5, '[\"朋友\"]', '地铁', '酒店', '没有', 1, '计划中', 1, 1, 1);
INSERT INTO `travel_footprints` VALUES (9, 1, '广州 Trip', '不错的选择', '广州', '广州', '中国', '广州', '广州', '广州', NULL, NULL, NULL, NULL, '2025-12-29', '17:20:14', NULL, NULL, NULL, '2025-12-29 17:16:53', '2025-12-29 17:31:26', '/profile/upload/2025/12/29/017_20251229171644A340.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173110A694.jpg\", \"/profile/upload/2025/12/29/ns6_20251229173110A151.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229173113A805.mp4\"]', 'null', '自由行', 'null', '未知', NULL, 0, NULL, 0, 0, 'null', '对方', '觉得', '所发生的', 1, '计划中', 1, 0, 0);
INSERT INTO `travel_footprints` VALUES (10, 1, '广州', '汉化', '广州', '广州', '中国', '广州', '广州', '广州', NULL, NULL, NULL, NULL, '2025-12-30', '17:35:06', '17:36:06', 1, NULL, '2025-12-29 17:32:04', '2025-12-29 17:37:09', '/profile/upload/2025/12/29/ns5_20251229173203A403.jpg', '[\"/profile/upload/2025/12/29/ns4_20251229173525A014.jpg\", \"/profile/upload/2025/12/29/ns5_20251229173525A579.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229173528A832.mp4\"]', 'null', '商务出行', '[\"朋友\"]', '冬', '很好', 5, '汉化', 5, 5, '[\"朋友\"]', '地图', '地图', '第三方', 1, '计划中', 1, 1, 1);
INSERT INTO `travel_footprints` VALUES (11, 1, '广州', '保持冷静', '广州', '广州', '中国', '广州', '广州', '广州', NULL, NULL, NULL, NULL, '2025-12-30', '17:38:32', '17:39:32', 2, '1', '2025-12-29 17:37:27', '2025-12-30 11:39:00', '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229173820A610.mp4\"]', 'null', '商务出行', '[\"地方\"]', '秋', '对方的', 5, '对方的', 5, 5, '[\"地方\"]', '地方', '地方', '额人', 1, '计划中', 1, 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
