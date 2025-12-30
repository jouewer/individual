<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="关键字" prop="keyword">
        <el-input
          v-model="queryParams.keyword"
          placeholder="请输入摄像头名称或IP"
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
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="Edit"
          :disabled="single"
          @click="handleUpdate"
        >修改</el-button>
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

    <el-table v-loading="loading" :data="cameraList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="摄像头名称" align="center" prop="liftName" />
      <el-table-column label="登录用户名" align="center" prop="cameraName" />
      <el-table-column label="登录密码" align="center" prop="cameraPassword">
        <template #default="scope">
          <span>******</span>
        </template>
      </el-table-column>
      <el-table-column label="IP地址" align="center" prop="cameraIp" />
      <el-table-column label="端口" align="center" prop="cameraPort" />
      <el-table-column label="视频流端口" align="center" prop="cameraRtspPort" />
      <el-table-column label="状态" align="center" prop="cameraStatus">
        <template #default="scope">
          <el-switch
            v-model="scope.row.cameraStatus"
            active-value="0"
            inactive-value="1"
            @change="handleStatusChange(scope.row)"
          ></el-switch>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="View" @click="handlePreview(scope.row)">预览</el-button>
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

    <!-- 添加或修改摄像头对话框 -->
    <el-dialog :title="title" v-model="open" width="500px" append-to-body>
      <el-form ref="cameraRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="摄像头名称" prop="liftName">
          <el-input v-model="form.liftName" placeholder="请输入摄像头名称" />
        </el-form-item>
        <el-form-item label="登录用户名" prop="cameraName">
          <el-input v-model="form.cameraName" placeholder="请输入登录用户名" />
        </el-form-item>
        <el-form-item label="登录密码" prop="cameraPassword">
          <el-input v-model="form.cameraPassword" placeholder="请输入登录密码" type="password" show-password />
        </el-form-item>
        <el-form-item label="IP地址" prop="cameraIp">
          <el-input v-model="form.cameraIp" placeholder="请输入IP地址" />
        </el-form-item>
        <el-form-item label="端口" prop="cameraPort">
          <el-input v-model="form.cameraPort" placeholder="请输入端口" />
        </el-form-item>
        <el-form-item label="视频流端口" prop="cameraRtspPort">
          <el-input v-model="form.cameraRtspPort" placeholder="请输入视频流端口" />
        </el-form-item>
        <el-form-item label="状态" prop="cameraStatus">
          <el-radio-group v-model="form.cameraStatus">
            <el-radio value="0">正常</el-radio>
            <el-radio value="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="cancel">取 消</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 预览对话框 -->
    <el-dialog :title="previewTitle" v-model="previewOpen" width="600px" append-to-body>
      <div style="text-align: center; margin-bottom: 20px;">
        <p>视频流地址 (RTSP):</p>
        <el-input v-model="previewUrl" readonly>
          <template #append>
            <el-button @click="copyPreviewUrl">复制</el-button>
          </template>
        </el-input>
      </div>
      <div style="background: #000; height: 300px; color: #fff; display: flex; align-items: center; justify-content: center;">
        <div style="text-align: center;">
          <el-icon :size="50"><VideoPlay /></el-icon>
          <p>此处为视频预览区域</p>
          <p style="font-size: 12px; color: #ccc;">(浏览器不支持直接播放RTSP流，请使用VLC等播放器)</p>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="previewOpen = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="Camera">
import { listCamera, getCamera, delCamera, addCamera, updateCamera } from "@/api/camera";
import { getCurrentInstance, reactive, ref, toRefs } from "vue";

const { proxy } = getCurrentInstance();

const cameraList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
const previewOpen = ref(false);
const previewTitle = ref("");
const previewUrl = ref("");

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    keyword: undefined
  },
  rules: {
    liftName: [
      { required: true, message: "摄像头名称不能为空", trigger: "blur" }
    ],
    cameraIp: [
      { required: true, message: "IP地址不能为空", trigger: "blur" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询摄像头列表 */
function getList() {
  loading.value = true;
  listCamera(queryParams.value).then(response => {
    cameraList.value = response.rows;
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
    liftName: undefined,
    cameraName: undefined,
    cameraPassword: undefined,
    cameraIp: undefined,
    cameraPort: undefined,
    cameraRtspPort: undefined,
    cameraStatus: "0"
  };
  proxy.resetForm("cameraRef");
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
  title.value = "添加摄像头";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const id = row.id || ids.value;
  getCamera(id).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改摄像头";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["cameraRef"].validate(valid => {
    if (valid) {
      if (form.value.id != undefined) {
        updateCamera(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addCamera(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功");
          open.value = false;
          getList();
        });
      }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const cameraIds = row.id || ids.value;
  proxy.$modal.confirm('是否确认删除摄像头编号为"' + cameraIds + '"的数据项？').then(function() {
    return delCamera(cameraIds);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 复制预览地址 */
function copyPreviewUrl() {
  navigator.clipboard.writeText(previewUrl.value).then(() => {
    proxy.$modal.msgSuccess("复制成功");
  });
}

/** 预览按钮操作 */
function handlePreview(row) {
  previewTitle.value = row.liftName + " - 预览";
  let url = "rtsp://";
  if (row.cameraName && row.cameraPassword) {
    url += `${row.cameraName}:${row.cameraPassword}@`;
  }
  url += `${row.cameraIp}`;
  if (row.cameraRtspPort) {
    url += `:${row.cameraRtspPort}`;
  }
  url += "/"; 
  previewUrl.value = url;
  previewOpen.value = true;
}

/** 状态修改 */
function handleStatusChange(row) {
  let text = row.cameraStatus === "0" ? "启用" : "停用";
  proxy.$modal.confirm('确认要"' + text + '""' + row.liftName + '"摄像头吗?').then(function() {
    return updateCamera({ id: row.id, cameraStatus: row.cameraStatus });
  }).then(() => {
    proxy.$modal.msgSuccess(text + "成功");
  }).catch(function() {
    row.cameraStatus = row.cameraStatus === "0" ? "1" : "0";
  });
}

getList();
</script>
