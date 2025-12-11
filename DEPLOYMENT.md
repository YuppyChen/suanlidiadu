# Cloudflare Pages 部署指南

## 📋 前置要求

- GitHub 账号
- Cloudflare 账号
- 项目代码已提交到 Git 仓库

## 🚀 部署步骤

### 1. 推送代码到 GitHub

如果还没有 GitHub 仓库，执行以下命令：

```bash
# 1. 在 GitHub 上创建新仓库（不要初始化 README 等文件）
# 2. 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# 3. 推送代码
git push -u origin main
```

如果已有仓库：
```bash
git push
```

### 2. 连接 Cloudflare Pages

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. 在左侧菜单选择 **Workers & Pages**
3. 点击 **Create application** > **Pages** > **Connect to Git**
4. 授权 Cloudflare 访问您的 GitHub 账号
5. 选择您的仓库

### 3. 配置构建设置

在 Cloudflare Pages 配置页面，设置以下参数：

#### 基本设置
- **项目名称**: `admin-backend` (或自定义名称)
- **生产分支**: `main`

#### 构建设置
- **框架预设**: `Vue`
- **构建命令**: `cd admin-backend && npm install && npm run build:production`
- **构建输出目录**: `admin-backend/dist`
- **根目录（高级）**: `/` (保持默认)

> **注意**: 使用 `build:production` 命令可跳过类型检查，加快构建速度。如需完整类型检查，使用 `npm run build`。

#### 环境变量（可选）
```
NODE_VERSION=20.19.0
```

### 4. 部署

点击 **Save and Deploy** 按钮，Cloudflare Pages 将自动：
1. 克隆您的仓库
2. 安装依赖
3. 执行构建命令
4. 部署到 CDN

初次部署通常需要 2-5 分钟。

### 5. 访问网站

部署成功后，您将获得：
- **生产环境**: `https://YOUR_PROJECT_NAME.pages.dev`
- **预览环境**: 每个 Git 分支/PR 都会自动生成预览链接

## ⚙️ 高级配置（可选）

### 使用自定义域名

1. 在 Cloudflare Pages 项目设置中，点击 **Custom domains**
2. 点击 **Set up a custom domain**
3. 输入您的域名（如 `admin.example.com`）
4. 按照提示添加 DNS 记录

### 配置文件方式（推荐）

在项目根目录创建 `wrangler.toml` 文件：

```toml
name = "admin-backend"
compatibility_date = "2024-01-01"

[site]
bucket = "./admin-backend/dist"

[build]
command = "cd admin-backend && npm install && npm run build"

[env.production]
name = "admin-backend"
```

### 环境变量管理

如果需要不同环境的配置：

1. 在 Cloudflare Pages 设置中添加环境变量
2. 在 `admin-backend/.env.production` 中使用：

```env
VITE_API_BASE_URL=https://api.example.com
VITE_APP_TITLE=超融合算力调度平台
```

## 🔄 自动部署

配置完成后，每次推送到 GitHub 仓库时，Cloudflare Pages 都会自动：
- **main 分支**: 部署到生产环境
- **其他分支**: 创建预览环境

## 📝 常见问题

### 构建失败

如果构建失败，检查：
1. **构建命令是否正确**: 确保路径 `admin-backend` 存在
2. **Node 版本**: 确保使用 Node.js 20.19.0 或以上
3. **依赖安装**: 检查 `package.json` 是否完整

### 404 错误（路由问题）

Vue Router 使用 history 模式时，需要配置重定向规则。

在 `admin-backend/public` 目录创建 `_redirects` 文件：

```
/*  /index.html  200
```

### 构建输出目录不正确

确保 `vite.config.ts` 中的构建配置正确：

```typescript
export default defineConfig({
  build: {
    outDir: 'dist'  // 确保输出到 dist 目录
  }
})
```

## 📊 监控和分析

在 Cloudflare Dashboard 中可以查看：
- 部署历史
- 访问统计
- 错误日志
- 性能指标

## 🔗 相关链接

- [Cloudflare Pages 文档](https://developers.cloudflare.com/pages/)
- [Vite 部署指南](https://vitejs.dev/guide/static-deploy.html)
- [Vue Router History 模式](https://router.vuejs.org/guide/essentials/history-mode.html)
