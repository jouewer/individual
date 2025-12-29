import request from '@/utils/request'

// 查询足迹旅行列表
export function listTravel(query) {
  return request({
    url: '/travel/list',
    method: 'get',
    params: query
  })
}

// 查询足迹旅行详细
export function getTravel(id) {
  return request({
    url: '/travel/' + id,
    method: 'get'
  })
}

// 新增足迹旅行
export function addTravel(data) {
  return request({
    url: '/travel',
    method: 'post',
    data: data
  })
}

// 修改足迹旅行
export function updateTravel(data) {
  return request({
    url: '/travel',
    method: 'put',
    data: data
  })
}

// 删除足迹旅行
export function delTravel(ids) {
  return request({
    url: '/travel/' + ids,
    method: 'delete'
  })
}
