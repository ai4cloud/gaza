# Gaza - 智能HR管理系统

Gaza是一个基于微服务架构的完整智能HR管理系统，包含多个前后端服务。

## 🏗️ 系统架构

### 后端服务

- **Gaza Server**: 主后端服务（基于ruoyi-vue-pro）
  - Java 17 + Spring Boot 3.5.5
  - 端口: 48080
  - 提供核心业务API、权限管理、OAuth2认证等

- **File Preview Server**: 文件在线预览服务（基于kkFileView）
  - Java 8 + Spring Boot 2.4.2
  - 端口: 8012
  - 支持多种文件格式在线预览

- **MinerU Service**: PDF转Markdown AI服务
  - Python 3.10+ + FastAPI
  - 端口: 8000
  - 提供智能PDF解析和转换能力

### 前端服务

- **Gaza UI**: 管理后台前端（基于yudao-ui-admin-vue3）
  - Vue3 + Vite + Element Plus
  - 端口: 80
  - 完整的后台管理界面

- **Candidate App**: HR候选人简历填写应用
  - Next.js 15 + React 19 + Prisma
  - 端口: 3000
  - 候选人简历填写和管理

### 基础设施

- **MySQL 8**: 关系型数据库（所有服务共享）
- **Redis 7**: 缓存和会话存储

## 🚀 快速开始

### 前置要求

- Docker (20.10+)
- Docker Compose (2.0+)
- 至少 8GB 内存
- 50GB+ 磁盘空间

### 一键启动

1. 克隆仓库：
   ```bash
   git clone https://gitee.com/gin_tonic/gaza.git
   cd gaza
   ```

2. 准备各服务代码：
   ```bash
   # 参考 GIT-REPOS.md 设置各服务代码
   # 或运行自动化脚本
   ./scripts/setup-services.sh
   ```

3. 配置环境变量：
   ```bash
   cp .env.example .env
   # 编辑 .env，至少修改数据库密码
   vim .env
   ```

4. 启动所有服务：
   ```bash
   docker-compose up -d --build
   ```

5. 查看服务状态：
   ```bash
   docker-compose ps
   ```

## 📊 服务端口映射

| 服务 | 端口 | 访问地址 | 说明 |
|------|------|----------|------|
| Gaza UI | 80 | http://localhost | 管理后台 |
| Candidate App | 3000 | http://localhost:3000 | 候选人应用 |
| Gaza Server | 48080 | http://localhost:48080 | 主API服务 |
| File Preview | 8012 | http://localhost:8012 | 文件预览 |
| MinerU API | 8000 | http://localhost:8000 | PDF解析API |
| MySQL | 3306 | localhost:3306 | 数据库 |
| Redis | 6379 | localhost:6379 | 缓存 |

## 📖 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看所有日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f gaza-server

# 重启服务
docker-compose restart gaza-server

# 停止所有服务
docker-compose down

# 停止并删除所有数据
docker-compose down -v

# 重新构建某个服务
docker-compose build gaza-server
docker-compose up -d gaza-server
```

## 🔧 服务依赖关系

```
Gaza UI (Vue3)
    ↓ (HTTP API)
Gaza Server (Spring Boot)
    ↓ (OAuth2)
Candidate App (Next.js) → Gaza Server
    ↓ (HTTP API)
File Preview Server
MinerU Service

All Services → MySQL (共享数据库)
Gaza Server, Candidate App → Redis
```

## 📁 项目结构

```
gaza/
├── docker-compose.yml          # Docker编排配置
├── .env.example                # 环境变量模板
├── GIT-REPOS.md               # Git仓库配置文档
├── README.md                  # 本文件
├── SETUP.md                   # 详细设置指南
├── DEPLOYMENT.md              # 云端部署指南
├── QUICKSTART.md              # 快速开始指南
├── services/                  # 所有服务目录
│   ├── gaza-server/           # 主后端服务
│   ├── gaza-ui/               # 管理后台前端
│   ├── file-preview-server/   # 文件预览服务
│   ├── candidate-app/         # 候选人应用
│   └── mineru-service/        # PDF解析服务
├── scripts/                   # 辅助脚本
│   ├── deploy.sh             # 一键部署
│   ├── backup.sh             # 数据备份
│   └── logs.sh               # 日志查看
└── nginx/                     # Nginx配置（可选）
    └── nginx.conf
```

## 📚 文档导航

- **[QUICKSTART.md](./QUICKSTART.md)** - 5分钟快速上手
- **[SETUP.md](./SETUP.md)** - 详细的项目设置指南
- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - 云端部署完整指南
- **[GIT-REPOS.md](./GIT-REPOS.md)** - Git仓库管理文档

## 🛠️ 开发指南

### 本地开发

各服务可以独立在本地运行进行开发：

```bash
# Gaza Server
cd services/gaza-server
mvn spring-boot:run

# Gaza UI
cd services/gaza-ui
pnpm dev

# Candidate App
cd services/candidate-app
npm run dev
```

### 代码提交规范

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式
refactor: 重构
test: 测试
chore: 构建/工具
```

## 🔐 安全建议

1. **修改默认密码**: 部署前务必修改 `.env` 中的所有默认密码
2. **使用HTTPS**: 生产环境启用SSL/TLS
3. **定期备份**: 使用 `./scripts/backup.sh` 定期备份数据
4. **防火墙配置**: 只开放必要的端口
5. **日志监控**: 定期检查服务日志

## 🌐 云端部署

支持部署到主流云平台：

- ✅ 阿里云 ECS
- ✅ 腾讯云 CVM
- ✅ AWS EC2
- ✅ Azure VM

详见 [DEPLOYMENT.md](./DEPLOYMENT.md)

## 📝 版本信息

- Gaza System: v1.0.0
- Gaza Server (ruoyi-vue-pro): 2025.09-SNAPSHOT
- Gaza UI: 2025.09-snapshot
- kkFileView: 4.4.0
- MinerU: 2.1.x

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

请查看各子项目的LICENSE文件。

## 🆘 故障排查

### 常见问题

1. **容器无法启动**
   ```bash
   docker-compose logs service-name
   ```

2. **端口被占用**
   ```bash
   lsof -i :端口号
   # 修改 .env 中的端口配置
   ```

3. **内存不足**
   - 调整 Docker Desktop 内存限制
   - 优化 JVM 参数（在 `.env` 中配置）

4. **数据库连接失败**
   - 检查 MySQL 容器是否正常启动
   - 确认 `.env` 中的数据库配置

更多问题请查看 [DEPLOYMENT.md](./DEPLOYMENT.md) 的故障排查章节。

## 📞 联系方式

- 项目主页: https://gitee.com/gin_tonic/gaza
- 问题反馈: https://gitee.com/gin_tonic/gaza/issues
