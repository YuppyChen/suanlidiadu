<template>
  <div class="main-layout-view">
    <!-- 顶部导航栏 -->
    <TopNavbar @toggle-sidebar="handleToggleSidebar" @menu-select="handleMenuSelect" />

    <!-- 侧边栏菜单 -->
    <SidebarMenu v-model="sidebarVisible" @menu-select="handleSidebarMenuSelect" />

    <!-- 主内容区域 -->
    <div class="main-layout">
      <!-- 左侧菜单 -->
      <LeftSidebar />

      <!-- 右侧内容 -->
      <div class="content-area">
        <slot />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import TopNavbar from '@/components/TopNavbar.vue'
import SidebarMenu from '@/components/SidebarMenu.vue'
import LeftSidebar from '@/components/LeftSidebar.vue'

const router = useRouter()
const sidebarVisible = ref(false)

const handleToggleSidebar = () => {
  sidebarVisible.value = !sidebarVisible.value
}

const handleMenuSelect = (index: string) => {
  console.log('Top menu selected:', index)
}

const handleSidebarMenuSelect = (index: string) => {
  console.log('Sidebar menu selected:', index)
  sidebarVisible.value = false
  
  // Route mapping: menu index -> route name
  const routeMap: Record<string, string> = {
    'scheduling-policy': 'scheduling-policy',
    'resource-pool': 'resource-pool',
    'compute-node': 'compute-node'
  }
  
  const routeName = routeMap[index]
  if (routeName) {
    router.push({ name: routeName })
  }
}
</script>

<style scoped lang="scss">
.main-layout-view {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: #f5f7fa;
}

.main-layout {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.content-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background-color: #fff;
}
</style>
