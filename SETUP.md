# 项目设置指南

本文档说明如何将现有的服务代码整合到这个Docker容器化项目中。

## 项目结构

```
gaza/
├── docker-compose.yml          # Docker编排配置
├── .env                        # 环境变量配置
├── .env.example                # 环境变量模板
├── README.md                   # 项目说明
├── DEPLOYMENT.md               # 部署指南
├── SETUP.md                    # 本文件：设置指南
├── services/                   # 所有服务目录
│   ├── java-service-1/         # Java服务1
│   │   ├── Dockerfile          # 已提供
│   │   ├── .dockerignore       # 已提供
│   │   └── [放置你的Java项目代码]
│   ├── java-service-2/         # Java服务2
│   │   ├── Dockerfile          # 已提供
│   │   ├── .dockerignore       # 已提供
│   │   └── [放置你的Java项目代码]
│   ├── vue-frontend/           # Vue3前端
│   │   ├── Dockerfile          # 已提供
│   │   ├── nginx.conf          # 已提供
│   │   ├── .dockerignore       # 已提供
│   │   └── [放置你的Vue项目代码]
│   ├── react-frontend/         # React前端
│   │   ├── Dockerfile          # 已提供
│   │   ├── nginx.conf          # 已提供
│   │   ├── .dockerignore       # 已提供
│   │   └── [放置你的React项目代码]
│   └── python-service/         # Python服务
│       ├── Dockerfile          # 已提供
│       ├── .dockerignore       # 已提供
│       └── [放置你的Python项目代码]
└── nginx/                      # Nginx反向代理（可选）
    └── nginx.conf              # 已提供
```

## 设置步骤

### 1. 准备Java服务

将你的两个Java项目代码分别复制到：
- `services/java-service-1/`
- `services/java-service-2/`

**确保包含以下文件：**
- `pom.xml` (Maven) 或 `build.gradle` (Gradle)
- `src/` 目录

**如果使用Gradle：**
修改对应的Dockerfile，将Maven命令替换为Gradle命令（注释中已提供示例）。

**配置检查：**
- Spring Boot应用端口需要配置为 `8080`（或在docker-compose.yml中调整）
- 数据库连接配置需要支持环境变量覆盖
- 建议添加Spring Boot Actuator用于健康检查

示例 `application.yml`:
```yaml
server:
  port: 8080

spring:
  datasource:
    url: ${DATABASE_URL:jdbc:mysql://localhost:3306/gaza_db}
    username: ${DATABASE_USERNAME:root}
    password: ${DATABASE_PASSWORD:password}

management:
  endpoints:
    web:
      exposure:
        include: health,info
  endpoint:
    health:
      show-details: always
```

### 2. 准备Vue3前端

将Vue3项目代码复制到 `services/vue-frontend/`

**确保包含：**
- `package.json`
- `src/` 目录
- Vue配置文件 (`vite.config.js` 或 `vue.config.js`)

**配置API地址：**

在你的Vue项目中，API地址应该从环境变量读取：

```javascript
// .env.production
VUE_APP_API_URL=http://localhost:8080/api

// 在代码中使用
const apiUrl = process.env.VUE_APP_API_URL || 'http://localhost:8080/api';
```

**构建命令检查：**

确保 `package.json` 中有构建命令：
```json
{
  "scripts": {
    "build": "vite build"  // 或 "vue-cli-service build"
  }
}
```

构建输出目录应该是 `dist/`（如果不同，需要修改Dockerfile）。

### 3. 准备React前端

将React项目代码复制到 `services/react-frontend/`

**确保包含：**
- `package.json`
- `src/` 目录
- `public/` 目录

**配置API地址：**

```javascript
// .env.production
REACT_APP_API_URL=http://localhost:8080/api

// 在代码中使用
const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:8080/api';
```

**构建命令检查：**

确保 `package.json` 中有构建命令：
```json
{
  "scripts": {
    "build": "react-scripts build"  // 或其他构建工具
  }
}
```

构建输出目录应该是 `build/`（如果不同，需要修改Dockerfile）。

### 4. 准备Python服务

将Python项目代码复制到 `services/python-service/`

**确保包含：**
- `requirements.txt` - Python依赖列表
- 主应用文件（如 `app.py`, `main.py`）

**Flask示例 `requirements.txt`:**
```txt
Flask==2.3.0
Flask-CORS==4.0.0
gunicorn==21.2.0
pymysql==1.1.0
redis==5.0.0
python-dotenv==1.0.0
```

**FastAPI示例 `requirements.txt`:**
```txt
fastapi==0.104.0
uvicorn[standard]==0.24.0
sqlalchemy==2.0.0
pymysql==1.1.0
redis==5.0.0
python-dotenv==1.0.0
```

