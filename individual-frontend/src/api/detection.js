import request from '@/utils/request'

// 查询综合检测列表
export function listDetection(query) {
  return request({
    url: '/action/list',
    method: 'get',
    params: query
  })
}

// 查询综合检测详细
export function getDetection(detectionId) {
  return request({
    url: '/action/' + detectionId,
    method: 'get'
  })
}
