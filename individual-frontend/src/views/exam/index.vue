<template>
  <div class="app-container tech-container">
    <el-card class="box-card mb8">
      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="记录类型" prop="recordType">
          <el-select v-model="queryParams.recordType" placeholder="请选择记录类型" clearable style="width: 200px" @change="handleQuery">
            <el-option label="全部分类" :value="undefined" />
            <el-option label="考试" value="考试" />
            <el-option label="题目" value="题目" />
            <el-option label="解析规则" value="解析规则" />
            <el-option label="考试记录" value="考试记录" />
            <el-option label="答题详情" value="答题详情" />
          </el-select>
        </el-form-item>
        <el-form-item label="考试名称" prop="examName">
          <el-input
            v-model="queryParams.examName"
            placeholder="请输入考试名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="考试科目" prop="examSubject">
          <el-input
            v-model="queryParams.examSubject"
            placeholder="请输入考试科目"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
          <el-button icon="Refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="box-card">
      <template #header>
        <div class="card-header">
          <span class="header-title">
            当前分类：
            <el-tag effect="dark" :type="getRecordTypeTagType(queryParams.recordType)">
              {{ queryParams.recordType || '全部分类' }}
            </el-tag>
          </span>
          <div class="header-actions">
            <el-button
              type="primary"
              plain
              icon="Plus"
              @click="handleAdd"
            >新增</el-button>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
          </div>
        </div>
      </template>

      <el-table v-loading="loading" :data="examList" @selection-change="handleSelectionChange" border stripe>
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="编号" align="center" prop="id" width="80" />
        <el-table-column label="记录类型" align="center" prop="recordType" width="100">
           <template #default="scope">
              <el-tag :type="getRecordTypeTagType(scope.row.recordType)" effect="light">
                {{ scope.row.recordType }}
              </el-tag>
           </template>
        </el-table-column>
        <el-table-column label="考试名称" align="center" prop="examName" :show-overflow-tooltip="true" min-width="120" />
        <el-table-column label="考试科目" align="center" prop="examSubject" :show-overflow-tooltip="true" min-width="100" />
        
        <el-table-column label="题目内容" align="center" prop="questionContent" :show-overflow-tooltip="true" min-width="150" />
        <el-table-column label="考生答案" align="center" prop="userAnswer" :show-overflow-tooltip="true" min-width="120" />
        <el-table-column label="评分备注" align="center" prop="scoringNotes" :show-overflow-tooltip="true" min-width="120" />
        <el-table-column label="正确答案" align="center" prop="correctAnswer" :show-overflow-tooltip="true" min-width="120" />
        <el-table-column label="答案解析" align="center" prop="explanation" :show-overflow-tooltip="true" min-width="120" />

        <el-table-column label="等级" align="center" prop="examLevel" width="80" />
        <el-table-column label="总分" align="center" prop="totalScore" width="80" />
        <el-table-column label="得分" align="center" prop="pointsObtained" width="80" />
        <el-table-column label="状态" align="center" prop="examStatus" width="100">
           <template #default="scope">
              <el-tag :type="scope.row.examStatus === '已发布' ? 'success' : (scope.row.examStatus === '草稿' ? 'info' : 'warning')">
                {{ scope.row.examStatus }}
              </el-tag>
           </template>
        </el-table-column>
        <el-table-column label="有效性" align="center" prop="isActive" width="80">
           <template #default="scope">
              <el-switch
                v-model="scope.row.isActive"
                disabled
                active-color="#13ce66"
                inactive-color="#ff4949"
              />
           </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="160">
          <template #default="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="150" fixed="right">
          <template #default="scope">
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total>0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </el-card>

    <!-- 添加或修改考试对话框 -->
    <el-dialog :title="title" v-model="open" width="900px" append-to-body custom-class="tech-dialog">
      <el-form ref="examRef" :model="form" :rules="rules" label-width="100px" class="tech-form">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="基本信息" name="basic">
            <el-row :gutter="20">
              <el-col :span="24">
                <el-form-item label="记录类型" prop="recordType">
                   <el-select v-model="form.recordType" placeholder="请选择记录类型" style="width: 100%">
                      <el-option label="考试" value="考试" />
                      <el-option label="题目" value="题目" />
                      <el-option label="解析规则" value="解析规则" />
                      <el-option label="考试记录" value="考试记录" />
                      <el-option label="答题详情" value="答题详情" />
                   </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            
            <!-- 考试 - 基本信息 -->
            <template v-if="form.recordType === '考试'">
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="考试名称" prop="examName">
                    <el-input v-model="form.examName" placeholder="请输入考试名称" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="考试科目" prop="examSubject">
                    <el-input v-model="form.examSubject" placeholder="请输入考试科目" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="考试等级" prop="examLevel">
                     <el-select v-model="form.examLevel" placeholder="请选择等级" style="width: 100%">
                        <el-option label="初级" value="初级" />
                        <el-option label="中级" value="中级" />
                        <el-option label="高级" value="高级" />
                     </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="考试状态" prop="examStatus">
                     <el-select v-model="form.examStatus" placeholder="请选择状态" style="width: 100%">
                        <el-option label="草稿" value="草稿" />
                        <el-option label="已发布" value="已发布" />
                        <el-option label="进行中" value="进行中" />
                        <el-option label="已结束" value="已结束" />
                        <el-option label="已归档" value="已归档" />
                     </el-select>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="24">
                  <el-form-item label="说明" prop="instructions">
                    <el-input type="textarea" v-model="form.instructions" placeholder="考试说明" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>

            <!-- 题目 - 基本信息 -->
            <template v-if="form.recordType === '题目'">
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="题号" prop="questionNumber">
                    <el-input-number v-model="form.questionNumber" :min="1" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="题型" prop="questionType">
                    <el-select v-model="form.questionType" placeholder="请选择题型" style="width: 100%">
                      <el-option label="单选题" value="单选题" />
                      <el-option label="多选题" value="多选题" />
                      <el-option label="判断题" value="判断题" />
                      <el-option label="填空题" value="填空题" />
                      <el-option label="简答题" value="简答题" />
                    </el-select>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="24">
                  <el-form-item label="题目内容" prop="questionContent">
                    <el-input type="textarea" :rows="3" v-model="form.questionContent" placeholder="请输入题目内容" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>

            <!-- 解析规则 - 基本信息 -->
            <template v-if="form.recordType === '解析规则'">
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="规则名称" prop="ruleName">
                    <el-input v-model="form.ruleName" placeholder="请输入规则名称" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="规则类型" prop="ruleType">
                    <el-select v-model="form.ruleType" placeholder="请选择规则类型" style="width: 100%">
                      <el-option label="题目检测" value="题目检测" />
                      <el-option label="选项检测" value="选项检测" />
                      <el-option label="答案检测" value="答案检测" />
                    </el-select>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="24">
                  <el-form-item label="检测模式" prop="detectionPattern">
                    <el-input v-model="form.detectionPattern" placeholder="请输入检测模式" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>

            <!-- 考试记录 - 基本信息 -->
            <template v-if="form.recordType === '考试记录'">
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="考生ID" prop="examineeUserId">
                    <el-input-number v-model="form.examineeUserId" :min="1" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="考试状态" prop="examRecordStatus">
                     <el-select v-model="form.examRecordStatus" placeholder="请选择状态" style="width: 100%">
                        <el-option label="未开始" value="未开始" />
                        <el-option label="进行中" value="进行中" />
                        <el-option label="已提交" value="已提交" />
                        <el-option label="已评分" value="已评分" />
                        <el-option label="已审核" value="已审核" />
                     </el-select>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="开始时间" prop="examStartTime">
                    <el-date-picker v-model="form.examStartTime" type="datetime" placeholder="选择开始时间" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="结束时间" prop="examEndTime">
                    <el-date-picker v-model="form.examEndTime" type="datetime" placeholder="选择结束时间" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>

            <!-- 答题详情 - 基本信息 -->
            <template v-if="form.recordType === '答题详情'">
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="题目ID" prop="questionId">
                    <el-input-number v-model="form.questionId" :min="1" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="答题时间" prop="answerTime">
                    <el-date-picker v-model="form.answerTime" type="datetime" placeholder="选择答题时间" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="24">
                  <el-form-item label="考生答案" prop="userAnswer">
                     <el-input type="textarea" :rows="2" v-model="form.userAnswer" placeholder="请输入考生答案" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>
            
            <el-row :gutter="20">
              <el-col :span="24">
                <el-form-item label="有效性" prop="isActive">
                   <el-switch v-model="form.isActive" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="详细设置" name="details">
             <!-- 考试 - 详细设置 -->
            <template v-if="form.recordType === '考试'">
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="总分" prop="totalScore">
                    <el-input-number v-model="form.totalScore" :precision="1" :step="1" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="及格分" prop="passScore">
                    <el-input-number v-model="form.passScore" :precision="1" :step="1" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="时长(分)" prop="timeLimit">
                    <el-input-number v-model="form.timeLimit" :min="1" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                   <el-form-item label="题目数" prop="questionCount">
                    <el-input-number v-model="form.questionCount" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-divider content-position="left">防作弊设置</el-divider>
              <el-row :gutter="20">
                <el-col :span="6">
                  <el-form-item label="允许重考" prop="allowRetake">
                    <el-switch v-model="form.allowRetake" />
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item label="随机题目" prop="shuffleQuestions">
                    <el-switch v-model="form.shuffleQuestions" />
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item label="随机选项" prop="shuffleOptions">
                    <el-switch v-model="form.shuffleOptions" />
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                   <el-form-item label="最大重考" prop="maxRetakes">
                    <el-input-number v-model="form.maxRetakes" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>

            <!-- 题目 - 详细设置 -->
            <template v-if="form.recordType === '题目'">
              <el-row :gutter="20">
                <el-col :span="12">
                   <el-form-item label="分值" prop="points">
                    <el-input-number v-model="form.points" :precision="1" :step="1" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                   <el-form-item label="难度" prop="difficultyLevel">
                     <el-select v-model="form.difficultyLevel" placeholder="请选择难度" style="width: 100%">
                      <el-option label="简单" value="简单" />
                      <el-option label="中等" value="中等" />
                      <el-option label="困难" value="困难" />
                    </el-select>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="知识点" prop="knowledgePoint">
                    <el-input v-model="form.knowledgePoint" placeholder="知识点" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="章节" prop="chapter">
                    <el-input v-model="form.chapter" placeholder="章节" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>
            
            <!-- 考试记录 - 详细设置 -->
            <template v-if="form.recordType === '考试记录'">
               <el-row :gutter="20">
                <el-col :span="12">
                   <el-form-item label="得分" prop="obtainedScore">
                    <el-input-number v-model="form.obtainedScore" :precision="1" :step="1" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                   <el-form-item label="得分率%" prop="scorePercentage">
                    <el-input-number v-model="form.scorePercentage" :precision="2" :step="1" :min="0" :max="100" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="是否通过" prop="isPassed">
                     <el-switch v-model="form.isPassed" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="是否作弊" prop="isCheating">
                     <el-switch v-model="form.isCheating" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-form-item label="作弊原因" prop="cheatingReason" v-if="form.isCheating">
                <el-input type="textarea" v-model="form.cheatingReason" />
              </el-form-item>
            </template>

            <!-- 答题详情 - 详细设置 -->
            <template v-if="form.recordType === '答题详情'">
               <el-row :gutter="20">
                <el-col :span="12">
                   <el-form-item label="得分" prop="pointsObtained">
                    <el-input-number v-model="form.pointsObtained" :precision="1" :step="1" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                   <el-form-item label="满分" prop="maxPoints">
                    <el-input-number v-model="form.maxPoints" :precision="1" :step="1" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="是否正确" prop="isCorrect">
                     <el-switch v-model="form.isCorrect" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="用时(秒)" prop="timeSpentOnQuestion">
                    <el-input-number v-model="form.timeSpentOnQuestion" :min="0" style="width: 100%" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="20">
                <el-col :span="24">
                   <el-form-item label="评分备注" prop="scoringNotes">
                     <el-input type="textarea" v-model="form.scoringNotes" placeholder="请输入评分备注" />
                  </el-form-item>
                </el-col>
              </el-row>
            </template>
          </el-tab-pane>

          <el-tab-pane label="内容与答案" name="content">
             <!-- 题目 - 内容与答案 -->
            <template v-if="form.recordType === '题目'">
              <el-form-item label="正确答案" prop="correctAnswer">
                <el-input type="textarea" :rows="3" v-model="form.correctAnswer" placeholder="请输入正确答案" />
              </el-form-item>
              <el-form-item label="答案解析" prop="explanation">
                <el-input type="textarea" :rows="3" v-model="form.explanation" placeholder="请输入答案解析" />
              </el-form-item>
              <el-form-item label="答题提示" prop="answerHints">
                <el-input type="textarea" :rows="2" v-model="form.answerHints" />
              </el-form-item>
            </template>
            
            <!-- 解析规则 - 内容与答案 -->
            <template v-if="form.recordType === '解析规则'">
              <el-form-item label="示例文本" prop="exampleText">
                <el-input type="textarea" :rows="3" v-model="form.exampleText" />
              </el-form-item>
              <el-form-item label="解析结果" prop="parsingResult">
                <el-input type="textarea" :rows="3" v-model="form.parsingResult" />
              </el-form-item>
            </template>

            <!-- 答题详情 - 内容与答案 -->
            <template v-if="form.recordType === '答题详情'">
              <el-form-item label="考生答案" prop="userAnswer">
                <el-input type="textarea" :rows="4" v-model="form.userAnswer" placeholder="请输入考生答案" />
              </el-form-item>
              <el-form-item label="评分备注" prop="scoringNotes">
                <el-input type="textarea" :rows="2" v-model="form.scoringNotes" placeholder="请输入评分备注" />
              </el-form-item>
            </template>
          </el-tab-pane>
          
          <el-tab-pane label="统计与系统" name="stats">
             <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="系统编号">
                    <el-input v-model="form.id" disabled />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="创建时间">
                    <el-input v-model="form.createTime" disabled />
                  </el-form-item>
                </el-col>
             </el-row>
             <!-- 考试统计 -->
             <template v-if="form.recordType === '考试'">
                <el-row :gutter="20">
                  <el-col :span="8"><el-form-item label="平均分"><el-input v-model="form.averageScore" disabled /></el-form-item></el-col>
                  <el-col :span="8"><el-form-item label="最高分"><el-input v-model="form.highestScore" disabled /></el-form-item></el-col>
                  <el-col :span="8"><el-form-item label="最低分"><el-input v-model="form.lowestScore" disabled /></el-form-item></el-col>
                </el-row>
                <el-row :gutter="20">
                  <el-col :span="8"><el-form-item label="及格率"><el-input v-model="form.passRate" disabled /></el-form-item></el-col>
                  <el-col :span="8"><el-form-item label="参与人数"><el-input v-model="form.participationCount" disabled /></el-form-item></el-col>
                </el-row>
             </template>

             <!-- 考试记录统计 -->
             <template v-if="form.recordType === '考试记录'">
                <el-row :gutter="20">
                  <el-col :span="12"><el-form-item label="获得分数"><el-input v-model="form.obtainedScore" disabled /></el-form-item></el-col>
                  <el-col :span="12"><el-form-item label="得分率%"><el-input v-model="form.scorePercentage" disabled /></el-form-item></el-col>
                </el-row>
                <el-row :gutter="20">
                  <el-col :span="8"><el-form-item label="正确数"><el-input v-model="form.correctCount" disabled /></el-form-item></el-col>
                  <el-col :span="8"><el-form-item label="错误数"><el-input v-model="form.wrongCount" disabled /></el-form-item></el-col>
                  <el-col :span="8"><el-form-item label="未答数"><el-input v-model="form.unansweredCount" disabled /></el-form-item></el-col>
                </el-row>
             </template>

             <!-- 答题详情统计 -->
             <template v-if="form.recordType === '答题详情'">
                <el-row :gutter="20">
                  <el-col :span="12"><el-form-item label="获得分值"><el-input v-model="form.pointsObtained" disabled /></el-form-item></el-col>
                  <el-col :span="12"><el-form-item label="题目满分"><el-input v-model="form.maxPoints" disabled /></el-form-item></el-col>
                </el-row>
                <el-row :gutter="20">
                  <el-col :span="12"><el-form-item label="是否正确"><el-tag :type="form.isCorrect ? 'success' : 'danger'">{{ form.isCorrect ? '正确' : '错误' }}</el-tag></el-form-item></el-col>
                  <el-col :span="12"><el-form-item label="是否已阅"><el-tag :type="form.isReviewed ? 'success' : 'info'">{{ form.isReviewed ? '已阅' : '未阅' }}</el-tag></el-form-item></el-col>
                </el-row>
             </template>
          </el-tab-pane>
        </el-tabs>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm" class="tech-btn-primary">确 定</el-button>
          <el-button @click="cancel" class="tech-btn-default">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Exam">
