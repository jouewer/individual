import request from '@/utils/request'

// 查询学习任务列表
export function listTask(query) {
  return request({
    url: '/learning/task/list',
    method: 'get',
    params: query
  })
}

// 查询学习任务详细
export function getTask(taskId) {
  return request({
    url: '/learning/task/' + taskId,
    method: 'get'
  })
}

// 新增学习任务
export function addTask(data) {
  return request({
    url: '/learning/task',
    method: 'post',
    data: data
  })
}

// 修改学习任务
export function updateTask(data) {
  return request({
    url: '/learning/task',
    method: 'put',
    data: data
  })
}

// 删除学习任务
export function delTask(taskId) {
  return request({
    url: '/learning/task/' + taskId,
    method: 'delete'
  })
}
