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
      <el-tooltip content="切换视图" placement="top">
        <el-button circle icon="Menu" @click="toggleView" />
      </el-tooltip>
    </el-row>

    <div v-if="!isCardView">
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
            <el-button link type="primary" icon="View" @click="handleView(scope.row)">详情</el-button>
            <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div v-else v-loading="loading">
      <el-empty v-if="groupedHolidayList.length === 0" description="暂无数据" />
      <div v-else>
        <el-card v-for="group in groupedHolidayList" :key="group.name" class="box-card mb-4" shadow="hover" style="margin-bottom: 20px;">
          <template #header>
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span style="font-weight: bold; font-size: 16px;">{{ group.name }}</span>
                <el-tag size="small" style="margin-left: 10px;" effect="dark">{{ group.list[0].holidayType }}</el-tag>
              </div>
              <span style="color: #909399; font-size: 14px;">{{ parseTime(group.date, '{y}-{m}-{d}') }}</span>
            </div>
          </template>
          <div v-for="item in group.list" :key="item.id" class="text item" style="padding: 10px 0; border-bottom: 1px solid #EBEEF5;">
            <el-row :gutter="20" align="middle" style="cursor: pointer;" @click="handleView(item)">
              <el-col :span="3" @click.stop>
                 <el-image 
                    v-if="item.coverImage"
                    :src="getRealUrl(item.coverImage)"
                    :preview-src-list="[getRealUrl(item.coverImage)]"
                    :preview-teleported="true"
                    style="width: 60px; height: 60px; border-radius: 4px;" 
                    fit="cover"
                 />
                 <div v-else style="width: 60px; height: 60px; background: #f5f7fa; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #909399;">
                    <el-icon :size="20"><Picture /></el-icon>
                 </div>
              </el-col>
              <el-col :span="5">
                <div style="font-weight: bold;">{{ item.scheduleTitle }}</div>
                <div style="font-size: 12px; color: #909399;">{{ item.scheduleType }}</div>
              </el-col>
              <el-col :span="6">
                <div style="font-size: 14px;">
                  <el-icon><Clock /></el-icon> {{ item.startTime }} - {{ item.endTime }}
                </div>
              </el-col>
              <el-col :span="6">
                <div style="font-size: 14px;">
                  <el-icon><Location /></el-icon> {{ item.locationName }}
                  <span v-if="item.address" style="color: #909399; font-size: 12px;">({{ item.address }})</span>
                </div>
              </el-col>
              <el-col :span="4" style="text-align: right;">
                <el-button link type="primary" icon="Edit" @click.stop="handleUpdate(item)">修改</el-button>
                <el-button link type="primary" icon="Delete" @click.stop="handleDelete(item)">删除</el-button>
              </el-col>
            </el-row>
          </div>
        </el-card>
      </div>
    </div>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- Add/Edit Dialog -->
    <el-dialog :title="title" v-model="open" width="900px" append-to-body>
      <el-form ref="holidayRef" :model="form" :rules="rules" label-width="100px">
        <el-tabs type="border-card">
          <!-- Tab 1: 基础信息 -->
          <el-tab-pane label="基础信息">
            <el-row>
              <el-col :span="12">
                <el-form-item label="节日名称" prop="holidayName">
                  <el-input v-model="form.holidayName" placeholder="请输入节日名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="日程标题" prop="scheduleTitle">
                  <el-input v-model="form.scheduleTitle" placeholder="请输入日程标题" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
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
                <el-form-item label="类型" prop="holidayType">
                  <el-select v-model="form.holidayType" placeholder="请选择类型" style="width: 100%">
                    <el-option label="传统节日" value="传统节日" />
                    <el-option label="法定节假日" value="法定节假日" />
                    <el-option label="特殊日" value="特殊日" />
                    <el-option label="个人纪念日" value="个人纪念日" />
                    <el-option label="其他" value="其他" />
                  </el-select>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="8">
                <el-form-item label="开始时间" prop="startTime">
                   <el-time-picker
                    v-model="form.startTime"
                    placeholder="选择时间"
                    value-format="HH:mm:ss"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="结束时间" prop="endTime">
                   <el-time-picker
                    v-model="form.endTime"
                    placeholder="选择时间"
                    value-format="HH:mm:ss"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="全天" prop="allDay">
                  <el-switch v-model="form.allDay" :active-value="1" :inactive-value="0" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
               <el-col :span="12">
                <el-form-item label="日程类型" prop="scheduleType">
                  <el-select v-model="form.scheduleType" placeholder="请选择或输入" allow-create filterable style="width: 100%">
                    <el-option label="家庭聚会" value="家庭聚会" />
                    <el-option label="朋友聚会" value="朋友聚会" />
                    <el-option label="旅行计划" value="旅行计划" />
                    <el-option label="其他活动" value="其他活动" />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                 <el-form-item label="持续(分)" prop="durationMinutes">
                   <el-input-number v-model="form.durationMinutes" :min="0" style="width: 100%" />
                 </el-form-item>
              </el-col>
            </el-row>
          </el-tab-pane>

          <!-- Tab 2: 地点与详情 -->
          <el-tab-pane label="地点与详情">
            <el-row>
              <el-col :span="12">
                <el-form-item label="地点名称" prop="locationName">
                  <el-input v-model="form.locationName" placeholder="请输入地点名称" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="详细地址" prop="address">
                  <el-input v-model="form.address" placeholder="请输入详细地址" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item label="经度" prop="longitude">
                  <el-input-number v-model="form.longitude" :precision="6" style="width: 100%" />
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="纬度" prop="latitude">
                  <el-input-number v-model="form.latitude" :precision="6" style="width: 100%" />
                </el-form-item>
              </el-col>
            </el-row>
            <el-form-item label="具体内容" prop="content">
              <el-input v-model="form.content" type="textarea" :rows="3" placeholder="具体内容/做什么" />
            </el-form-item>
            <el-form-item label="描述" prop="description">
              <el-input v-model="form.description" type="textarea" :rows="3" placeholder="描述" />
            </el-form-item>
            <el-form-item label="准备工作" prop="preparation">
              <el-input v-model="form.preparation" type="textarea" :rows="3" placeholder="准备工作/怎么做" />
            </el-form-item>
          </el-tab-pane>

          <!-- Tab 3: 清单与物资 -->
          <el-tab-pane label="清单与物资">
            <el-form-item label="购物清单" prop="shoppingList">
              <el-input v-model="form.shoppingList" type="textarea" placeholder='JSON格式或文本，例如: ["苹果", "香蕉"]' />
            </el-form-item>
            <el-form-item label="所需物品" prop="requiredItems">
              <el-input v-model="form.requiredItems" type="textarea" placeholder='JSON格式或文本' />
            </el-form-item>
            <el-form-item label="清单(Check)" prop="checklist">
              <el-input v-model="form.checklist" type="textarea" placeholder='JSON格式或文本' />
            </el-form-item>
            <el-form-item label="参与人员" prop="participants">
              <el-input v-model="form.participants" type="textarea" placeholder='JSON格式或文本' />
            </el-form-item>
            <el-row>
               <el-col :span="8">
                 <el-form-item label="预算" prop="budget">
                   <el-input-number v-model="form.budget" :min="0" :precision="2" style="width: 100%" />
                 </el-form-item>
               </el-col>
               <el-col :span="8">
                 <el-form-item label="实际花费" prop="actualCost">
                   <el-input-number v-model="form.actualCost" :min="0" :precision="2" style="width: 100%" />
                 </el-form-item>
               </el-col>
               <el-col :span="8">
                 <el-form-item label="币种" prop="currency">
                   <el-input v-model="form.currency" placeholder="CNY" />
                 </el-form-item>
               </el-col>
            </el-row>
          </el-tab-pane>

          <!-- Tab 4: 状态与多媒体 -->
          <el-tab-pane label="状态与多媒体">
             <el-row>
               <el-col :span="12">
                 <el-form-item label="状态" prop="status">
                   <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
                     <el-option label="计划中" value="计划中" />
                     <el-option label="进行中" value="进行中" />
                     <el-option label="已完成" value="已完成" />
                     <el-option label="取消" value="取消" />
                     <el-option label="延期" value="延期" />
                   </el-select>
                 </el-form-item>
               </el-col>
               <el-col :span="12">
                 <el-form-item label="有效性" prop="isActive">
                   <el-switch v-model="form.isActive" :active-value="1" :inactive-value="0" />
                 </el-form-item>
               </el-col>
             </el-row>
             <el-row>
               <el-col :span="12">
                 <el-form-item label="是否重复" prop="isRepeat">
                    <el-switch v-model="form.isRepeat" :active-value="1" :inactive-value="0" />
                 </el-form-item>
               </el-col>
               <el-col :span="12">
                 <el-form-item label="重复规则" prop="repeatRule">
                    <el-input v-model="form.repeatRule" placeholder="例如: 每周一" />
                 </el-form-item>
               </el-col>
             </el-row>
             <el-form-item label="提醒时间" prop="reminderTime">
                <el-date-picker v-model="form.reminderTime" type="datetime" placeholder="选择提醒时间" value-format="YYYY-MM-DD HH:mm:ss" style="width: 100%" />
             </el-form-item>
             <el-form-item label="封面图片" prop="coverImage">
                <image-upload v-model="form.coverImage" :limit="1" />
             </el-form-item>
             <el-form-item label="图片记录" prop="images">
                <image-upload v-model="form.images" :limit="10" />
             </el-form-item>
             <el-form-item label="视频链接" prop="videos">
                <file-upload v-model="form.videos" :file-type="['mp4', 'avi', 'mov', 'webm', 'mkv']" :limit="5" />
             </el-form-item>
             <el-form-item label="菜谱" prop="recipes">
                <el-input v-model="form.recipes" type="textarea" placeholder='JSON格式' />
             </el-form-item>
             <el-form-item label="文档" prop="documents">
                <el-input v-model="form.documents" type="textarea" placeholder='JSON格式' />
             </el-form-item>
          </el-tab-pane>

          <!-- Tab 5: 评价与隐私 -->
          <el-tab-pane label="评价与隐私">
             <el-row>
               <el-col :span="8">
                 <el-form-item label="评分" prop="rating">
                   <el-rate v-model="form.rating" />
                 </el-form-item>
               </el-col>
               <el-col :span="8">
                 <el-form-item label="精力消耗" prop="energyLevel">
                   <el-slider v-model="form.energyLevel" :min="1" :max="5" show-stops />
                 </el-form-item>
               </el-col>
               <el-col :span="8">
                 <el-form-item label="满意度" prop="satisfactionLevel">
                   <el-slider v-model="form.satisfactionLevel" :min="1" :max="5" show-stops />
                 </el-form-item>
               </el-col>
             </el-row>
             <el-form-item label="心情" prop="mood">
               <el-input v-model="form.mood" placeholder="例如: 开心, 疲惫" />
             </el-form-item>
             <el-form-item label="回顾/总结" prop="review">
               <el-input v-model="form.review" type="textarea" :rows="3" />
             </el-form-item>
             <el-form-item label="亮点" prop="highlights">
               <el-input v-model="form.highlights" type="textarea" placeholder='JSON格式' />
             </el-form-item>
             <el-form-item label="经验教训" prop="lessonsLearned">
               <el-input v-model="form.lessonsLearned" type="textarea" />
             </el-form-item>
             
             <el-row>
               <el-col :span="12">
                 <el-form-item label="隐私级别" prop="privacyLevel">
                    <el-select v-model="form.privacyLevel" placeholder="请选择" style="width: 100%">
                      <el-option label="公开" value="公开" />
                      <el-option label="好友可见" value="好友可见" />
                      <el-option label="仅自己" value="仅自己" />
                    </el-select>
                 </el-form-item>
               </el-col>
               <el-col :span="12">
                 <el-form-item label="可见性" prop="visibility">
                    <el-input v-model="form.visibility" />
                 </el-form-item>
               </el-col>
             </el-row>
             <el-form-item label="分享给" prop="shareWith">
                <el-input v-model="form.shareWith" type="textarea" placeholder='JSON格式用户列表' />
             </el-form-item>
             
             <el-form-item label="标签" prop="tags">
                <el-input v-model="form.tags" type="textarea" placeholder='JSON格式标签数组' />
             </el-form-item>
             
             <el-row>
                <el-col :span="12">
                  <el-form-item label="关联足迹ID" prop="relatedFootprintId">
                     <el-input v-model="form.relatedFootprintId" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                   <el-form-item label="模板ID" prop="templateId">
                      <el-input v-model="form.templateId" />
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

    <!-- View Dialog -->
    <el-dialog title="节日详情" v-model="viewDialogVisible" width="900px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="节日名称">{{ viewForm.holidayName }}</el-descriptions-item>
        <el-descriptions-item label="日程标题">{{ viewForm.scheduleTitle }}</el-descriptions-item>
        <el-descriptions-item label="节日日期">{{ viewForm.holidayDate }}</el-descriptions-item>
        <el-descriptions-item label="类型">
          <el-tag size="small">{{ viewForm.holidayType }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="时间">{{ viewForm.startTime }} - {{ viewForm.endTime }}</el-descriptions-item>
        <el-descriptions-item label="日程类型">{{ viewForm.scheduleType }}</el-descriptions-item>
        <el-descriptions-item label="地点">{{ viewForm.locationName }}</el-descriptions-item>
        <el-descriptions-item label="地址">{{ viewForm.address }}</el-descriptions-item>
        <el-descriptions-item label="经度">{{ viewForm.longitude }}</el-descriptions-item>
        <el-descriptions-item label="纬度">{{ viewForm.latitude }}</el-descriptions-item>
        <el-descriptions-item label="全天">{{ viewForm.allDay ? '是' : '否' }}</el-descriptions-item>
        <el-descriptions-item label="持续时间">{{ viewForm.durationMinutes }} 分钟</el-descriptions-item>
        
        <el-descriptions-item label="状态">
          <el-tag v-if="viewForm.status" type="success">{{ viewForm.status }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="有效性">{{ viewForm.isActive ? '有效' : '无效' }}</el-descriptions-item>
        <el-descriptions-item label="重复">{{ viewForm.isRepeat ? '是' : '否' }}</el-descriptions-item>
        <el-descriptions-item label="重复规则">{{ viewForm.repeatRule }}</el-descriptions-item>
        <el-descriptions-item label="提醒时间">{{ viewForm.reminderTime }}</el-descriptions-item>
        
        <el-descriptions-item label="心情">{{ viewForm.mood }}</el-descriptions-item>
        <el-descriptions-item label="评分">
           <el-rate v-model="viewForm.rating" disabled show-score text-color="#ff9900" />
        </el-descriptions-item>
        <el-descriptions-item label="精力消耗">{{ viewForm.energyLevel }} / 5</el-descriptions-item>
        <el-descriptions-item label="满意度">{{ viewForm.satisfactionLevel }} / 5</el-descriptions-item>
        
        <el-descriptions-item label="可见性">{{ viewForm.visibility }}</el-descriptions-item>
        <el-descriptions-item label="隐私级别">{{ viewForm.privacyLevel }}</el-descriptions-item>
        
        <el-descriptions-item label="预算">
          {{ viewForm.budget }} {{ viewForm.currency }}
        </el-descriptions-item>
        <el-descriptions-item label="实际花费">
          {{ viewForm.actualCost }} {{ viewForm.currency }}
        </el-descriptions-item>

        <el-descriptions-item label="标签" :span="2">
          <div v-if="viewForm.tags">
             <el-tag v-for="tag in parseTags(viewForm.tags)" :key="tag" style="margin-right: 5px;">{{ tag }}</el-tag>
          </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="参与人员" :span="2">
          <div v-if="viewForm.participants">
             <el-tag type="info" v-for="(p, index) in parseTags(viewForm.participants)" :key="index" style="margin-right: 5px;">{{ p }}</el-tag>
          </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="分享给" :span="2">
          <div v-if="viewForm.shareWith">
             <el-tag type="warning" v-for="(u, index) in parseTags(viewForm.shareWith)" :key="index" style="margin-right: 5px;">{{ u }}</el-tag>
          </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="购物清单" :span="2">
          <div v-if="viewForm.shoppingList">
             <ul style="padding-left: 20px; margin: 0;">
                <li v-for="(item, index) in parseTags(viewForm.shoppingList)" :key="index">{{ item }}</li>
             </ul>
          </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="所需物品" :span="2">
          <div v-if="viewForm.requiredItems">
             <ul style="padding-left: 20px; margin: 0;">
                <li v-for="(item, index) in parseTags(viewForm.requiredItems)" :key="index">{{ item }}</li>
             </ul>
          </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="清单(Checklist)" :span="2">
          <div v-if="viewForm.checklist">
             <ul style="padding-left: 20px; margin: 0;">
                <li v-for="(item, index) in parseTags(viewForm.checklist)" :key="index">{{ item }}</li>
             </ul>
          </div>
        </el-descriptions-item>

        <el-descriptions-item label="具体内容" :span="2">
           <div style="white-space: pre-wrap;">{{ viewForm.content }}</div>
        </el-descriptions-item>
        
        <el-descriptions-item label="描述" :span="2">
           <div style="white-space: pre-wrap;">{{ viewForm.description }}</div>
        </el-descriptions-item>
        
        <el-descriptions-item label="准备工作" :span="2">
           <div style="white-space: pre-wrap;">{{ viewForm.preparation }}</div>
        </el-descriptions-item>
        
        <el-descriptions-item label="回顾/总结" :span="2">
           <div style="white-space: pre-wrap;">{{ viewForm.review }}</div>
        </el-descriptions-item>
        
        <el-descriptions-item label="经验教训" :span="2">
           <div style="white-space: pre-wrap;">{{ viewForm.lessonsLearned }}</div>
        </el-descriptions-item>
        
        <el-descriptions-item label="亮点/精彩时刻" :span="2">
           <div v-if="viewForm.highlights">
              <el-tag type="success" v-for="(h, index) in parseTags(viewForm.highlights)" :key="index" style="margin-right: 5px; margin-bottom: 5px;">{{ h }}</el-tag>
           </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="封面图片" :span="2">
           <el-image 
             v-if="viewForm.coverImage" 
             :src="getRealUrl(viewForm.coverImage)" 
             :preview-src-list="[getRealUrl(viewForm.coverImage)]"
             style="max-width: 200px; max-height: 200px;" 
             fit="cover"
           />
        </el-descriptions-item>
        
        <el-descriptions-item label="图片记录" :span="2">
           <div v-if="viewForm.images">
              <el-image 
                v-for="(img, index) in parseTags(viewForm.images)" 
                :key="index" 
                :src="getRealUrl(img)" 
                :preview-src-list="parseTags(viewForm.images).map(url => getRealUrl(url))"
                :initial-index="index"
                style="max-width: 100px; max-height: 100px; margin-right: 10px; margin-bottom: 10px;" 
                fit="cover"
              />
           </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="视频链接" :span="2">
           <div v-if="viewForm.videos">
              <div v-for="(v, index) in parseTags(viewForm.videos)" :key="index" style="margin-bottom: 10px;">
                 <video :src="getRealUrl(v)" controls style="max-width: 400px; max-height: 300px;"></video>
              </div>
           </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="菜谱" :span="2">
           <div v-if="viewForm.recipes">
              <pre>{{ parseTags(viewForm.recipes) }}</pre>
           </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="文档" :span="2">
           <div v-if="viewForm.documents">
              <div v-for="(d, index) in parseTags(viewForm.documents)" :key="index">
                 <a :href="d" target="_blank">{{ d }}</a>
              </div>
           </div>
        </el-descriptions-item>
        
        <el-descriptions-item label="关联足迹ID">{{ viewForm.relatedFootprintId }}</el-descriptions-item>
        <el-descriptions-item label="模板ID">{{ viewForm.templateId }}</el-descriptions-item>
        
        <el-descriptions-item label="创建时间">{{ viewForm.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ viewForm.updateTime }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="() => { viewDialogVisible = false; handleUpdate(viewForm); }">修 改</el-button>
          <el-button @click="viewDialogVisible = false">关 闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { listHoliday, getHoliday, delHoliday, addHoliday, updateHoliday } from "@/api/holiday";
import { ref, reactive, toRefs, getCurrentInstance, computed } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { Clock, Location, Menu, Picture } from '@element-plus/icons-vue';
import ImageUpload from "@/components/ImageUpload";
import FileUpload from "@/components/FileUpload";
import { isExternal } from "@/utils/validate";

const baseUrl = import.meta.env.VITE_APP_BASE_API;

function getRealUrl(path) {
  if (!path) return '';
  if (isExternal(path)) return path;
  if (path.startsWith('http')) return path;
  return baseUrl + path;
}

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
const isCardView = ref(true); // Default to card view

// View Dialog Logic
const viewDialogVisible = ref(false);
const viewForm = ref({});

function handleView(row) {
  viewForm.value = { ...row };
  viewDialogVisible.value = true;
}

function parseTags(jsonStr) {
  if (!jsonStr) return [];
  try {
    if (Array.isArray(jsonStr)) return jsonStr;
    return JSON.parse(jsonStr);
  } catch (e) {
    if (typeof jsonStr === 'string' && jsonStr.includes(',')) {
      return jsonStr.split(',');
    }
    return [jsonStr];
  }
}

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    holidayName: null,
    holidayType: null
  },
  rules: {
    holidayName: [
      { required: true, message: "节日名称不能为空", trigger: "blur" }
    ],
    holidayDate: [
      { required: true, message: "节日日期不能为空", trigger: "blur" }
    ]
  }
});

