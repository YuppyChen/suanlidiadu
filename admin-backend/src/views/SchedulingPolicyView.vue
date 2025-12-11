<template>
  <MainLayout>
    <div class="content-wrapper">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2 class="page-title">调度策略管理</h2>
      </div>

      <!-- 内容区 -->
      <div class="content-section">
        <!-- 操作栏 -->
        <div class="toolbar">
          <el-button type="primary" @click="handleAddPolicy">
            <el-icon><Plus /></el-icon>
            新建
          </el-button>
          <el-button @click="handleDeletePolicy">
            <el-icon><Delete /></el-icon>
            删除
          </el-button>
          <div class="toolbar-right">
            <el-input
              v-model="policySearchText"
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
          :data="filteredPolicyData"
          @selection-change="handlePolicySelectionChange"
          class="resource-table"
        >
          <el-table-column type="selection" width="55" />
          <el-table-column prop="name" label="名称" sortable>
            <template #default="{ row }">
              <el-link type="primary" :underline="false" @click="handleViewPolicy(row)">
                {{ row.name }}
              </el-link>
            </template>
          </el-table-column>
          <el-table-column prop="type" label="类型" width="150" />
          <el-table-column prop="remark" label="备注" width="200" />
          <el-table-column prop="status" label="状态" width="120">
            <template #default="{ row }">
              <el-tag v-if="row.enabled" type="success" size="small">启用</el-tag>
              <el-tag v-else type="info" size="small">禁用</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="240" fixed="right">
            <template #default="{ row }">
              <el-link type="primary" :underline="false" @click="handleEditPolicy(row)">
                编辑
              </el-link>
              <el-divider direction="vertical" />
              <el-link
                type="primary"
                :underline="false"
                @click="handleTogglePolicyStatus(row)"
              >
                {{ row.enabled ? '禁用' : '启用' }}
              </el-link>
              <el-divider direction="vertical" />
              <el-link type="primary" :underline="false" @click="handleDeleteSinglePolicy(row)">
                删除
              </el-link>
            </template>
          </el-table-column>
        </el-table>

        <!-- 分页 -->
        <div class="pagination-wrapper">
          <span class="pagination-total">共{{ filteredPolicyData.length }}条，</span>
          <el-pagination
            v-model:current-page="policyCurrentPage"
            v-model:page-size="policyPageSize"
            :page-sizes="[10, 20, 50, 100]"
            :total="filteredPolicyData.length"
            layout="sizes, prev, pager, next"
            class="pagination"
          />
        </div>
      </div>
    </div>

    <!-- 调度策略编辑弹窗 -->
    <el-dialog
      v-model="policyDialogVisible"
      :title="policyDialogTitle"
      width="600px"
      :close-on-click-modal="false"
      class="edit-dialog"
    >
      <el-form
        :model="policyFormData"
        :rules="policyFormRules"
        ref="policyFormRef"
        label-width="100px"
      >
        <el-form-item label="名称" prop="name" required>
          <el-input v-model="policyFormData.name" placeholder="请输入策略名称" />
        </el-form-item>

        <el-form-item label="类型" prop="type" required>
          <el-select v-model="policyFormData.type" placeholder="请选择" style="width: 100%">
            <el-option label="基础策略" value="基础策略" />
            <el-option label="高级策略" value="高级策略" />
            <el-option label="自定义策略" value="自定义策略" />
          </el-select>
        </el-form-item>

        <el-form-item label="备注">
          <el-input
            v-model="policyFormData.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息"
          />
        </el-form-item>

        <el-form-item label="状态">
          <el-switch v-model="policyFormData.enabled" active-text="启用" inactive-text="禁用" />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="policyDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handlePolicySubmit">确定</el-button>
      </template>
    </el-dialog>
  </MainLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Search, Plus, Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import MainLayout from '@/components/MainLayout.vue'

interface SchedulingPolicy {
  id: string
  name: string
  type: string
  remark: string
  enabled: boolean
  createdAt: string
}

const POLICY_STORAGE_KEY = 'scheduling_policy_data'

const policySearchText = ref('')
const policyCurrentPage = ref(1)
const policyPageSize = ref(10)
const selectedPolicyRows = ref<SchedulingPolicy[]>([])
const policyDialogVisible = ref(false)
const policyDialogTitle = ref('新建策略')
const policyFormRef = ref<FormInstance>()
const policyTableData = ref<SchedulingPolicy[]>([])

const policyFormData = ref<SchedulingPolicy>({
  id: '',
  name: '',
  type: '基础策略',
  remark: '',
  enabled: true,
  createdAt: ''
})

const policyFormRules: FormRules = {
  name: [{ required: true, message: '请输入策略名称', trigger: 'blur' }],
  type: [{ required: true, message: '请选择策略类型', trigger: 'change' }]
}