import { listExam, getExam, delExam, addExam, updateExam } from "@/api/exam/exam";
import { parseTime } from "@/utils/ruoyi";

const { proxy } = getCurrentInstance();

const examList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
const activeTab = ref("basic");

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    examName: undefined,
    examSubject: undefined,
    isActive: undefined,
    recordType: undefined
  },
  rules: {
    examName: [
      { required: false, message: "考试名称不能为空", trigger: "blur" }
    ],
    examSubject: [
      { required: false, message: "考试科目不能为空", trigger: "blur" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询考试列表 */
function getList() {
  loading.value = true;
  listExam(queryParams.value).then(response => {
    examList.value = response.rows;
    total.value = response.total;
    loading.value = false;
  }).catch(() => {
    loading.value = false;
  });
}

/** 取消按钮 */
function cancel() {
  open.value = false;
  reset();
}

/** 表单重置 */
function reset() {
  form.value = {
    id: undefined,
    recordType: '考试',
    examName: undefined,
    examSubject: undefined,
    examLevel: '初级',
    totalScore: 100.0,
    passScore: 60.0,
    timeLimit: 60,
    questionCount: 0,
    isActive: true,
    examStatus: '草稿'
  };
  proxy.resetForm("examRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1;
  getList();
}

/** 获取记录类型标签颜色 */
function getRecordTypeTagType(type) {
  switch (type) {
    case '考试': return '';
    case '题目': return 'success';
    case '解析规则': return 'warning';
    case '考试记录': return 'danger';
    case '答题详情': return 'info';
    default: return 'primary';
  }
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef");
  handleQuery();
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.id);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加考试";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const examId = row.id || ids.value;
  getExam(examId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改考试";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["examRef"].validate(valid => {
    if (valid) {
      proxy.$modal.confirm('确认提交吗？').then(function() {
        if (form.value.id != undefined) {
          updateExam(form.value).then(response => {
            proxy.$modal.msgSuccess("修改成功");
            open.value = false;
            getList();
          });
        } else {
          addExam(form.value).then(response => {
            proxy.$modal.msgSuccess("新增成功");
            open.value = false;
            getList();
          });
        }
      }).catch(() => {});
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const examIds = row.id || ids.value;
  proxy.$modal.confirm('是否确认删除考试编号为"' + examIds + '"的数据项？').then(function() {
    return delExam(examIds);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

getList();
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
  background-color: #f0f2f5;
  min-height: 100vh;
}

.box-card {
  margin-bottom: 20px;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  
  :deep(.el-card__header) {
    padding: 15px 20px;
    border-bottom: 1px solid #ebeef5;
  }
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.expand-content {
  padding: 20px;
  background-color: #f8fafd;
  border-radius: 4px;
}

/* Override Element Plus default styles for cleaner look */
:deep(.el-table) {
  border-radius: 4px;
  overflow: hidden;
  
  th.el-table__cell {
    background-color: #f5f7fa !important;
    color: #606266;
    font-weight: 600;
    height: 50px;
  }
}

:deep(.el-descriptions__title) {
  font-size: 14px;
  font-weight: 600;
  color: #303133;
}

:deep(.el-tag) {
  border-radius: 4px;
}

:deep(.el-button--primary.is-plain) {
  --el-button-bg-color: #ecf5ff;
  --el-button-border-color: #b3d8ff;
  --el-button-hover-bg-color: #409eff;
  --el-button-hover-border-color: #409eff;
  --el-button-hover-text-color: #ffffff;
}
</style>
