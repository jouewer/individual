import request from '@/utils/request'

// 查询摄像头列表
export function listCamera(query) {
  return request({
    url: '/camera/list',
    method: 'get',
    params: query
  })
}

// 查询摄像头详细
export function getCamera(id) {
  return request({
    url: '/camera/' + id,
    method: 'get'
  })
}

// 新增摄像头
export function addCamera(data) {
  return request({
    url: '/camera',
    method: 'post',
    data: data
  })
}

// 修改摄像头
export function updateCamera(data) {
  return request({
    url: '/camera',
    method: 'put',
    data: data
  })
}

// 删除摄像头
export function delCamera(ids) {
  return request({
    url: '/camera/' + ids,
    method: 'delete'
  })
}
