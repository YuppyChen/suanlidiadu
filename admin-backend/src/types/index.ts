// 通用类型定义
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
}

export interface PageParams {
  page: number
  size: number
}

export interface PageResult<T = any> {
  list: T[]
  total: number
  page: number
  size: number
}

// 用户相关类型
export interface User {
  id: number
  username: string
  nickname: string
  email: string
  avatar?: string
  status: 0 | 1 // 0: 禁用, 1: 启用
  createTime: string
  updateTime: string
}
