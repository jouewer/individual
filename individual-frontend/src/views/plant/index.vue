<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="植物名称" prop="plantName">
        <el-input
          v-model="queryParams.plantName"
          placeholder="请输入植物名称"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="生长阶段" prop="growthStage">
        <el-select v-model="queryParams.growthStage" placeholder="请选择生长阶段" clearable style="width: 240px">
          <el-option label="发芽期" value="发芽期" />
          <el-option label="幼苗期" value="幼苗期" />
          <el-option label="生长期" value="生长期" />
          <el-option label="开花期" value="开花期" />
          <el-option label="结果期" value="结果期" />
          <el-option label="成熟期" value="成熟期" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="Plus"
          @click="handleAdd"
        >新增植物</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <div v-loading="loading" class="plant-card-container">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="6" v-for="item in plantList" :key="item.id" class="mb-20">
          <el-card :body-style="{ padding: '0px' }" shadow="hover" class="plant-card">
            <div class="image-wrapper">
              <el-image 
                :key="item.coverImage"
                :src="getCoverImage(item.coverImage)" 
                fit="cover" 
                class="plant-image"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>
              <div class="plant-status-tag">
                <el-tag :type="getStatusType(item.healthStatus)" effect="dark" size="small">{{ item.healthStatus || '未知' }}</el-tag>
              </div>
            </div>
            
            <div class="card-content">
              <div class="plant-header">
                <span class="plant-name" :title="item.plantName">{{ item.plantName }}</span>
                <span class="plant-stage">{{ item.growthStage || '未设置' }}</span>
              </div>
              
              <div class="plant-info-grid">
                <div class="info-item">
                  <span class="label">高度</span>
                  <span class="value">{{ item.heightCm ? item.heightCm + 'cm' : '-' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">叶片</span>
                  <span class="value">{{ item.leafCount || '-' }}</span>
                </div>
                <div class="info-item">
                  <span class="label">下次养护</span>
                  <span class="value date">{{ parseTime(item.nextCareDate, '{y}-{m}-{d}') || '-' }}</span>
                </div>
              </div>

              <div class="plant-desc" v-if="item.plantLocation">
                <el-icon><Location /></el-icon> {{ item.plantLocation }}
              </div>
            </div>

            <div class="card-footer">
              <el-button link type="primary" icon="Edit" @click="handleUpdate(item)">编辑</el-button>
              <el-button link type="danger" icon="Delete" @click="handleDelete(item)">删除</el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>
      
      <el-empty v-if="plantList.length === 0 && !loading" description="暂无植物数据"></el-empty>
    </div>
    
    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.page_num"
      v-model:limit="queryParams.page_size"
      @pagination="getList"
    />

    <!-- 添加或修改植物对话框 -->
    <el-dialog :title="title" v-model="open" width="900px" append-to-body>
      <el-form ref="plantRef" :model="form" :rules="rules" label-width="110px">
        <el-tabs type="border-card">
          <!-- 1. 基础信息 -->
          <el-tab-pane label="基础信息">
            <el-row>
              <el-col :span="24">
                <el-form-item label="封面图片" prop="coverImage">
                  <ImageUpload v-model="form.coverImage" :limit="1" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="植物名称" prop="plantName">
                  <el-input v-model="form.plantName" placeholder="请输入植物名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="植物类型" prop="plantType">
                   <el-select v-model="form.plantType" placeholder="请选择类型" style="width: 100%">
                    <el-option label="观叶植物" value="观叶植物" />
                    <el-option label="多肉植物" value="多肉植物" />
                    <el-option label="开花植物" value="开花植物" />
                    <el-option label="蔬菜" value="蔬菜" />
                    <el-option label="水果" value="水果" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="品种" prop="variety">
                  <el-input v-model="form.variety" placeholder="请输入品种" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="是否存活" prop="isActive">
                  <el-switch v-model="form.isActive" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 2. 种植详情 -->
          <el-tab-pane label="种植详情">
            <el-row>
              <el-col :span="12">
                <el-form-item label="种植日期" prop="plantDate">
                  <el-date-picker
                    v-model="form.plantDate"
                    type="date"
                    placeholder="选择日期"
                    value-format="YYYY-MM-DD"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="种植地点" prop="plantLocation">
                  <el-input v-model="form.plantLocation" placeholder="如：阳台、客厅" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="种植方式" prop="plantingMethod">
                  <el-input v-model="form.plantingMethod" placeholder="如：土培、水培" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="土壤类型" prop="soilType">
                  <el-input v-model="form.soilType" placeholder="请输入土壤类型" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="花盆尺寸" prop="potSize">
                  <el-input v-model="form.potSize" placeholder="请输入花盆尺寸" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 3. 生长状态 -->
          <el-tab-pane label="生长状态">
            <el-row>
              <el-col :span="12">
                <el-form-item label="生长阶段" prop="growthStage">
                  <el-select v-model="form.growthStage" placeholder="请选择阶段" style="width: 100%">
                    <el-option label="发芽期" value="发芽期" />
                    <el-option label="幼苗期" value="幼苗期" />
                    <el-option label="生长期" value="生长期" />
                    <el-option label="开花期" value="开花期" />
                    <el-option label="结果期" value="结果期" />
                    <el-option label="成熟期" value="成熟期" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="健康状态" prop="healthStatus">
                  <el-select v-model="form.healthStatus" placeholder="请选择状态" style="width: 100%">
                    <el-option label="健康" value="健康" />
                    <el-option label="良好" value="良好" />
                    <el-option label="一般" value="一般" />
                    <el-option label="生病" value="生病" />
                    <el-option label="濒死" value="濒死" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="高度(cm)" prop="heightCm">
                  <el-input-number v-model="form.heightCm" :min="0" :precision="2" :step="0.5" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="叶片数量" prop="leafCount">
                  <el-input-number v-model="form.leafCount" :min="0" :step="1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="花朵数量" prop="flowerCount">
                  <el-input-number v-model="form.flowerCount" :min="0" :step="1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="果实数量" prop="fruitCount">
                  <el-input-number v-model="form.fruitCount" :min="0" :step="1" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 4. 养护环境 -->
          <el-tab-pane label="养护环境">
            <el-row>
              <el-col :span="12">
                <el-form-item label="适宜温度" prop="idealTemperature">
                  <el-input v-model="form.idealTemperature" placeholder="如：20-25℃" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="适宜湿度" prop="idealHumidity">
                  <el-input v-model="form.idealHumidity" placeholder="如：50-60%" />
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="光照要求" prop="lightRequirements">
                  <el-input v-model="form.lightRequirements" placeholder="请输入光照要求" />
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="浇水需求" prop="wateringNeeds">
                  <el-input v-model="form.wateringNeeds" placeholder="请输入浇水需求" />
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="施肥需求" prop="fertilizingNeeds">
                  <el-input v-model="form.fertilizingNeeds" placeholder="请输入施肥需求" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 5. 养护指南 -->
          <el-tab-pane label="养护指南">
            <el-form-item label="养护说明" prop="careInstructions">
              <el-input v-model="form.careInstructions" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="浇水教程" prop="wateringGuide">
              <el-input v-model="form.wateringGuide" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="施肥教程" prop="fertilizingGuide">
              <el-input v-model="form.fertilizingGuide" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="修剪教程" prop="pruningGuide">
              <el-input v-model="form.pruningGuide" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="换盆教程" prop="repottingGuide">
              <el-input v-model="form.repottingGuide" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="繁殖方法" prop="propagationMethods">
              <el-input v-model="form.propagationMethods" type="textarea" :rows="3" />
            </el-form-item>
          </el-tab-pane>

          <!-- 6. 问题记录 -->
          <el-tab-pane label="问题记录">
            <el-form-item label="常见问题" prop="commonProblems">
              <el-input v-model="form.commonProblems" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="病虫害防治" prop="pestSolutions">
              <el-input v-model="form.pestSolutions" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="故障排除" prop="troubleshooting">
              <el-input v-model="form.troubleshooting" type="textarea" :rows="3" />
            </el-form-item>
          </el-tab-pane>

          <!-- 7. 生长记录 -->
          <el-tab-pane label="生长记录">
            <el-form-item label="生长记录" prop="growthNotes">
              <el-input v-model="form.growthNotes" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="观察记录" prop="observations">
              <el-input v-model="form.observations" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="遇到的问题" prop="challenges">
              <el-input v-model="form.challenges" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="解决方案" prop="solutions">
              <el-input v-model="form.solutions" type="textarea" :rows="3" />
            </el-form-item>
            <el-form-item label="成功秘诀" prop="successTips">
              <el-input v-model="form.successTips" type="textarea" :rows="3" />
            </el-form-item>
          </el-tab-pane>

          <!-- 8. 重要日期 -->
          <el-tab-pane label="重要日期">
            <el-row>
              <el-col :span="12">
                <el-form-item label="发芽日期" prop="germinationDate">
                  <el-date-picker v-model="form.germinationDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="开花日期" prop="floweringDate">
                  <el-date-picker v-model="form.floweringDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="结果日期" prop="fruitingDate">
                  <el-date-picker v-model="form.fruitingDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="收获日期" prop="harvestDate">
                  <el-date-picker v-model="form.harvestDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="上次浇水" prop="lastWatering">
                  <el-date-picker v-model="form.lastWatering" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="上次施肥" prop="lastFertilizing">
                  <el-date-picker v-model="form.lastFertilizing" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="上次修剪" prop="lastPruning">
                  <el-date-picker v-model="form.lastPruning" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="下次养护" prop="nextCareDate">
                  <el-date-picker v-model="form.nextCareDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 9. 成本与收获 -->
          <el-tab-pane label="成本与收获">
            <el-row>
              <el-col :span="12">
                <el-form-item label="购买价格" prop="purchasePrice">
                  <el-input-number v-model="form.purchasePrice" :min="0" :precision="2" :step="1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="总成本" prop="totalCost">
                  <el-input-number v-model="form.totalCost" :min="0" :precision="2" :step="1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="收获量" prop="harvestAmount">
                  <el-input-number v-model="form.harvestAmount" :min="0" :precision="2" :step="0.1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="收获单位" prop="harvestUnit">
                  <el-input v-model="form.harvestUnit" placeholder="如：kg、个" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 10. 提醒设置 -->
          <el-tab-pane label="提醒设置">
            <el-row>
              <el-col :span="8">
                <el-form-item label="浇水提醒" prop="wateringReminder">
                  <el-switch v-model="form.wateringReminder" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="施肥提醒" prop="fertilizingReminder">
                  <el-switch v-model="form.fertilizingReminder" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="生长记录提醒" prop="growthReminder">
                  <el-switch v-model="form.growthReminder" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 11. 媒体资料 -->
          <el-tab-pane label="媒体资料">
            <el-divider content-position="left">生长图片</el-divider>
            <div class="media-list" v-if="form.growthImages && form.growthImages.length">
               <el-image 
                 v-for="(img, index) in form.growthImages" 
                 :key="index" 
                 :src="img" 
                 :preview-src-list="form.growthImages"
                 fit="cover"
                 class="media-item"
               />
            </div>
            <el-empty v-else description="暂无生长图片" :image-size="60"></el-empty>

            <el-divider content-position="left">教程图片</el-divider>
             <div class="media-list" v-if="form.tutorialImages && form.tutorialImages.length">
               <el-image 
                 v-for="(img, index) in form.tutorialImages" 
                 :key="index" 
                 :src="img" 
                 :preview-src-list="form.tutorialImages"
                 fit="cover"
                 class="media-item"
               />
            </div>
            <el-empty v-else description="暂无教程图片" :image-size="60"></el-empty>

            <el-divider content-position="left">养护视频</el-divider>
            <div class="video-list" v-if="form.careVideos && form.careVideos.length">
               <div v-for="(video, index) in form.careVideos" :key="index" class="video-item">
                  <video controls width="100%" height="200">
                    <source :src="video" type="video/mp4">
                    您的浏览器不支持视频播放。
                  </video>
               </div>
            </div>
             <el-empty v-else description="暂无养护视频" :image-size="60"></el-empty>
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

<script setup name="Plant">
import { listPlant, getPlant, delPlant, addPlant, updatePlant } from "@/api/plant";
import { getCurrentInstance, reactive, ref, toRefs } from "vue";
import { parseTime } from "@/utils/ruoyi";
import { Picture, Location } from '@element-plus/icons-vue'

const { proxy } = getCurrentInstance();

const plantList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
// 默认图片占位符
const defaultImage = "https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png";
const baseUrl = import.meta.env.VITE_APP_BASE_API || '/dev-api';

/** 获取封面图片地址 */
function getCoverImage(url) {
  if (!url) return defaultImage;
  if (url.startsWith('http') || url.startsWith('https')) return url;
  if (url.startsWith('/profile')) return baseUrl + url;
  // Handle legacy /images path or other relative paths by prepending baseUrl
  return baseUrl + url;
}

const data = reactive({
  form: {},
  queryParams: {
    page_num: 1,
    page_size: 12, // 卡片布局每页显示更多一点
    plantName: undefined,
    growthStage: undefined
  },
  rules: {
    plantName: [
      { required: true, message: "植物名称不能为空", trigger: "blur" }
    ],
    growthStage: [
      { required: true, message: "生长阶段不能为空", trigger: "change" }
    ],
    healthStatus: [
      { required: true, message: "健康状态不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询植物列表 */
function getList() {
  loading.value = true;
  // Add timestamp to prevent caching
  const params = { ...queryParams.value, _t: new Date().getTime() };
  listPlant(params).then(response => {
    plantList.value = response.rows;
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
    plantName: undefined,
    plantType: undefined,
    variety: undefined,
    plantDate: undefined,
    plantLocation: undefined,
    plantingMethod: undefined,
    soilType: undefined,
    potSize: undefined,
    growthStage: undefined,
    healthStatus: '健康',
    heightCm: undefined,
    leafCount: undefined,
    flowerCount: undefined,
    fruitCount: undefined,
    idealTemperature: undefined,
    idealHumidity: undefined,
    lightRequirements: undefined,
    wateringNeeds: undefined,
    fertilizingNeeds: undefined,
    careInstructions: undefined,
    wateringGuide: undefined,
    fertilizingGuide: undefined,
    pruningGuide: undefined,
    repottingGuide: undefined,
    propagationMethods: undefined,
    commonProblems: undefined,
    pestSolutions: undefined,
    troubleshooting: undefined,
    growthNotes: undefined,
    observations: undefined,
    challenges: undefined,
    solutions: undefined,
    successTips: undefined,
    germinationDate: undefined,
    floweringDate: undefined,
    fruitingDate: undefined,
    harvestDate: undefined,
    lastWatering: undefined,
    lastFertilizing: undefined,
    lastPruning: undefined,
    nextCareDate: undefined,
    coverImage: undefined,
    purchasePrice: undefined,
    totalCost: undefined,
    harvestAmount: undefined,
    harvestUnit: undefined,
    isActive: 1,
    wateringReminder: 1,
    fertilizingReminder: 0,
    growthReminder: 0,
    growthImages: [],
    tutorialImages: [],
    careVideos: []
  };
  proxy.resetForm("plantRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.page_num = 1;
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  proxy.resetForm("queryRef");
  handleQuery();
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加植物";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const id = row.id;
  getPlant(id).then(response => {
    form.value = response.data;
    // 确保图片和视频字段为数组
    const ensureArray = (key) => {
      if (typeof form.value[key] === 'string') {
        try {
          form.value[key] = JSON.parse(form.value[key]);
        } catch (e) {
          form.value[key] = [];
        }
      } else if (!form.value[key]) {
        form.value[key] = [];
      }
    };
    ensureArray('growthImages');
    ensureArray('tutorialImages');
    ensureArray('careVideos');
    
    open.value = true;
    title.value = "修改植物";
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const ids = row.id;
  proxy.$modal.confirm('是否确认删除植物名称为"' + row.plantName + '"的数据项？').then(function() {
    return delPlant(ids);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["plantRef"].validate(valid => {
    if (valid) {
      if (form.value.id != undefined) {
        updatePlant(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addPlant(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功");
          open.value = false;
          getList();
        });
      }
    }
  });
}

/** 获取状态对应的Tag类型 */
function getStatusType(status) {
  switch(status) {
    case '健康': return 'success';
    case '良好': return 'primary';
    case '一般': return 'warning';
    case '生病': return 'danger';
    case '濒死': return 'info';
    default: return 'info';
  }
}

getList();
</script>

<style scoped>
.mb-20 {
  margin-bottom: 20px;
}
.plant-card {
  transition: all 0.3s;
  height: 100%;
  display: flex;
  flex-direction: column;
}
.plant-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.1);
}
.image-wrapper {
  position: relative;
  height: 180px;
  overflow: hidden;
}
.plant-image {
  width: 100%;
  height: 100%;
  display: block;
}
.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}
.plant-status-tag {
  position: absolute;
  top: 10px;
  right: 10px;
}
.card-content {
  padding: 15px;
  flex: 1;
}
.plant-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}
.plant-name {
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.plant-stage {
  font-size: 12px;
  color: #606266;
  background-color: #f4f4f5;
  padding: 2px 6px;
  border-radius: 4px;
}
.plant-info-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  margin-bottom: 15px;
}
.info-item {
  text-align: center;
  display: flex;
  flex-direction: column;
}
.info-item .label {
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
}
.info-item .value {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}
.info-item .value.date {
  font-size: 12px;
}
.plant-desc {
  font-size: 13px;
  color: #606266;
  margin-top: 10px;
  display: flex;
  align-items: center;
  gap: 4px;
}
.card-footer {
  border-top: 1px solid #EBEEF5;
  padding: 10px 15px;
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
.media-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.media-item {
  width: 100px;
  height: 100px;
  border-radius: 4px;
  border: 1px solid #eee;
}
.video-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 15px;
}
.video-item {
  border: 1px solid #eee;
  border-radius: 4px;
  overflow: hidden;
}
</style>
