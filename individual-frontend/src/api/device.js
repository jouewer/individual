import request from '@/utils/request'

// 查询电子设备列表
export function listDevice(query) {
  return request({
    url: '/device/list',
    method: 'get',
    params: query
  })
}

// 查询电子设备详细
export function getDevice(deviceId) {
  return request({
    url: '/device/' + deviceId,
    method: 'get'
  })
}

// 新增电子设备
export function addDevice(data) {
  return request({
    url: '/device',
    method: 'post',
    data: data
  })
}

// 修改电子设备
export function updateDevice(data) {
  return request({
    url: '/device',
    method: 'put',
    data: data
  })
}

// 删除电子设备
export function delDevice(deviceId) {
  return request({
    url: '/device/' + deviceId,
    method: 'delete'
  })
}
