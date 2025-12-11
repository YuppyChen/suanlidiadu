<template>
  <div class="resource-pool-view">
    <!-- 顶部导航栏 -->
    <TopNavbar @toggle-sidebar="handleToggleSidebar" @menu-select="handleMenuSelect" />

    <!-- 侧边栏菜单 -->
    <SidebarMenu v-model="sidebarVisible" @menu-select="handleSidebarMenuSelect" />

    <!-- 主内容区域 -->
    <div class="main-layout">
      <!-- 左侧菜单 -->
      <LeftSidebar :default-active="activeLeftMenu" @menu-select="handleLeftMenuSelect" />

      <!-- 右侧内容 -->
      <div class="content-area">
        <!-- 资源池管理 -->
        <div v-if="activeLeftMenu === 'resource-pool'" class="content-wrapper">
          <!-- 页面标题 -->
          <div class="page-header">
            <h2 class="page-title">资源池管理</h2>
          </div>

          <!-- 内容区 -->
          <div class="content-section">
            <!-- 操作栏 -->
            <div class="toolbar">
              <el-button type="primary" @click="handleAdd">
                <el-icon><Plus /></el-icon>
                新建
              </el-button>
              <el-button @click="handleSync">
                <el-icon><Refresh /></el-icon>
                同步信息
              </el-button>
              <el-button :disabled="selectedRows.length === 0" @click="handleBatchDelete">
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
              <div class="toolbar-right">
                <el-input
                  v-model="searchText"
                  placeholder="搜索"
                  class="search-input"
                  clearable
                >
                  <template #suffix>
                    <el-icon class="search-icon"><Search /></el-icon>
                  </template>
                </el-input>
              </div>
            </div>

            <!-- 数据表格 -->
            <el-table
              :data="filteredData"
              @selection-change="handleSelectionChange"
              class="resource-table"
            >
              <el-table-column type="selection" width="55" />
              <el-table-column prop="name" label="资源池名称" sortable>
                <template #default="{ row }">
                  <el-link type="primary" :underline="false" @click="handleView(row)">
                    {{ row.name }}
                  </el-link>
                  <el-tag v-if="row.location" size="small" class="name-tag">
                    {{ row.location }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="cpuCores" label="录入CPU总数（核）" width="150" />
              <el-table-column prop="memorySize" label="录入内存大小（GB）" width="160" />
              <el-table-column prop="gpuCount" label="录入GPU卡数量" width="140" />
              <el-table-column prop="status" label="资源纳管数量" width="140" />
              <el-table-column prop="createdAt" label="创建时间" width="180" />
              <el-table-column label="操作" width="140" fixed="right">
                <template #default="{ row }">
                  <el-link type="primary" :underline="false" @click="handleEdit(row)">
                    编辑
                  </el-link>
                  <el-divider direction="vertical" />
                  <el-link type="primary" :underline="false" @click="handleDelete(row)">
                    移除
                  </el-link>
                </template>
              </el-table-column>
            </el-table>

            <!-- 分页 -->
            <div class="pagination-wrapper">
              <span class="pagination-total">共{{ filteredData.length }}条，</span>
              <el-pagination
                v-model:current-page="currentPage"
                v-model:page-size="pageSize"
                :page-sizes="[10, 20, 50, 100]"
                :total="filteredData.length"
                layout="sizes, prev, pager, next"
                class="pagination"
              />
            </div>
          </div>
        </div>

        <!-- 算力节点管理 -->
        <div v-else-if="activeLeftMenu === 'compute-category'" class="content-wrapper">
          <div class="page-header">
            <h2 class="page-title">算力节点管理</h2>
          </div>

          <!-- 内容区 -->
          <div class="content-section">
            <!-- 操作栏 -->
            <div class="toolbar">
              <el-button type="primary" @click="handleAddNode">
                <el-icon><Plus /></el-icon>
                新增
              </el-button>
              <el-button @click="handleSyncNode">
                <el-icon><Refresh /></el-icon>
                同步数据
              </el-button>
              <el-button :disabled="selectedNodeRows.length === 0" @click="handleBatchDeleteNode">
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
              <div class="toolbar-right">
                <el-input
                  v-model="nodeSearchText"
                  placeholder="搜索"
                  class="search-input"
                  clearable
                >
                  <template #suffix>
                    <el-icon class="search-icon"><Search /></el-icon>
                  </template>
                </el-input>
              </div>
            </div>

            <!-- 数据表格 -->
            <el-table
              :data="filteredNodeData"
              @selection-change="handleNodeSelectionChange"
              class="resource-table"
            >
              <el-table-column type="selection" width="55" />
              <el-table-column prop="name" label="算力节点名称" sortable>
                <template #default="{ row }">
                  <el-link type="primary" :underline="false" @click="handleViewNode(row)">
                    {{ row.name }}
                  </el-link>
                  <el-tag v-if="row.location" size="small" class="name-tag">
                    {{ row.location }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="nodeCount" label="节点数量" width="120" />
              <el-table-column prop="resourcePool" label="资源池" width="180" />
              <el-table-column prop="createdAt" label="创建时间" width="180" />
              <el-table-column label="操作" width="140" fixed="right">
                <template #default="{ row }">
                  <el-link type="primary" :underline="false" @click="handleEditNode(row)">
                    编辑
                  </el-link>
                  <el-divider direction="vertical" />
                  <el-link type="primary" :underline="false" @click="handleDeleteNode(row)">
                    移除
                  </el-link>
                </template>
              </el-table-column>
            </el-table>

            <!-- 分页 -->
            <div class="pagination-wrapper">
              <span class="pagination-total">共{{ filteredNodeData.length }}条，</span>
              <el-pagination
                v-model:current-page="nodeCurrentPage"
                v-model:page-size="nodePageSize"
                :page-sizes="[10, 20, 50, 100]"
                :total="filteredNodeData.length"
                layout="sizes, prev, pager, next"
                class="pagination"
              />
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="800px"
      :close-on-click-modal="false"
      class="edit-dialog"
    >
      <el-form :model="formData" :rules="formRules" ref="formRef" label-width="120px">
        <el-form-item label="名称" prop="name" required>
          <el-input v-model="formData.name" placeholder="Resource-Pool01" />
        </el-form-item>

        <el-form-item label="地域信息" prop="location" required>
          <el-select v-model="formData.location" placeholder="请选择" style="width: 100%">
            <el-option label="北京" value="北京" />
            <el-option label="上海" value="上海" />
            <el-option label="广州" value="广州" />
            <el-option label="深圳" value="深圳" />
          </el-select>
        </el-form-item>

        <el-form-item label="描述">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入描述信息"
          />
        </el-form-item>

        <div class="form-section-title">资源录入</div>

        <el-form-item label="CPU总数">
          <el-input-number
            v-model="formData.cpuCores"
            :min="1"
            :step="1"
            controls-position="right"
          />
          <span style="margin-left: 8px">核</span>
        </el-form-item>

        <el-form-item label="内存总大小">
          <el-input v-model="formData.memorySize" placeholder="请输入" style="width: 200px" />
          <span style="margin-left: 8px">GB</span>
        </el-form-item>

        <el-form-item label="GPU资源">
          <div
            v-for="(gpu, index) in formData.gpuList"
            :key="index"
            style="display: flex; gap: 12px; margin-bottom: 12px; align-items: center"
          >
            <el-select v-model="gpu.brand" placeholder="请选择" style="width: 200px">
              <el-option label="NVIDA" value="NVIDA" />
              <el-option label="AMD" value="AMD" />
            </el-select>
            <el-input v-model="gpu.count" placeholder="请输入数量" style="width: 200px" />
            <el-button
              v-if="formData.gpuList.length > 1"
              :icon="Close"
              circle
              @click="removeGpu(index)"
            />
          </div>
          <el-button type="primary" :icon="Plus" text @click="addGpu"> 添加 </el-button>
        </el-form-item>

        <el-form-item label="公网IP池">
          <div
            v-for="(ip, index) in formData.ipList"
            :key="index"
            style="display: flex; gap: 12px; margin-bottom: 12px; align-items: center"
          >
            <el-input v-model="formData.ipList[index]" placeholder="输入公网IP" />
            <el-button
              v-if="formData.ipList.length > 1"
              :icon="Close"
              circle
              @click="removeIp(index)"
            />
          </div>
          <el-button type="primary" :icon="Plus" text @click="addIp"> 添加 </el-button>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 算力节点编辑弹窗 -->
    <el-dialog
      v-model="nodeDialogVisible"
      :title="nodeDialogTitle"
      width="800px"
      :close-on-click-modal="false"
      class="edit-dialog node-dialog"
    >
      <!-- 步骤指示器 -->
      <el-steps :active="nodeCurrentStep" align-center class="node-steps">
        <el-step title="基本信息" />
        <el-step title="连接设置" />
      </el-steps>

      <!-- 第一步：基本信息 -->
      <div v-show="nodeCurrentStep === 0" class="step-content">
        <el-form
          :model="nodeFormData"
          :rules="nodeFormRules"
          ref="nodeFormRef"
          label-width="120px"
        >
          <el-form-item label="算力节点名称" prop="name" required>
            <el-input v-model="nodeFormData.name" placeholder="请输入名称" />
          </el-form-item>

          <el-form-item label="资源池" prop="resourcePool" required>
            <el-select
              v-model="nodeFormData.resourcePool"
              placeholder="请选择"
              style="width: 100%"
            >
              <el-option
                v-for="pool in tableData"
                :key="pool.id"
                :label="pool.name"
                :value="pool.name"
              />
            </el-select>
          </el-form-item>

          <el-form-item label="别名">
            <el-input v-model="nodeFormData.alias" placeholder="请输入别名" />
          </el-form-item>

          <el-form-item label="描述">
            <el-input
              v-model="nodeFormData.description"
              type="textarea"
              :rows="3"
              placeholder="请输入描述信息"
            />
          </el-form-item>
        </el-form>
      </div>

      <!-- 第二步：连接设置 -->
      <div v-show="nodeCurrentStep === 1" class="step-content">
        <el-form
          :model="nodeFormData"
          :rules="nodeFormRules"
          ref="nodeFormRef2"
          label-width="120px"
        >
          <el-form-item label="连接方式" required>
            <el-radio-group v-model="nodeFormData.connectionType">
              <el-radio-button label="direct">直接连接</el-radio-button>
              <el-radio-button label="proxy">代理连接</el-radio-button>
            </el-radio-group>
            <el-icon style="margin-left: 8px; color: #909399; cursor: help">
              <QuestionFilled />
            </el-icon>
          </el-form-item>

          <div class="kubeconfig-section">
            <div class="section-label">成员集群 kubeconfig</div>
            <el-input
              v-model="nodeFormData.kubeconfig"
              type="textarea"
              :rows="15"
              placeholder="请输入 kubeconfig 内容"
              class="kubeconfig-input"
            />
          </div>
        </el-form>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button v-if="nodeCurrentStep === 1" @click="handleNodePrevStep">上一步</el-button>
          <el-button v-if="nodeCurrentStep === 0" @click="nodeDialogVisible = false"
            >取消</el-button
          >
          <el-button v-if="nodeCurrentStep === 0" type="primary" @click="handleNodeNextStep"
            >下一步</el-button
          >
          <el-button v-if="nodeCurrentStep === 1" type="primary" @click="handleNodeSubmit"
            >确定</el-button
          >
          <el-button v-if="nodeCurrentStep === 1" @click="nodeDialogVisible = false"
            >取消</el-button
          >
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Search, Refresh, Plus, Delete, Close, QuestionFilled } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import TopNavbar from '@/components/TopNavbar.vue'
import SidebarMenu from '@/components/SidebarMenu.vue'
import LeftSidebar from '@/components/LeftSidebar.vue'

interface GpuResource {
  brand: string
  count: string
}

interface ResourcePool {
  id: string
  name: string
  location: string
  description: string
  cpuCores: number
  memorySize: string
  gpuList: GpuResource[]
  gpuCount: number
  ipList: string[]
  status: string
  createdAt: string
}

interface ComputeNode {
  id: string
  name: string
  location: string
  alias: string
  description: string
  resourcePool: string
  nodeCount: number
  connectionType: 'direct' | 'proxy'
  kubeconfig: string
  createdAt: string
}

const STORAGE_KEY = 'resource_pool_data'
const NODE_STORAGE_KEY = 'compute_node_data'

const sidebarVisible = ref(false)
const activeLeftMenu = ref('resource-pool')
const searchText = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const selectedRows = ref<ResourcePool[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('新建')
const formRef = ref<FormInstance>()
const tableData = ref<ResourcePool[]>([])

// 算力节点相关状态
const nodeSearchText = ref('')
const nodeCurrentPage = ref(1)
const nodePageSize = ref(10)
const selectedNodeRows = ref<ComputeNode[]>([])
const nodeDialogVisible = ref(false)
const nodeDialogTitle = ref('新增算力节点')
const nodeCurrentStep = ref(0)
const nodeFormRef = ref<FormInstance>()
const nodeFormRef2 = ref<FormInstance>()
const nodeTableData = ref<ComputeNode[]>([])

// 表单数据
const formData = ref<ResourcePool>({
  id: '',
  name: '',
  location: '',
  description: '',
  cpuCores: 1,
  memorySize: '',
  gpuList: [{ brand: '', count: '' }],
  gpuCount: 0,
  ipList: [''],
  status: '已纳管0/总数量0',
  createdAt: ''
})

// 表单验证规则
const formRules: FormRules = {
  name: [{ required: true, message: '请输入名称', trigger: 'blur' }],
  location: [{ required: true, message: '请选择地域信息', trigger: 'change' }]
}

// 算力节点表单数据
const nodeFormData = ref<ComputeNode>({
  id: '',
  name: '',
  location: '',
  alias: '',
  description: '',
  resourcePool: '',
  nodeCount: 25,
  connectionType: 'direct',
  kubeconfig: '',
  createdAt: ''
})

// 算力节点表单验证规则
const nodeFormRules: FormRules = {
  name: [{ required: true, message: '请输入算力节点名称', trigger: 'blur' }],
  resourcePool: [{ required: true, message: '请选择资源池', trigger: 'change' }]
}

// 初始化默认数据
const initDefaultData = (): ResourcePool[] => {
  return [
    {
      id: '1',
      name: 'Resource-Pool01',
      location: '北京',
      description: '',
      cpuCores: 25,
      memorySize: '1256',
      gpuList: [{ brand: 'NVIDA', count: '12' }],
      gpuCount: 12,
      ipList: [],
      status: '已纳管4/总数量7',
      createdAt: '2024-01-17 19:43:23'
    },
    {
      id: '2',
      name: 'Resource-Pool02',
      location: '上海',
      description: '',
      cpuCores: 25,
      memorySize: '1256',
      gpuList: [{ brand: 'NVIDA', count: '12' }],
      gpuCount: 12,
      ipList: [],
      status: '已纳管4/总数量7',
      createdAt: '2024-01-17 19:43:23'
    }
  ]
}

// 从本地存储加载数据
const loadData = () => {
  const stored = localStorage.getItem(STORAGE_KEY)
  if (stored) {
    try {
      tableData.value = JSON.parse(stored)
    } catch (e) {
      tableData.value = initDefaultData()
      saveData()
    }
  } else {
    tableData.value = initDefaultData()
    saveData()
  }
}

// 保存数据到本地存储
const saveData = () => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(tableData.value))
}