const initDefaultPolicyData = (): SchedulingPolicy[] => {
  return [
    {
      id: '1',
      name: '平均调度策略',
      type: '基础策略',
      remark: '---',
      enabled: true,
      createdAt: '2024-01-17 19:43:23'
    },
    {
      id: '2',
      name: '集中调度策略',
      type: '基础策略',
      remark: '---',
      enabled: true,
      createdAt: '2024-01-17 19:43:23'
    },
    {
      id: '3',
      name: '神域权重调度策略',
      type: '基础策略',
      remark: '---',
      enabled: true,
      createdAt: '2024-01-17 19:43:23'
    },
    {
      id: '4',
      name: '权限调度策略',
      type: '基础策略',
      remark: '---',
      enabled: true,
      createdAt: '2024-01-17 19:43:23'
    }
  ]
}

const loadPolicyData = () => {
  const stored = localStorage.getItem(POLICY_STORAGE_KEY)
  if (stored) {
    try {
      policyTableData.value = JSON.parse(stored)
    } catch (e) {
      policyTableData.value = initDefaultPolicyData()
      savePolicyData()
    }
  } else {
    policyTableData.value = initDefaultPolicyData()
    savePolicyData()
  }
}

const savePolicyData = () => {
  localStorage.setItem(POLICY_STORAGE_KEY, JSON.stringify(policyTableData.value))
}

const filteredPolicyData = computed(() => {
  if (!policySearchText.value) {
    return policyTableData.value
  }
  return policyTableData.value.filter((item) =>
    item.name.toLowerCase().includes(policySearchText.value.toLowerCase())
  )
})

const handleAddPolicy = () => {
  policyDialogTitle.value = '新建策略'
  policyFormData.value = {
    id: '',
    name: '',
    type: '基础策略',
    remark: '',
    enabled: true,
    createdAt: ''
  }
  policyDialogVisible.value = true
}

const handleEditPolicy = (row: SchedulingPolicy) => {
  policyDialogTitle.value = '编辑策略'
  policyFormData.value = JSON.parse(JSON.stringify(row))
  policyDialogVisible.value = true
}

const handleViewPolicy = (row: SchedulingPolicy) => {
  handleEditPolicy(row)
}

const handleDeleteSinglePolicy = (row: SchedulingPolicy) => {
  ElMessageBox.confirm('确定要删除该调度策略吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const index = policyTableData.value.findIndex((item) => item.id === row.id)
      if (index > -1) {
        policyTableData.value.splice(index, 1)
        savePolicyData()
        ElMessage.success('删除成功')
      }
    })
    .catch(() => {})
}

const handleDeletePolicy = () => {
  if (selectedPolicyRows.value.length === 0) {
    ElMessage.warning('请先选择要删除的数据')
    return
  }

  ElMessageBox.confirm(
    `确定要删除选中的 ${selectedPolicyRows.value.length} 条数据吗？`,
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(() => {
      const ids = selectedPolicyRows.value.map((item) => item.id)
      policyTableData.value = policyTableData.value.filter((item) => !ids.includes(item.id))
      savePolicyData()
      ElMessage.success('删除成功')
      selectedPolicyRows.value = []
    })
    .catch(() => {})
}

const handleTogglePolicyStatus = (row: SchedulingPolicy) => {
  const action = row.enabled ? '禁用' : '启用'
  ElMessageBox.confirm(`确定要${action}该策略吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const index = policyTableData.value.findIndex((item) => item.id === row.id)
      if (index > -1) {
        policyTableData.value[index].enabled = !row.enabled
        savePolicyData()
        ElMessage.success(`${action}成功`)
      }
    })
    .catch(() => {})
}

const handlePolicySubmit = async () => {
  if (!policyFormRef.value) return

  await policyFormRef.value.validate((valid) => {
    if (valid) {
      if (policyFormData.value.id) {
        const index = policyTableData.value.findIndex((item) => item.id === policyFormData.value.id)
        if (index > -1) {
          policyTableData.value[index] = { ...policyFormData.value }
        }
      } else {
        const now = new Date()
        const createdAt = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`

        const newItem: SchedulingPolicy = {
          ...policyFormData.value,
          id: Date.now().toString(),
          createdAt
        }
        policyTableData.value.unshift(newItem)
      }

      savePolicyData()
      policyDialogVisible.value = false
      ElMessage.success('保存成功')
    }
  })
}

const handlePolicySelectionChange = (rows: SchedulingPolicy[]) => {
  selectedPolicyRows.value = rows
}

onMounted(() => {
  loadPolicyData()
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
  :deep(.el-form-item__label) {
    font-weight: 500;
  }
}
</style>
