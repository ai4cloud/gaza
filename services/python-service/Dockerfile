# Python服务Dockerfile
# 支持Flask/FastAPI/Django等框架

FROM python:3.11-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 创建非root用户
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY . .

# 创建数据目录
RUN mkdir -p /app/data && chown -R appuser:appuser /app

# 切换到非root用户
USER appuser

# 暴露端口
EXPOSE 5000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# 环境变量
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py

# 启动命令 - 根据实际框架调整
# Flask示例：
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "60", "app:app"]

# FastAPI示例：
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000", "--workers", "4"]

# Django示例：
# CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "myproject.wsgi:application"]

# 使用说明：
# 1. 将此文件放在Python项目根目录
# 2. 确保requirements.txt在同级目录
# 3. 根据使用的框架调整CMD命令
# 4. 如果使用Flask开发服务器，可以用: CMD ["python", "app.py"]
#    但生产环境建议使用gunicorn或uwsgi