// 算力节点初始化默认数据
const initDefaultNodeData = (): ComputeNode[] => {
  return [
    {
      id: '1',
      name: 'Computing-node01',
      location: '北京',
      alias: '',
      description: '',
      resourcePool: 'Resource-Pool01',
      nodeCount: 25,
      connectionType: 'direct',
      kubeconfig: '',
      createdAt: '2024-01-17 19:43:23'
    },
    {
      id: '2',
      name: 'Computing-node02',
      location: '上海',
      alias: '',
      description: '',
      resourcePool: 'Resource-Pool01',
      nodeCount: 25,
      connectionType: 'direct',
      kubeconfig: '',
      createdAt: '2024-01-17 19:43:23'
    }
  ]
}

// 从本地存储加载算力节点数据
const loadNodeData = () => {
  const stored = localStorage.getItem(NODE_STORAGE_KEY)
  if (stored) {
    try {
      nodeTableData.value = JSON.parse(stored)
    } catch (e) {
      nodeTableData.value = initDefaultNodeData()
      saveNodeData()
    }
  } else {
    nodeTableData.value = initDefaultNodeData()
    saveNodeData()
  }
}

// 保存算力节点数据到本地存储
const saveNodeData = () => {
  localStorage.setItem(NODE_STORAGE_KEY, JSON.stringify(nodeTableData.value))
}

