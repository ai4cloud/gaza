# Gaza UI

基于 Vue3 + Vite + Element Plus 的管理后台前端。

## 本地代码路径

将 `/Users/daizhenzhong/Documents/workspace/private/yudao-ui-admin-vue3` 的代码链接或复制到此目录。

## Git 仓库

```bash
# 示例 - 请替换为实际的仓库地址
git clone https://gitee.com/yudaocode/yudao-ui-admin-vue3.git .
```

## 构建说明

1. 确保使用 pnpm 作为包管理器
2. 环境变量配置参考 `.env.production`
3. 使用 docker-compose 构建镜像：
   ```bash
   docker-compose build gaza-ui
   ```

## 端口

- 服务端口: 80 (容器内) -> 8080 (宿主机，可配置)

## API 代理

nginx已配置 `/prod-api/` 自动代理到 `gaza-server:48080`
