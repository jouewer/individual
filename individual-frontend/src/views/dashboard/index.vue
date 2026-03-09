<template>
  <div class="digital-twin-container" ref="dashboardContainer">
    <div class="header-section">
      <h1 class="title">individual大屏</h1>
      <div class="fullscreen-btn" @click="toggleFullScreen">
        <el-button type="primary" plain size="small">
          {{ isFullscreen ? '退屏' : '全屏' }}
        </el-button>
      </div>
    </div>

    <el-row :gutter="20" class="main-content">
      <!-- 左侧列 -->
      <el-col :span="6">
        <div class="panel-box">
          <div class="panel-header">足迹旅行 & 节假快乐</div>
          <div class="chart-container" ref="travelHolidayChart"></div>
        </div>
        <div class="panel-box">
          <div class="panel-header">节日购物 & 每日美食</div>
          <div class="chart-container" ref="shoppingFoodChart"></div>
        </div>
        <div class="panel-box">
          <div class="panel-header">植物生长监测</div>
          <div class="chart-container" ref="plantChart"></div>
        </div>
      </el-col>

      <!-- 中间列 -->
      <el-col :span="12">
        <div class="center-panel">
          <div class="center-map-container" ref="centerMapChart"></div>
          <div class="stats-cards">
             <el-row :gutter="10">
               <el-col :span="6" v-for="(item, index) in statsData" :key="index">
                 <div class="stat-item">
                   <div class="stat-value">{{ item.value }}</div>
                   <div class="stat-label">{{ item.label }}</div>
                 </div>
               </el-col>
             </el-row>
          </div>
        </div>
        <div class="bottom-panel">
          <el-row :gutter="20">
            <el-col :span="12">
              <div class="panel-box">
                 <div class="panel-header">考试管理分析</div>
                 <div class="chart-container" ref="examChart"></div>
              </div>
            </el-col>
            <el-col :span="12">
               <div class="panel-box">
                 <div class="panel-header">学习任务进度</div>
                 <div class="chart-container" ref="studyChart"></div>
              </div>
            </el-col>
          </el-row>
        </div>
      </el-col>

      <!-- 右侧列 -->
      <el-col :span="6">
        <div class="panel-box">
          <div class="panel-header">动作检测数据</div>
          <div class="chart-container" ref="actionChart"></div>
        </div>
        <div class="panel-box">
          <div class="panel-header">摄像管理监控</div>
          <div class="chart-container" ref="cameraChart"></div>
        </div>
        <div class="panel-box">
          <div class="panel-header">电子设备状态</div>
          <div class="chart-container" ref="deviceChart"></div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import * as echarts from 'echarts';
import { onMounted, onUnmounted, ref, reactive } from 'vue';

defineOptions({
  name: "DashBoard",
});

// Refs for chart DOM elements
const travelHolidayChart = ref(null);
const shoppingFoodChart = ref(null);
const plantChart = ref(null);
const centerMapChart = ref(null);
const examChart = ref(null);
const studyChart = ref(null);
const actionChart = ref(null);
const cameraChart = ref(null);
const deviceChart = ref(null);

// Chart instances
let charts = [];

const statsData = reactive([
  { label: '系统总运行时间', value: '365天' },
  { label: '接入设备总数', value: '128个' },
  { label: '今日活跃用户', value: '1,024' },
  { label: '异常告警次数', value: '3' },
]);

