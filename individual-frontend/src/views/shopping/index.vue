<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="商品名称" prop="shoppingName">
        <el-input
          v-model="queryParams.shoppingName"
          placeholder="请输入商品名称"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="节日名称" prop="holidayName">
        <el-input
          v-model="queryParams.holidayName"
          placeholder="请输入节日名称"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="状态" prop="purchaseStatus">
        <el-select v-model="queryParams.purchaseStatus" placeholder="请选择状态" clearable style="width: 240px">
          <el-option label="计划中" value="计划中" />
          <el-option label="待购买" value="待购买" />
          <el-option label="已下单" value="已下单" />
          <el-option label="运输中" value="运输中" />
          <el-option label="已收到" value="已收到" />
          <el-option label="已退货" value="已退货" />
          <el-option label="已取消" value="已取消" />
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
        >新增商品</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <div v-loading="loading" class="shopping-card-container">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="8" :lg="6" :xl="4" v-for="item in shoppingList" :key="item.id" class="mb-20">
          <el-card :body-style="{ padding: '0px' }" shadow="hover" class="shopping-card">
            <div class="image-wrapper">
              <el-image 
                :src="getImageUrl(item.coverImage)" 
                fit="cover" 
                class="shopping-image"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>
              <div class="status-tag">
                <el-tag :type="getStatusType(item.purchaseStatus)" effect="dark" size="small">{{ item.purchaseStatus }}</el-tag>
              </div>
            </div>
            
            <div class="card-content">
              <div class="item-header">
                <span class="item-name" :title="item.shoppingName">{{ item.shoppingName }}</span>
                <span class="item-price">¥{{ item.actualPrice || item.expectedPrice }}</span>
              </div>
              
              <div class="item-info">
                <div class="info-row">
                  <span class="label">节日:</span>
                  <span class="value">{{ item.holidayName }}</span>
                </div>
                <div class="info-row">
                  <span class="label">分类:</span>
                  <span class="value">{{ item.itemCategory }}</span>
                </div>
                 <div class="info-row">
                  <span class="label">数量:</span>
                  <span class="value">{{ item.quantity }}</span>
                </div>
              </div>

              <div class="item-desc" v-if="item.shoppingReason">
                <span class="text-truncate" :title="item.shoppingReason">{{ item.shoppingReason }}</span>
              </div>
              
              <div class="item-links" v-if="item.purchaseLink">
                 <a :href="item.purchaseLink" target="_blank" class="link-btn">
                   <el-icon><Link /></el-icon> 购买链接
                 </a>
              </div>
            </div>

            <div class="card-footer">
              <el-button link type="primary" icon="Edit" @click="handleUpdate(item)">编辑</el-button>
              <el-button link type="danger" icon="Delete" @click="handleDelete(item)">删除</el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>
      
      <el-empty v-if="shoppingList.length === 0" description="暂无数据" />
      
      <pagination
        v-show="total > 0"
        :total="total"
        v-model:page="queryParams.pageNum"
        v-model:limit="queryParams.pageSize"
        @pagination="getList"
      />
    </div>

    <!-- 添加或修改对话框 -->
    <el-dialog :title="title" v-model="open" width="800px" append-to-body>
      <el-form ref="shoppingRef" :model="form" :rules="rules" label-width="100px">
        <el-tabs v-model="activeTab">
          <!-- 基本信息 Tab -->
          <el-tab-pane label="基本信息" name="basic">
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="商品名称" prop="shoppingName">
                  <el-input v-model="form.shoppingName" placeholder="请输入商品名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="节日名称" prop="holidayName">
                  <el-input v-model="form.holidayName" placeholder="请输入节日名称" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="节日日期" prop="holidayDate">
                  <el-date-picker
                    v-model="form.holidayDate"
                    type="date"
                    placeholder="选择日期"
                    value-format="YYYY-MM-DD"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="送给谁" prop="itemForWhom">
                  <el-input v-model="form.itemForWhom" placeholder="请输入送给谁" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="商品分类" prop="itemCategory">
                  <el-select v-model="form.itemCategory" placeholder="请选择商品分类">
                    <el-option v-for="item in categoryOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="商品类型" prop="itemType">
                  <el-select v-model="form.itemType" placeholder="请选择商品类型">
                    <el-option v-for="item in typeOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="封面图片" prop="coverImage">
              <image-upload v-model="form.coverImage" :limit="1" />
            </el-form-item>
            <el-form-item label="物品图片" prop="itemImages">
              <image-upload v-model="form.itemImages" :limit="9" />
            </el-form-item>
            <el-form-item label="购物截图" prop="shoppingScreenshots">
              <image-upload v-model="form.shoppingScreenshots" :limit="9" />
            </el-form-item>
            <el-form-item label="购买理由" prop="shoppingReason">
              <el-input v-model="form.shoppingReason" type="textarea" placeholder="请输入购买理由" />
            </el-form-item>
          </el-tab-pane>

          <!-- 购买详情 Tab -->
          <el-tab-pane label="购买详情" name="purchase">
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="购买状态" prop="purchaseStatus">
                  <el-select v-model="form.purchaseStatus" placeholder="请选择状态">
                    <el-option v-for="item in purchaseStatusOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="购买时机" prop="purchaseTiming">
                  <el-select v-model="form.purchaseTiming" placeholder="请选择购买时机">
                    <el-option v-for="item in purchaseTimingOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="购买方式" prop="purchaseMethod">
                  <el-select v-model="form.purchaseMethod" placeholder="请选择购买方式">
                    <el-option v-for="item in purchaseMethodOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                 <el-form-item label="店铺类型" prop="storeType">
                  <el-select v-model="form.storeType" placeholder="请选择店铺类型">
                    <el-option v-for="item in storeTypeOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="店铺名称" prop="storeName">
              <el-input v-model="form.storeName" placeholder="请输入店铺名称" />
            </el-form-item>
            <el-form-item label="购买链接" prop="purchaseLink">
              <el-input v-model="form.purchaseLink" placeholder="请输入购买链接" />
            </el-form-item>
            <el-row :gutter="20">
              <el-col :span="8">
                <el-form-item label="预期价格" prop="expectedPrice">
                  <el-input-number v-model="form.expectedPrice" :min="0" :precision="2" :step="10" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="实际价格" prop="actualPrice">
                  <el-input-number v-model="form.actualPrice" :min="0" :precision="2" :step="10" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="货币" prop="currency">
                   <el-input v-model="form.currency" placeholder="如CNY" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="数量" prop="quantity">
                  <el-input-number v-model="form.quantity" :min="1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="单位" prop="unit">
                  <el-input v-model="form.unit" placeholder="如：个/件" />
                </el-form-item>
              </el-col>
            </el-row>
             <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="下单日期" prop="orderDate">
                  <el-date-picker
                    v-model="form.orderDate"
                    type="date"
                    placeholder="选择下单日期"
                    value-format="YYYY-MM-DD"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="收货日期" prop="receiveDate">
                  <el-date-picker
                    v-model="form.receiveDate"
                    type="date"
                    placeholder="选择收货日期"
                    value-format="YYYY-MM-DD"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 反馈与评价 Tab -->
          <el-tab-pane label="反馈与评价" name="feedback">
            <el-row :gutter="20">
              <el-col :span="8">
                <el-form-item label="购买体验" prop="purchaseExperience">
                  <el-select v-model="form.purchaseExperience" placeholder="请选择">
                    <el-option v-for="item in purchaseExperienceOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="配送速度" prop="deliverySpeed">
                  <el-select v-model="form.deliverySpeed" placeholder="请选择">
                    <el-option v-for="item in deliverySpeedOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="包装质量" prop="packagingQuality">
                   <el-select v-model="form.packagingQuality" placeholder="请选择">
                    <el-option v-for="item in packagingQualityOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
             <el-row :gutter="20">
              <el-col :span="8">
                <el-form-item label="物品质量" prop="itemQuality">
                   <el-select v-model="form.itemQuality" placeholder="请选择">
                    <el-option v-for="item in itemQualityOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="喜爱程度" prop="likingLevel">
                   <el-select v-model="form.likingLevel" placeholder="请选择">
                    <el-option v-for="item in likingLevelOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="使用频率" prop="usageFrequency">
                   <el-select v-model="form.usageFrequency" placeholder="请选择">
                    <el-option v-for="item in usageFrequencyOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="优点" prop="pros">
              <el-input v-model="form.pros" type="textarea" placeholder="请输入优点" />
            </el-form-item>
            <el-form-item label="缺点" prop="cons">
              <el-input v-model="form.cons" type="textarea" placeholder="请输入缺点" />
            </el-form-item>
             <el-form-item label="建议" prop="suggestions">
              <el-input v-model="form.suggestions" type="textarea" placeholder="请输入建议" />
            </el-form-item>
             <el-form-item label="有趣故事" prop="memorableStory">
              <el-input v-model="form.memorableStory" type="textarea" placeholder="请输入有趣故事" />
            </el-form-item>
          </el-tab-pane>

          <!-- 其他信息 Tab -->
          <el-tab-pane label="其他信息" name="other">
             <el-row :gutter="20">
              <el-col :span="12">
                 <el-form-item label="预算分类" prop="budgetCategory">
                   <el-input v-model="form.budgetCategory" placeholder="请输入预算分类" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="总花费" prop="totalSpent">
                   <el-input-number v-model="form.totalSpent" :min="0" :precision="2" :step="10" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
             <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="是否在预算内" prop="isInBudget">
                  <el-switch v-model="form.isInBudget" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
               <el-col :span="12">
                <el-form-item label="是否有效" prop="isActive">
                  <el-switch v-model="form.isActive" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
               <el-col :span="12">
                <el-form-item label="提醒日期" prop="reminderDate">
                  <el-date-picker
                    v-model="form.reminderDate"
                    type="date"
                    placeholder="选择提醒日期"
                    value-format="YYYY-MM-DD"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
               <el-col :span="12">
                 <el-form-item label="重复频率" prop="repeatFrequency">
                   <el-select v-model="form.repeatFrequency" placeholder="请选择">
                    <el-option v-for="item in repeatFrequencyOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
               </el-col>
            </el-row>
             <el-row :gutter="20">
              <el-col :span="8">
                <el-form-item label="重复购买" prop="isRepeatPurchase">
                  <el-switch v-model="form.isRepeatPurchase" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="分享给家人" prop="shareWithFamily">
                   <el-switch v-model="form.shareWithFamily" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="分享给朋友" prop="shareWithFriends">
                   <el-switch v-model="form.shareWithFriends" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="节日传统" prop="holidayTradition">
              <el-input v-model="form.holidayTradition" type="textarea" placeholder="请输入节日传统" />
            </el-form-item>
             <el-form-item label="文化意义" prop="culturalSignificance">
              <el-input v-model="form.culturalSignificance" type="textarea" placeholder="请输入文化意义" />
            </el-form-item>
            <el-form-item label="开箱视频" prop="unboxingVideos">
              <el-input v-model="form.unboxingVideos" placeholder="请输入视频URL" />
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

