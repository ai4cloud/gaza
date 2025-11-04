# File Preview Server (kkFileView) Dockerfile
# Java 8 + Spring Boot 2.4.2
# 文件在线预览服务

FROM keking/kkfileview-base:4.4.0

WORKDIR /opt

# 添加构建好的 tar.gz 文件
ADD server/target/kkFileView-*.tar.gz /opt/

# 设置环境变量
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0/bin
ENV TZ=Asia/Shanghai

# 暴露端口 (kkFileView默认使用8012端口)
EXPOSE 8012

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8012 || exit 1

# 启动应用
ENTRYPOINT ["java", \
            "-Dfile.encoding=UTF-8", \
            "-Dspring.config.location=/opt/kkFileView-4.4.0/config/application.properties", \
            "-jar", \
            "/opt/kkFileView-4.4.0/bin/kkFileView-4.4.0.jar"]