const initCharts = () => {
  // 1. 足迹旅行 & 节假快乐 (Bar Chart)
  const chart1 = echarts.init(travelHolidayChart.value);
  chart1.setOption({
    tooltip: { trigger: 'axis' },
    legend: { textStyle: { color: '#fff' }, data: ['足迹', '节假'] },
    xAxis: { type: 'category', data: ['一月', '二月', '三月', '四月', '五月'], axisLabel: { color: '#fff' } },
    yAxis: { type: 'value', axisLabel: { color: '#fff' }, splitLine: { lineStyle: { color: 'rgba(255,255,255,0.1)' } } },
    series: [
      { name: '足迹', type: 'bar', data: [12, 19, 3, 5, 2], itemStyle: { color: '#00d2ff' } },
      { name: '节假', type: 'bar', data: [2, 3, 20, 9, 11], itemStyle: { color: '#3a7bd5' } }
    ]
  });
  charts.push(chart1);

  // 2. 节日购物 & 每日美食 (Pie Chart)
  const chart2 = echarts.init(shoppingFoodChart.value);
  chart2.setOption({
    tooltip: { trigger: 'item' },
    legend: { orient: 'vertical', left: 'left', textStyle: { color: '#fff' } },
    series: [
      {
        name: '消费占比',
        type: 'pie',
        radius: '70%',
        data: [
          { value: 1048, name: '购物', itemStyle: { color: '#ff9a9e' } },
          { value: 735, name: '美食', itemStyle: { color: '#fad0c4' } },
          { value: 580, name: '其他', itemStyle: { color: '#a18cd1' } }
        ],
        emphasis: { itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)' } }
      }
    ]
  });
  charts.push(chart2);

  // 3. 植物生长监测 (Line Chart)
  const chart3 = echarts.init(plantChart.value);
  chart3.setOption({
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'category', data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], axisLabel: { color: '#fff' } },
    yAxis: { type: 'value', axisLabel: { color: '#fff' }, splitLine: { lineStyle: { color: 'rgba(255,255,255,0.1)' } } },
    series: [
      { data: [15, 23, 22, 21, 24, 25, 26], type: 'line', smooth: true, itemStyle: { color: '#84fab0' }, areaStyle: { color: 'rgba(132, 250, 176, 0.3)' } }
    ]
  });
  charts.push(chart3);

  // 4. 中心综合态势 (Radar Chart simulating Digital Twin core)
  const chart4 = echarts.init(centerMapChart.value);
  chart4.setOption({
    radar: {
      indicator: [
        { name: '健康', max: 100 },
        { name: '效率', max: 100 },
        { name: '安全', max: 100 },
        { name: '资源', max: 100 },
        { name: '成长', max: 100 },
        { name: '娱乐', max: 100 }
      ],
      axisName: { color: '#00d2ff', fontSize: 14 },
      splitArea: { areaStyle: { color: ['rgba(0, 210, 255, 0.1)', 'rgba(0, 210, 255, 0.2)'] } },
      splitLine: { lineStyle: { color: 'rgba(0, 210, 255, 0.5)' } }
    },
    series: [
      {
        type: 'radar',
        data: [
          {
            value: [80, 90, 85, 70, 95, 60],
            name: '综合评分',
            itemStyle: { color: '#00d2ff' },
            areaStyle: { color: 'rgba(0, 210, 255, 0.4)' }
          }
        ]
      }
    ]
  });
  charts.push(chart4);

  // 5. 考试管理分析 (Gauge Chart)
  const chart5 = echarts.init(examChart.value);
  chart5.setOption({
    series: [
      {
        type: 'gauge',
        startAngle: 180,
        endAngle: 0,
        min: 0,
        max: 100,
        splitNumber: 10,
        axisLine: { lineStyle: { width: 6, color: [[0.25, '#FF6E76'], [0.5, '#FDDD60'], [0.75, '#58D9F9'], [1, '#7CFFB2']] } },
        pointer: { icon: 'path://M12.8,0.7l12,40.1H0.7L12.8,0.7z', length: '12%', width: 20, offsetCenter: [0, '-60%'], itemStyle: { color: 'auto' } },
        axisTick: { length: 12, lineStyle: { color: 'auto', width: 2 } },
        splitLine: { length: 20, lineStyle: { color: 'auto', width: 5 } },
        axisLabel: { color: '#fff', fontSize: 14, distance: -40, formatter: function (value) { if (value === 0 || value === 100) { return value; } return ''; } },
        title: { offsetCenter: [0, '-20%'], fontSize: 20, color: '#fff' },
        detail: { fontSize: 30, offsetCenter: [0, '20%'], valueAnimation: true, formatter: function (value) { return Math.round(value) + '%'; }, color: '#fff' },
        data: [{ value: 87, name: '考试及格率' }]
      }
    ]
  });
  charts.push(chart5);

  // 6. 学习任务进度 (Stacked Bar)
  const chart6 = echarts.init(studyChart.value);
  chart6.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    legend: { textStyle: { color: '#fff' } },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: { type: 'value', axisLabel: { color: '#fff' }, splitLine: { lineStyle: { color: 'rgba(255,255,255,0.1)' } } },
    yAxis: { type: 'category', data: ['Python', 'Vue', 'Java', 'SQL'], axisLabel: { color: '#fff' } },
    series: [
      { name: '已完成', type: 'bar', stack: 'total', label: { show: true }, emphasis: { focus: 'series' }, data: [320, 302, 301, 334], itemStyle: { color: '#4facfe' } },
      { name: '进行中', type: 'bar', stack: 'total', label: { show: true }, emphasis: { focus: 'series' }, data: [120, 132, 101, 134], itemStyle: { color: '#00f2fe' } },
    ]
  });
  charts.push(chart6);

  // 7. 动作检测数据 (Scatter)
  const chart7 = echarts.init(actionChart.value);
  chart7.setOption({
    xAxis: { scale: true, axisLabel: { color: '#fff' }, splitLine: { lineStyle: { color: 'rgba(255,255,255,0.1)' } } },
    yAxis: { scale: true, axisLabel: { color: '#fff' }, splitLine: { lineStyle: { color: 'rgba(255,255,255,0.1)' } } },
    series: [
      {
        type: 'scatter',
        symbolSize: 10,
        data: [[10.0, 8.04], [8.0, 6.95], [13.0, 7.58], [9.0, 8.81], [11.0, 8.33], [14.0, 9.96], [6.0, 7.24], [4.0, 4.26], [12.0, 10.84], [7.0, 4.82], [5.0, 5.68]],
        itemStyle: { color: '#ff0844' }
      }
    ]
  });
  charts.push(chart7);

  // 8. 摄像管理监控 (Pie Doughnut)
  const chart8 = echarts.init(cameraChart.value);
  chart8.setOption({
    tooltip: { trigger: 'item' },
    legend: { top: '5%', left: 'center', textStyle: { color: '#fff' } },
    series: [
      {
        name: '设备状态',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
        label: { show: false, position: 'center' },
        emphasis: { label: { show: true, fontSize: 20, fontWeight: 'bold' } },
        labelLine: { show: false },
        data: [
          { value: 10, name: '在线', itemStyle: { color: '#43e97b' } },
          { value: 2, name: '离线', itemStyle: { color: '#fa709a' } },
          { value: 1, name: '故障', itemStyle: { color: '#fddb92' } }
        ]
      }
    ]
  });
  charts.push(chart8);

  // 9. 电子设备状态 (Gauge Speedometer)
  const chart9 = echarts.init(deviceChart.value);
  chart9.setOption({
    series: [
      {
        type: 'gauge',
        progress: { show: true, width: 18 },
        axisLine: { lineStyle: { width: 18 } },
        axisTick: { show: false },
        splitLine: { length: 15, lineStyle: { width: 2, color: '#999' } },
        axisLabel: { distance: 25, color: '#999', fontSize: 12 },
        anchor: { show: true, showAbove: true, size: 25, itemStyle: { borderWidth: 10 } },
        title: { show: false },
        detail: { valueAnimation: true, fontSize: 20, offsetCenter: [0, '70%'], color: '#fff' },
        data: [{ value: 70, name: 'CPU Load' }]
      }
    ]
  });
  charts.push(chart9);
};

