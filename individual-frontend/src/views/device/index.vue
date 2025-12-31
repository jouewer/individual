<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="设备名称" prop="deviceName">
        <el-input
          v-model="queryParams.deviceName"
          placeholder="请输入设备名称"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备类型" prop="deviceType">
        <el-input
          v-model="queryParams.deviceType"
          placeholder="请输入设备类型"
          clearable
          @keyup.enter="handleQuery"
        />
      </el-form-item>
      <el-form-item label="设备状态" prop="deviceStatus">
        <el-select v-model="queryParams.deviceStatus" placeholder="请选择状态" clearable>
          <el-option label="全新" value="全新" />
          <el-option label="已使用" value="已使用" />
          <el-option label="已损坏" value="已损坏" />
          <el-option label="待维修" value="待维修" />
          <el-option label="已闲置" value="已闲置" />
          <el-option label="已丢弃" value="已丢弃" />
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

    <el-table v-loading="loading" :data="deviceList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="设备名称" align="center" prop="deviceName" />
      <el-table-column label="图片" align="center" width="100">
        <template #default="scope">
          <image-preview v-if="scope.row.deviceImages && scope.row.deviceImages.length > 0" :src="Array.isArray(scope.row.deviceImages) ? scope.row.deviceImages.join(',') : scope.row.deviceImages" :width="50" :height="50"/>
        </template>
      </el-table-column>
      <el-table-column label="类型" align="center" prop="deviceType" />
      <el-table-column label="品牌" align="center" prop="brand" />
      <el-table-column label="型号" align="center" prop="model" />
      <el-table-column label="单价" align="center" prop="unitPrice" />
      <el-table-column label="购买日期" align="center" prop="purchaseDate" width="180">
        <template #default="scope">
          <span>{{ parseTime(scope.row.purchaseDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="设备状态" align="center" prop="deviceStatus">
        <template #default="scope">
          <el-tag v-if="scope.row.deviceStatus === '全新'" type="success">全新</el-tag>
          <el-tag v-else-if="scope.row.deviceStatus === '已使用'" type="primary">已使用</el-tag>
          <el-tag v-else-if="scope.row.deviceStatus === '已闲置'" type="info">已闲置</el-tag>
          <el-tag v-else-if="scope.row.deviceStatus === '已损坏'" type="danger">已损坏</el-tag>
          <el-tag v-else-if="scope.row.deviceStatus === '待维修'" type="warning">待维修</el-tag>
          <el-tag v-else>{{ scope.row.deviceStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="购买状态" align="center" prop="purchaseStatus" />
      <el-table-column label="存放位置" align="center" prop="storageLocation" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
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

    <!-- 添加或修改电子设备对话框 -->
    <el-dialog :title="title" v-model="open" width="800px" append-to-body>
      <el-form ref="deviceRef" :model="form" :rules="rules" label-width="100px">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="基本信息" name="basic">
            <el-row>
              <el-col :span="12">
                <el-form-item label="设备名称" prop="deviceName">
                  <el-input v-model="form.deviceName" placeholder="请输入设备名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="设备类型" prop="deviceType">
                  <el-select v-model="form.deviceType" placeholder="请选择类型" allow-create filterable>
                     <el-option v-for="item in ['手机','电脑','平板','相机','电视','音响','游戏机','智能家居','小家电','办公设备','其他']" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="品牌" prop="brand">
                  <el-input v-model="form.brand" placeholder="请输入品牌" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="型号" prop="model">
                  <el-input v-model="form.model" placeholder="请输入型号" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="序列号" prop="serialNumber">
                  <el-input v-model="form.serialNumber" placeholder="请输入序列号" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="颜色" prop="color">
                  <el-input v-model="form.color" placeholder="请输入颜色" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="设备状态" prop="deviceStatus">
                  <el-select v-model="form.deviceStatus" placeholder="请选择状态">
                    <el-option v-for="item in ['全新','已使用','已损坏','待维修','已闲置','已丢弃']" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="购买状态" prop="purchaseStatus">
                  <el-select v-model="form.purchaseStatus" placeholder="请选择购买状态">
                    <el-option v-for="item in ['已拥有','待购买','购买中','运输中','退货中']" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="位置与价值" name="location">
             <el-row>
              <el-col :span="12">
                <el-form-item label="存放位置" prop="storageLocation">
                  <el-input v-model="form.storageLocation" placeholder="请输入存放位置" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="位置类型" prop="locationType">
                  <el-select v-model="form.locationType" placeholder="请选择位置类型">
                    <el-option v-for="item in ['客厅','卧室','书房','厨房','办公室','仓库','车上','随身携带','其他']" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="具体位置" prop="specificSpot">
                  <el-input v-model="form.specificSpot" placeholder="请输入具体位置" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="8">
                <el-form-item label="数量" prop="quantity">
                  <el-input-number v-model="form.quantity" :min="1" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="单价" prop="unitPrice">
                  <el-input-number v-model="form.unitPrice" :precision="2" :step="100" :min="0" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="总价值" prop="totalValue">
                  <el-input-number v-model="form.totalValue" :precision="2" :step="100" :min="0" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
             <el-row>
              <el-col :span="12">
                <el-form-item label="货币" prop="currency">
                  <el-input v-model="form.currency" placeholder="CNY" />
                </el-form-item>
              </el-col>
             </el-row>
          </el-tab-pane>

          <el-tab-pane label="购买与保修" name="purchase">
            <el-row>
              <el-col :span="12">
                <el-form-item label="购买日期" prop="purchaseDate">
                  <el-date-picker clearable v-model="form.purchaseDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择购买日期" style="width: 100%"/>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="购买渠道" prop="purchaseFrom">
                  <el-input v-model="form.purchaseFrom" placeholder="请输入购买渠道" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="保修期(月)" prop="warrantyPeriod">
                  <el-input-number v-model="form.warrantyPeriod" :min="0" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="保修截止" prop="warrantyEndDate">
                  <el-date-picker clearable v-model="form.warrantyEndDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择保修截止日期" style="width: 100%"/>
                </el-form-item>
              </el-col>
            </el-row>
             <el-row>
              <el-col :span="24">
                <el-form-item label="发票号码" prop="invoiceNumber">
                  <el-input v-model="form.invoiceNumber" placeholder="请输入发票号码" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="使用与维护" name="usage">
             <el-row>
              <el-col :span="12">
                <el-form-item label="启用日期" prop="startUseDate">
                  <el-date-picker clearable v-model="form.startUseDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择启用日期" style="width: 100%"/>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="预计寿命(月)" prop="estimatedLifespan">
                  <el-input-number v-model="form.estimatedLifespan" :min="0" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
             <el-row>
              <el-col :span="12">
                <el-form-item label="使用频率" prop="usageFrequency">
                   <el-select v-model="form.usageFrequency" placeholder="请选择使用频率">
                    <el-option v-for="item in ['每天使用','经常使用','偶尔使用','很少使用','基本不用']" :key="item" :label="item" :value="item" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="最后使用" prop="lastUsedDate">
                  <el-date-picker clearable v-model="form.lastUsedDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择最后使用日期" style="width: 100%"/>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="图片与备注" name="images">
            <el-row>
              <el-col :span="24">
                <el-form-item label="设备图片" prop="deviceImages">
                  <image-upload v-model="form.deviceImages" :limit="5"/>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="说明书" prop="manualPath">
                  <el-input v-model="form.manualPath" placeholder="请输入说明书路径" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="保修卡" prop="warrantyCardImage">
                  <image-upload v-model="form.warrantyCardImage" :limit="1"/>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                 <el-form-item label="发票图片" prop="invoiceImage">
                  <image-upload v-model="form.invoiceImage" :limit="1"/>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="备注" prop="notes">
                  <el-input v-model="form.notes" type="textarea" placeholder="请输入备注" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="重要程度" prop="importantLevel">
                   <el-radio-group v-model="form.importantLevel">
                      <el-radio value="非常重要">非常重要</el-radio>
                      <el-radio value="重要">重要</el-radio>
                      <el-radio value="一般">一般</el-radio>
                      <el-radio value="不重要">不重要</el-radio>
                    </el-radio-group>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="技术规格" name="specs">
            <el-row>
              <el-col :span="24">
                <el-form-item label="技术规格" prop="specifications">
                  <el-input v-model="form.specifications" type="textarea" :rows="4" placeholder="请输入技术规格(JSON格式)" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="配件清单" prop="accessories">
                  <el-input v-model="form.accessories" type="textarea" :rows="4" placeholder="请输入配件清单(JSON格式)" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="软件信息" prop="softwareInfo">
                  <el-input v-model="form.softwareInfo" type="textarea" :rows="4" placeholder="请输入软件信息" />
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="维护记录" name="maintenance">
            <el-row>
              <el-col :span="24">
                <el-form-item label="维护记录" prop="maintenanceRecords">
                   <el-input v-model="form.maintenanceRecords" type="textarea" :rows="4" placeholder="请输入维护记录(JSON格式)" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="24">
                <el-form-item label="维修历史" prop="repairHistory">
                   <el-input v-model="form.repairHistory" type="textarea" :rows="4" placeholder="请输入维修历史(JSON格式)" />
                </el-form-item>
              </el-col>
            </el-row>
             <el-row>
              <el-col :span="12">
                <el-form-item label="下次维护" prop="nextMaintenanceDate">
                  <el-date-picker clearable v-model="form.nextMaintenanceDate" type="date" value-format="YYYY-MM-DD" placeholder="请选择下次维护日期" style="width: 100%"/>
                </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <el-tab-pane label="更多设置" name="settings">
             <el-row>
              <el-col :span="24">
                <el-form-item label="标签" prop="tags">
                   <el-input v-model="form.tags" type="textarea" placeholder="请输入标签(JSON格式)" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="是否共享" prop="isShared">
                  <el-switch v-model="form.isShared" />
                </el-form-item>
              </el-col>
               <el-col :span="12">
                <el-form-item label="共享给谁" prop="sharedWith" v-if="form.isShared">
                   <el-input v-model="form.sharedWith" placeholder="请输入共享给谁(JSON格式)" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="低电量提醒" prop="lowBatteryReminder">
                   <el-switch v-model="form.lowBatteryReminder" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="保修提醒" prop="warrantyExpireReminder">
                   <el-switch v-model="form.warrantyExpireReminder" />
                </el-form-item>
              </el-col>
            </el-row>
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

<script setup name="Device">
import { listDevice, getDevice, delDevice, addDevice, updateDevice } from "@/api/device";
import { ref, reactive, toRefs, getCurrentInstance } from 'vue';

const { proxy } = getCurrentInstance();

const deviceList = ref([]);
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
    deviceName: null,
    deviceType: null,
    deviceStatus: null
  },
  rules: {
    deviceName: [
      { required: true, message: "设备名称不能为空", trigger: "blur" }
    ],
    deviceType: [
      { required: true, message: "设备类型不能为空", trigger: "blur" }
    ],
    brand: [
      { required: true, message: "品牌不能为空", trigger: "blur" }
    ],
    model: [
      { required: true, message: "型号不能为空", trigger: "blur" }
    ],
    deviceStatus: [
      { required: true, message: "设备状态不能为空", trigger: "change" }
    ],
    storageLocation: [
      { required: true, message: "存放位置不能为空", trigger: "blur" }
    ],
    locationType: [
      { required: true, message: "位置类型不能为空", trigger: "change" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询电子设备列表 */
function getList() {
  loading.value = true;
  listDevice(queryParams.value).then(response => {
    deviceList.value = response.rows;
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
    deviceName: null,
    deviceType: null,
    brand: null,
    model: null,
    serialNumber: null,
    color: null,
    deviceStatus: '已使用',
    purchaseStatus: '已拥有',
    storageLocation: null,
    locationType: null,
    specificSpot: null,
    quantity: 1,
    unitPrice: null,
    totalValue: null,
    currency: 'CNY',
    purchaseDate: null,
    purchaseFrom: null,
    warrantyPeriod: null,
    warrantyEndDate: null,
    invoiceNumber: null,
    startUseDate: null,
    estimatedLifespan: null,
    usageFrequency: null,
    lastUsedDate: null,
    deviceImages: null,
    manualPath: null,
    warrantyCardImage: null,
    invoiceImage: null,
    notes: null,
    importantLevel: '一般',
    specifications: null,
    accessories: null,
    softwareInfo: null,
    maintenanceRecords: null,
    repairHistory: null,
    nextMaintenanceDate: null,
    tags: null,
    isShared: false,
    sharedWith: null,
    lowBatteryReminder: false,
    warrantyExpireReminder: false
  };
  proxy.resetForm("deviceRef");
  activeTab.value = "basic";
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
  title.value = "添加电子设备";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const deviceId = row.id || ids.value;
  getDevice(deviceId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改电子设备";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["deviceRef"].validate(valid => {
    if (valid) {
      if (form.value.id != null) {
        updateDevice(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addDevice(form.value).then(response => {
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
  const deviceIds = row.id || ids.value;
  proxy.$modal.confirm('是否确认删除电子设备编号为"' + deviceIds + '"的数据项？').then(function() {
    return delDevice(deviceIds);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

getList();
</script>
