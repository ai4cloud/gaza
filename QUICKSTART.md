# 快速开始指南

这是一个5分钟快速开始指南，帮助你快速理解和使用这个容器化项目。

## 当前项目结构

```
gaza/
├── README.md                   # 项目概述
├── QUICKSTART.md              # 本文件：快速开始
├── SETUP.md                   # 详细设置指南
├── DEPLOYMENT.md              # 云端部署指南
├── docker-compose.yml         # Docker编排配置
├── .env.example               # 环境变量模板
├── .gitignore                 # Git忽略配置
│
├── scripts/                   # 辅助脚本
│   ├── deploy.sh             # 一键部署脚本
│   ├── backup.sh             # 数据备份脚本
│   └── logs.sh               # 日志查看脚本
│
├── services/                  # 所有服务目录
│   ├── java-service-1/       # Java服务1
│   │   ├── Dockerfile        # ✓ 已创建
│   │   ├── .dockerignore     # ✓ 已创建
│   │   └── [你的Java代码]    # ← 需要你添加
│   │
│   ├── java-service-2/       # Java服务2
│   │   ├── Dockerfile        # ✓ 已创建
│   │   ├── .dockerignore     # ✓ 已创建
│   │   └── [你的Java代码]    # ← 需要你添加
│   │
│   ├── vue-frontend/         # Vue3前端
│   │   ├── Dockerfile        # ✓ 已创建
│   │   ├── nginx.conf        # ✓ 已创建
│   │   ├── .dockerignore     # ✓ 已创建
│   │   └── [你的Vue代码]     # ← 需要你添加
│   │
│   ├── react-frontend/       # React前端
│   │   ├── Dockerfile        # ✓ 已创建
│   │   ├── nginx.conf        # ✓ 已创建
│   │   ├── .dockerignore     # ✓ 已创建
│   │   └── [你的React代码]   # ← 需要你添加
│   │
│   └── python-service/       # Python服务
│       ├── Dockerfile        # ✓ 已创建
│       ├── .dockerignore     # ✓ 已创建
│       └── [你的Python代码]  # ← 需要你添加
│
└── nginx/                     # Nginx配置（可选）
    └── nginx.conf            # ✓ 已创建
```

## 三步完成设置

### 第一步：复制你的服务代码

将你本地的5个项目代码分别复制到对应目录：

```bash
# 假设你的项目在以下位置
cp -r ~/my-projects/java-project-1/* ./services/java-service-1/
cp -r ~/my-projects/java-project-2/* ./services/java-service-2/
cp -r ~/my-projects/vue-app/* ./services/vue-frontend/
cp -r ~/my-projects/react-app/* ./services/react-frontend/
cp -r ~/my-projects/python-api/* ./services/python-service/
```

**重要提示：**
- Java项目需要包含 `pom.xml` 或 `build.gradle`
- Vue/React项目需要包含 `package.json`
- Python项目需要包含 `requirements.txt`

### 第二步：配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑配置（至少要修改数据库密码）
nano .env  # 或使用 vim/code 等编辑器
```

**必须修改的配置：**
- `DATABASE_ROOT_PASSWORD` - 数据库root密码
- `DATABASE_PASSWORD` - 应用数据库密码

### 第三步：启动服务

**方式1：使用脚本（推荐）**

```bash
# 一键部署
./scripts/deploy.sh
```

**方式2：手动执行**

```bash
# 构建并启动
docker-compose up -d --build

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

## 验证部署

打开浏览器访问：

- Vue前端: http://localhost:3000
- React前端: http://localhost:3001
- Java服务1: http://localhost:8080
- Java服务2: http://localhost:8081
- Python服务: http://localhost:5000

## 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看所有日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f java-service-1

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 停止并删除数据
docker-compose down -v

# 更新服务（重新构建）
docker-compose up -d --build service-name
```

## 下一步

- **本地开发**：参考 [SETUP.md](./SETUP.md) 了解详细配置
- **云端部署**：参考 [DEPLOYMENT.md](./DEPLOYMENT.md) 部署到阿里云/腾讯云/AWS等

## 故障排查

### 问题1：容器无法启动

```bash
# 查看具体错误
docker-compose logs service-name

# 检查配置
docker-compose config
```

### 问题2：端口被占用

```bash
# 查看端口占用
lsof -i :8080

# 修改.env中的端口配置
```

### 问题3：服务间无法通信

确保在应用配置中使用Docker服务名而不是localhost：
- 数据库地址: `database:3306` 而不是 `localhost:3306`
- Redis地址: `redis:6379` 而不是 `localhost:6379`

## 获取帮助

- 查看详细文档：[README.md](./README.md)
- 设置指南：[SETUP.md](./SETUP.md)
- 部署指南：[DEPLOYMENT.md](./DEPLOYMENT.md)