**应用配置示例 (`app.py`):**
```python
from flask import Flask
import os

app = Flask(__name__)

# 从环境变量读取配置
DATABASE_URL = os.getenv('DATABASE_URL', 'mysql://localhost:3306/gaza_db')
REDIS_URL = os.getenv('REDIS_URL', 'redis://localhost:6379/0')

@app.route('/health')
def health():
    return {'status': 'healthy'}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

**检查启动命令：**

在 `services/python-service/Dockerfile` 中根据实际框架调整CMD命令。

### 5. 配置环境变量

```bash
# 复制模板
cp .env.example .env

# 编辑配置
nano .env  # 或使用你喜欢的编辑器
```

**必须修改的配置：**

```bash
# 数据库密码（强烈建议修改）
DATABASE_ROOT_PASSWORD=your_secure_root_password
DATABASE_PASSWORD=your_secure_password

# 数据库类型选择（MySQL或PostgreSQL）
# 如果使用PostgreSQL，需要同时修改docker-compose.yml中的database服务
DATABASE_URL=jdbc:mysql://database:3306/gaza_db

# API地址（根据实际情况）
VUE_APP_API_URL=http://localhost:8080/api
REACT_APP_API_URL=http://localhost:8080/api
```

**可选配置：**

```bash
# 修改服务端口
JAVA_SERVICE_1_PORT=8080
JAVA_SERVICE_2_PORT=8081
VUE_PORT=3000
REACT_PORT=3001
PYTHON_SERVICE_PORT=5000

# Spring Profile
SPRING_PROFILES_ACTIVE=prod

# Flask环境
FLASK_ENV=production
```

### 6. 调整docker-compose.yml（如果需要）

根据实际需求，可能需要调整：

1. **服务名称**：将 `java-service-1`、`java-service-2` 改为实际的服务名
2. **端口映射**：如果有端口冲突
3. **数据库选择**：MySQL或PostgreSQL
4. **依赖关系**：`depends_on` 配置
5. **环境变量**：传递给容器的环境变量

### 7. 本地测试

```bash
# 构建并启动所有服务
docker-compose up -d --build

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 测试各服务
curl http://localhost:8080/actuator/health  # Java服务1
curl http://localhost:8081/actuator/health  # Java服务2
curl http://localhost:5000/health           # Python服务
curl http://localhost:3000                  # Vue前端
curl http://localhost:3001                  # React前端
```

## 常见问题

### Q1: 构建失败，提示找不到文件

**原因**：服务目录中缺少必要的文件（如pom.xml、package.json等）

**解决**：确保已将完整的项目代码复制到对应的services目录下

### Q2: Java服务启动失败

**可能原因**：
1. Dockerfile中的构建命令与实际项目不匹配（Maven vs Gradle）
2. 数据库连接失败
3. JVM内存不足

**解决**：
1. 检查Dockerfile中的构建命令
2. 检查数据库配置和连接
3. 调整Dockerfile中的JAVA_OPTS内存参数

### Q3: 前端访问API失败（CORS错误）

**原因**：后端未配置CORS

**解决**：在后端添加CORS配置

Spring Boot示例：
```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedMethods("*");
            }
        };
    }
}
```

Flask示例：
```python
from flask_cors import CORS
CORS(app)
```

### Q4: 数据库连接失败

**检查**：
1. 数据库容器是否正常启动：`docker-compose ps`
2. 数据库连接配置是否正确
3. 服务是否等待数据库就绪

**解决**：可以在docker-compose.yml中为数据库添加健康检查

### Q5: 容器内存不足

**解决**：
1. 增加Docker Desktop的内存限制
2. 优化应用的内存使用
3. 在docker-compose.yml中限制单个服务的资源使用

```yaml
services:
  java-service-1:
    # ...
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

## 进阶配置

### 添加新的服务依赖

如果你的服务需要额外的中间件（如RabbitMQ、Elasticsearch等），可以在docker-compose.yml中添加：

```yaml
services:
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"
      - "15672:15672"
    networks:
      - app-network
```

### 自定义网络

如果需要更复杂的网络拓扑：

```yaml
networks:
  frontend-network:
    driver: bridge
  backend-network:
    driver: bridge
```

### 持久化更多数据

添加新的volume：

```yaml
volumes:
  custom-data:

services:
  your-service:
    volumes:
      - custom-data:/path/in/container
```

## 下一步

完成设置后，参考 [DEPLOYMENT.md](./DEPLOYMENT.md) 了解如何部署到云端。
