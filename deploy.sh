#!/bin/bash
# 🎮 之玥游戏世界 - 一键部署脚本
# 用法: ./deploy.sh [项目名]
# 示例: ./deploy.sh snake

set -e

# Cloudflare API Token 从环境变量读取
# 设置方法: export CLOUDFLARE_API_TOKEN=你的token
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ 请设置 CLOUDFLARE_API_TOKEN 环境变量"
    echo "   export CLOUDFLARE_API_TOKEN=你的token"
    exit 1
fi

PROJECT_DIR="/root/.openclaw/workspace-zhiyue-bot/zhiyue-games"
CF_PROJECT="zhiyue-page"

echo "🎮 之玥游戏世界 - 部署工具"
echo "=========================="

# 检查参数
if [ -z "$1" ]; then
    echo ""
    echo "📋 当前游戏列表："
    ls -d "$PROJECT_DIR"/games/*/ 2>/dev/null | while read dir; do
        name=$(basename "$dir")
        echo "  🎯 $name"
    done
    echo ""
    echo "用法:"
    echo "  ./deploy.sh              # 查看游戏列表"
    echo "  ./deploy.sh <游戏名>      # 部署指定游戏"
    echo "  ./deploy.sh all           # 部署所有内容"
    echo ""
    exit 0
fi

GAME_NAME="$1"

# Git 版本管理
git_push() {
    cd "$PROJECT_DIR"
    if git remote -v | grep -q origin; then
        echo "📤 推送到 GitHub..."
        git add -A
        git diff --cached --quiet || {
            git commit -m "🎮 更新: $(date '+%Y-%m-%d %H:%M')"
            git push origin main
            echo "✅ GitHub 推送完成"
        }
    else
        echo "⚠️  GitHub 远程仓库未配置，跳过推送"
    fi
}

# 部署到 Cloudflare Pages
deploy_cf() {
    echo "🚀 部署到 Cloudflare Pages..."
    cd "$PROJECT_DIR"
    wrangler pages deploy . --project-name="$CF_PROJECT" --commit-dirty=true 2>&1
    echo ""
    echo "✅ 部署完成！"
    echo "🔗 访问地址: https://${CF_PROJECT}.pages.dev"
}

# 主流程
echo ""
echo "📝 提交变更..."
cd "$PROJECT_DIR"
git add -A
git diff --cached --quiet || git commit -m "🎮 添加/更新游戏: $GAME_NAME - $(date '+%Y-%m-%d %H:%M')" 2>/dev/null

# 推送到 GitHub
git_push

# 部署到 Cloudflare Pages
deploy_cf

echo ""
echo "🎉 完成！分享链接给朋友玩吧！"