const dashboardContainer = ref(null);
const isFullscreen = ref(false);

const toggleFullScreen = () => {
  if (!document.fullscreenElement) {
    if (dashboardContainer.value) {
      dashboardContainer.value.requestFullscreen();
    }
    isFullscreen.value = true;
  } else {
    if (document.exitFullscreen) {
      document.exitFullscreen();
      isFullscreen.value = false;
    }
  }
};

onMounted(() => {
  initCharts();
  window.addEventListener('resize', handleResize);
  
  // Auto fullscreen on mount
  // Note: Browsers block auto-fullscreen without user interaction. 
  // We'll try, but it might fail until user interacts.
  // A better UX pattern is to let user click the button.
  // However, requested to try auto-fullscreen logic if possible or just show button.
  // Adding event listener to detect fullscreen change (e.g. via ESC key)
  document.addEventListener('fullscreenchange', () => {
    isFullscreen.value = !!document.fullscreenElement;
  });
  
  // Try auto fullscreen on mount (likely to be blocked by browser policy without interaction)
  // toggleFullScreen(); 
});

onUnmounted(() => {
  window.removeEventListener('resize', handleResize);
  document.removeEventListener('fullscreenchange', () => {});
  charts.forEach(chart => chart.dispose());
});

const handleResize = () => {
  charts.forEach(chart => chart.resize());
};
</script>

