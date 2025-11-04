# MinerU Service Dockerfile
# PDF转Markdown服务，支持FastAPI接口
# Python 3.10+ based on sglang

FROM lmsysorg/sglang:latest

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY . .

# 安装MinerU及其依赖
# 使用 pip install 而不是 源码安装，以便利用PyPI的预构建包
RUN pip install --no-cache-dir -e ".[api]"

# 或者使用完整安装（包括VLM和其他功能）
# RUN pip install --no-cache-dir -e ".[all]"

# 设置环境变量
ENV MINERU_MODEL_SOURCE=modelscope \
    PYTHONUNBUFFERED=1 \
    TZ=Asia/Shanghai

# 暴露API端口
EXPOSE 8000

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# 默认启动FastAPI服务
CMD ["mineru-api", "--host", "0.0.0.0", "--port", "8000"]

# 可选的其他启动方式：
# Gradio界面: CMD ["mineru-gradio", "--server-name", "0.0.0.0", "--server-port", "7860"]
# sglang服务器: CMD ["mineru-sglang-server", "--host", "0.0.0.0", "--port", "30000"]