<script setup name="Shopping">
import { listShopping, getShopping, addShopping, updateShopping, delShopping } from "@/api/shopping";
import { ref, reactive, toRefs, getCurrentInstance } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';

const { proxy } = getCurrentInstance();

const shoppingList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const title = ref("");
const total = ref(0);

const categoryOptions = ["食品", "礼品", "装饰品", "服装", "家居用品", "电子产品", "其他"];
const typeOptions = ["用的", "吃的", "穿的", "玩的", "送的", "装饰的"];
const purchaseStatusOptions = ['计划中', '待购买', '已下单', '运输中', '已收到', '已退货', '已取消'];
const purchaseTimingOptions = ['提前1个月', '提前2周', '提前1周', '节日当天', '节日后'];
const purchaseMethodOptions = ['线上', '线下', '海外代购', '定制'];
const storeTypeOptions = ['天猫', '京东', '淘宝', '拼多多', '实体店', '超市', '专卖店', '其他'];
const purchaseExperienceOptions = ['非常满意', '满意', '一般', '不满意', '很差'];
const deliverySpeedOptions = ['很快', '正常', '较慢', '很慢'];
const packagingQualityOptions = ['很好', '一般', '简陋', '破损'];
const itemQualityOptions = ['非常好', '好', '一般', '差', '很差'];
const likingLevelOptions = ['非常喜欢', '喜欢', '一般', '不喜欢', '讨厌'];
const usageFrequencyOptions = ['每天使用', '经常使用', '偶尔使用', '很少使用', '未使用'];
const repeatFrequencyOptions = ['每年', '每季', '每次节日', '不重复'];

