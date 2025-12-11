#!/bin/bash

# 超融合算力调度平台 - Cloudflare Pages 部署脚本
# 使用方法: ./deploy-to-cloudflare.sh

set -e

echo "🚀 开始准备部署到 Cloudflare Pages..."

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. 检查是否在正确的目录
if [ ! -d "admin-backend" ]; then
    echo -e "${RED}❌ 错误: 找不到 admin-backend 目录${NC}"
    echo "请在项目根目录执行此脚本"
    exit 1
fi

echo -e "${GREEN}✓ 目录检查通过${NC}"

# 2. 检查 Git 状态
echo -e "\n${YELLOW}📝 检查 Git 状态...${NC}"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  发现未提交的更改${NC}"
    git status --short

    read -p "是否要提交这些更改? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "请输入提交信息: " commit_msg
        git add .
        git commit -m "$commit_msg"
        echo -e "${GREEN}✓ 更改已提交${NC}"
    else
        echo -e "${YELLOW}⚠️  继续使用未提交的更改进行部署${NC}"
    fi
else
    echo -e "${GREEN}✓ 工作区干净${NC}"
fi

# 3. 检查远程仓库
echo -e "\n${YELLOW}🔗 检查远程仓库...${NC}"
if ! git remote | grep -q 'origin'; then
    echo -e "${RED}❌ 未配置远程仓库${NC}"
    echo -e "${YELLOW}请先配置 GitHub 远程仓库:${NC}"
    echo "  git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    exit 1
fi

remote_url=$(git remote get-url origin)
echo -e "${GREEN}✓ 远程仓库: ${remote_url}${NC}"

# 4. 推送到 GitHub
echo -e "\n${YELLOW}⬆️  推送代码到 GitHub...${NC}"
current_branch=$(git branch --show-current)
git push -u origin $current_branch
echo -e "${GREEN}✓ 代码已推送到分支: ${current_branch}${NC}"

# 5. 本地构建测试（可选）
echo -e "\n${YELLOW}🔨 是否进行本地构建测试? (y/n)${NC}"
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}开始构建...${NC}"
    cd admin-backend
    npm install
    npm run build
    cd ..
    echo -e "${GREEN}✓ 本地构建成功${NC}"
    echo -e "${GREEN}✓ 构建产物位于: admin-backend/dist${NC}"
fi

# 6. 提供下一步指引
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ 代码已成功推送到 GitHub!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${YELLOW}📌 接下来请在 Cloudflare Pages 控制台配置:${NC}"
echo ""
echo -e "1. 访问: ${GREEN}https://dash.cloudflare.com/${NC}"
echo "2. 选择 Workers & Pages > Create application > Pages"
echo "3. 连接您的 GitHub 仓库"
echo ""
echo -e "${YELLOW}📋 构建配置:${NC}"
echo -e "   框架预设: ${GREEN}Vue${NC}"
echo -e "   构建命令: ${GREEN}cd admin-backend && npm install && npm run build${NC}"
echo -e "   输出目录: ${GREEN}admin-backend/dist${NC}"
echo -e "   Node 版本: ${GREEN}20.19.0${NC}"
echo ""
echo -e "${YELLOW}📄 详细文档请查看: DEPLOYMENT.md${NC}"
echo ""
