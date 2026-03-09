<template>
  <div class="app-container tech-container">
    <el-card class="box-card mb8">
      <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
        <el-form-item label="任务状态" prop="taskStatus">
          <el-select v-model="queryParams.taskStatus" placeholder="请选择任务状态" clearable style="width: 200px" @change="handleQuery">
            <el-option label="待开始" value="待开始" />
            <el-option label="进行中" value="进行中" />
            <el-option label="已完成" value="已完成" />
            <el-option label="已延期" value="已延期" />
            <el-option label="已放弃" value="已放弃" />
          </el-select>
        </el-form-item>
        <el-form-item label="任务名称" prop="taskName">
          <el-input
            v-model="queryParams.taskName"
            placeholder="请输入任务名称"
            clearable
            style="width: 200px"
            @keyup.enter="handleQuery"
          />
        </el-form-item>
        <el-form-item label="学习领域" prop="learningArea">
          <el-input
            v-model="queryParams.learningArea"
            placeholder="请输入学习领域"
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
            当前任务列表
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

      <el-table v-loading="loading" :data="taskList" @selection-change="handleSelectionChange" border stripe>
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="编号" align="center" prop="id" width="80" />
        <el-table-column label="任务名称" align="center" prop="taskName" :show-overflow-tooltip="true" min-width="150" />
        <el-table-column label="学习领域" align="center" prop="learningArea" :show-overflow-tooltip="true" min-width="120" />
        <el-table-column label="学习类型" align="center" prop="learningType" width="100" />
        
        <el-table-column label="当前章节" align="center" prop="currentChapter" :show-overflow-tooltip="true" min-width="150" />
        <el-table-column label="下一步计划" align="center" prop="nextStep" :show-overflow-tooltip="true" min-width="150" />
        <el-table-column label="每日目标" align="center" prop="dailyGoal" :show-overflow-tooltip="true" min-width="150" />
        
        <el-table-column label="进度" align="center" prop="progressPercent" width="100">
          <template #default="scope">
            <el-progress :percentage="scope.row.progressPercent || 0" />
          </template>
        </el-table-column>
        
        <el-table-column label="优先级" align="center" prop="priorityLevel" width="80">
           <template #default="scope">
              <el-tag :type="getPriorityTagType(scope.row.priorityLevel)">
                {{ scope.row.priorityLevel }}
              </el-tag>
           </template>
        </el-table-column>
        
        <el-table-column label="状态" align="center" prop="taskStatus" width="100">
           <template #default="scope">
              <el-tag :type="getStatusTagType(scope.row.taskStatus)">
                {{ scope.row.taskStatus }}
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

    <!-- 添加或修改学习任务对话框 -->
    <el-dialog :title="title" v-model="open" width="900px" append-to-body destroy-on-close>
      <el-form ref="taskRef" :model="form" :rules="rules" label-width="100px" class="tech-form">
        <el-tabs v-model="activeTab" type="card">
          <!-- 基本信息 -->
          <el-tab-pane label="基本信息" name="basic">
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="任务名称" prop="taskName">
                  <el-input v-model="form.taskName" placeholder="请输入任务名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="学习领域" prop="learningArea">
                  <el-input v-model="form.learningArea" placeholder="请输入学习领域" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="学习类型" prop="learningType">
                  <el-select v-model="form.learningType" placeholder="请选择学习类型">
                    <el-option label="自学" value="自学" />
                    <el-option label="课程" value="课程" />
                    <el-option label="项目" value="项目" />
                    <el-option label="阅读" value="阅读" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="任务状态" prop="taskStatus">
                  <el-select v-model="form.taskStatus" placeholder="请选择任务状态">
                    <el-option label="待开始" value="待开始" />
                    <el-option label="进行中" value="进行中" />
                    <el-option label="已完成" value="已完成" />
                    <el-option label="已延期" value="已延期" />
                    <el-option label="已放弃" value="已放弃" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="优先级" prop="priorityLevel">
                  <el-select v-model="form.priorityLevel" placeholder="请选择优先级">
                    <el-option label="高" value="高" />
                    <el-option label="中" value="中" />
                    <el-option label="低" value="低" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="难度等级" prop="difficultyLevel">
                   <el-select v-model="form.difficultyLevel" placeholder="请选择难度等级">
                    <el-option label="简单" value="简单" />
                    <el-option label="中等" value="中等" />
                    <el-option label="困难" value="困难" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
             <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="是否有效" prop="isActive">
                  <el-switch v-model="form.isActive" active-text="有效" inactive-text="无效" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 详细设置 -->
          <el-tab-pane label="详细设置" name="detail">
             <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="计划开始" prop="plannedStartDate">
                  <el-date-picker v-model="form.plannedStartDate" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="计划结束" prop="plannedEndDate">
                  <el-date-picker v-model="form.plannedEndDate" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="实际开始" prop="actualStartDate">
                  <el-date-picker v-model="form.actualStartDate" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="实际结束" prop="actualEndDate">
                  <el-date-picker v-model="form.actualEndDate" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
               <el-col :span="12">
                <el-form-item label="预计耗时" prop="estimatedHours">
                  <el-input-number v-model="form.estimatedHours" :precision="1" :step="0.5" /> 小时
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="实际耗时" prop="actualHours">
                  <el-input-number v-model="form.actualHours" :precision="1" :step="0.5" /> 小时
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="学习链接" prop="learningUrl">
              <el-input v-model="form.learningUrl" placeholder="请输入学习链接" />
            </el-form-item>
          </el-tab-pane>

          <!-- 内容与进度 -->
          <el-tab-pane label="内容与进度" name="content">
            <el-form-item label="学习内容" prop="learningContent">
              <el-input type="textarea" :rows="3" v-model="form.learningContent" placeholder="请输入学习内容" />
            </el-form-item>
            <el-form-item label="当前章节" prop="currentChapter">
              <el-input v-model="form.currentChapter" placeholder="请输入当前章节" />
            </el-form-item>
            <el-form-item label="下一步计划" prop="nextStep">
              <el-input type="textarea" :rows="2" v-model="form.nextStep" placeholder="请输入下一步计划" />
            </el-form-item>
             <el-form-item label="每日目标" prop="dailyGoal">
              <el-input type="textarea" :rows="2" v-model="form.dailyGoal" placeholder="请输入每日目标" />
            </el-form-item>
            <el-form-item label="进度百分比" prop="progressPercent">
              <el-slider v-model="form.progressPercent" show-input />
            </el-form-item>
          </el-tab-pane>

          <!-- 统计与反馈 -->
          <el-tab-pane label="统计与反馈" name="stats">
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
             <el-row :gutter="20">
                <el-col :span="8">
                   <el-form-item label="已用天数">
                     <el-input v-model="form.daysSpent" disabled />
                   </el-form-item>
                </el-col>
                <el-col :span="8">
                   <el-form-item label="剩余天数">
                     <el-input v-model="form.daysRemaining" disabled />
                   </el-form-item>
                </el-col>
                <el-col :span="8">
                   <el-form-item label="连续打卡">
                     <el-input v-model="form.streakDays" disabled />
                   </el-form-item>
                </el-col>
             </el-row>
             <el-form-item label="关键点" prop="keyPoints">
                <el-input type="textarea" :rows="2" v-model="form.keyPoints" />
             </el-form-item>
             <el-form-item label="遇到的困难" prop="difficultiesEncountered">
                <el-input type="textarea" :rows="2" v-model="form.difficultiesEncountered" />
             </el-form-item>
             <el-form-item label="解决方案" prop="solutions">
                <el-input type="textarea" :rows="2" v-model="form.solutions" />
             </el-form-item>
             <el-form-item label="自我评价" prop="selfAssessment">
                <el-input type="textarea" :rows="2" v-model="form.selfAssessment" />
             </el-form-item>
          </el-tab-pane>
        </el-tabs>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Task">
