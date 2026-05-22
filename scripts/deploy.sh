#!/bin/bash

# 部署脚本
# 用法: ./scripts/deploy.sh [environment]
# environment: production  (默认: production)

set -e

ENVIRONMENT=${1:-production}

echo "🚀 开始部署到 $ENVIRONMENT 环境..."

# 1. 类型检查
echo "📝 执行类型检查..."
pnpm run type-check

# 2. 运行测试
echo "🧪 运行测试..."
pnpm run test

# 3. 构建项目
echo "🔨 构建项目..."
pnpm run build-only

# 4. 部署到 Cloudflare
if [ "$ENVIRONMENT" = "production" ]; then
    echo "📦 部署到生产环境..."
    pnpx wrangler deploy --env production
else
    echo "❌ 未知的环境: $ENVIRONMENT"
    echo "支持的环境: production"
    exit 1
fi

echo "✅ 部署完成！"