// 过滤后的数据
const filteredData = computed(() => {
  if (!searchText.value) {
    return tableData.value
  }
  return tableData.value.filter((item) =>
    item.name.toLowerCase().includes(searchText.value.toLowerCase())
  )
})

// 过滤后的算力节点数据
const filteredNodeData = computed(() => {
  if (!nodeSearchText.value) {
    return nodeTableData.value
  }
  return nodeTableData.value.filter((item) =>
    item.name.toLowerCase().includes(nodeSearchText.value.toLowerCase())
  )
})

// 新建
const handleAdd = () => {
  dialogTitle.value = '新建'
  formData.value = {
    id: '',
    name: '',
    location: '',
    description: '',
    cpuCores: 1,
    memorySize: '',
    gpuList: [{ brand: '', count: '' }],
    gpuCount: 0,
    ipList: [''],
    status: '已纳管0/总数量0',
    createdAt: ''
  }
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row: ResourcePool) => {
  dialogTitle.value = '编辑'
  formData.value = JSON.parse(JSON.stringify(row))
  if (!formData.value.gpuList || formData.value.gpuList.length === 0) {
    formData.value.gpuList = [{ brand: '', count: '' }]
  }
  if (!formData.value.ipList || formData.value.ipList.length === 0) {
    formData.value.ipList = ['']
  }
  dialogVisible.value = true
}

