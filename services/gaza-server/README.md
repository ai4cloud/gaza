# Gaza Server

基于 ruoyi-vue-pro 的后端主服务。

## 本地代码路径

将 `/Users/daizhenzhong/Documents/workspace/tmp/ruoyi-vue-pro` 的代码链接或复制到此目录。

## Git 仓库

```bash
# 示例 - 请替换为实际的仓库地址
git clone https://gitee.com/gin_tonic/gaza-pro.git .
```

## 构建说明

1. 首先在项目根目录构建 JAR 包：
   ```bash
   mvn clean package -DskipTests
   ```

2. 确保 `target/yudao-server.jar` 存在

3. 使用 docker-compose 构建镜像：
   ```bash
   docker-compose build gaza-server
   ```

## 端口

- 服务端口: 48080
- 数据库: MySQL 8
- 缓存: Redis 6
