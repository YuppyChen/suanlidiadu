<template>
  <div class="home">
    <!-- 顶部导航栏 -->
    <TopNavbar @toggle-sidebar="handleToggleSidebar" @menu-select="handleMenuSelect" />

    <!-- 侧边栏菜单 -->
    <SidebarMenu v-model="sidebarVisible" @menu-select="handleSidebarMenuSelect" />

    <!-- 主要内容区域 -->
    <div class="main-content">
      <div class="content-header">
        <el-button type="primary">
          <el-icon><Search /></el-icon>
          搜索
        </el-button>
      </div>
      <div class="content-body">
        <el-table :data="tableData" style="width: 100%">
          <el-table-column prop="status" label="状态" width="120">
            <template #default>
              <el-tag type="success">启用</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="name" label="名称" />
          <el-table-column label="操作" width="200">
            <template #default>
              <el-link type="primary" :underline="false">编辑</el-link>
              <el-divider direction="vertical" />
              <el-link type="primary" :underline="false">启用</el-link>
            </template>
          </el-table-column>
        </el-table>
        <div class="pagination-wrapper">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            :page-sizes="[10, 20, 50, 100]"
            :total="20"
            layout="total, sizes, prev, pager, next, jumper"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Search } from '@element-plus/icons-vue'
import TopNavbar from '@/components/TopNavbar.vue'
import SidebarMenu from '@/components/SidebarMenu.vue'

const router = useRouter()

const sidebarVisible = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)

const tableData = ref([
  {
    name: '资源池1',
    status: '启用'
  },
  {
    name: '资源池2',
    status: '启用'
  },
  {
    name: '资源池3',
    status: '启用'
  },
  {
    name: '资源池4',
    status: '启用'
  }
])

const handleToggleSidebar = () => {
  sidebarVisible.value = !sidebarVisible.value
}

const handleMenuSelect = (index: string) => {
  console.log('Menu selected:', index)
}

const handleSidebarMenuSelect = (index: string) => {
  console.log('Sidebar menu selected:', index)
  // 关闭侧边栏
  sidebarVisible.value = false

  // 根据选择的菜单项进行路由跳转
  if (index === 'resource-pool-management' || index === 'compute-node-management') {
    // 跳转到资源池管理页面
    router.push('/resource-pool')
  }
}
</script>

<style scoped lang="scss">
.home {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 24px;
  background-color: #f5f7fa;
  overflow: hidden;
}

.content-header {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 16px;
}

.content-body {
  flex: 1;
  background-color: #fff;
  border-radius: 4px;
  padding: 20px;
  overflow: auto;
  display: flex;
  flex-direction: column;

  .pagination-wrapper {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
  }
}
</style>
