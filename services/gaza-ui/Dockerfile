# Gaza UI (yudao-ui-admin-vue3) Dockerfile
# Vue 3 + Vite + pnpm + Element Plus

# 构建阶段
FROM node:20-alpine AS builder

WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm@8.6.0

# 复制package文件
COPY package.json pnpm-lock.json* ./

# 安装依赖
RUN pnpm install --frozen-lockfile

# 复制源代码
COPY . .

# 构建时环境变量（可通过 --build-arg 传入）
ARG NODE_ENV=production
ARG VITE_BASE_PATH=/
ARG VITE_APP_TITLE=Gaza智能管理系统
ARG VITE_BASE_URL=/prod-api
ARG VITE_APP_ENV=production

ENV NODE_ENV=$NODE_ENV \
    VITE_BASE_PATH=$VITE_BASE_PATH \
    VITE_APP_TITLE=$VITE_APP_TITLE \
    VITE_BASE_URL=$VITE_BASE_URL \
    VITE_APP_ENV=$VITE_APP_ENV

# 构建生产版本
RUN pnpm run build:prod

# 生产阶段 - 使用nginx服务静态文件
FROM nginx:alpine

# 复制nginx配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 从构建阶段复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80 || exit 1

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]