// 查看
const handleView = (row: ResourcePool) => {
  handleEdit(row)
}

// 删除
const handleDelete = (row: ResourcePool) => {
  ElMessageBox.confirm('确定要删除该资源池吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const index = tableData.value.findIndex((item) => item.id === row.id)
      if (index > -1) {
        tableData.value.splice(index, 1)
        saveData()
        ElMessage.success('删除成功')
      }
    })
    .catch(() => {})
}

// 批量删除
const handleBatchDelete = () => {
  ElMessageBox.confirm(`确定要删除选中的 ${selectedRows.value.length} 条数据吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const ids = selectedRows.value.map((item) => item.id)
      tableData.value = tableData.value.filter((item) => !ids.includes(item.id))
      saveData()
      ElMessage.success('删除成功')
      selectedRows.value = []
    })
    .catch(() => {})
}

// 同步信息
const handleSync = () => {
  ElMessage.info('同步功能开发中...')
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate((valid) => {
    if (valid) {
      // 计算 GPU 总数
      const gpuCount = formData.value.gpuList.reduce((sum, gpu) => {
        return sum + (parseInt(gpu.count) || 0)
      }, 0)

      if (formData.value.id) {
        // 编辑
        const index = tableData.value.findIndex((item) => item.id === formData.value.id)
        if (index > -1) {
          tableData.value[index] = {
            ...formData.value,
            gpuCount
          }
        }
      } else {
        // 新建
        const now = new Date()
        const createdAt = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`

        const newItem: ResourcePool = {
          ...formData.value,
          id: Date.now().toString(),
          gpuCount,
          createdAt
        }
        tableData.value.unshift(newItem)
      }

      saveData()
      dialogVisible.value = false
      ElMessage.success('保存成功')
    }
  })
}

