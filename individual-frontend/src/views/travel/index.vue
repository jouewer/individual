<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="城市" prop="city">
        <el-input
          v-model="queryParams.city"
          placeholder="请输入城市"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="国家" prop="country">
        <el-input
          v-model="queryParams.country"
          placeholder="请输入国家"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
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
        >新增</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <div class="travel-grid">
      <el-empty v-if="travelList.length === 0" description="暂无足迹" />
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="item in travelList" :key="item.id">
          <el-card class="travel-card" :body-style="{ padding: '0px' }" @click="handleDetail(item)">
            <div class="image-container">
              <el-image
                v-if="item.coverImage"
                :src="item.coverImage.startsWith('http') || item.coverImage.startsWith('https') ? item.coverImage : baseUrl + item.coverImage"
                fit="cover"
                class="travel-image"
              />
              <div v-else class="image-placeholder">
                <el-icon><Picture /></el-icon>
              </div>
              <div class="card-actions">
                <el-button type="danger" circle icon="Delete" @click.stop="handleDelete(item)" />
              </div>
            </div>
            <div class="card-content">
              <div class="location">
                <span class="city">{{ item.city }}</span>
                <span class="country" v-if="item.country">, {{ item.country }}</span>
              </div>
              <div class="date" v-if="item.visitDate">
                <el-icon><Calendar /></el-icon>
                <span>{{ parseTime(item.visitDate, '{y}-{m}-{d}') }}</span>
              </div>
              <div class="description" v-if="item.description">
                {{ item.description }}
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.page_num"
      v-model:limit="queryParams.page_size"
      :page-sizes="[8, 12, 16, 20]"
      @pagination="getList"
    />

    <!-- Add/Edit Dialog -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="travelRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="城市" prop="city">
          <el-input v-model="form.city" placeholder="请输入城市" />
        </el-form-item>
        <el-form-item label="国家" prop="country">
          <el-input v-model="form.country" placeholder="请输入国家" />
        </el-form-item>
        <el-form-item label="访问日期" prop="visit_date">
          <el-date-picker
            v-model="form.visit_date"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="封面图片" prop="cover_image">
          <image-upload v-model="form.cover_image" :limit="1" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea" placeholder="请输入描述" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- Detail Dialog -->
    <el-dialog title="足迹详情" v-model="detailOpen" width="800px" append-to-body>
      <el-descriptions :column="2" border v-if="!isEdit">
        <el-descriptions-item label="标题" :span="2">{{ detailData.title }}</el-descriptions-item>
        <el-descriptions-item label="城市">{{ detailData.city }}</el-descriptions-item>
        <el-descriptions-item label="国家">{{ detailData.country }}</el-descriptions-item>
        <el-descriptions-item label="省份">{{ detailData.province }}</el-descriptions-item>
        <el-descriptions-item label="区县">{{ detailData.district }}</el-descriptions-item>
        <el-descriptions-item label="地点名称" :span="2">{{ detailData.locationName }}</el-descriptions-item>
        <el-descriptions-item label="详细地址" :span="2">{{ detailData.address }}</el-descriptions-item>
        <el-descriptions-item label="访问日期">{{ parseTime(detailData.visitDate, '{y}-{m}-{d}') }}</el-descriptions-item>
        <el-descriptions-item label="开始时间">{{ detailData.startTime }}</el-descriptions-item>
        <el-descriptions-item label="结束时间">{{ detailData.endTime }}</el-descriptions-item>
        <el-descriptions-item label="停留时长(分)">{{ detailData.duration }}</el-descriptions-item>
        <el-descriptions-item label="时区">{{ detailData.timezone }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(detailData.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ parseTime(detailData.updateTime) }}</el-descriptions-item>
        <el-descriptions-item label="经度">{{ detailData.longitude }}</el-descriptions-item>
        <el-descriptions-item label="纬度">{{ detailData.latitude }}</el-descriptions-item>
        <el-descriptions-item label="Geohash">{{ detailData.geohash }}</el-descriptions-item>
        <el-descriptions-item label="旅行类型">{{ detailData.travelType }}</el-descriptions-item>
        <el-descriptions-item label="季节">{{ detailData.season }}</el-descriptions-item>
        <el-descriptions-item label="天气">{{ detailData.weather }}</el-descriptions-item>
        <el-descriptions-item label="评分">{{ detailData.rating }} / 5</el-descriptions-item>
        <el-descriptions-item label="心情">{{ detailData.mood }}</el-descriptions-item>
        <el-descriptions-item label="推荐程度">{{ detailData.recommendLevel }} / 5</el-descriptions-item>
        <el-descriptions-item label="消费水平">{{ detailData.costLevel }} / 5</el-descriptions-item>
        <el-descriptions-item label="同行人员" :span="2">
          <el-tag v-for="(tag, index) in detailData.companions" :key="index" class="mr-5">{{ tag }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="标签" :span="2">
          <el-tag v-for="(tag, index) in detailData.tags" :key="index" type="success" class="mr-5">{{ tag }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="交通工具" :span="2">{{ detailData.transportation }}</el-descriptions-item>
        <el-descriptions-item label="住宿信息" :span="2">{{ detailData.accommodation }}</el-descriptions-item>
        <el-descriptions-item label="状态">{{ detailData.status }}</el-descriptions-item>
        <el-descriptions-item label="公开">{{ detailData.isPublic === 1 ? '是' : '否' }}</el-descriptions-item>
        <el-descriptions-item label="收藏数">{{ detailData.favoriteCount }}</el-descriptions-item>
        <el-descriptions-item label="浏览数">{{ detailData.viewCount }}</el-descriptions-item>
        <el-descriptions-item label="描述" :span="2">{{ detailData.description }}</el-descriptions-item>
        <el-descriptions-item label="注意事项" :span="2">{{ detailData.notes }}</el-descriptions-item>
        <el-descriptions-item label="封面图片" :span="2">
          <el-image
            v-if="detailData.coverImage"
            :src="detailData.coverImage.startsWith('http') || detailData.coverImage.startsWith('https') ? detailData.coverImage : baseUrl + detailData.coverImage"
            style="width: 100%; max-height: 400px;"
            fit="contain"
          />
        </el-descriptions-item>
        <el-descriptions-item label="相册" :span="2">
          <div class="image-list">
            <el-image
              v-for="(img, index) in detailData.images"
              :key="index"
              :src="img.startsWith('http') || img.startsWith('https') ? img : baseUrl + img"
              style="width: 100px; height: 100px; margin-right: 10px; margin-bottom: 10px;"
              fit="cover"
              :preview-src-list="detailData.images.map(i => i.startsWith('http') || i.startsWith('https') ? i : baseUrl + i)"
            />
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="视频" :span="2">
          <div v-for="(video, index) in detailData.videos" :key="index" class="video-item">
            <video :src="video.startsWith('http') || video.startsWith('https') ? video : baseUrl + video" controls style="max-width: 100%; max-height: 400px;"></video>
          </div>
        </el-descriptions-item>
      </el-descriptions>

      <!-- Edit Form -->
      <el-form v-else ref="editFormRef" :model="editForm" label-width="100px">
        <el-tabs type="border-card">
          <el-tab-pane label="基本信息">
            <el-row :gutter="20">
              <el-col :span="12"><el-form-item label="标题"><el-input v-model="editForm.title" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="城市"><el-input v-model="editForm.city" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="国家"><el-input v-model="editForm.country" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="省份"><el-input v-model="editForm.province" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="区县"><el-input v-model="editForm.district" /></el-form-item></el-col>
              <el-col :span="24"><el-form-item label="地点名称"><el-input v-model="editForm.locationName" /></el-form-item></el-col>
              <el-col :span="24"><el-form-item label="详细地址"><el-input v-model="editForm.address" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="访问日期"><el-date-picker v-model="editForm.visitDate" type="date" value-format="YYYY-MM-DD" style="width: 100%" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="开始时间"><el-time-picker v-model="editForm.startTime" value-format="HH:mm:ss" style="width: 100%" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="结束时间"><el-time-picker v-model="editForm.endTime" value-format="HH:mm:ss" style="width: 100%" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="停留时长(分)"><el-input-number v-model="editForm.duration" :min="0" style="width: 100%" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="时区"><el-input v-model="editForm.timezone" /></el-form-item></el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane label="地理信息">
            <el-row :gutter="20">
              <el-col :span="12"><el-form-item label="经度"><el-input v-model="editForm.longitude" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="纬度"><el-input v-model="editForm.latitude" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="Geohash"><el-input v-model="editForm.geohash" /></el-form-item></el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane label="旅行详情">
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="旅行类型">
                  <el-select v-model="editForm.travelType" placeholder="请选择">
                    <el-option label="自由行" value="自由行" />
                    <el-option label="跟团游" value="跟团游" />
                    <el-option label="商务出行" value="商务出行" />
                    <el-option label="探亲访友" value="探亲访友" />
                    <el-option label="其他" value="其他" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="季节">
                  <el-select v-model="editForm.season" placeholder="请选择">
                    <el-option label="春" value="春" />
                    <el-option label="夏" value="夏" />
                    <el-option label="秋" value="秋" />
                    <el-option label="冬" value="冬" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12"><el-form-item label="天气"><el-input v-model="editForm.weather" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="评分"><el-rate v-model="editForm.rating" allow-half /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="心情"><el-input v-model="editForm.mood" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="推荐程度"><el-rate v-model="editForm.recommendLevel" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="消费水平"><el-rate v-model="editForm.costLevel" /></el-form-item></el-col>
              <el-col :span="24">
                <el-form-item label="同行人员">
                  <el-select v-model="editForm.companions" multiple filterable allow-create default-first-option placeholder="请输入同行人员">
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="标签">
                  <el-select v-model="editForm.tags" multiple filterable allow-create default-first-option placeholder="请输入标签">
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane label="其他信息">
            <el-row :gutter="20">
              <el-col :span="12"><el-form-item label="交通工具"><el-input v-model="editForm.transportation" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="住宿信息"><el-input v-model="editForm.accommodation" /></el-form-item></el-col>
              <el-col :span="12">
                <el-form-item label="状态">
                  <el-select v-model="editForm.status">
                    <el-option label="计划中" value="计划中" />
                    <el-option label="进行中" value="进行中" />
                    <el-option label="已完成" value="已完成" />
                    <el-option label="取消" value="取消" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="公开">
                  <el-switch v-model="editForm.isPublic" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="12"><el-form-item label="收藏数"><el-input-number v-model="editForm.favoriteCount" :min="0" /></el-form-item></el-col>
              <el-col :span="12"><el-form-item label="浏览数"><el-input-number v-model="editForm.viewCount" :min="0" /></el-form-item></el-col>
              <el-col :span="24"><el-form-item label="描述"><el-input v-model="editForm.description" type="textarea" :rows="3" /></el-form-item></el-col>
              <el-col :span="24"><el-form-item label="注意事项"><el-input v-model="editForm.notes" type="textarea" :rows="3" /></el-form-item></el-col>
            </el-row>
          </el-tab-pane>
          <el-tab-pane label="媒体资源">
            <el-form-item label="封面图片">
              <image-upload v-model="editForm.coverImage" :limit="1" />
            </el-form-item>
            <el-form-item label="相册">
              <image-upload v-model="editForm.images" :limit="10" />
            </el-form-item>
            <el-form-item label="视频">
              <file-upload v-model="editForm.videos" :file-type="['mp4', 'avi', 'mov', 'webm']" :limit="3" :file-size="100" />
            </el-form-item>
          </el-tab-pane>
        </el-tabs>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button v-if="!isEdit" type="primary" @click="handleEdit">修 改</el-button>
          <el-button v-if="isEdit" type="primary" @click="handleSubmitEdit">确定修改</el-button>
          <el-button v-if="isEdit" type="warning" @click="handleResetEdit">重 置</el-button>
          <el-button @click="detailOpen = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { listTravel, addTravel, delTravel, getTravel, updateTravel } from "@/api/travel";
import { parseTime } from "@/utils/ruoyi";
import { ref, reactive, toRefs, onMounted } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";

const baseUrl = import.meta.env.VITE_APP_BASE_API;

defineOptions({
  name: "Travel",
});

const showSearch = ref(true);
const loading = ref(true);
const total = ref(0);
const travelList = ref([]);
const open = ref(false);
const detailOpen = ref(false);
const detailData = ref({});
const title = ref("");
const travelRef = ref(null);
const isEdit = ref(false);
const editForm = ref({});

const data = reactive({
  queryParams: {
    page_num: 1,
    page_size: 8,
    city: undefined,
    country: undefined,
  },
  form: {},
  rules: {
    city: [{ required: true, message: "城市不能为空", trigger: "blur" }],
    country: [{ required: true, message: "国家不能为空", trigger: "blur" }],
    visit_date: [{ required: true, message: "访问日期不能为空", trigger: "blur" }],
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询足迹列表 */
function getList() {
  loading.value = true;
  listTravel(queryParams.value).then((response) => {
    travelList.value = response.rows || response.data || [];
    total.value = response.total || 0;
    loading.value = false;
  });
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.page_num = 1;
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  queryParams.value.city = undefined;
  queryParams.value.country = undefined;
  handleQuery();
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加足迹";
}

/** 删除按钮操作 */
function handleDelete(row) {
  const ids = row.id;
  ElMessageBox.confirm('是否确认删除该足迹？', "警告", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning"
  }).then(function() {
    return delTravel(ids);
  }).then(() => {
    getList();
    ElMessage.success("删除成功");
  }).catch(() => {});
}

/** 详情按钮操作 */
function handleDetail(row) {
  detailData.value = row;
  isEdit.value = false;
  detailOpen.value = true;
}

/** 进入编辑模式 */
function handleEdit() {
  editForm.value = JSON.parse(JSON.stringify(detailData.value));
  isEdit.value = true;
}

/** 重置编辑 */
function handleResetEdit() {
  editForm.value = JSON.parse(JSON.stringify(detailData.value));
  ElMessage.info("已重置");
}

/** 提交修改 */
function handleSubmitEdit() {
  ElMessageBox.confirm('是否确认修改？', "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning"
  }).then(() => {
    updateTravel(editForm.value).then(response => {
      ElMessage.success("修改成功");
      isEdit.value = false;
      detailOpen.value = false;
      getList();
    });
  }).catch(() => {});
}

/** 提交按钮 */
function submitForm() {
  travelRef.value.validate(valid => {
    if (valid) {
      addTravel(form.value).then(response => {
        ElMessage.success("新增成功");
        open.value = false;
        getList();
      });
    }
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
    city: undefined,
    country: undefined,
    visit_date: undefined,
    description: undefined,
    cover_image: undefined
  };
  if (travelRef.value) {
    travelRef.value.resetFields();
  }
}

onMounted(() => {
  getList();
});
</script>

<style scoped lang="scss">
.travel-grid {
  margin-top: 20px;
}

.travel-card {
  margin-bottom: 20px;
  transition: all 0.3s;
  cursor: pointer;
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    
    .card-actions {
      opacity: 1;
    }
  }
}

.image-container {
  height: 200px;
  overflow: hidden;
  position: relative;
  background-color: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
}

.travel-image {
  width: 100%;
  height: 100%;
  display: block;
}

.image-placeholder {
  font-size: 40px;
  color: #909399;
}

.card-actions {
  position: absolute;
  top: 10px;
  right: 10px;
  opacity: 0;
  transition: opacity 0.3s;
  z-index: 10;
}

.card-content {
  padding: 14px;
}

.location {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
  color: #303133;
}

.date {
  font-size: 13px;
  color: #909399;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
  .el-icon {
    margin-right: 5px;
  }
}

.description {
  font-size: 14px;
  color: #606266;
  line-height: 1.5;
  height: 63px; /* 14px * 1.5 * 3 lines */
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}
</style>