const { queryParams, form, rules } = toRefs(data);

const groupedHolidayList = computed(() => {
  const groups = new Map();
  holidayList.value.forEach(item => {
    const name = item.holidayName || '未命名节日';
    if (!groups.has(name)) {
      groups.set(name, []);
    }
    groups.get(name).push(item);
  });
  
  // Convert map to array and maybe sort by date if needed
  // Here we just use the order of appearance or sort by the first item's date
  return Array.from(groups.entries()).map(([name, list]) => ({
    name,
    list,
    date: list[0].holidayDate
  }));
});

function toggleView() {
  isCardView.value = !isCardView.value;
}

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
    address: undefined,
    allDay: 1,
    status: '计划中',
    currency: 'CNY',
    isRepeat: 0,
    isActive: 1,
    privacyLevel: '仅自己',
    budget: 0,
    actualCost: 0,
    rating: 0,
    energyLevel: 0,
    satisfactionLevel: 0
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
    // Handle JSON fields for ImageUpload/FileUpload compatibility
    if (form.value.images) {
      const parsed = parseTags(form.value.images);
      if (Array.isArray(parsed)) {
        form.value.images = parsed.join(',');
      }
    }
    if (form.value.videos) {
      const parsed = parseTags(form.value.videos);
      if (Array.isArray(parsed)) {
        form.value.videos = parsed.join(',');
      }
    }
    open.value = true;
    title.value = "修改节假快乐";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["holidayRef"].validate(valid => {
    if (valid) {
      if (form.value.id != undefined) {
        ElMessageBox.confirm('是否确认修改？', "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => {
          updateHoliday(form.value).then(response => {
            ElMessage.success("修改成功");
            open.value = false;
            getList();
          });
        }).catch(() => {});
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
