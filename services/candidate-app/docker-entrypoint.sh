#!/bin/bash
set -e

echo "=========================================="
echo "HR 候选人应用 Docker 启动脚本"
echo "=========================================="

# 打印环境信息
echo "Node 版本: $(node --version)"
echo "环境: ${NODE_ENV:-development}"
echo "租户 ID: ${TENANT_ID:-未设置}"
echo "应用名称: ${NEXT_PUBLIC_APP_NAME:-未设置}"
echo "应用版本: ${NEXT_PUBLIC_APP_VERSION:-未设置}"

# 检查必需的环境变量
check_env_var() {
    local var_name=$1
    local var_value=${!var_name}

    if [ -z "$var_value" ]; then
        echo "警告: 环境变量 $var_name 未设置"
        return 1
    fi
    return 0
}

echo ""
echo "检查必需的环境变量..."

# 检查数据库连接
if check_env_var "DATABASE_URL"; then
    echo "✓ DATABASE_URL 已设置"
else
    echo "✗ DATABASE_URL 未设置"
fi

# 检查 AES 密钥
if check_env_var "ACCESS_TOKEN_AES_KEY"; then
    echo "✓ ACCESS_TOKEN_AES_KEY 已设置"
else
    echo "✗ ACCESS_TOKEN_AES_KEY 未设置"
fi

# 检查租户 ID
if check_env_var "TENANT_ID"; then
    echo "✓ TENANT_ID 已设置: ${TENANT_ID}"
else
    echo "✗ TENANT_ID 未设置，使用默认值: 600"
    export TENANT_ID=600
fi

echo ""
echo "环境变量检查完成"
echo "=========================================="

# 可选：运行数据库迁移
if [ "$RUN_MIGRATIONS" = "true" ]; then
    echo "运行数据库迁移..."
    npx prisma migrate deploy || echo "警告: 数据库迁移失败"
fi

# 可选：生成 Prisma 客户端（如果需要）
if [ "$REGENERATE_PRISMA" = "true" ]; then
    echo "重新生成 Prisma 客户端..."
    npx prisma generate
fi

echo ""
echo "启动 Next.js 应用..."
echo "监听地址: ${HOSTNAME}:${PORT}"
echo "=========================================="
echo ""

# 执行传入的命令
exec "$@"
