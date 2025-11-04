# MinerU Service

PDF转Markdown的AI服务，提供FastAPI接口。

## 本地代码路径

将 `/Users/daizhenzhong/Documents/workspace/lab/MinerU` 的代码链接或复制到此目录。

## Git 仓库

```bash
# 示例
git clone https://github.com/opendatalab/MinerU.git .
```

## 构建说明

1. 确保有 pyproject.toml 和 mineru 目录
2. 使用 docker-compose 构建镜像：
   ```bash
   docker-compose build mineru-service
   ```

## 端口

- FastAPI: 8000
- Gradio (可选): 7860
- sglang-server (可选): 30000

## 运行模式

### 1. FastAPI模式 (默认)
提供HTTP API接口用于PDF解析

### 2. Gradio模式
提供Web UI界面

### 3. sglang-server模式
提供VLM推理服务

## GPU要求

- 建议：NVIDIA GPU with 8GB+ VRAM
- 架构：Turing或更新
- CUDA支持

## 使用方式

API调用示例：
```bash
curl -X POST http://localhost:8000/parse \
  -F "file=@document.pdf" \
  -F "mode=auto"
```

## 环境变量

- MINERU_MODEL_SOURCE: modelscope 或 local
- GPU配置：通过docker-compose.yml配置
