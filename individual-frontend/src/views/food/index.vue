<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="食物名称" prop="food_name">
        <el-input
          v-model="queryParams.food_name"
          placeholder="请输入食物名称"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="类别" prop="food_category">
        <el-select v-model="queryParams.food_category" placeholder="请选择类别" clearable style="width: 240px">
          <el-option label="主食" value="主食" />
          <el-option label="快餐" value="快餐" />
          <el-option label="小吃" value="小吃" />
          <el-option label="饮品" value="饮品" />
          <el-option label="水果" value="水果" />
          <el-option label="甜点" value="甜点" />
        </el-select>
      </el-form-item>
      <el-form-item label="用餐时段" prop="meal_time">
        <el-select v-model="queryParams.meal_time" placeholder="请选择时段" clearable style="width: 240px">
          <el-option label="早餐" value="早餐" />
          <el-option label="午餐" value="午餐" />
          <el-option label="晚餐" value="晚餐" />
          <el-option label="加餐" value="加餐" />
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
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="Delete"
          :disabled="multiple"
          @click="handleDelete"
        >删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="foodList" @selection-change="handleSelectionChange" @row-click="handleRowClick">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="封面" align="center" width="80">
        <template #default="scope">
          <el-image
            v-if="getCover(scope.row)"
            style="width: 50px; height: 50px; border-radius: 4px"
            :src="getCover(scope.row)"
            :preview-src-list="getPreviewList(scope.row)"
            fit="cover"
            preview-teleported
            @click.stop
          />
        </template>
      </el-table-column>
      <el-table-column label="日期" align="center" prop="recordDate" width="100">
        <template #default="scope">
          <span>{{ parseTime(scope.row.recordDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="时段" align="center" prop="mealTime" width="80" />
      <el-table-column label="食物名称" align="center" prop="foodName" />
      <el-table-column label="类别" align="center" prop="foodCategory" width="80" />
      <el-table-column label="地点" align="center" prop="locationType" width="80" />
      <el-table-column label="具体地点" align="center" prop="locationName" show-overflow-tooltip />
      <el-table-column label="价格" align="center" prop="cost" width="100">
        <template #default="scope">
           <span v-if="scope.row.cost">{{ scope.row.cost }} {{ scope.row.currency }}</span>
        </template>
      </el-table-column>
      <el-table-column label="口味" align="center" prop="tasteRating" width="60" />
      <el-table-column label="健康" align="center" prop="healthRating" width="60" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click.stop="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="primary" icon="Delete" @click.stop="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- Add/Edit Dialog -->
    <el-dialog :title="title" v-model="open" width="900px" append-to-body>
      <el-form ref="foodRef" :model="form" :rules="rules" label-width="110px">
        <el-tabs v-model="activeTab">
          <!-- 基础信息 -->
          <el-tab-pane label="基础信息" name="basic">
            <el-row>
              <el-col :span="12">
                <el-form-item label="记录日期" prop="record_date">
                  <el-date-picker v-model="form.record_date" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="用餐时段" prop="meal_time">
                  <el-select v-model="form.meal_time" placeholder="请选择时段" style="width: 100%">
                    <el-option label="早餐" value="早餐" />
                    <el-option label="午餐" value="午餐" />
                    <el-option label="晚餐" value="晚餐" />
                    <el-option label="上午加餐" value="上午加餐" />
                    <el-option label="下午加餐" value="下午加餐" />
                    <el-option label="夜宵" value="夜宵" />
                    <el-option label="其他" value="其他" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="具体时间" prop="meal_time_detail">
                  <el-time-picker v-model="form.meal_time_detail" format="HH:mm" value-format="HH:mm:ss" placeholder="选择时间" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="食物名称" prop="food_name">
                  <el-input v-model="form.food_name" placeholder="请输入食物名称" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="食物类别" prop="food_category">
                  <el-select v-model="form.food_category" placeholder="请选择类别" style="width: 100%">
                    <el-option label="主食" value="主食" />
                    <el-option label="蔬菜" value="蔬菜" />
                    <el-option label="水果" value="水果" />
                    <el-option label="蛋白质" value="蛋白质" />
                    <el-option label="零食" value="零食" />
                    <el-option label="饮料" value="饮料" />
                    <el-option label="甜品" value="甜品" />
                    <el-option label="其他" value="其他" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="烹饪方式" prop="cooking_method">
                  <el-input v-model="form.cooking_method" placeholder="如：炒、煮、蒸" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="食物标签" prop="food_tags">
              <el-select v-model="form.food_tags" multiple filterable allow-create default-first-option placeholder="请输入标签" style="width: 100%">
              </el-select>
            </el-form-item>
          </el-tab-pane>

          <!-- 用餐详情 -->
          <el-tab-pane label="用餐详情" name="dining">
            <el-row>
              <el-col :span="12">
                <el-form-item label="地点类型" prop="location_type">
                  <el-select v-model="form.location_type" placeholder="请选择地点类型" style="width: 100%">
                    <el-option label="家里" value="家里" />
                    <el-option label="餐厅" value="餐厅" />
                    <el-option label="外卖" value="外卖" />
                    <el-option label="公司" value="公司" />
                    <el-option label="学校" value="学校" />
                    <el-option label="朋友家" value="朋友家" />
                    <el-option label="其他" value="其他" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="具体地点" prop="location_name">
                  <el-input v-model="form.location_name" placeholder="请输入具体地点" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="详细地址" prop="address">
              <el-input v-model="form.address" placeholder="请输入详细地址" />
            </el-form-item>
            <el-row>
              <el-col :span="12">
                <el-form-item label="用餐同伴" prop="companion_type">
                  <el-select v-model="form.companion_type" placeholder="请选择同伴类型" style="width: 100%">
                    <el-option label="独自" value="独自" />
                    <el-option label="家人" value="家人" />
                    <el-option label="朋友" value="朋友" />
                    <el-option label="同事" value="同事" />
                    <el-option label="客户" value="客户" />
                    <el-option label="其他" value="其他" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="同伴名单" prop="companions">
                  <el-select v-model="form.companions" multiple filterable allow-create default-first-option placeholder="请输入同伴姓名" style="width: 100%">
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 数量与营养 -->
          <el-tab-pane label="数量与营养" name="nutrition">
            <el-row>
              <el-col :span="12">
                <el-form-item label="分量描述" prop="portion_size">
                  <el-input v-model="form.portion_size" placeholder="如：一碗、200g" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="预估卡路里" prop="estimated_calories">
                  <el-input-number v-model="form.estimated_calories" :min="0" :precision="1" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="是否自制" prop="is_homemade">
                   <el-switch v-model="form.is_homemade" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="关联菜谱ID" prop="recipe_id">
                  <el-input v-model="form.recipe_id" placeholder="请输入菜谱ID" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="营养标签" prop="nutrition_tags">
              <el-select v-model="form.nutrition_tags" multiple filterable allow-create default-first-option placeholder="如：高蛋白、低脂" style="width: 100%">
              </el-select>
            </el-form-item>
          </el-tab-pane>

          <!-- 评价与感受 -->
          <el-tab-pane label="评价与感受" name="review">
            <el-row>
              <el-col :span="8">
                <el-form-item label="口味评分" prop="taste_rating">
                  <el-rate v-model="form.taste_rating" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="健康评分" prop="health_rating">
                  <el-rate v-model="form.health_rating" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="满意度" prop="satisfaction_level">
                  <el-rate v-model="form.satisfaction_level" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="用餐心情" prop="mood_during_meal">
                  <el-input v-model="form.mood_during_meal" placeholder="如：开心、焦虑" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="餐后感受" prop="feeling_after_meal">
                  <el-input v-model="form.feeling_after_meal" placeholder="如：饱腹、满足" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="特别备注" prop="special_notes">
              <el-input v-model="form.special_notes" type="textarea" placeholder="请输入备注" />
            </el-form-item>
          </el-tab-pane>

          <!-- 图片与菜谱 -->
           <el-tab-pane label="图片与菜谱" name="images">
              <el-form-item label="食物封面" prop="food_images">
                 <image-upload v-model="form.food_images" :limit="1" />
              </el-form-item>
              <el-form-item label="食物图片" prop="images">
                 <image-upload v-model="form.images" :limit="9" />
              </el-form-item>
              <el-form-item label="主要食材" prop="ingredients">
                <el-select v-model="form.ingredients" multiple filterable allow-create default-first-option placeholder="请输入食材" style="width: 100%">
                </el-select>
             </el-form-item>
             <el-form-item label="食材文本" prop="ingredients_text">
                <el-input v-model="form.ingredients_text" type="textarea" placeholder="用于搜索的食材文本" />
             </el-form-item>
             <el-form-item label="制作步骤" prop="recipe_steps">
                <el-input v-model="form.recipe_steps" type="textarea" rows="4" placeholder="请输入制作步骤" />
             </el-form-item>
          </el-tab-pane>

          <!-- 花费信息 -->
          <el-tab-pane label="花费信息" name="cost">
            <el-row>
              <el-col :span="12">
                <el-form-item label="花费金额" prop="cost">
                  <el-input-number v-model="form.cost" :min="0" :precision="2" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="货币" prop="currency">
                  <el-input v-model="form.currency" placeholder="CNY" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="是否分摊" prop="is_shared_cost">
                  <el-switch v-model="form.is_shared_cost" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="分摊人员" prop="shared_with">
                   <el-select v-model="form.shared_with" multiple filterable allow-create default-first-option placeholder="请输入分摊人" style="width: 100%">
                   </el-select>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- 状态与隐私 -->
          <el-tab-pane label="状态与隐私" name="status">
             <el-row>
               <el-col :span="12">
                 <el-form-item label="重复频率" prop="repeat_frequency">
                   <el-input v-model="form.repeat_frequency" placeholder="如：每周" />
                 </el-form-item>
               </el-col>
               <el-col :span="12">
                 <el-form-item label="隐私级别" prop="privacy_level">
                   <el-select v-model="form.privacy_level" placeholder="请选择" style="width: 100%">
                     <el-option label="公开" value="公开" />
                     <el-option label="好友可见" value="好友可见" />
                     <el-option label="仅自己" value="仅自己" />
                   </el-select>
                 </el-form-item>
               </el-col>
             </el-row>
             <el-row>
               <el-col :span="8">
                 <el-form-item label="是否收藏" prop="is_favorite">
                   <el-switch v-model="form.is_favorite" :active-value="1" :inactive-value="0" />
                 </el-form-item>
               </el-col>
               <el-col :span="8">
                 <el-form-item label="想再吃" prop="want_to_repeat">
                   <el-switch v-model="form.want_to_repeat" :active-value="1" :inactive-value="0" />
                 </el-form-item>
               </el-col>
               <el-col :span="8">
                 <el-form-item label="食用次数" prop="times_eaten">
                   <el-input-number v-model="form.times_eaten" :min="1" />
                 </el-form-item>
               </el-col>
             </el-row>
             <el-form-item label="上次日期" prop="last_eaten_date">
                <el-date-picker v-model="form.last_eaten_date" type="date" value-format="YYYY-MM-DD" style="width: 100%" />
             </el-form-item>
             <el-form-item label="类似食物" prop="similar_food_ids">
                 <el-select v-model="form.similar_food_ids" multiple filterable allow-create default-first-option placeholder="类似食物ID" style="width: 100%">
                 </el-select>
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

<script setup>
import { listFood, getFood, delFood, addFood, updateFood } from "@/api/food";
import { ref, reactive, toRefs, getCurrentInstance } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import ImageUpload from "@/components/ImageUpload";

const { proxy } = getCurrentInstance();

const foodList = ref([]);
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
    food_name: null,
    food_category: null,
    meal_time: null
  },
  rules: {
    food_name: [
      { required: true, message: "食物名称不能为空", trigger: "blur" }
    ],
    record_date: [
      { required: true, message: "日期不能为空", trigger: "blur" }
    ],
    meal_time: [
      { required: true, message: "用餐时段不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 获取封面图片 */
function getCover(row) {
  let img = null;
  if (row.images && Array.isArray(row.images) && row.images.length > 0) {
    img = row.images[0];
  } else if (row.images && typeof row.images === 'string') {
    img = row.images;
  } else if (row.foodImages) {
    img = row.foodImages;
  }
  
  if (img && !img.startsWith('http') && !img.startsWith('data:')) {
    return import.meta.env.VITE_APP_BASE_API + img;
  }
  return img;
}

/** 获取图片预览列表 */
function getPreviewList(row) {
  let list = [];
  if (row.images && Array.isArray(row.images)) {
    list = [...row.images];
  } else if (row.images && typeof row.images === 'string') {
    list = [row.images];
  }
  
  if (row.foodImages) {
    list.push(row.foodImages);
  }
  
  return list.map(img => {
    if (img && !img.startsWith('http') && !img.startsWith('data:')) {
      return import.meta.env.VITE_APP_BASE_API + img;
    }
    return img;
  });
}

/** 查询列表 */
function getList() {
  loading.value = true;
  listFood(queryParams.value).then(response => {
    foodList.value = response.rows;
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
  activeTab.value = "basic";
  form.value = {
    id: undefined,
    user_id: undefined,
    record_date: undefined,
    meal_time: undefined,
    meal_time_detail: undefined,
    food_name: undefined,
    food_category: undefined,
    food_tags: [],
    cooking_method: undefined,
    location_type: '家里',
    location_name: undefined,
    address: undefined,
    companion_type: '独自',
    companions: [],
    portion_size: undefined,
    estimated_calories: undefined,
    nutrition_tags: [],
    is_homemade: 0,
    recipe_id: undefined,
    taste_rating: undefined,
    health_rating: undefined,
    satisfaction_level: undefined,
    mood_during_meal: undefined,
    feeling_after_meal: undefined,
    special_notes: undefined,
    images: [],
    recipe_steps: undefined,
    ingredients: [],
    ingredients_text: undefined,
    cost: undefined,
    currency: 'CNY',
    is_shared_cost: 0,
    shared_with: [],
    repeat_frequency: undefined,
    last_eaten_date: undefined,
    times_eaten: 1,
    similar_food_ids: [],
    is_favorite: 0,
    want_to_repeat: 1,
    privacy_level: '仅自己'
  };
  proxy.resetForm("foodRef");
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

/** 行点击事件 */
function handleRowClick(row, column, event) {
  // 如果点击的是操作列或多选列，不触发详情
  if (column && (column.type === 'selection' || column.label === '操作')) {
    return;
  }
  handleUpdate(row);
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加美食日记";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const foodId = row.id || ids.value;
  getFood(foodId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改美食日记";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["foodRef"].validate(valid => {
    if (valid) {
      if (form.value.id != undefined) {
        updateFood(form.value).then(response => {
          ElMessage.success("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addFood(form.value).then(response => {
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
  const foodIds = row.id || ids.value;
  ElMessageBox.confirm('是否确认删除编号为"' + foodIds + '"的数据项？', "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning"
  }).then(() => {
    return delFood(foodIds);
  }).then(() => {
    getList();
    ElMessage.success("删除成功");
  }).catch(() => {});
}

getList();
</script>
