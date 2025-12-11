<template>
  <div class="left-sidebar">
    <div class="sidebar-menu">
      <div
        v-for="item in menuItems"
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
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Box, List, Operation } from '@element-plus/icons-vue'

interface MenuItem {
  key: string
  label: string
  icon: any
  route: string
}

const router = useRouter()
const route = useRoute()

const menuItems: MenuItem[] = [
  {
    key: 'scheduling-policy',
    label: '调度策略管理',
    icon: Operation,
    route: '/scheduling-policy'
  },
  {
    key: 'resource-pool',
    label: '资源池管理',
    icon: Box,
    route: '/resource-pool'
  },
  {
    key: 'compute-node',
    label: '算力节点管理',
    icon: List,
    route: '/compute-node'
  }
]

const isActive = (key: string) => {
  const item = menuItems.find((m) => m.key === key)
  return item && route.path === item.route
}

const handleMenuClick = (key: string) => {
  const item = menuItems.find((m) => m.key === key)
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

.menu-item {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  cursor: pointer;
  transition: all 0.3s;
  color: #606266;
  position: relative;

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
    font-size: 18px;
    margin-right: 12px;
    color: #909399;
    transition: color 0.3s;
  }

  .menu-text {
    font-size: 14px;
    flex: 1;
  }
}
</style>
