<template>
  <!-- 遮罩层 -->
  <transition name="fade">
    <div v-if="visible" class="sidebar-overlay" @click="handleClose"></div>
  </transition>

  <!-- 侧边栏 -->
  <transition name="slide">
    <div v-if="visible" class="sidebar-panel">
      <div class="drawer-header">
        <span class="drawer-title">服务目录</span>
        <el-icon class="close-icon" @click="handleClose"><Close /></el-icon>
      </div>

      <div class="sidebar-layout">
        <!-- 左侧快捷导航 -->
        <div class="sidebar-left">
          <div class="section-title">最近访问</div>
          <div class="quick-nav-list">
            <div
              v-for="item in recentItems"
              :key="item.index"
              class="quick-nav-item"
              :class="{ active: activeMenu === item.index }"
              @click="handleMenuSelect(item.index)"
            >
              <span class="nav-text">{{ item.label }}</span>
            </div>
          </div>

          <div class="section-title" style="margin-top: 24px">系统概览</div>
          <div class="quick-nav-list">
            <div
              v-for="item in systemItems"
              :key="item.index"
              class="quick-nav-item"
              :class="{ active: activeMenu === item.index }"
              @click="handleMenuSelect(item.index)"
            >
              <span class="nav-text">{{ item.label }}</span>
            </div>
          </div>
        </div>

        <!-- 右侧服务目录 -->
        <div class="sidebar-right">
          <div class="service-grid">
            <!-- 访问控制 -->
            <div class="service-category">
              <div class="category-header">
                <el-icon><Lock /></el-icon>
                <span class="category-title">访问控制</span>
              </div>
              <div class="service-items">
                <div
                  v-for="item in accessControlItems"
                  :key="item.index"
                  class="service-item"
                  :class="{ active: activeMenu === item.index }"
                  @click="handleMenuSelect(item.index)"
                >
                  {{ item.label }}
                </div>
              </div>
            </div>

            <!-- 资源池纳管 -->
            <div class="service-category">
              <div class="category-header">
                <el-icon><Box /></el-icon>
                <span class="category-title">资源池纳管</span>
              </div>
              <div class="service-items">
                <div
                  v-for="item in resourcePoolItems"
                  :key="item.index"
                  class="service-item"
                  :class="{ active: activeMenu === item.index }"
                  @click="handleMenuSelect(item.index)"
                >
                  {{ item.label }}
                </div>
              </div>
            </div>

            <!-- 工单管理 -->
            <div class="service-category">
              <div class="category-header">
                <el-icon><Document /></el-icon>
                <span class="category-title">工单管理</span>
              </div>
              <div class="service-items">
                <div
                  v-for="item in workOrderItems"
                  :key="item.index"
                  class="service-item"
                  :class="{ active: activeMenu === item.index }"
                  @click="handleMenuSelect(item.index)"
                >
                  {{ item.label }}
                </div>
              </div>
            </div>

            <!-- 统一视图 -->
            <div class="service-category">
              <div class="category-header">
                <el-icon><TakeawayBox /></el-icon>
                <span class="category-title">统一视图</span>
              </div>
              <div class="service-items">
                <div
                  v-for="item in unifiedViewItems"
                  :key="item.index"
                  class="service-item"
                  :class="{ active: activeMenu === item.index }"
                  @click="handleMenuSelect(item.index)"
                >
                  {{ item.label }}
                </div>
              </div>
            </div>

            <!-- 集群联邦管理 -->
            <div class="service-category full-width">
              <div class="category-header">
                <el-icon><Connection /></el-icon>
                <span class="category-title">集群联邦管理</span>
              </div>
              <div class="service-items">
                <div
                  v-for="item in clusterFederationItems"
                  :key="item.index"
                  class="service-item"
                  :class="{ active: activeMenu === item.index }"
                  @click="handleMenuSelect(item.index)"
                >
                  {{ item.label }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Close, Lock, Box, Document, Connection, TakeawayBox } from '@element-plus/icons-vue'

const props = defineProps<{
  modelValue: boolean
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  menuSelect: [index: string]
}>()

const visible = ref(props.modelValue)
const activeMenu = ref('')

// 最近访问
const recentItems = [
  { index: 'system-overview', label: '系统概览' },
  { index: 'user-management', label: '用户管理' },
  { index: 'physical-resources', label: '物理机资源' },
  { index: 'cluster-backup', label: '集群备份' }
]

// 系统概览
const systemItems = [
  { index: 'user-mgmt', label: '用户管理' },
  { index: 'physical-machine', label: '物理机资源' }
]

// 访问控制
const accessControlItems = [
  { index: 'user-management-detail', label: '用户管理' },
  { index: 'role-management', label: '角色管理' },
  { index: 'tenant-management', label: '租户管理' }
]

// 资源池纳管
const resourcePoolItems = [
  { index: 'resource-pool-management', label: '资源池管理' },
  { index: 'compute-node-management', label: '算力节点管理' }
]

// 工单管理
const workOrderItems = [
  { index: 'my-applications', label: '我的申请' },
  { index: 'my-todos', label: '我的待办' },
  { index: 'my-completed', label: '我的已办' },
  { index: 'work-order-settings', label: '工单设置' }
]