const activeTab = ref('basic');

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 12,
    shoppingName: null,
    holidayName: null,
    purchaseStatus: null,
    itemCategory: null
  },
  rules: {
    shoppingName: [
      { required: true, message: "商品名称不能为空", trigger: "blur" }
    ],
    holidayName: [
      { required: true, message: "节日名称不能为空", trigger: "blur" }
    ],
    holidayDate: [
      { required: true, message: "节日日期不能为空", trigger: "blur" }
    ],
    itemCategory: [
      { required: true, message: "商品分类不能为空", trigger: "change" }
    ],
     itemType: [
      { required: true, message: "商品类型不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询列表 */
function getList() {
  loading.value = true;
  listShopping(queryParams.value).then(response => {
    shoppingList.value = response.rows;
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
    id: null,
    shoppingName: null,
    holidayName: null,
    holidayDate: null,
    itemCategory: null,
    itemType: null,
    itemForWhom: null,
    purchaseTiming: '提前1周',
    purchaseMethod: '线上',
    storeName: null,
    storeType: null,
    purchaseLink: null,
    quantity: 1,
    unit: null,
    expectedPrice: null,
    actualPrice: null,
    currency: 'CNY',
    purchaseStatus: '计划中',
    shoppingReason: null,
    coverImage: null,
    itemImages: null,
    shoppingScreenshots: null,
    unboxingVideos: null,
    pros: null,
    cons: null,
    suggestions: null,
    memorableStory: null,
    holidayTradition: null,
    culturalSignificance: null,
    isInBudget: 1,
    isRepeatPurchase: 0,
    shareWithFamily: 0,
    shareWithFriends: 0,
    isActive: 1
  };
  proxy.resetForm("shoppingRef");
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

/** 新增按钮操作 */
function handleAdd() {
  reset();
  activeTab.value = 'basic';
  open.value = true;
  title.value = "添加节日购物";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const id = row.id;
  getShopping(id).then(response => {
    form.value = response.data;
    activeTab.value = 'basic';
    open.value = true;
    title.value = "修改节日购物";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["shoppingRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateShopping(form.value).then(response => {
          ElMessage.success("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addShopping(form.value).then(response => {
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
  const ids = row.id;
  ElMessageBox.confirm('是否确认删除商品名称为"' + row.shoppingName + '"的数据项？').then(function() {
    return delShopping(ids);
  }).then(() => {
    getList();
    ElMessage.success("删除成功");
  }).catch(() => {});
}

function getImageUrl(url) {
  if (!url) return '';
  if (url.startsWith('http')) return url;
  return import.meta.env.VITE_APP_BASE_API + url;
}

function getStatusType(status) {
  const map = {
    '计划中': 'info',
    '待购买': 'warning',
    '已下单': 'primary',
    '运输中': 'primary',
    '已收到': 'success',
    '已退货': 'danger',
    '已取消': 'info'
  };
  return map[status] || 'info';
}

getList();
</script>

<style lang="scss" scoped>
.shopping-card-container {
  padding: 10px;
}

.shopping-card {
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
  }
  
  .image-wrapper {
    position: relative;
    height: 180px;
    overflow: hidden;
    
    .shopping-image {
      width: 100%;
      height: 100%;
      transition: transform 0.5s;
    }
    
    .status-tag {
      position: absolute;
      top: 10px;
      right: 10px;
    }
  }
  
  .card-content {
    padding: 15px;
    
    .item-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
      
      .item-name {
        font-size: 16px;
        font-weight: bold;
        color: #333;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 70%;
      }
      
      .item-price {
        font-size: 16px;
        color: #f56c6c;
        font-weight: bold;
      }
    }
    
    .item-info {
      font-size: 13px;
      color: #666;
      margin-bottom: 10px;
      
      .info-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 5px;
      }
    }
    
    .item-desc {
      font-size: 12px;
      color: #999;
      margin-bottom: 10px;
      height: 36px;
      overflow: hidden;
    }
    
    .item-links {
      text-align: right;
      
      .link-btn {
        font-size: 12px;
        color: #409eff;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        
        &:hover {
          text-decoration: underline;
        }
        
        .el-icon {
          margin-right: 3px;
        }
      }
    }
  }
  
  .card-footer {
    border-top: 1px solid #eee;
    padding: 10px 15px;
    display: flex;
    justify-content: flex-end;
  }
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

.text-truncate {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}
</style>
