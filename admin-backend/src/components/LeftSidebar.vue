<template>
  <div class="left-sidebar">
    <div class="sidebar-header">
      <span class="header-title">资源池纳管</span>
    </div>
    <div class="sidebar-menu">
      <div
        v-for="item in menuItems"
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
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Box, List } from '@element-plus/icons-vue'

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

const menuItems: MenuItem[] = [
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

.sidebar-header {
  padding: 16px;
  border-bottom: 1px solid #e4e7ed;
  background-color: #fff;

  .header-title {
    font-size: 16px;
    font-weight: 600;
    color: #303133;
  }
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
