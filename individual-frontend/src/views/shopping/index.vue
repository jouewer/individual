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
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="shoppingRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="商品名称" prop="shoppingName">
          <el-input v-model="form.shoppingName" placeholder="请输入商品名称" />
        </el-form-item>
        <el-form-item label="节日名称" prop="holidayName">
          <el-input v-model="form.holidayName" placeholder="请输入节日名称" />
        </el-form-item>
        <el-form-item label="节日日期" prop="holidayDate">
           <el-date-picker
            v-model="form.holidayDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="商品分类" prop="itemCategory">
           <el-select v-model="form.itemCategory" placeholder="请选择商品分类">
             <el-option v-for="item in categoryOptions" :key="item" :label="item" :value="item" />
           </el-select>
        </el-form-item>
        <el-form-item label="商品类型" prop="itemType">
            <el-select v-model="form.itemType" placeholder="请选择商品类型">
             <el-option v-for="item in typeOptions" :key="item" :label="item" :value="item" />
           </el-select>
        </el-form-item>
         <el-form-item label="购买状态" prop="purchaseStatus">
           <el-select v-model="form.purchaseStatus" placeholder="请选择状态">
             <el-option label="计划中" value="计划中" />
             <el-option label="待购买" value="待购买" />
             <el-option label="已下单" value="已下单" />
             <el-option label="运输中" value="运输中" />
             <el-option label="已收到" value="已收到" />
             <el-option label="已退货" value="已退货" />
             <el-option label="已取消" value="已取消" />
           </el-select>
        </el-form-item>
        <el-row>
          <el-col :span="12">
            <el-form-item label="预期价格" prop="expectedPrice">
              <el-input-number v-model="form.expectedPrice" :min="0" :precision="2" :step="10" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="实际价格" prop="actualPrice">
              <el-input-number v-model="form.actualPrice" :min="0" :precision="2" :step="10" />
            </el-form-item>
          </el-col>
        </el-row>
         <el-row>
          <el-col :span="12">
            <el-form-item label="数量" prop="quantity">
              <el-input-number v-model="form.quantity" :min="1" />
            </el-form-item>
          </el-col>
           <el-col :span="12">
             <el-form-item label="送给谁" prop="itemForWhom">
               <el-input v-model="form.itemForWhom" />
             </el-form-item>
           </el-col>
        </el-row>
        <el-form-item label="购买链接" prop="purchaseLink">
          <el-input v-model="form.purchaseLink" placeholder="请输入购买链接" />
        </el-form-item>
        <el-form-item label="封面图片" prop="coverImage">
          <el-input v-model="form.coverImage" placeholder="请输入图片URL" />
        </el-form-item>
        <el-form-item label="购买理由" prop="shoppingReason">
          <el-input v-model="form.shoppingReason" type="textarea" placeholder="请输入购买理由" />
        </el-form-item>
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
  open.value = true;
  title.value = "添加节日购物";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const id = row.id;
  getShopping(id).then(response => {
    form.value = response.data;
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