// 选择变更
const handleSelectionChange = (rows: ResourcePool[]) => {
  selectedRows.value = rows
}

// GPU 管理
const addGpu = () => {
  formData.value.gpuList.push({ brand: '', count: '' })
}

const removeGpu = (index: number) => {
  formData.value.gpuList.splice(index, 1)
}

// IP 管理
const addIp = () => {
  formData.value.ipList.push('')
}

const removeIp = (index: number) => {
  formData.value.ipList.splice(index, 1)
}

const handleToggleSidebar = () => {
  sidebarVisible.value = !sidebarVisible.value
}

const handleMenuSelect = (index: string) => {
  console.log('Top menu selected:', index)
}

const handleSidebarMenuSelect = (index: string) => {
  console.log('Sidebar menu selected:', index)
  sidebarVisible.value = false

  if (index === 'resource-pool-management') {
    activeLeftMenu.value = 'resource-pool'
  } else if (index === 'compute-node-management') {
    activeLeftMenu.value = 'compute-category'
  }
}

const handleLeftMenuSelect = (key: string) => {
  activeLeftMenu.value = key
  console.log('Left menu selected:', key)
}

// ========== 算力节点管理方法 ==========

// 新增算力节点
const handleAddNode = () => {
  nodeDialogTitle.value = '新增算力节点'
  nodeCurrentStep.value = 0
  nodeFormData.value = {
    id: '',
    name: '',
    location: '',
    alias: '',
    description: '',
    resourcePool: '',
    nodeCount: 25,
    connectionType: 'direct',
    kubeconfig: '',
    createdAt: ''
  }
  nodeDialogVisible.value = true
}

