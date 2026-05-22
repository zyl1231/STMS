# 部署脚本
# 用法: .\deploy.ps1 [environment]
# environment: production  (默认: production)

$Environment = if ($args[0]) { $args[0] } else { "production" }

Write-Host "🚀 开始部署到 $Environment 环境..."

# 1. 类型检查
Write-Host "📝 执行类型检查..."
pnpm run type-check
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# 2. 运行测试
Write-Host "🧪 运行测试..."
pnpm run test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# 3. 构建项目
Write-Host "🔨 构建项目..."
pnpm run build-only
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# 4. 部署到 Cloudflare
if ($Environment -eq "production") {
    Write-Host "📦 部署到生产环境..."
    pnpx wrangler deploy --env production
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
    Write-Host "❌ 未知的环境: $Environment" -ForegroundColor Red
    Write-Host "支持的环境: production" -ForegroundColor Red
    exit 1
}

Write-Host "✅ 部署完成！" -ForegroundColor Green
