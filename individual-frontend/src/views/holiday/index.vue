<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="节日名称" prop="holidayName">
        <el-input
          v-model="queryParams.holidayName"
          placeholder="请输入节日名称"
          clearable
          style="width: 240px"
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="类型" prop="holidayType">
        <el-select v-model="queryParams.holidayType" placeholder="请选择类型" clearable style="width: 240px">
          <el-option label="传统节日" value="传统节日" />
          <el-option label="法定节假日" value="法定节假日" />
          <el-option label="特殊日" value="特殊日" />
          <el-option label="个人纪念日" value="个人纪念日" />
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

    <el-table v-loading="loading" :data="holidayList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="节日名称" align="center" prop="holidayName" />
      <el-table-column label="日程标题" align="center" prop="scheduleTitle" />
      <el-table-column label="节日日期" align="center" prop="holidayDate" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.holidayDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="开始时间" align="center" prop="startTime" />
      <el-table-column label="结束时间" align="center" prop="endTime" />
      <el-table-column label="类型" align="center" prop="holidayType" />
      <el-table-column label="地点" align="center" prop="locationName" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
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
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="holidayRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="节日名称" prop="holidayName">
          <el-input v-model="form.holidayName" placeholder="请输入节日名称" />
        </el-form-item>
        <el-form-item label="日程标题" prop="scheduleTitle">
          <el-input v-model="form.scheduleTitle" placeholder="请输入日程标题" />
        </el-form-item>
        <el-form-item label="节日日期" prop="holidayDate">
          <el-date-picker
            v-model="form.holidayDate"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
           <el-time-picker
            v-model="form.startTime"
            placeholder="选择时间"
            value-format="HH:mm:ss"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
           <el-time-picker
            v-model="form.endTime"
            placeholder="选择时间"
            value-format="HH:mm:ss"
          />
        </el-form-item>
        <el-form-item label="类型" prop="holidayType">
          <el-select v-model="form.holidayType" placeholder="请选择类型">
            <el-option label="传统节日" value="传统节日" />
            <el-option label="法定节假日" value="法定节假日" />
            <el-option label="特殊日" value="特殊日" />
            <el-option label="个人纪念日" value="个人纪念日" />
          </el-select>
        </el-form-item>
        <el-form-item label="日程类型" prop="scheduleType">
          <el-input v-model="form.scheduleType" placeholder="请输入日程类型" />
        </el-form-item>
        <el-form-item label="地点名称" prop="locationName">
          <el-input v-model="form.locationName" placeholder="请输入地点名称" />
        </el-form-item>
        <el-form-item label="详细地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入详细地址" />
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

<script setup>
import { listHoliday, getHoliday, delHoliday, addHoliday, updateHoliday } from "@/api/holiday";
import { ref, reactive, toRefs, getCurrentInstance } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';

const { proxy } = getCurrentInstance();

const holidayList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    holidayName: undefined,
    holidayType: undefined
  },
  rules: {
    holidayName: [{ required: true, message: "节日名称不能为空", trigger: "blur" }],
    holidayDate: [{ required: true, message: "节日日期不能为空", trigger: "blur" }]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询列表 */
function getList() {
  loading.value = true;
  listHoliday(queryParams.value).then(response => {
    holidayList.value = response.rows;
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
    holidayName: undefined,
    scheduleTitle: undefined,
    holidayDate: undefined,
    startTime: undefined,
    endTime: undefined,
    holidayType: undefined,
    scheduleType: undefined,
    locationName: undefined,
    address: undefined
  };
  proxy.resetForm("holidayRef");
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
  title.value = "添加节假快乐";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const holidayId = row.id || ids.value;
  getHoliday(holidayId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改节假快乐";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["holidayRef"].validate(valid => {
    if (valid) {
      if (form.value.id != undefined) {
        updateHoliday(form.value).then(response => {
          ElMessage.success("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addHoliday(form.value).then(response => {
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
  const holidayIds = row.id || ids.value;
  ElMessageBox.confirm('是否确认删除编号为"' + holidayIds + '"的数据项？', "提示", {
    confirmButtonText: "确定",
    cancelButtonText: "取消",
    type: "warning"
  }).then(() => {
    return delHoliday(holidayIds);
  }).then(() => {
    getList();
    ElMessage.success("删除成功");
  }).catch(() => {});
}

getList();
</script>
