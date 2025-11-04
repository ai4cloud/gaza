# Candidate App

HR候选人简历填写应用，基于 Next.js 15 + React 19 + Prisma。

## 本地代码路径

将 `/Users/daizhenzhong/Documents/workspace/private/hr-candidate-server/hr-candidate-app` 的代码链接或复制到此目录。

## Git 仓库

```bash
# 示例 - 请替换为实际的仓库地址
git clone <your-repository-url> .
```

## 构建说明

1. 确保有 package.json 和 prisma 目录
2. 配置环境变量（DATABASE_URL, OAuth配置等）
3. 使用 docker-compose 构建镜像：
   ```bash
   docker-compose build candidate-app
   ```

## 端口

- 服务端口: 3000

## 依赖

- MySQL 数据库 (与 gaza-server 共享)
- OAuth2 认证（调用 gaza-server 服务）

## 环境变量

详见 `.env.example` 文件，主要包括：
- DATABASE_URL: 数据库连接
- OAUTH2_*: OAuth认证配置
- ADMIN_SERVICE_BASE_URL: gaza-server 地址
