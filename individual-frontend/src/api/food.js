import request from '@/utils/request'

// 查询美食日记列表
export function listFood(query) {
  return request({
    url: '/food/list',
    method: 'get',
    params: query
  })
}

// 查询美食日记详细
export function getFood(id) {
  return request({
    url: '/food/' + id,
    method: 'get'
  })
}

// 新增美食日记
export function addFood(data) {
  return request({
    url: '/food',
    method: 'post',
    data: data
  })
}

// 修改美食日记
export function updateFood(data) {
  return request({
    url: '/food',
    method: 'put',
    data: data
  })
}

// 删除美食日记
export function delFood(ids) {
  return request({
    url: '/food/' + ids,
    method: 'delete'
  })
}
