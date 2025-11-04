# HR 候选人应用 - Docker 多阶段构建
# 支持环境变量参数传入

# ============================================
# 基础镜像阶段
# ============================================
FROM node:20-alpine AS base

# 安装必要的系统依赖
RUN apk add --no-cache libc6-compat openssl bash

WORKDIR /app

# ============================================
# 依赖安装阶段
# ============================================
FROM base AS deps

# 复制依赖文件
COPY package*.json ./

# 安装所有依赖（包括 devDependencies，用于构建）
RUN npm ci

# ============================================
# 构建阶段
# ============================================
FROM base AS builder

WORKDIR /app

# 复制依赖
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 构建时环境变量（可通过 --build-arg 传入）
ARG DATABASE_URL
ARG ACCESS_TOKEN_AES_KEY
ARG OAUTH2_CLIENT_ID
ARG OAUTH2_CLIENT_SECRET
ARG OAUTH2_USERNAME
ARG OAUTH2_PASSWORD
ARG OAUTH2_TOKEN_URL
ARG OAUTH2_FILE_UPLOAD_URL
ARG ADMIN_SERVICE_BASE_URL
ARG TENANT_ID
ARG NEXT_PUBLIC_APP_NAME
ARG NEXT_PUBLIC_APP_VERSION

# 设置环境变量用于构建
ENV DATABASE_URL=$DATABASE_URL \
    ACCESS_TOKEN_AES_KEY=$ACCESS_TOKEN_AES_KEY \
    OAUTH2_CLIENT_ID=$OAUTH2_CLIENT_ID \
    OAUTH2_CLIENT_SECRET=$OAUTH2_CLIENT_SECRET \
    OAUTH2_USERNAME=$OAUTH2_USERNAME \
    OAUTH2_PASSWORD=$OAUTH2_PASSWORD \
    OAUTH2_TOKEN_URL=$OAUTH2_TOKEN_URL \
    OAUTH2_FILE_UPLOAD_URL=$OAUTH2_FILE_UPLOAD_URL \
    ADMIN_SERVICE_BASE_URL=$ADMIN_SERVICE_BASE_URL \
    TENANT_ID=$TENANT_ID \
    NEXT_PUBLIC_APP_NAME=$NEXT_PUBLIC_APP_NAME \
    NEXT_PUBLIC_APP_VERSION=$NEXT_PUBLIC_APP_VERSION

# 生成 Prisma 客户端
RUN npx prisma generate

# 构建 Next.js 应用（启用 standalone 输出）
RUN npm run build

# ============================================
# 生产运行阶段
# ============================================
FROM base AS runner

WORKDIR /app

# 设置生产环境
ENV NODE_ENV=production

# 创建非 root 用户
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# 创建必要的目录
RUN mkdir -p /app/uploads /app/logs && \
    chown -R nextjs:nodejs /app

# 复制必要的文件
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/src/generated ./src/generated

# 复制 standalone 输出
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# 复制启动脚本
COPY --chown=nextjs:nodejs docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh

# 切换到非 root 用户
USER nextjs

# 暴露端口
EXPOSE 3000

# 设置环境变量
ENV PORT=3000 \
    HOSTNAME="0.0.0.0"

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); })"

# 启动应用
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["node", "server.js"]