<style scoped lang="scss">
.digital-twin-container {
  background-color: #0b1120;
  min-height: 100vh;
  color: #fff;
  padding: 20px;
  background-image: 
    radial-gradient(at 0% 0%, rgba(56, 189, 248, 0.1) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(139, 92, 246, 0.1) 0px, transparent 50%);
  overflow-x: hidden;
  
  /* Ensure container covers full screen in fullscreen mode */
  &:fullscreen {
    width: 100vw;
    height: 100vh;
    overflow-y: auto;
    padding: 20px;
  }
}

.header-section {
  text-align: center;
  margin-bottom: 30px;
  border-bottom: 1px solid rgba(56, 189, 248, 0.3);
  padding-bottom: 10px;
  position: relative;
  
  .title {
    font-size: 32px;
    font-weight: bold;
    background: linear-gradient(to right, #00d2ff, #3a7bd5);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin: 0;
    letter-spacing: 2px;
    text-shadow: 0 0 20px rgba(0, 210, 255, 0.5);
  }
  
  .subtitle {
    color: #94a3b8;
    font-size: 14px;
    margin-top: 5px;
    text-transform: uppercase;
    letter-spacing: 5px;
  }

  .fullscreen-btn {
    position: absolute;
    right: 20px;
    top: 50%;
    transform: translateY(-50%);
  }
}

.panel-box {
  background: rgba(30, 41, 59, 0.5);
  border: 1px solid rgba(56, 189, 248, 0.2);
  border-radius: 10px;
  padding: 15px;
  margin-bottom: 20px;
  backdrop-filter: blur(10px);
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
  
  &:hover {
    border-color: rgba(56, 189, 248, 0.6);
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.2);
    transform: translateY(-2px);
  }
}

.panel-header {
  font-size: 16px;
  font-weight: bold;
  color: #38bdf8;
  margin-bottom: 15px;
  padding-left: 10px;
  border-left: 4px solid #38bdf8;
}

.chart-container {
  width: 100%;
  height: 200px;
}

.center-panel {
  background: rgba(15, 23, 42, 0.6);
  border-radius: 15px;
  padding: 20px;
  margin-bottom: 20px;
  border: 1px solid rgba(139, 92, 246, 0.3);
  height: 440px; /* Adjust based on content */
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.center-map-container {
  width: 100%;
  height: 300px;
}

.stats-cards {
  margin-top: 20px;
  
  .stat-item {
    background: rgba(56, 189, 248, 0.1);
    border-radius: 8px;
    padding: 15px 10px;
    text-align: center;
    border: 1px solid rgba(56, 189, 248, 0.2);
    
    .stat-value {
      font-size: 20px;
      font-weight: bold;
      color: #fff;
      margin-bottom: 5px;
    }
    
    .stat-label {
      font-size: 12px;
      color: #94a3b8;
    }
  }
}
</style>