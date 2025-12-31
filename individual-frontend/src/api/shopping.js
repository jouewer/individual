import request from '@/utils/request'

// 查询节日购物列表
export function listShopping(query) {
  return request({
    url: '/shopping/list',
    method: 'get',
    params: query
  })
}

// 查询节日购物详细
export function getShopping(shoppingId) {
  return request({
    url: '/shopping/' + shoppingId,
    method: 'get'
  })
}

// 新增节日购物
export function addShopping(data) {
  return request({
    url: '/shopping',
    method: 'post',
    data: data
  })
}

// 修改节日购物
export function updateShopping(data) {
  return request({
    url: '/shopping',
    method: 'put',
    data: data
  })
}

// 删除节日购物
export function delShopping(shoppingId) {
  return request({
    url: '/shopping/' + shoppingId,
    method: 'delete'
  })
}
