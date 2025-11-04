# Gaza - 多服务系统

这是一个基于微服务架构的完整系统，包含多个前后端服务。

## 系统架构

- **Java服务1**: 后端服务（具体功能待补充）
- **Java服务2**: 后端服务（具体功能待补充）
- **Vue3前端**: 前端应用
- **React前端**: 前端应用
- **Python服务**: 后端服务

## 快速开始

### 前置要求

- Docker (20.10+)
- Docker Compose (2.0+)

### 本地开发部署

1. 克隆仓库并准备各服务代码
2. 复制环境变量配置：
   ```bash
   cp .env.example .env
   ```

3. 编辑 `.env` 文件，配置必要的环境变量

4. 构建并启动所有服务：
   ```bash
   docker-compose up -d --build
   ```

5. 查看服务状态：
   ```bash
   docker-compose ps
   ```

6. 查看日志：
   ```bash
   docker-compose logs -f [service-name]
   ```

### 停止服务

```bash
docker-compose down
```

### 停止并清除数据卷

```bash
docker-compose down -v
```

## 服务端口映射

根据实际配置调整：

- Java服务1: `http://localhost:8080`
- Java服务2: `http://localhost:8081`
- Vue3前端: `http://localhost:3000`
- React前端: `http://localhost:3001`
- Python服务: `http://localhost:5000`

## 云端部署

详见 [DEPLOYMENT.md](./DEPLOYMENT.md)
