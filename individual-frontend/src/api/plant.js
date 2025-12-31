import request from '@/utils/request'

// 查询植物列表
export function listPlant(query) {
  return request({
    url: '/plant/list',
    method: 'get',
    params: query
  })
}

// 查询植物详细
export function getPlant(id) {
  return request({
    url: '/plant/' + id,
    method: 'get'
  })
}

// 新增植物
export function addPlant(data) {
  return request({
    url: '/plant',
    method: 'post',
    data: data
  })
}

// 修改植物
export function updatePlant(data) {
  return request({
    url: '/plant',
    method: 'put',
    data: data
  })
}

// 删除植物
export function delPlant(ids) {
  return request({
    url: '/plant/' + ids,
    method: 'delete'
  })
}
