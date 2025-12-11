<template>
  <MainLayout>
    <div class="content-wrapper">
      <!-- 页面标题 -->
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
              <el-option label="Resource-Pool01" value="Resource-Pool01" />
              <el-option label="Resource-Pool02" value="Resource-Pool02" />
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
  </MainLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Search, Refresh, Plus, Delete, QuestionFilled } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import MainLayout from '@/components/MainLayout.vue'

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

const NODE_STORAGE_KEY = 'compute_node_data'

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

const nodeFormRules: FormRules = {
  name: [{ required: true, message: '请输入算力节点名称', trigger: 'blur' }],
  resourcePool: [{ required: true, message: '请选择资源池', trigger: 'change' }]
}

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

const saveNodeData = () => {
  localStorage.setItem(NODE_STORAGE_KEY, JSON.stringify(nodeTableData.value))
}

const filteredNodeData = computed(() => {
  if (!nodeSearchText.value) {
    return nodeTableData.value
  }
  return nodeTableData.value.filter((item) =>
    item.name.toLowerCase().includes(nodeSearchText.value.toLowerCase())
  )
})

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

const handleEditNode = (row: ComputeNode) => {
  nodeDialogTitle.value = '编辑算力节点'
  nodeCurrentStep.value = 0
  nodeFormData.value = JSON.parse(JSON.stringify(row))
  nodeDialogVisible.value = true
}

const handleViewNode = (row: ComputeNode) => {
  handleEditNode(row)
}

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

const handleSyncNode = () => {
  ElMessage.info('同步功能开发中...')
}

const handleNodeNextStep = async () => {
  if (!nodeFormRef.value) return

  await nodeFormRef.value.validate((valid) => {
    if (valid) {
      nodeCurrentStep.value = 1
    }
  })
}

const handleNodePrevStep = () => {
  nodeCurrentStep.value = 0
}

const handleNodeSubmit = async () => {
  if (!nodeFormRef2.value) return

  await nodeFormRef2.value.validate((valid) => {
    if (valid) {
      const location = nodeFormData.value.resourcePool === 'Resource-Pool01' ? '北京' : '上海'

      if (nodeFormData.value.id) {
        const index = nodeTableData.value.findIndex((item) => item.id === nodeFormData.value.id)
        if (index > -1) {
          nodeTableData.value[index] = {
            ...nodeFormData.value,
            location
          }
        }
      } else {
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

const handleNodeSelectionChange = (rows: ComputeNode[]) => {
  selectedNodeRows.value = rows
}

onMounted(() => {
  loadNodeData()
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