// 编辑算力节点
const handleEditNode = (row: ComputeNode) => {
  nodeDialogTitle.value = '编辑算力节点'
  nodeCurrentStep.value = 0
  nodeFormData.value = JSON.parse(JSON.stringify(row))
  nodeDialogVisible.value = true
}

// 查看算力节点
const handleViewNode = (row: ComputeNode) => {
  handleEditNode(row)
}

// 删除算力节点
const handleDeleteNode = (row: ComputeNode) => {
  ElMessageBox.confirm('确定要删除该算力节点吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const index = nodeTableData.value.findIndex((item) => item.id === row.id)
      if (index > -1) {
        nodeTableData.value.splice(index, 1)
        saveNodeData()
        ElMessage.success('删除成功')
      }
    })
    .catch(() => {})
}

// 批量删除算力节点
const handleBatchDeleteNode = () => {
  ElMessageBox.confirm(
    `确定要删除选中的 ${selectedNodeRows.value.length} 条数据吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(() => {
      const ids = selectedNodeRows.value.map((item) => item.id)
      nodeTableData.value = nodeTableData.value.filter((item) => !ids.includes(item.id))
      saveNodeData()
      ElMessage.success('删除成功')
      selectedNodeRows.value = []
    })
    .catch(() => {})
}

// 同步数据
const handleSyncNode = () => {
  ElMessage.info('同步功能开发中...')
}

// 下一步
const handleNodeNextStep = async () => {
  if (!nodeFormRef.value) return

  await nodeFormRef.value.validate((valid) => {
    if (valid) {
      nodeCurrentStep.value = 1
    }
  })
}

// 上一步
const handleNodePrevStep = () => {
  nodeCurrentStep.value = 0
}

// 提交表单
const handleNodeSubmit = async () => {
  if (!nodeFormRef2.value) return

  await nodeFormRef2.value.validate((valid) => {
    if (valid) {
      // 从资源池中获取地域信息
      const pool = tableData.value.find((p) => p.name === nodeFormData.value.resourcePool)
      const location = pool?.location || ''

      if (nodeFormData.value.id) {
        // 编辑
        const index = nodeTableData.value.findIndex((item) => item.id === nodeFormData.value.id)
        if (index > -1) {
          nodeTableData.value[index] = {
            ...nodeFormData.value,
            location
          }
        }
      } else {
        // 新建
        const now = new Date()
        const createdAt = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`

        const newItem: ComputeNode = {
          ...nodeFormData.value,
          id: Date.now().toString(),
          location,
          createdAt
        }
        nodeTableData.value.unshift(newItem)
      }

      saveNodeData()
      nodeDialogVisible.value = false
      ElMessage.success('保存成功')
    }
  })
}

