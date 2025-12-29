import request from '@/utils/request'

// 查询节假快乐列表
export function listHoliday(query) {
  return request({
    url: '/holiday/list',
    method: 'get',
    params: query
  })
}

// 查询节假快乐详细
export function getHoliday(id) {
  return request({
    url: '/holiday/' + id,
    method: 'get'
  })
}

// 新增节假快乐
export function addHoliday(data) {
  return request({
    url: '/holiday',
    method: 'post',
    data: data
  })
}

// 修改节假快乐
export function updateHoliday(data) {
  return request({
    url: '/holiday',
    method: 'put',
    data: data
  })
}

// 删除节假快乐
export function delHoliday(ids) {
  return request({
    url: '/holiday/' + ids,
    method: 'delete'
  })
}
