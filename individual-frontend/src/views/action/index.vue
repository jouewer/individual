<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="检测类型" prop="detectionType">
        <el-select v-model="queryParams.detectionType" placeholder="请选择检测类型" clearable>
          <el-option label="表情检测" value="表情检测" />
          <el-option label="动作检测" value="动作检测" />
          <el-option label="人物检测" value="人物检测" />
          <el-option label="综合检测" value="综合检测" />
        </el-select>
      </el-form-item>
      <el-form-item label="安全等级" prop="safetyLevel">
        <el-select v-model="queryParams.safetyLevel" placeholder="请选择安全等级" clearable>
          <el-option label="安全" value="安全" />
          <el-option label="注意" value="注意" />
          <el-option label="警告" value="警告" />
          <el-option label="危险" value="危险" />
          <el-option label="紧急" value="紧急" />
        </el-select>
      </el-form-item>
       <el-form-item label="事件类型" prop="eventType">
        <el-input v-model="queryParams.eventType" placeholder="请输入事件类型" clearable @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="detectionList">
      <el-table-column label="ID" align="center" prop="id" width="60" />
      <el-table-column label="媒体" align="center" width="100">
        <template #default="scope">
            <el-image 
                v-if="scope.row.mediaType === '图片'" 
                style="width: 50px; height: 50px" 
                :src="scope.row.mediaPath" 
                :preview-src-list="[scope.row.mediaPath]"
                fit="cover"
            />
            <el-icon v-else size="30"><VideoPlay /></el-icon>
        </template>
      </el-table-column>
      <el-table-column label="检测时间" align="center" prop="detectionTime" width="160">
        <template #default="scope">
          <span>{{ parseTime(scope.row.detectionTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="检测类型" align="center" prop="detectionType" />
      <el-table-column label="检测结果" align="center">
          <template #default="scope">
              <span v-if="scope.row.detectionType === '表情检测'">{{ scope.row.emotionType }}</span>
              <span v-else-if="scope.row.detectionType === '动作检测'">{{ scope.row.actionType }}</span>
              <span v-else-if="scope.row.detectionType === '人物检测'">{{ scope.row.personType }}</span>
              <span v-else>{{ scope.row.eventType }}</span>
          </template>
      </el-table-column>
      <el-table-column label="置信度" align="center">
           <template #default="scope">
              <span v-if="scope.row.detectionType === '表情检测'">{{ scope.row.emotionConfidence }}</span>
              <span v-else-if="scope.row.detectionType === '动作检测'">{{ scope.row.actionConfidence }}</span>
              <span v-else-if="scope.row.detectionType === '人物检测'">{{ scope.row.personConfidence }}</span>
          </template>
      </el-table-column>
      <el-table-column label="地点" align="center" prop="locationName" />
      <el-table-column label="安全等级" align="center" prop="safetyLevel">
        <template #default="scope">
          <el-tag :type="getSafetyTagType(scope.row.safetyLevel)">{{ scope.row.safetyLevel }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handleView(scope.row)">详情</el-button>
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

    <!-- 详情对话框 -->
    <el-dialog :title="title" v-model="open" width="900px" append-to-body>
        <el-tabs type="border-card">
            <el-tab-pane label="基本信息">
                <el-descriptions bordered :column="2">
                    <el-descriptions-item label="ID">{{ form.id }}</el-descriptions-item>
                    <el-descriptions-item label="用户ID">{{ form.userId }}</el-descriptions-item>
                    <el-descriptions-item label="检测时间">{{ parseTime(form.detectionTime) }}</el-descriptions-item>
                    <el-descriptions-item label="媒体类型">{{ form.mediaType }}</el-descriptions-item>
                    <el-descriptions-item label="检测类型">{{ form.detectionType }}</el-descriptions-item>
                    <el-descriptions-item label="安全等级">
                        <el-tag :type="getSafetyTagType(form.safetyLevel)">{{ form.safetyLevel }}</el-tag>
                    </el-descriptions-item>
                    <el-descriptions-item label="地点">{{ form.locationName }}</el-descriptions-item>
                    <el-descriptions-item label="环境">{{ form.environment }}</el-descriptions-item>
                    <el-descriptions-item label="场景描述" :span="2">{{ form.sceneContext }}</el-descriptions-item>
                    <el-descriptions-item label="媒体预览" :span="2">
                         <el-image 
                            v-if="form.mediaType === '图片'" 
                            style="max-width: 100%; max-height: 400px;" 
                            :src="form.mediaPath" 
                            :preview-src-list="[form.mediaPath]"
                            fit="contain"
                        />
                        <video v-else-if="form.mediaType === '视频'" controls style="max-width: 100%; max-height: 400px;">
                            <source :src="form.mediaPath" type="video/mp4">
                        </video>
                    </el-descriptions-item>
                </el-descriptions>
            </el-tab-pane>
            
            <el-tab-pane label="表情检测" v-if="form.detectionType === '表情检测' || form.detectionType === '综合检测'">
                <el-descriptions bordered :column="2">
                    <el-descriptions-item label="表情类型">{{ form.emotionType }}</el-descriptions-item>
                    <el-descriptions-item label="表情置信度">{{ form.emotionConfidence }}</el-descriptions-item>
                    <el-descriptions-item label="表情边界框" :span="2">
                        <pre>{{ form.emotionBbox }}</pre>
                    </el-descriptions-item>
                </el-descriptions>
            </el-tab-pane>
            
            <el-tab-pane label="动作检测" v-if="form.detectionType === '动作检测' || form.detectionType === '综合检测'">
                <el-descriptions bordered :column="2">
                    <el-descriptions-item label="动作类型">{{ form.actionType }}</el-descriptions-item>
                    <el-descriptions-item label="动作置信度">{{ form.actionConfidence }}</el-descriptions-item>
                    <el-descriptions-item label="动作边界框" :span="2">
                         <pre>{{ form.actionBbox }}</pre>
                    </el-descriptions-item>
                    <el-descriptions-item label="摔倒方向" v-if="form.actionType === '摔倒' || form.actionType === '跌倒'">{{ form.fallDirection }}</el-descriptions-item>
                    <el-descriptions-item label="摔倒严重程度" v-if="form.actionType === '摔倒' || form.actionType === '跌倒'">{{ form.fallSeverity }}</el-descriptions-item>
                    <el-descriptions-item label="恢复时间(秒)" v-if="form.actionType === '摔倒' || form.actionType === '跌倒'">{{ form.recoveryTimeSeconds }}</el-descriptions-item>
                    <el-descriptions-item label="是否正在起身" v-if="form.actionType === '摔倒' || form.actionType === '跌倒'">{{ form.isGettingUp ? '是' : '否' }}</el-descriptions-item>
                </el-descriptions>
            </el-tab-pane>

            <el-tab-pane label="人物检测" v-if="form.detectionType === '人物检测' || form.detectionType === '综合检测'">
                <el-descriptions bordered :column="2">
                    <el-descriptions-item label="人员类型">{{ form.personType }}</el-descriptions-item>
                    <el-descriptions-item label="人员姓名">{{ form.personName }}</el-descriptions-item>
                    <el-descriptions-item label="人员标识符">{{ form.personIdentifier }}</el-descriptions-item>
                    <el-descriptions-item label="人物置信度">{{ form.personConfidence }}</el-descriptions-item>
                    <el-descriptions-item label="估计年龄">{{ form.estimatedAge }}</el-descriptions-item>
                    <el-descriptions-item label="估计性别">{{ form.estimatedGender }}</el-descriptions-item>
                    <el-descriptions-item label="服装主色">{{ form.clothingColor }}</el-descriptions-item>
                    <el-descriptions-item label="是否本人">{{ form.isSelf ? '是' : '否' }}</el-descriptions-item>
                    <el-descriptions-item label="配饰" :span="2">
                        <pre>{{ form.accessories }}</pre>
                    </el-descriptions-item>
                </el-descriptions>
            </el-tab-pane>
            
             <el-tab-pane label="关系与安全">
                <el-descriptions bordered :column="2">
                    <el-descriptions-item label="关系程度">{{ form.relationshipLevel }}</el-descriptions-item>
                    <el-descriptions-item label="是否可信人员">{{ form.isTrusted ? '是' : '否' }}</el-descriptions-item>
                    <el-descriptions-item label="是否黑名单">{{ form.isBlacklist ? '是' : '否' }}</el-descriptions-item>
                    <el-descriptions-item label="异常分数">{{ form.anomalyScore }}</el-descriptions-item>
                    <el-descriptions-item label="事件类型">{{ form.eventType }}</el-descriptions-item>
                    <el-descriptions-item label="事件描述" :span="2">{{ form.eventDescription }}</el-descriptions-item>
                    <el-descriptions-item label="需要人工关注">{{ form.requiresAttention ? '是' : '否' }}</el-descriptions-item>
                    <el-descriptions-item label="是否已验证">{{ form.isVerified ? '是' : '否' }}</el-descriptions-item>
                    <el-descriptions-item label="验证备注" :span="2">{{ form.verificationNotes }}</el-descriptions-item>
                </el-descriptions>
            </el-tab-pane>

             <el-tab-pane label="检测统计与元数据">
                <el-descriptions bordered :column="2">
                    <el-descriptions-item label="检测次数">{{ form.detectionCount }}</el-descriptions-item>
                    <el-descriptions-item label="首次检测时间">{{ parseTime(form.firstDetectedTime) }}</el-descriptions-item>
                    <el-descriptions-item label="最后检测时间">{{ parseTime(form.lastDetectedTime) }}</el-descriptions-item>
                    <el-descriptions-item label="检测模型">{{ form.detectorModel }}</el-descriptions-item>
                    <el-descriptions-item label="检测器版本">{{ form.detectorVersion }}</el-descriptions-item>
                    <el-descriptions-item label="创建时间">{{ parseTime(form.createTime) }}</el-descriptions-item>
                    <el-descriptions-item label="更新时间">{{ parseTime(form.updateTime) }}</el-descriptions-item>
                     <el-descriptions-item label="原始数据 (JSON)" :span="2">
                        <pre style="white-space: pre-wrap; word-wrap: break-word;">{{ form.rawData }}</pre>
                    </el-descriptions-item>
                </el-descriptions>
            </el-tab-pane>
        </el-tabs>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="open = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Detection">
import { listDetection, getDetection } from "@/api/detection";
import { parseTime } from "@/utils/ruoyi";

const { proxy } = getCurrentInstance();

const detectionList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const total = ref(0);
const title = ref("");

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    detectionType: undefined,
    safetyLevel: undefined,
    eventType: undefined
  }
});

const { queryParams, form } = toRefs(data);

/** 查询列表 */
function getList() {
  loading.value = true;
  listDetection(queryParams.value).then(response => {
    detectionList.value = response.rows;
    total.value = response.total;
    loading.value = false;
  });
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

/** 详情按钮操作 */
function handleView(row) {
  loading.value = true;
  getDetection(row.id).then(response => {
      form.value = response.data;
      open.value = true;
      title.value = "检测详情";
      loading.value = false;
  });
}

function getSafetyTagType(level) {
    switch (level) {
        case '安全': return 'success';
        case '注意': return 'info';
        case '警告': return 'warning';
        case '危险': return 'danger';
        case '紧急': return 'danger';
        default: return '';
    }
}

getList();
</script>
