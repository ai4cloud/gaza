# Java服务Dockerfile - Spring Boot示例
# 多阶段构建，减小镜像大小

# 构建阶段
FROM maven:3.8-openjdk-17 AS builder

WORKDIR /app

# 复制pom.xml和下载依赖（利用Docker缓存）
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 复制源代码并构建
COPY src ./src
RUN mvn clean package -DskipTests

# 运行阶段
FROM openjdk:17-jdk-slim

WORKDIR /app

# 创建非root用户
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 从构建阶段复制jar文件
COPY --from=builder /app/target/*.jar app.jar

# 创建日志目录
RUN mkdir -p /app/logs && chown -R appuser:appuser /app

# 切换到非root用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# JVM优化参数
ENV JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# 启动应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]

# 使用说明：
# 1. 将此文件放在Java项目根目录
# 2. 确保pom.xml在同级目录
# 3. 如果使用Gradle，替换Maven命令为Gradle命令
#
# Gradle示例：
# FROM gradle:7.6-jdk17 AS builder
# WORKDIR /app
# COPY build.gradle settings.gradle ./
# COPY gradle ./gradle
# RUN gradle dependencies --no-daemon
# COPY src ./src
# RUN gradle clean build -x test --no-daemon
# COPY --from=builder /app/build/libs/*.jar app.jar