// 选择变更
const handleNodeSelectionChange = (rows: ComputeNode[]) => {
  selectedNodeRows.value = rows
}

// 初始化
onMounted(() => {
  loadData()
  loadNodeData()
})
</script>

<style scoped lang="scss">
.resource-pool-view {
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

.content-wrapper {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.page-header {
  padding: 16px 24px;
  border-bottom: 1px solid #e4e7ed;
  background-color: #fff;

  .page-title {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    color: #303133;
  }
}

.content-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  padding: 16px 24px;
}

.toolbar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;

  .toolbar-right {
    margin-left: auto;
  }

  .search-input {
    width: 300px;
  }

  .search-icon {
    color: #909399;
    cursor: pointer;
  }
}

.resource-table {
  flex: 1;

  .name-tag {
    margin-left: 8px;
  }

  :deep(.el-table__header) {
    th {
      background-color: #f5f7fa;
      color: #606266;
      font-weight: 600;
    }
  }
}

.pagination-wrapper {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  margin-top: 16px;
  padding: 16px 0;

  .pagination-total {
    font-size: 14px;
    color: #606266;
    margin-right: 8px;
  }

  .pagination {
    :deep(.el-pagination__sizes) {
      margin-right: 8px;
    }
  }
}

.edit-dialog {
  .form-section-title {
    font-size: 14px;
    font-weight: 600;
    color: #303133;
    margin: 20px 0 16px;
    padding-bottom: 8px;
    border-bottom: 1px solid #e4e7ed;
  }

  :deep(.el-form-item__label) {
    font-weight: 500;
  }
}

// 算力节点对话框样式
.node-dialog {
  .node-steps {
    margin-bottom: 32px;
    padding: 0 50px;
  }

  .step-content {
    min-height: 300px;
    padding: 20px 0;
  }

  .kubeconfig-section {
    margin-top: 24px;

    .section-label {
      font-size: 14px;
      font-weight: 500;
      color: #303133;
      margin-bottom: 12px;
    }

    .kubeconfig-input {
      :deep(textarea) {
        font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', 'source-code-pro', monospace;
        font-size: 13px;
        line-height: 1.6;
        background-color: #2b3035;
        color: #e8eaed;
        border: 1px solid #3c4043;
        border-radius: 4px;

        &:focus {
          background-color: #2b3035;
          border-color: #409eff;
        }

        &::placeholder {
          color: #80868b;
        }
      }
    }
  }

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
  }

  :deep(.el-radio-button) {
    .el-radio-button__inner {
      padding: 8px 20px;
    }
  }
}
</style>
