<template>
  <div class="top-navbar">
    <div class="navbar-left">
      <div class="logo-wrapper">
        <img src="@/assets/logo.png" alt="Logo" class="logo-icon" />
        <h1 class="navbar-title">算力调度平台</h1>
      </div>
      <el-menu
        :default-active="activeIndex"
        mode="horizontal"
        class="navbar-menu"
        @select="handleMenuSelect"
      >
        <el-menu-item index="products">
          <el-icon><Grid /></el-icon>
          <span>产品与服务</span>
        </el-menu-item>
      </el-menu>
    </div>
    <div class="navbar-right">
     
      <el-dropdown trigger="click" class="user-dropdown">
        <div class="user-info">
          <el-avatar :size="32" class="user-avatar">
            <el-icon><User /></el-icon>
          </el-avatar>
          <div class="user-info-content">
            <span class="username">cadmin</span>
            <span class="user-role">系统管理员</span>
          </div>
        </div>
        
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item>
              <el-icon><SwitchButton /></el-icon>
              <span>退出登录</span>
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import {
  Bell,
  User,
  Message,
  QuestionFilled,
  Grid,
  Setting,
  SwitchButton
} from '@element-plus/icons-vue'

const activeIndex = ref('products')

const emit = defineEmits<{
  toggleSidebar: []
  menuSelect: [index: string]
}>()

const toggleSidebar = () => {
  emit('toggleSidebar')
}

const handleMenuSelect = (index: string) => {
  activeIndex.value = index
  if (index === 'products') {
    toggleSidebar()
  }
  emit('menuSelect', index)
}
</script>

<style scoped lang="scss">
.top-navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
  padding: 0 24px;
  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);

  .navbar-left {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 24px;

    .logo-wrapper {
      display: flex;
      align-items: center;
      gap: 12px;

      .logo-icon {
        height: 32px;
        width: auto;
        object-fit: contain;
      }

      .navbar-title {
        font-size: 18px;
        font-weight: 600;
        color: #ffffff;
        margin: 0;
        letter-spacing: 0.5px;
      }
    }

    .navbar-menu {
      border-bottom: none;
      background-color: transparent;
      flex-shrink: 0;
      min-width: 500px;
      color: rgba(255, 255, 255, 255);

      :deep(.el-menu-item) {
        height: 64px;
        line-height: 64px;
        padding: 0 20px;
        border-bottom: 3px solid transparent;
        font-size: 14px;
        background-color: transparent;
        color: #ffffff !important;
        transition: all 0.3s;
        white-space: nowrap !important;
        overflow: visible !important;
        min-width: auto !important;
        max-width: none !important;
        text-overflow: clip !important;
        width: auto !important;

        * {
          white-space: nowrap !important;
          overflow: visible !important;
          text-overflow: clip !important;
        }

        span {
          display: inline-block;
          white-space: nowrap !important;
          overflow: visible !important;
          text-overflow: clip !important;
          color: #ffffff !important;
        }

        .el-icon {
          margin-right: 6px;
          font-size: 16px;
          color: #ffffff !important;
        }

        &:hover {
          color: #ffffff !important;
          background-color: rgba(255, 255, 255, 0.1) !important;
        }

      }
    }
  }

  .navbar-right {
    flex: 0 0 auto;
    display: flex;
    align-items: center;
    gap: 16px;

    .notification-badge {
      :deep(.el-badge__content) {
        background-color: #f56c6c;
        border: 2px solid #2c3e50;
      }
    }

    .icon-button {
      background-color: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.2);
      color: rgba(255, 255, 255, 0.9);
      transition: all 0.3s;

      &:hover {
        background-color: rgba(255, 255, 255, 0.2);
        border-color: rgba(255, 255, 255, 0.3);
        color: #ffffff;
      }
    }

    .user-info {
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 8px;

      .user-info-content {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
      }

      .username {
        font-size: 14px;
        color: #ffffff;
        font-weight: 500;
      }

      .user-role {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.7);
      }
    }

    .user-dropdown {
      cursor: pointer;

      .user-avatar {
        background: linear-gradient(135deg, #409eff 0%, #5cadff 100%);
        border: 2px solid rgba(255, 255, 255, 0.3);
        transition: all 0.3s;

        &:hover {
          transform: scale(1.05);
          border-color: rgba(255, 255, 255, 0.5);
        }
      }
    }
  }
}
</style>