// 统一视图
const unifiedViewItems = [
  { index: 'physical-machine-resources', label: '物理机资源' },
  { index: 'virtual-machine-resources', label: '虚拟机资源' },
  { index: 'container-cluster', label: '容器集群' }
]

// 集群联邦管理
const clusterFederationItems = [
  { index: 'cluster-federation-management', label: '集群联邦管理' },
  { index: 'plugin-management', label: '插件管理' },
  { index: 'network-management', label: '网络管理' },
  { index: 'cluster-inspection', label: '集群巡检' },
  { index: 'cluster-backup-detail', label: '集群备份' },
  { index: 'scheduling-policy', label: '调度策略管理' },
  { index: 'unified-image-repo', label: '统一镜像仓库' },
  { index: 'unified-storage-pool', label: '统一存储池' },
  { index: 'container-security', label: '容器安全' }
]

watch(
  () => props.modelValue,
  (newVal) => {
    visible.value = newVal
  }
)

watch(visible, (newVal) => {
  emit('update:modelValue', newVal)
})

const handleClose = () => {
  visible.value = false
}

const handleMenuSelect = (index: string) => {
  activeMenu.value = index
  emit('menuSelect', index)
}
</script>

<style scoped lang="scss">
// 遮罩层
.sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 1000;
}

// 侧边栏面板
.sidebar-panel {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: 67%;
  background-color: #1e2a3a;
  z-index: 1001;
  display: flex;
  flex-direction: column;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.15);
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 24px;
  background-color: #1a2332;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  flex-shrink: 0;

  .drawer-title {
    font-size: 16px;
    font-weight: 600;
    color: #ffffff;
  }

  .close-icon {
    font-size: 18px;
    color: rgba(255, 255, 255, 0.6);
    cursor: pointer;
    transition: color 0.3s;

    &:hover {
      color: #ffffff;
    }
  }
}

.sidebar-layout {
  display: flex;
  flex: 1;
  background-color: #1e2a3a;
  overflow: hidden;
  min-height: 0;
}

// 左侧快捷导航
.sidebar-left {
  width: 220px;
  padding: 0;
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  background-color: #1a2332;
  overflow-y: auto;
  overflow-x: hidden;
  flex-shrink: 0;

  .section-title {
    padding: 16px 12px 10px;
    font-size: 12px;
    font-weight: 600;
    color: rgba(255, 255, 255, 0.45);
    text-transform: uppercase;
    letter-spacing: 0.5px;

    &:first-child {
      padding-top: 16px;
    }
  }

  .quick-nav-list {
    display: flex;
    flex-direction: column;
    gap: 0;
    padding: 0 8px;
  }

  .quick-nav-item {
    padding: 10px 12px;
    color: rgba(255, 255, 255, 0.85);
    font-size: 14px;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;

    &:hover {
      background-color: rgba(64, 158, 255, 0.1);
      color: #ffffff;
    }

    &.active {
      background: linear-gradient(90deg, rgba(64, 158, 255, 0.25) 0%, rgba(64, 158, 255, 0.1) 100%);
      color: #409eff;
      border-left: 3px solid #409eff;
      padding-left: 9px;
    }

    .nav-text {
      font-size: 14px;
    }
  }
}

// 右侧服务目录
.sidebar-right {
  flex: 1;
  padding: 0;
  overflow-y: auto;
  overflow-x: hidden;
  background-color: #1e2a3a;
  min-width: 0;
}

.service-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  padding: 20px 24px;
}

.service-category {
  &.full-width {
    grid-column: 1 / -1;
  }

  .category-header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);

    .el-icon {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.6);
    }

    .category-title {
      font-size: 14px;
      font-weight: 600;
      color: rgba(255, 255, 255, 0.9);
    }
  }

  .service-items {
    display: flex;
    flex-direction: column;
    gap: 6px;

    &.grid-layout {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 8px;
    }
  }

  .service-item {
    padding: 8px 12px;
    color: rgba(255, 255, 255, 0.75);
    font-size: 13px;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
    background-color: rgba(255, 255, 255, 0.03);

    &:hover {
      background-color: rgba(64, 158, 255, 0.15);
      color: #ffffff;
      transform: translateX(4px);
    }

    &.active {
      background: linear-gradient(90deg, rgba(64, 158, 255, 0.25) 0%, rgba(64, 158, 255, 0.1) 100%);
      color: #409eff;
      border-left: 3px solid #409eff;
      padding-left: 9px;
    }
  }
}

// 集群联邦管理特殊布局
.service-category.full-width .service-items {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

// 滚动条样式
.sidebar-left::-webkit-scrollbar,
.sidebar-right::-webkit-scrollbar {
  width: 6px;
}

.sidebar-left::-webkit-scrollbar-track,
.sidebar-right::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 3px;
}

.sidebar-left::-webkit-scrollbar-thumb,
.sidebar-right::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;

  &:hover {
    background: rgba(255, 255, 255, 0.3);
  }
}

// 动画效果
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease;
}

.slide-enter-from,
.slide-leave-to {
  transform: translateX(-100%);
}
</style>
