<template>
  <div class="left-sidebar">
    <div class="sidebar-menu">
      <!-- 调度管理 -->
      <div class="menu-group">
        <div class="group-header">
          <span class="group-title">调度管理</span>
        </div>
        <div
          v-for="item in schedulingMenuItems"
          :key="item.key"
          class="menu-item"
          :class="{ active: activeMenu === item.key }"
          @click="handleMenuClick(item.key)"
        >
          <el-icon class="menu-icon">
            <component :is="item.icon" />
          </el-icon>
          <span class="menu-text">{{ item.label }}</span>
        </div>
      </div>

      <!-- 资源池纳管 -->
      <div class="menu-group">
        <div class="group-header">
          <span class="group-title">资源池纳管</span>
        </div>
        <div
          v-for="item in resourceMenuItems"
          :key="item.key"
          class="menu-item"
          :class="{ active: activeMenu === item.key }"
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
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Box, List, Operation } from '@element-plus/icons-vue'

interface MenuItem {
  key: string
  label: string
  icon: any
}

const props = defineProps<{
  defaultActive?: string
}>()

const emit = defineEmits<{
  menuSelect: [key: string]
}>()

const activeMenu = ref(props.defaultActive || 'resource-pool')

// 监听 props 变化
watch(
  () => props.defaultActive,
  (newValue) => {
    if (newValue) {
      activeMenu.value = newValue
    }
  }
)

// 调度管理菜单
const schedulingMenuItems: MenuItem[] = [
  {
    key: 'scheduling-policy',
    label: '调度策略管理',
    icon: Operation
  }
]

// 资源池纳管菜单
const resourceMenuItems: MenuItem[] = [
  {
    key: 'resource-pool',
    label: '资源池管理',
    icon: Box
  },
  {
    key: 'compute-category',
    label: '算力分类管理',
    icon: List
  }
]

const handleMenuClick = (key: string) => {
  activeMenu.value = key
  emit('menuSelect', key)
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
}

.group-header {
  padding: 12px 16px 8px;

  .group-title {
    font-size: 13px;
    font-weight: 600;
    color: #909399;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
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
