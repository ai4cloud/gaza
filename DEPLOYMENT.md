# 云端部署指南

本文档提供将系统部署到云端的详细步骤。

## 目录

- [准备工作](#准备工作)
- [部署到阿里云](#部署到阿里云)
- [部署到腾讯云](#部署到腾讯云)
- [部署到AWS](#部署到aws)
- [部署到Azure](#部署到azure)
- [通用部署步骤](#通用部署步骤)
- [监控和维护](#监控和维护)

## 准备工作

### 1. 本地测试

在部署到云端前，确保在本地环境测试通过：

```bash
# 构建并启动所有服务
docker-compose up -d --build

# 检查服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 测试服务是否正常
curl http://localhost:8080/health
curl http://localhost:3000
```

### 2. 准备云服务器

**最低配置建议：**
- CPU: 4核心
- 内存: 8GB
- 存储: 50GB SSD
- 操作系统: Ubuntu 20.04/22.04 LTS 或 CentOS 7/8

### 3. 域名和SSL证书（可选）

如果需要通过域名访问：
- 购买域名并配置DNS解析
- 申请SSL证书（Let's Encrypt免费证书或云服务商提供的证书）

## 通用部署步骤

### 步骤1: 安装Docker和Docker Compose

**Ubuntu/Debian:**

```bash
# 更新系统
sudo apt-get update
sudo apt-get upgrade -y

# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo apt-get install docker-compose-plugin -y

# 验证安装
docker --version
docker compose version

# 将当前用户加入docker组
sudo usermod -aG docker $USER
```

**CentOS:**

```bash
# 安装Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# 启动Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### 步骤2: 上传代码到服务器

**方法1: 使用Git（推荐）**

```bash
# 在服务器上克隆仓库
git clone <your-repository-url>
cd gaza

# 复制各服务代码到对应目录
# 将本地的Java、Vue、React、Python项目代码分别复制到：
# - services/java-service-1/
# - services/java-service-2/
# - services/vue-frontend/
# - services/react-frontend/
# - services/python-service/
```

**方法2: 使用SCP**

```bash
# 在本地执行，将整个项目上传到服务器
scp -r /path/to/gaza user@server-ip:/home/user/
```

**方法3: 使用rsync**

```bash
# 在本地执行
rsync -avz --progress /path/to/gaza user@server-ip:/home/user/
```

### 步骤3: 配置环境变量

```bash
cd gaza

# 复制环境变量模板
cp .env.example .env

# 编辑环境变量
nano .env  # 或使用 vim .env
```

**重要配置项：**

```bash
# 数据库密码（务必修改为强密码）
DATABASE_ROOT_PASSWORD=your_strong_root_password
DATABASE_PASSWORD=your_strong_password

# 根据实际情况配置API地址
VUE_APP_API_URL=http://your-server-ip:8080/api
REACT_APP_API_URL=http://your-server-ip:8080/api

# 如果使用域名
# VUE_APP_API_URL=https://api.yourdomain.com
# REACT_APP_API_URL=https://api.yourdomain.com
```

### 步骤4: 配置防火墙

**Ubuntu (UFW):**

```bash
# 允许必要的端口
sudo ufw allow 22/tcp      # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS
sudo ufw allow 8080/tcp    # Java服务1
sudo ufw allow 8081/tcp    # Java服务2
sudo ufw allow 3000/tcp    # Vue前端
sudo ufw allow 3001/tcp    # React前端
sudo ufw allow 5000/tcp    # Python服务

sudo ufw enable
sudo ufw status
```

**CentOS (firewalld):**

```bash
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=3001/tcp
sudo firewall-cmd --permanent --add-port=5000/tcp
sudo firewall-cmd --reload
```

**云服务商安全组：**

同时需要在云服务商控制台配置安全组规则，开放上述端口。

### 步骤5: 部署应用

```bash
cd gaza

# 构建并启动所有服务（首次部署）
docker compose up -d --build

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f
```

### 步骤6: 验证部署

```bash
# 检查各服务健康状态
curl http://localhost:8080/actuator/health  # Java服务1
curl http://localhost:8081/actuator/health  # Java服务2
curl http://localhost:5000/health           # Python服务
curl http://localhost:3000                  # Vue前端
curl http://localhost:3001                  # React前端

# 查看容器状态
docker compose ps

# 查看容器资源使用情况
docker stats
```

## 部署到阿里云

### 使用阿里云ECS

1. **创建ECS实例**
   - 登录阿里云控制台
   - 创建ECS实例（推荐：计算型c6 或 通用型g6）
   - 选择Ubuntu 20.04镜像
   - 配置安全组规则

2. **配置安全组**
   - 入方向规则添加：22, 80, 443, 8080, 8081, 3000, 3001, 5000

3. **连接服务器并部署**
   ```bash
   ssh root@your-ecs-ip
   # 按照通用部署步骤执行
   ```

### 使用阿里云容器服务ACK（可选）

如果需要更强大的容器编排能力，可以使用阿里云容器服务Kubernetes版(ACK)。

## 部署到腾讯云

### 使用腾讯云CVM

1. **创建CVM实例**
   - 登录腾讯云控制台
   - 创建云服务器（推荐：标准型S5）
   - 选择Ubuntu 20.04镜像

2. **配置安全组**
   - 添加入站规则：22, 80, 443, 8080, 8081, 3000, 3001, 5000

3. **部署应用**
   ```bash
   ssh ubuntu@your-cvm-ip
   # 按照通用部署步骤执行
   ```

## 部署到AWS

### 使用EC2

1. **创建EC2实例**
   - 选择Ubuntu Server 20.04 LTS AMI
   - 实例类型：t3.medium 或更高
   - 配置安全组

2. **安全组配置**
   ```
   Type            Protocol    Port Range    Source
   SSH             TCP         22            0.0.0.0/0
   HTTP            TCP         80            0.0.0.0/0
   HTTPS           TCP         443           0.0.0.0/0
   Custom TCP      TCP         8080          0.0.0.0/0
   Custom TCP      TCP         8081          0.0.0.0/0
   Custom TCP      TCP         3000          0.0.0.0/0
   Custom TCP      TCP         3001          0.0.0.0/0
   Custom TCP      TCP         5000          0.0.0.0/0
   ```

3. **连接并部署**
   ```bash
   ssh -i your-key.pem ubuntu@ec2-ip-address
   # 按照通用部署步骤执行
   ```

### 使用ECS (Elastic Container Service)（可选）

AWS ECS提供托管的容器服务，可以直接部署Docker容器。

## 部署到Azure

### 使用Azure虚拟机

1. **创建虚拟机**
   - 选择Ubuntu Server 20.04 LTS
   - 大小：Standard_B2s 或更高
   - 配置网络安全组

2. **网络安全组规则**
   - 添加入站端口规则：22, 80, 443, 8080, 8081, 3000, 3001, 5000

3. **部署**
   ```bash
   ssh azureuser@vm-ip-address
   # 按照通用部署步骤执行
   ```

## 使用Nginx反向代理（推荐）

为了提供统一的访问入口，建议使用Nginx作为反向代理。

### 1. 启用Nginx服务

在 `docker-compose.yml` 中取消注释nginx服务部分。

### 2. 配置Nginx

创建 `nginx/nginx.conf`:

```nginx
events {
    worker_connections 1024;
}

http {
    upstream java_service_1 {
        server java-service-1:8080;
    }

    upstream java_service_2 {
        server java-service-2:8080;
    }

    upstream python_service {
        server python-service:5000;
    }

    upstream vue_frontend {
        server vue-frontend:80;
    }

    upstream react_frontend {
        server react-frontend:80;
    }

    # Vue前端
    server {
        listen 80;
        server_name your-vue-domain.com;

        location / {
            proxy_pass http://vue_frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /api/ {
            proxy_pass http://java_service_1/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }

    # React前端
    server {
        listen 80;
        server_name your-react-domain.com;

        location / {
            proxy_pass http://react_frontend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /api/ {
            proxy_pass http://python_service/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

### 3. 配置SSL（Let's Encrypt）

```bash
# 安装certbot
sudo apt-get install certbot python3-certbot-nginx -y

# 获取证书
sudo certbot --nginx -d your-domain.com
```

## 监控和维护

### 查看日志

```bash
# 查看所有服务日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f java-service-1

# 查看最近100行日志
docker compose logs --tail=100 java-service-1
```

### 重启服务

```bash
# 重启所有服务
docker compose restart

# 重启特定服务
docker compose restart java-service-1

# 更新服务（重新构建）
docker compose up -d --build java-service-1
```

### 备份数据

```bash
# 备份数据库
docker compose exec database mysqldump -u root -p gaza_db > backup.sql

# 备份Docker volumes
docker run --rm -v gaza_database-data:/data -v $(pwd):/backup ubuntu tar czf /backup/database-backup.tar.gz /data
```

### 清理资源

```bash
# 清理未使用的镜像
docker image prune -a

# 清理未使用的容器
docker container prune

# 清理未使用的卷
docker volume prune

# 清理所有未使用的资源
docker system prune -a
```

### 监控资源使用

```bash
# 查看容器资源使用情况
docker stats

# 查看磁盘使用
df -h

# 查看Docker磁盘使用
docker system df
```

### 设置自动重启

docker-compose.yml中已配置 `restart: unless-stopped`，容器会在退出时自动重启。

### 设置开机自启动

```bash
# 创建systemd服务
sudo nano /etc/systemd/system/gaza-app.service
```

内容如下：

```ini
[Unit]
Description=Gaza Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/path/to/gaza
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

启用服务：

```bash
sudo systemctl daemon-reload
sudo systemctl enable gaza-app.service
sudo systemctl start gaza-app.service
```

## 故障排查

### 常见问题

1. **容器无法启动**
   ```bash
   docker compose logs service-name
   ```

2. **端口被占用**
   ```bash
   sudo lsof -i :8080
   sudo netstat -tulpn | grep 8080
   ```

3. **内存不足**
   ```bash
   free -h
   docker stats
   # 考虑增加服务器配置或优化容器资源限制
   ```

4. **磁盘空间不足**
   ```bash
   df -h
   docker system prune -a
   ```

## 安全建议

1. **定期更新系统和Docker**
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

2. **使用强密码**
   - 数据库密码
   - SSH密钥认证

3. **限制SSH访问**
   ```bash
   # 禁用root登录
   sudo nano /etc/ssh/sshd_config
   # 设置 PermitRootLogin no
   sudo systemctl restart sshd
   ```

4. **配置防火墙**
   - 只开放必要的端口
   - 使用云服务商的安全组功能

5. **备份策略**
   - 定期备份数据库
   - 定期备份配置文件
   - 使用云服务商的快照功能

## 性能优化

1. **调整JVM参数**（Java服务）
   - 在Dockerfile中配置合适的堆内存大小

2. **配置数据库连接池**
   - 根据并发需求调整连接池大小

3. **启用Gzip压缩**
   - Nginx已配置，确保前端资源被压缩

4. **使用CDN**
   - 将静态资源部署到CDN加速访问

5. **配置Redis缓存**
   - 缓存热点数据减少数据库压力

## 扩展阅读

- [Docker官方文档](https://docs.docker.com/)
- [Docker Compose文档](https://docs.docker.com/compose/)
- [Nginx配置指南](https://nginx.org/en/docs/)
- [Let's Encrypt文档](https://letsencrypt.org/docs/)
