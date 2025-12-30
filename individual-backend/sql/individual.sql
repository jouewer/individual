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

 Date: 30/12/2025 09:54:57
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
  `food_images` json NULL COMMENT '食物图片',
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
INSERT INTO `food_diaries` VALUES (1, 1, '2024-01-15', '早餐', '08:30:00', '全麦煎蛋三明治+牛奶', '主食', '[\"咸\", \"香\", \"健康\"]', '煎', '家里', NULL, NULL, '独自', NULL, '1份三明治+250ml牛奶', 450.5, '[\"高蛋白\", \"高纤维\", \"低脂\"]', 1, NULL, 4, 5, 4, '清醒', '饱腹有能量', NULL, '[\"/uploads/food/breakfast_20240115_1.jpg\", \"/uploads/food/breakfast_20240115_2.jpg\"]', '1. 鸡蛋打散，加少许盐\r\n2. 平底锅少油，煎蛋\r\n3. 面包烤至微黄\r\n4. 依次放生菜、番茄、煎蛋、芝士\r\n5. 搭配牛奶食用', '[\"全麦面包2片\", \"鸡蛋1个\", \"生菜2片\", \"番茄2片\", \"低脂芝士1片\", \"牛奶250ml\"]', '全麦面包 鸡蛋 生菜 番茄 低脂芝士 牛奶', 8.50, 'CNY', 0, NULL, NULL, NULL, 1, NULL, 1, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-29 15:26:45');
INSERT INTO `food_diaries` VALUES (2, 1, '2024-01-15', '午餐', '12:45:00', '番茄牛腩面+凉拌黄瓜', '主食', '[\"酸\", \"鲜\", \"微辣\"]', '煮', '餐厅', '兰州拉面', '北京市朝阳区建国路88号', '同事', '[\"张三\", \"李四\"]', '大碗面+小份凉菜', 650.0, '[\"高蛋白\", \"适中碳水\"]', 0, NULL, 5, 3, 4, '愉快', '满足但稍咸', '牛腩很嫩，汤底浓郁，就是稍微咸了点', '[\"/uploads/food/lunch_20240115_1.jpg\"]', NULL, '[\"牛腩\", \"番茄\", \"面条\", \"黄瓜\", \"蒜末\", \"醋\", \"辣椒油\"]', '牛腩 番茄 面条 黄瓜 蒜末 醋 辣椒油', 35.00, 'CNY', 1, '[\"张三\", \"李四\"]', NULL, NULL, 1, NULL, 0, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-29 15:26:45');
INSERT INTO `food_diaries` VALUES (3, 1, '2024-01-15', '晚餐', '19:00:00', '红烧排骨+蒜蓉西兰花+米饭', '主食', '[\"甜\", \"咸\", \"鲜\"]', '炖', '家里', NULL, NULL, '家人', '[\"妻子\", \"儿子\"]', '排骨200g+西兰花150g+米饭1碗', 580.0, '[\"高蛋白\", \"适中脂肪\", \"蔬菜纤维\"]', 1, NULL, 5, 3, 5, '温馨', '满足舒适', NULL, '[\"/uploads/food/dinner_20240115_1.jpg\", \"/uploads/food/dinner_20240115_2.jpg\"]', '1. 排骨焯水去血沫\r\n2. 炒糖色，加入排骨翻炒\r\n3. 加生抽、老抽、料酒、水，炖40分钟\r\n4. 西兰花焯水，蒜末爆香后翻炒\r\n5. 搭配米饭食用', '[\"排骨500g\", \"西兰花1颗\", \"蒜5瓣\", \"生姜\", \"冰糖\", \"生抽\", \"老抽\", \"料酒\", \"米饭\"]', '排骨 西兰花 蒜 生姜 冰糖 生抽 老抽 料酒 米饭', 45.00, 'CNY', 0, NULL, NULL, '2024-01-08', 3, NULL, 1, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-29 15:26:45');
INSERT INTO `food_diaries` VALUES (4, 1, '2024-01-15', '下午加餐', '15:30:00', '拿铁咖啡+提拉米苏', '甜品', '[\"甜\", \"苦\", \"香\"]', '烘焙', '外卖', '星巴克', NULL, '独自', NULL, '中杯拿铁+1块蛋糕', 420.0, '[\"高糖\", \"高脂肪\", \"咖啡因\"]', 0, NULL, 4, 2, 4, '放松', '提神但稍腻', '提拉米苏有点甜，下次试试少糖的', '[\"/uploads/food/afternoon_tea_20240115.jpg\"]', NULL, '[\"咖啡\", \"牛奶\", \"可可粉\", \"马斯卡彭奶酪\", \"手指饼干\", \"咖啡酒\"]', '咖啡 牛奶 可可粉 马斯卡彭奶酪 手指饼干 咖啡酒', 68.00, 'CNY', 0, NULL, '每周2-3次', NULL, 1, NULL, 1, 1, '仅自己', '2025-12-29 15:26:45', '2025-12-29 15:26:45');
INSERT INTO `food_diaries` VALUES (5, 1, '2024-01-14', '晚餐', '19:30:00', '麻辣火锅', '主食', '[\"辣\", \"麻\", \"鲜\"]', '煮', '餐厅', '海底捞', '北京市海淀区中关村大街1号', '朋友', '[\"王五\", \"赵六\", \"钱七\"]', '多人分享', 850.0, NULL, 0, NULL, 5, 2, 5, '兴奋', '过瘾但有点撑', NULL, '[\"/uploads/food/hotpot_20240114_1.jpg\", \"/uploads/food/hotpot_20240114_2.jpg\"]', NULL, '[\"牛肉\", \"羊肉\", \"毛肚\", \"虾滑\", \"蔬菜拼盘\", \"豆腐\", \"宽粉\", \"麻辣锅底\"]', '牛肉 羊肉 毛肚 虾滑 蔬菜 豆腐 宽粉 麻辣锅底', 280.00, 'CNY', 1, '[\"王五\", \"赵六\", \"钱七\"]', NULL, '2023-12-20', 5, NULL, 1, 1, '好友可见', '2025-12-29 15:26:45', '2025-12-29 15:26:45');
INSERT INTO `food_diaries` VALUES (6, 1, '2024-01-14', '午餐', '13:00:00', '蒸三文鱼+糙米饭+水煮西兰花', '蛋白质', '[\"清淡\", \"健康\", \"原味\"]', '蒸', '家里', NULL, NULL, '独自', NULL, '三文鱼150g+糙米饭100g+西兰花200g', 520.0, '[\"高蛋白\", \"低脂\", \"优质脂肪\", \"高纤维\"]', 1, NULL, 3, 5, 4, '自律', '健康饱腹', NULL, '[\"/uploads/food/fitness_meal_20240114.jpg\"]', '1. 三文鱼用盐、黑胡椒、柠檬汁腌制\r\n2. 上锅蒸8-10分钟\r\n3. 糙米提前浸泡，煮熟\r\n4. 西兰花焯水\r\n5. 摆盘食用', '[\"三文鱼150g\", \"糙米50g\", \"西兰花200g\", \"柠檬\", \"盐\", \"黑胡椒\"]', '三文鱼 糙米 西兰花 柠檬 盐 黑胡椒', 35.00, 'CNY', 0, NULL, '健身日', NULL, 1, NULL, 1, 1, '仅自己', '2025-12-29 15:26:46', '2025-12-29 15:26:46');
INSERT INTO `food_diaries` VALUES (7, 1, '2024-01-13', '晚餐', '18:30:00', '韭菜猪肉饺子', '主食', '[\"鲜\", \"香\", \"家常\"]', '煮', '家里', NULL, NULL, '家人', '[\"全家\"]', '20个', 550.0, NULL, 1, NULL, 5, 3, 5, '温馨', '满足幸福', NULL, '[\"/uploads/food/dumplings_20240113_1.jpg\", \"/uploads/food/dumplings_20240113_2.jpg\"]', '1. 和面，醒面30分钟\r\n2. 韭菜切碎，猪肉剁馅\r\n3. 调馅：肉馅加姜末、葱花、酱油、盐、香油\r\n4. 加入韭菜拌匀\r\n5. 擀皮包饺子\r\n6. 水开下饺子，煮三开', '[\"面粉\", \"猪肉馅\", \"韭菜\", \"生姜\", \"葱\", \"酱油\", \"盐\", \"香油\"]', '面粉 猪肉馅 韭菜 生姜 葱 酱油 盐 香油', 25.00, 'CNY', 0, NULL, NULL, '2024-01-01', 2, NULL, 1, 1, '好友可见', '2025-12-29 15:26:46', '2025-12-29 15:26:46');
INSERT INTO `food_diaries` VALUES (8, 1, '2024-01-12', '夜宵', '23:15:00', '羊肉串+烤韭菜+烤馒头片', '零食', '[\"辣\", \"咸\", \"香\"]', '烤', '外卖', '老王烧烤', NULL, '独自', NULL, '中份', 520.0, NULL, 0, NULL, 4, 1, 3, '罪恶但快乐', '满足但有点咸渴', '不应该吃夜宵的，但实在忍不住', '[\"/uploads/food/night_snack_20240112.jpg\"]', NULL, '[\"羊肉\", \"韭菜\", \"馒头\", \"孜然\", \"辣椒粉\", \"盐\"]', '羊肉 韭菜 馒头 孜然 辣椒粉 盐', 48.00, 'CNY', 0, NULL, NULL, NULL, 1, NULL, 0, 1, '仅自己', '2025-12-29 15:26:46', '2025-12-29 15:26:46');

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
INSERT INTO `holiday_schedules` VALUES (2, 1, '2024-10-01', '国庆节', '法定节假日', '桂林阳朔三日游', '旅行计划', '08:00:00', '20:00:00', 0, 720, '桂林阳朔', '广西桂林市阳朔县', 24.77850000, 110.49660000, '第一天：抵达桂林，入住酒店，晚上两江四湖夜游\r\n第二天：漓江竹筏漂流，游览阳朔西街\r\n第三天：骑自行车游览十里画廊，参观银子岩，下午返程', '提前一个月：\n- 预订机票和酒店- 查看天气预报- 制定详细行程- 办理请假\n出发前一周：\n- 打包行李- 购买旅游保险- 下载离线地图\n出发前一天：\n- 确认航班信息- 准备证件- 通知家人', '[\"防晒霜\", \"雨伞\", \"晕车药\", \"充电宝\", \"相机\", \"零食\"]', '[\"身份证\", \"信用卡\", \"现金\", \"手机充电器\", \"换洗衣物\", \"洗漱用品\", \"游泳衣\"]', '[\"妻子\", \"儿子\"]', 8000.00, 'CNY', NULL, '/profile/upload/2025/12/29/ns7_20251229193313A841.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229193322A541.jpg\", \"/profile/upload/2025/12/29/ns6_20251229193322A633.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229193326A756.mp4\"]', NULL, NULL, '计划中', '2024-09-25 10:00:00', 0, NULL, 5, NULL, NULL, NULL, '[\"旅行\", \"自然风光\", \"摄影\", \"亲子\"]', '期待', 3, NULL, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:34', '2025-12-29 19:33:28', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (3, 1, '2024-02-14', '情人节', '特殊日', '浪漫烛光晚餐', '美食计划', '19:00:00', '21:30:00', 0, 150, '法式餐厅', '上海市黄浦区南京西路某餐厅', NULL, NULL, '1. 开胃菜：法式鹅肝\r\n2. 汤：奶油蘑菇汤\r\n3. 主菜：惠灵顿牛排\r\n4. 甜点：心形巧克力蛋糕\r\n5. 红酒：法国波尔多', '提前一周预订餐厅\r\n当天：\r\n- 购买玫瑰花\r\n- 准备小礼物（项链）\r\n- 穿戴正式服装', NULL, NULL, '[\"妻子\"]', 1500.00, 'CNY', 1680.00, NULL, '[\"https://example.com/images/valentine1.jpg\", \"https://example.com/images/valentine2.jpg\"]', NULL, NULL, NULL, '已完成', NULL, 0, NULL, 5, '餐厅环境很好，服务周到。惠灵顿牛排做得非常地道，红酒配得恰到好处。妻子很喜欢项链礼物。', NULL, NULL, '[\"浪漫\", \"约会\", \"西餐\", \"庆祝\"]', '浪漫', NULL, 5, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:34', '2025-12-29 17:58:34', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (4, 1, '2024-06-10', '端午节', '传统节日', '家庭包粽子活动', '家庭聚会', '14:00:00', '18:00:00', 0, 240, '妈妈家', NULL, NULL, NULL, '1. 准备粽叶和糯米\r\n2. 准备馅料（红枣、豆沙、咸蛋黄、五花肉）\r\n3. 学习包粽子技巧\r\n4. 煮粽子\r\n5. 品尝成果', '提前一天：\r\n- 浸泡糯米\r\n- 清洗粽叶\r\n- 准备馅料\r\n当天：\r\n- 整理工作台\r\n- 准备锅具', '[\"糯米5斤\", \"粽叶100张\", \"红枣2斤\", \"豆沙1斤\", \"咸蛋黄20个\", \"五花肉2斤\", \"棉线\"]', '[\"大锅\", \"蒸笼\", \"剪刀\", \"绳子\", \"碗盘\"]', '[\"妈妈\", \"姐姐\", \"侄女\"]', 200.00, 'CNY', 180.50, NULL, NULL, NULL, '{\"咸粽子\": [\"五花肉腌制过夜\", \"糯米加酱油拌匀\", \"包入肉和咸蛋黄\", \"煮3小时\"], \"甜粽子\": [\"糯米提前浸泡4小时\", \"粽叶煮软洗净\", \"包入红枣或豆沙\", \"用棉线扎紧\", \"煮2小时\"]}', NULL, '进行中', NULL, 0, NULL, NULL, NULL, NULL, NULL, '[\"传统\", \"手工\", \"美食\", \"亲子\"]', '开心', NULL, NULL, NULL, NULL, '好友可见', '[\"好友1\", \"好友2\", \"家人群\"]', 1, '2025-12-29 17:58:34', '2025-12-29 17:58:34', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (5, 1, '2024-03-15', '生日', '个人纪念日', '30岁生日派对', '朋友聚会', '18:00:00', '23:00:00', 0, 300, 'KTV包厢', '北京市海淀区中关村某KTV', NULL, NULL, '1. 朋友陆续到场\r\n2. 切生日蛋糕\r\n3. 唱生日歌\r\n4. KTV唱歌\r\n5. 玩桌游\r\n6. 拍照留念\r\n7. 夜宵烧烤', '提前一周：\r\n- 预订KTV包厢\r\n- 预订生日蛋糕\r\n- 通知朋友\r\n当天：\r\n- 购买零食饮料\r\n- 布置场地\r\n- 准备游戏道具', NULL, NULL, '[\"张三\", \"李四\", \"王五\", \"赵六\", \"钱七\", \"孙八\", \"周九\", \"吴十\"]', 2000.00, 'CNY', 2350.00, NULL, '[\"https://example.com/images/birthday1.jpg\", \"https://example.com/images/birthday2.jpg\", \"https://example.com/images/birthday3.jpg\"]', '[\"https://example.com/videos/birthday.mp4\"]', NULL, NULL, '已完成', NULL, 0, NULL, 4, '来了很多朋友，玩得很开心。蛋糕很好吃，KTV音响效果不错。就是花费超预算了。', '[\"张三的深情演唱\", \"李四的搞笑舞蹈\", \"切蛋糕时刻\", \"集体大合照\"]', NULL, '[\"生日\", \"朋友\", \"庆祝\", \"KTV\", \"派对\"]', '兴奋', 5, 4, NULL, NULL, '公开', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 17:58:35', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (6, 1, '2024-09-17', '中秋节', '传统节日', '中秋家庭赏月', '家庭聚会', '19:00:00', '22:00:00', 0, NULL, '家里阳台', '上海市浦东新区某小区', 31.23040000, 121.47370000, '1. 准备月饼和茶点\r\n2. 摆放桌椅和灯笼\r\n3. 赏月聊天\r\n4. 分享月饼\r\n5. 讲中秋故事\r\n6. 拍摄月亮照片', '提前购买月饼\r\n当天：\r\n- 打扫阳台\r\n- 准备茶具\r\n- 检查灯笼', '[\"月饼礼盒\", \"茶叶\", \"水果\", \"坚果\", \"灯笼\", \"蜡烛\"]', NULL, '[\"父母\", \"配偶\", \"孩子\"]', 500.00, 'CNY', NULL, NULL, NULL, NULL, NULL, NULL, '计划中', '2024-09-16 18:00:00', 0, NULL, NULL, NULL, NULL, NULL, '[\"家庭\", \"传统\", \"赏月\", \"月饼\"]', '温馨', NULL, NULL, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 17:58:35', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (7, 1, '2023-12-24', '圣诞节', '特殊日', '家庭圣诞装饰', '文化活动', '14:00:00', '17:30:00', 0, 210, '家里', NULL, NULL, NULL, '1. 组装圣诞树\r\n2. 挂装饰品和彩灯\r\n3. 摆放圣诞老人和麋鹿\r\n4. 挂圣诞袜\r\n5. 布置餐桌\r\n6. 制作圣诞贺卡', '提前购买装饰品\r\n当天：\r\n- 清理客厅空间\r\n- 准备工具\r\n- 播放圣诞音乐', '[\"圣诞树\", \"彩灯\", \"装饰球\", \"圣诞老人玩偶\", \"雪花贴纸\", \"贺卡材料\", \"圣诞袜\"]', '[\"梯子\", \"胶带\", \"剪刀\", \"电线\", \"电池\"]', '[\"妻子\", \"儿子\", \"女儿\"]', 800.00, 'CNY', 750.00, NULL, '[\"https://example.com/images/christmas1.jpg\", \"https://example.com/images/christmas2.jpg\"]', NULL, NULL, NULL, '已完成', NULL, 1, '每年12月24日', 5, '孩子们非常开心，装饰过程充满乐趣。圣诞树效果很好，整个家都充满了节日气氛。', NULL, NULL, '[\"节日\", \"装饰\", \"亲子\", \"手工\"]', '快乐', 3, 5, NULL, NULL, '好友可见', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 17:58:35', NULL, NULL, NULL);
INSERT INTO `holiday_schedules` VALUES (8, 1, '2024-01-01', '元旦', '法定节假日', '新年第一天健身', '健身运动', '09:00:00', '11:00:00', 0, 120, '健身房', '北京市朝阳区某健身中心', 31.23040000, 121.47370000, '1. 热身运动10分钟\r\n2. 跑步机30分钟\r\n3. 力量训练（胸、背、腿）\r\n4. 拉伸放松10分钟\r\n5. 记录训练数据', '准备健身装备\r\n前一天保证充足睡眠\r\n控制饮食', '[\"圣诞树\", \"彩灯\", \"装饰球\", \"圣诞老人玩偶\", \"雪花贴纸\", \"贺卡材料\", \"圣诞袜\"]', '[\"运动服\", \"运动鞋\", \"毛巾\", \"水壶\", \"手套\"]', '[\"妻子\", \"儿子\", \"女儿\"]', 800.00, 'CNY', 750.00, 'https://example.com/images/guilin_cover.jpg', '[\"https://example.com/images/christmas1.jpg\", \"https://example.com/images/christmas2.jpg\"]', '[\"https://example.com/videos/birthday.mp4\"]', '{\"咸粽子\": [\"五花肉腌制过夜\", \"糯米加酱油拌匀\", \"包入肉和咸蛋黄\", \"煮3小时\"], \"甜粽子\": [\"糯米提前浸泡4小时\", \"粽叶煮软洗净\", \"包入红枣或豆沙\", \"用棉线扎紧\", \"煮2小时\"]}', NULL, '进行中', '2024-09-16 18:00:00', 0, NULL, NULL, NULL, NULL, NULL, '[\"健康\", \"健身\", \"新年\", \"自律\"]', '充满活力', 4, NULL, NULL, NULL, '仅自己', NULL, 1, '2025-12-29 17:58:35', '2025-12-29 18:36:29', NULL, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-29 18:04:01');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '', '未知', 'Edge 143', 'Windows 10', '0', '登录成功', '2025-12-30 09:05:37');

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
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '超级管理员', '00', 'niangao@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-12-30 09:05:37', '2025-12-29 10:57:10', 'admin', '2025-12-29 10:57:10', '', NULL, '管理员');
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
INSERT INTO `travel_footprints` VALUES (11, 1, '广州', '保持冷静', '广州', '广州', '中国', '广州', '广州', '广州', NULL, NULL, NULL, NULL, '2025-12-30', '17:38:32', '17:39:32', 1, '1', '2025-12-29 17:37:27', '2025-12-29 18:09:07', '/profile/upload/2025/12/29/ns6_20251229180904A299.jpg', '[\"/profile/upload/2025/12/29/ns5_20251229173817A526.jpg\", \"/profile/upload/2025/12/29/ns4_20251229173817A032.jpg\"]', '[\"/profile/upload/2025/12/29/wei_20251229173820A610.mp4\"]', 'null', '商务出行', '[\"地方\"]', '秋', '对方的', 5, '对方的', 5, 5, '[\"地方\"]', '地方', '地方', '额人', 1, '计划中', 1, 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
