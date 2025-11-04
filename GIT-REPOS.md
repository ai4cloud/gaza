# Git 仓库配置

本文档记录Gaza系统各服务的Git仓库地址和代码管理信息。

## 📦 服务仓库列表

### 1. Gaza Server (主后端服务)

**项目**: ruoyi-vue-pro
**技术栈**: Java 17 + Spring Boot 3.5.5 + MyBatis-Plus
**Git仓库**: https://gitee.com/gin_tonic/gaza-pro
**本地路径**: `/Users/daizhenzhong/Documents/workspace/tmp/ruoyi-vue-pro`
**服务目录**: `services/gaza-server/`

```bash
# 克隆或链接代码
cd services/gaza-server
git clone https://gitee.com/gin_tonic/gaza-pro.git .
```

**构建说明**:
```bash
# 在项目根目录执行
mvn clean package -DskipTests
# 确保 target/yudao-server.jar 生成
```

---

### 2. Gaza UI (管理后台前端)

**项目**: yudao-ui-admin-vue3
**技术栈**: Vue3 + Vite + Element Plus + TypeScript
**Git仓库**: (请填写实际地址)
**本地路径**: `/Users/daizhenzhong/Documents/workspace/private/yudao-ui-admin-vue3`
**服务目录**: `services/gaza-ui/`

```bash
# 克隆或链接代码
cd services/gaza-ui
# git clone <your-repo-url> .
# 或者创建符号链接
ln -s /Users/daizhenzhong/Documents/workspace/private/yudao-ui-admin-vue3/* .
```

**构建说明**:
```bash
# 使用pnpm
pnpm install
pnpm run build:prod
```

---

### 3. File Preview Server (文件预览服务)

**项目**: kkFileView
**技术栈**: Java 8 + Spring Boot 2.4.2
**Git仓库**: https://github.com/kekingcn/kkFileView
**本地路径**: `/Users/daizhenzhong/Documents/workspace/lab/kkFileView`
**服务目录**: `services/file-preview-server/`

```bash
# 克隆或链接代码
cd services/file-preview-server
git clone https://github.com/kekingcn/kkFileView.git .
```

**构建说明**:
```bash
mvn clean package -DskipTests
# 确保 server/target/kkFileView-4.4.0.tar.gz 生成
```

---

### 4. Candidate App (HR候选人应用)

**项目**: hr-candidate-app
**技术栈**: Next.js 15 + React 19 + Prisma + TypeScript
**Git仓库**: (请填写实际地址)
**本地路径**: `/Users/daizhenzhong/Documents/workspace/private/hr-candidate-server/hr-candidate-app`
**服务目录**: `services/candidate-app/`

```bash
# 克隆或链接代码
cd services/candidate-app
# git clone <your-repo-url> .
# 或者创建符号链接
ln -s /Users/daizhenzhong/Documents/workspace/private/hr-candidate-server/hr-candidate-app/* .
```

**构建说明**:
```bash
npm install
# Prisma客户端在Docker构建时生成
```

---

### 5. MinerU Service (PDF转Markdown服务)

**项目**: MinerU
**技术栈**: Python 3.10+ + FastAPI + PyTorch
**Git仓库**: https://github.com/opendatalab/MinerU
**本地路径**: `/Users/daizhenzhong/Documents/workspace/lab/MinerU`
**服务目录**: `services/mineru-service/`

```bash
# 克隆或链接代码
cd services/mineru-service
git clone https://github.com/opendatalab/MinerU.git .
```

**构建说明**:
- Docker构建时自动安装依赖
- 需要GPU支持以获得最佳性能

---

## 🔧 快速设置所有服务

### 方法1: 使用符号链接（推荐用于开发）

```bash
#!/bin/bash
# setup-services.sh

cd services

# Gaza Server
cd gaza-server
cp -r /Users/daizhenzhong/Documents/workspace/tmp/ruoyi-vue-pro/* .
cd ..

# Gaza UI
cd gaza-ui
ln -s /Users/daizhenzhong/Documents/workspace/private/yudao-ui-admin-vue3/* .
cd ..

# File Preview Server
cd file-preview-server
cp -r /Users/daizhenzhong/Documents/workspace/lab/kkFileView/* .
cd ..

# Candidate App
cd candidate-app
ln -s /Users/daizhenzhong/Documents/workspace/private/hr-candidate-server/hr-candidate-app/* .
cd ..

# MinerU Service
cd mineru-service
cp -r /Users/daizhenzhong/Documents/workspace/lab/MinerU/* .
cd ..

echo "所有服务代码已设置完成"
```

### 方法2: 使用Git克隆

```bash
#!/bin/bash
# clone-all-repos.sh

cd services

# Gaza Server
cd gaza-server
git clone https://gitee.com/gin_tonic/gaza-pro.git .
cd ..

# Gaza UI
cd gaza-ui
git clone <your-gaza-ui-repo> .
cd ..

# File Preview Server
cd file-preview-server
git clone https://github.com/kekingcn/kkFileView.git .
cd ..

# Candidate App
cd candidate-app
git clone <your-candidate-app-repo> .
cd ..

# MinerU Service
cd mineru-service
git clone https://github.com/opendatalab/MinerU.git .
cd ..

echo "所有仓库已克隆完成"
```

---

## 📝 Git分支管理策略

### 开发分支

- `main` / `master`: 生产环境分支
- `develop`: 开发环境分支
- `feature/*`: 功能开发分支
- `hotfix/*`: 紧急修复分支

### 提交规范

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建/工具链更新
```

---

## 🔄 代码同步

### 从本地更新到Docker服务

开发时修改了本地代码后，重新构建Docker镜像：

```bash
# 重新构建特定服务
docker-compose build gaza-server

# 重新启动服务
docker-compose up -d gaza-server
```

### 从Git更新代码

```bash
# 进入服务目录
cd services/gaza-server

# 拉取最新代码
git pull

# 重新构建
cd ../..
docker-compose build gaza-server
docker-compose up -d gaza-server
```

---

## 📌 注意事项

1. **敏感信息**: 不要将 `.env` 文件提交到Git仓库
2. **大文件**: 使用 Git LFS 管理大文件（模型文件、数据集等）
3. **代码审查**: 所有代码合并到主分支前需经过Code Review
4. **版本标签**: 发布新版本时打上Git标签

```bash
# 创建版本标签
git tag -a v1.0.0 -m "Gaza System v1.0.0"
git push origin v1.0.0
```

---

## 🆘 常见问题

### Q: 如何更新某个服务的代码？

A: 进入对应的services子目录，使用git pull更新，然后重新构建Docker镜像。

### Q: 本地开发时是否需要Docker？

A: 不一定。可以直接在本地运行服务进行开发，只在部署时使用Docker。

### Q: 如何处理多个服务的版本依赖？

A: 建议在docker-compose.yml中使用具体的镜像版本tag，而不是latest。
