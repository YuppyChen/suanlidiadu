<template>
  <div class="left-sidebar">
    <div class="sidebar-menu">
      <!-- 调度管理分组 -->
      <div v-if="currentGroup === 'scheduling'" class="menu-group">
        <div class="group-title">
          <el-icon class="group-icon">
            <Operation />
          </el-icon>
          <span class="group-text">调度管理</span>
        </div>
        <div class="group-items">
          <div
            v-for="item in schedulingItems"
            :key="item.key"
            class="menu-item"
            :class="{ active: isActive(item.key) }"
            @click="handleMenuClick(item.key)"
          >
            <el-icon class="menu-icon">
              <component :is="item.icon" />
            </el-icon>
            <span class="menu-text">{{ item.label }}</span>
          </div>
        </div>
      </div>

      <!-- 资源池管理分组 -->
      <div v-if="currentGroup === 'resource-pool'" class="menu-group">
        <div class="group-title">
          <el-icon class="group-icon">
            <Box />
          </el-icon>
          <span class="group-text">资源池管理</span>
        </div>
        <div class="group-items">
          <div
            v-for="item in resourcePoolItems"
            :key="item.key"
            class="menu-item"
            :class="{ active: isActive(item.key) }"
            @click="handleMenuClick(item.key)"
          >
            <el-icon class="menu-icon">
              <component :is="item.icon" />
            </el-icon>
            <span class="menu-text">{{ item.label }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Box, Operation, Files } from '@element-plus/icons-vue'

interface MenuItem {
  key: string
  label: string
  icon: any
  route: string
}

const router = useRouter()
const route = useRoute()

// 调度管理菜单项
const schedulingItems: MenuItem[] = [
  {
    key: 'scheduling-policy',
    label: '调度策略管理',
    icon: Files,
    route: '/scheduling-policy'
  }
]

// 资源池管理菜单项
const resourcePoolItems: MenuItem[] = [
  {
    key: 'resource-pool',
    label: '资源池管理',
    icon: Box,
    route: '/resource-pool'
  },
  {
    key: 'compute-node',
    label: '算力节点管理',
    icon: Files,
    route: '/compute-node'
  }
]

// 根据当前路由判断应该显示哪个分组
const currentGroup = computed(() => {
  const path = route.path
  if (path === '/scheduling-policy') {
    return 'scheduling'
  } else if (path === '/resource-pool' || path === '/compute-node') {
    return 'resource-pool'
  }
  return 'resource-pool' // 默认显示资源池管理
})

const isActive = (key: string) => {
  const allItems = [...schedulingItems, ...resourcePoolItems]
  const item = allItems.find((m) => m.key === key)
  return item && route.path === item.route
}

const handleMenuClick = (key: string) => {
  const allItems = [...schedulingItems, ...resourcePoolItems]
  const item = allItems.find((m) => m.key === key)
  if (item) {
    router.push(item.route)
  }
}
</script>

<style scoped lang="scss">
.left-sidebar {
  width: 200px;
  height: 100%;
  background-color: #fff;
  border-right: 1px solid #e4e7ed;
  display: flex;
  flex-direction: column;
}

.sidebar-menu {
  flex: 1;
  padding: 8px 0;
  overflow-y: auto;
}

.menu-group {
  margin-bottom: 16px;

  &:last-child {
    margin-bottom: 0;
  }

  .group-title {
    display: flex;
    align-items: center;
    padding: 12px 16px 8px;
    color: #909399;
    font-size: 13px;
    font-weight: 600;
    cursor: default;

    .group-icon {
      font-size: 16px;
      margin-right: 8px;
    }

    .group-text {
      flex: 1;
    }
  }

  .group-items {
    padding: 0;
  }
}

.menu-item {
  display: flex;
  align-items: center;
  padding: 10px 16px 10px 40px;
  cursor: pointer;
  transition: all 0.3s;
  color: #606266;
  position: relative;
  font-size: 14px;

  &:hover {
    background-color: #f5f7fa;
    color: #409eff;
  }

  &.active {
    background-color: #e6f4ff;
    color: #409eff;

    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 3px;
      background-color: #409eff;
    }

    .menu-icon {
      color: #409eff;
    }
  }

  .menu-icon {
    font-size: 16px;
    margin-right: 8px;
    color: #909399;
    transition: color 0.3s;
  }

  .menu-text {
    flex: 1;
  }
}
</style>