import { listTask, getTask, delTask, addTask, updateTask } from "@/api/study/task";
import { reactive, ref, toRefs } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";

const { proxy } = getCurrentInstance();

const taskList = ref([]);
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
    taskName: undefined,
    learningArea: undefined,
    taskStatus: undefined
  },
  rules: {
    taskName: [
      { required: true, message: "任务名称不能为空", trigger: "blur" }
    ],
    learningArea: [
      { required: true, message: "学习领域不能为空", trigger: "blur" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询学习任务列表 */
function getList() {
  loading.value = true;
  listTask(queryParams.value).then(response => {
    taskList.value = response.rows;
    total.value = response.total;
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
    taskName: undefined,
    learningArea: undefined,
    learningType: undefined,
    learningContent: undefined,
    learningUrl: undefined,
    plannedStartDate: undefined,
    plannedEndDate: undefined,
    actualStartDate: undefined,
    actualEndDate: undefined,
    estimatedHours: undefined,
    actualHours: undefined,
    progressPercent: 0,
    currentChapter: undefined,
    nextStep: undefined,
    difficultyLevel: undefined,
    priorityLevel: undefined,
    dailyGoal: undefined,
    taskStatus: "待开始",
    isActive: true,
    keyPoints: undefined,
    difficultiesEncountered: undefined,
    solutions: undefined,
    selfAssessment: undefined,
    daysSpent: 0,
    daysRemaining: 0,
    streakDays: 0
  };
  activeTab.value = "basic";
  proxy.resetForm("taskRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1;
  getList();
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
  title.value = "添加学习任务";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const taskId = row.id || ids.value;
  getTask(taskId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改学习任务";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["taskRef"].validate(valid => {
    if (valid) {
      if (form.value.id != undefined) {
        updateTask(form.value).then(() => {
          ElMessage.success("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addTask(form.value).then(() => {
          ElMessage.success("新增成功");
          open.value = false;
          getList();
        });
      }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const taskIds = row.id || ids.value;
  ElMessageBox.confirm('是否确认删除学习任务编号为"' + taskIds + '"的数据项？', "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning"
    }).then(() => {
      return delTask(taskIds);
    }).then(() => {
      getList();
      ElMessage.success("删除成功");
    }).catch(() => {});
}

function getPriorityTagType(level) {
  const map = {
    '高': 'danger',
    '中': 'warning',
    '低': 'success'
  };
  return map[level] || 'info';
}

function getStatusTagType(status) {
  const map = {
    '待开始': 'info',
    '进行中': 'primary',
    '已完成': 'success',
    '已延期': 'warning',
    '已放弃': 'danger'
  };
  return map[status] || '';
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

:deep(.el-dialog) {
  background: #ffffff;
  border-radius: 8px;
  
  .el-dialog__header {
    border-bottom: 1px solid #ebeef5;
    margin-right: 0;
  }
  
  .el-dialog__body {
    padding: 20px;
  }
  
  .el-dialog__footer {
    border-top: 1px solid #ebeef5;
    padding-top: 20px;
  }
}
</style>
