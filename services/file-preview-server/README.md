# File Preview Server (kkFileView)

文件在线预览服务，支持多种文件格式的在线预览。

## 本地代码路径

将 `/Users/daizhenzhong/Documents/workspace/lab/kkFileView` 的代码链接或复制到此目录。

## Git 仓库

```bash
# 示例 - 请替换为实际的仓库地址
git clone https://github.com/kekingcn/kkFileView.git .
```

## 构建说明

1. 首先在项目根目录构建项目：
   ```bash
   mvn clean package -DskipTests
   ```

2. 确保 `server/target/kkFileView-4.4.0.tar.gz` 存在

3. 使用 docker-compose 构建镜像：
   ```bash
   docker-compose build file-preview-server
   ```

## 端口

- 服务端口: 8012 (默认)

## 使用方式

通过 HTTP URL 方式访问，例如：
```
http://file-preview-server:8012/onlinePreview?url=文件URL
```
