<template>
  <MainLayout>
    <div class="content-wrapper">
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
          <el-button @click="handleSync" :loading="isSyncing">
            <el-icon v-if="!isSyncing"><Refresh /></el-icon>
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
  </MainLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Search, Refresh, Plus, Delete, Close } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import MainLayout from '@/components/MainLayout.vue'

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

const STORAGE_KEY = 'resource_pool_data'

const searchText = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const selectedRows = ref<ResourcePool[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('新建')
const formRef = ref<FormInstance>()
const tableData = ref<ResourcePool[]>([])
const isSyncing = ref(false)

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

// 过滤后的数据
const filteredData = computed(() => {
  if (!searchText.value) {
    return tableData.value
  }
  return tableData.value.filter((item) =>
    item.name.toLowerCase().includes(searchText.value.toLowerCase())
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
const handleSync = async () => {
  if (isSyncing.value) return
  
  isSyncing.value = true
  
  // Simulate sync process
  await new Promise(resolve => setTimeout(resolve, 1500))
  
  isSyncing.value = false
  ElMessage.warning('没有最新数据可以同步')
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

// 初始化
onMounted(() => {
  loadData()
})
</script>

<style scoped lang="scss">
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
</style>
