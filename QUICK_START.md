# 快速部署到 Cloudflare Pages

## 🚀 一键部署（推荐）

### 第一步：准备 GitHub 仓库

如果还没有 GitHub 仓库：

1. 访问 [GitHub](https://github.com/new) 创建新仓库
2. 复制仓库 URL（如：`https://github.com/username/repo-name.git`）
3. 在终端执行：

```bash
# 在项目根目录
cd /Users/roc/Desktop/shida/09-撮合算力平台/超融合算力调度平台/v1

# 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# 推送代码
git push -u origin main
```

### 第二步：运行部署脚本

```bash
# 执行一键部署脚本
./deploy-to-cloudflare.sh
```

脚本将自动：
- ✅ 检查 Git 状态
- ✅ 提交未保存的更改
- ✅ 推送代码到 GitHub
- ✅ 可选：本地构建测试

### 第三步：Cloudflare Pages 配置

1. 访问 https://dash.cloudflare.com/
2. 选择 **Workers & Pages** > **Create application**
3. 选择 **Pages** > **Connect to Git**
4. 授权并选择您的 GitHub 仓库
5. 使用以下配置：

```
项目名称: admin-backend
生产分支: main
构建命令: cd admin-backend && npm install && npm run build:production
输出目录: admin-backend/dist
环境变量: NODE_VERSION=20.19.0
```

> **提示**: `build:production` 会跳过类型检查以加快构建速度

6. 点击 **Save and Deploy**

## ⚡ 快速命令

```bash
# 添加远程仓库（首次）
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# 提交并推送更改
git add .
git commit -m "Update admin backend"
git push

# 查看远程仓库
git remote -v
```

## 📋 Cloudflare Pages 配置速查

| 配置项 | 值 |
|--------|-----|
| Framework preset | Vue |
| Build command | `cd admin-backend && npm install && npm run build:production` |
| Build output directory | `admin-backend/dist` |
| Root directory | `/` |
| Node.js version | `20.19.0` |

## 🔧 环境变量（可选）

在 Cloudflare Pages 项目设置中添加：

```
NODE_VERSION=20.19.0
```

## ✅ 部署成功后

您的网站将部署在：
- 生产环境：`https://YOUR_PROJECT_NAME.pages.dev`
- 预览环境：每个分支自动生成预览链接

## 🆘 遇到问题？

查看详细文档：`DEPLOYMENT.md`

常见问题：
1. **404 错误**: 已自动配置 `_redirects` 文件解决路由问题
2. **构建失败**: 检查 Node 版本和构建命令
3. **推送失败**: 检查 GitHub 仓库权限
