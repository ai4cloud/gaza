# Vue 3 前端Dockerfile
# 多阶段构建

# 构建阶段
FROM node:18-alpine AS builder

WORKDIR /app

# 复制package文件并安装依赖
COPY package*.json ./
RUN npm ci --only=production

# 复制源代码
COPY . .

# 构建时接收环境变量
ARG VUE_APP_API_URL
ENV VUE_APP_API_URL=$VUE_APP_API_URL

# 构建生产版本
RUN npm run build

# 生产阶段 - 使用nginx服务静态文件
FROM nginx:alpine

# 复制自定义nginx配置
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

# 使用说明：
# 1. 将此文件放在Vue项目根目录
# 2. 确保package.json在同级目录
# 3. 确保有nginx.conf配置文件
# 4. 如果使用Vite，dist目录可能不同，需要调整
