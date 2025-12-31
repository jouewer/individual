<template>
  <div class="component-upload-video">
    <el-upload
      multiple
      :disabled="disabled"
      :action="uploadVideoUrl"
      list-type="text"
      :on-success="handleUploadSuccess"
      :before-upload="handleBeforeUpload"
      :data="data"
      :limit="limit"
      :on-error="handleUploadError"
      :on-exceed="handleExceed"
      ref="videoUpload"
      :before-remove="handleDelete"
      :show-file-list="true"
      :headers="headers"
      :file-list="fileList"
      :class="{ hide: fileList.length >= limit }"
    >
      <el-button type="primary">点击上传视频</el-button>
    </el-upload>
    <!-- 上传提示 -->
    <div class="el-upload__tip" v-if="showTip && !disabled">
      请上传
      <template v-if="fileSize">
        大小不超过 <b style="color: #f56c6c">{{ fileSize }}MB</b>
      </template>
      <template v-if="fileType">
        格式为 <b style="color: #f56c6c">{{ fileType.join("/") }}</b>
      </template>
      的文件
    </div>

    <!-- 视频预览列表 -->
    <div class="video-preview-list" v-if="fileList.length > 0">
        <div v-for="(file, index) in fileList" :key="index" class="video-item">
            <video controls width="300" height="200" v-if="file.url">
                <source :src="file.url" type="video/mp4">
                您的浏览器不支持视频播放。
            </video>
            <div class="video-name">{{ file.name }}</div>
        </div>
    </div>
  </div>
</template>

<script setup>
import { getToken } from "@/utils/auth";
import { isExternal } from "@/utils/validate";

const props = defineProps({
  modelValue: [String, Object, Array],
  // 上传接口地址
  action: {
    type: String,
    default: "/common/upload"
  },
  // 上传携带的参数
  data: {
    type: Object
  },
  // 数量限制
  limit: {
    type: Number,
    default: 5
  },
  // 大小限制(MB)
  fileSize: {
    type: Number,
    default: 100 // 视频通常较大
  },
  // 文件类型
  fileType: {
    type: Array,
    default: () => ["mp4", "webm", "ogg"]
  },
  // 是否显示提示
  isShowTip: {
    type: Boolean,
    default: true
  },
  // 禁用组件
  disabled: {
    type: Boolean,
    default: false
  }
});

const { proxy } = getCurrentInstance();
const emit = defineEmits();
const number = ref(0);
const uploadList = ref([]);
const baseUrl = import.meta.env.VITE_APP_BASE_API;
const uploadVideoUrl = ref(import.meta.env.VITE_APP_BASE_API + props.action); // 上传的服务器地址
const headers = ref({ Authorization: "Bearer " + getToken() });
const fileList = ref([]);
const showTip = computed(
  () => props.isShowTip && (props.fileType || props.fileSize)
);

watch(() => props.modelValue, val => {
  if (val) {
    // 首先将值转为数组
    const list = Array.isArray(val) ? val : props.modelValue.split(",");
    // 然后将数组转为对象数组
    fileList.value = list.map(item => {
      if (typeof item === "string") {
        if (item.indexOf(baseUrl) === -1 && !isExternal(item)) {
          item = { name: item, url: baseUrl + item };
        } else {
          item = { name: item, url: item };
        }
      }
      return item;
    });
  } else {
    fileList.value = [];
    return [];
  }
},{ deep: true, immediate: true });

// 上传前loading加载
function handleBeforeUpload(file) {
  let isVideo = false;
  if (props.fileType.length) {
    let fileExtension = "";
    if (file.name.lastIndexOf(".") > -1) {
      fileExtension = file.name.slice(file.name.lastIndexOf(".") + 1);
    }
    isVideo = props.fileType.some(type => {
      if (file.type.indexOf(type) > -1) return true;
      if (fileExtension && fileExtension.indexOf(type) > -1) return true;
      return false;
    });
  } else {
    isVideo = file.type.indexOf("video") > -1;
  }
  if (!isVideo) {
    proxy.$modal.msgError(`文件格式不正确，请上传${props.fileType.join("/")}视频格式文件!`);
    return false;
  }
  if (props.fileSize) {
    const isLt = file.size / 1024 / 1024 < props.fileSize;
    if (!isLt) {
      proxy.$modal.msgError(`上传视频大小不能超过 ${props.fileSize} MB!`);
      return false;
    }
  }
  proxy.$modal.loading("正在上传视频，请稍候...");
  number.value++;
}

// 文件个数超出
function handleExceed() {
  proxy.$modal.msgError(`上传文件数量不能超过 ${props.limit} 个!`);
}

// 上传成功回调
function handleUploadSuccess(res, file) {
  if (res.code === 200) {
    uploadList.value.push({ name: res.fileName, url: res.fileName });
    uploadedSuccessfully();
  } else {
    number.value--;
    proxy.$modal.closeLoading();
    proxy.$modal.msgError(res.msg);
    proxy.$refs.videoUpload.handleRemove(file);
    uploadedSuccessfully();
  }
}

// 删除视频
function handleDelete(file) {
  const findex = fileList.value.map(f => f.name).indexOf(file.name);
  if (findex > -1 && uploadList.value.length === number.value) {
    fileList.value.splice(findex, 1);
    emit("update:modelValue", listToString(fileList.value));
    return false;
  }
}

// 上传结束处理
function uploadedSuccessfully() {
  if (number.value > 0 && uploadList.value.length === number.value) {
    fileList.value = fileList.value.filter(f => f.url !== undefined).concat(uploadList.value);
    uploadList.value = [];
    number.value = 0;
    emit("update:modelValue", listToString(fileList.value));
    proxy.$modal.closeLoading();
  }
}

// 上传失败
function handleUploadError() {
  proxy.$modal.msgError("上传视频失败");
  proxy.$modal.closeLoading();
}

// 对象转成指定字符串分隔
function listToString(list, separator) {
  let strs = "";
  separator = separator || ",";
  for (let i in list) {
    if (undefined !== list[i].url && list[i].url.indexOf("blob:") !== 0) {
      strs += list[i].url.replace(baseUrl, "") + separator;
    }
  }
  return strs != "" ? strs.substr(0, strs.length - 1) : "";
}
</script>

<style scoped lang="scss">
.video-preview-list {
    margin-top: 10px;
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}
.video-item {
    text-align: center;
    border: 1px solid #ddd;
    padding: 5px;
    border-radius: 4px;
}
.video-name {
    margin-top: 5px;
    font-size: 12px;
    color: #666;
    max-width: 300px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
</style>
