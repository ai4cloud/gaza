#!/bin/bash

# 部署脚本 - 用于快速部署应用

set -e  # 遇到错误立即退出

echo "==================================="
echo "  Gaza 应用部署脚本"
echo "==================================="

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查Docker是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: Docker未安装${NC}"
        echo "请先安装Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        echo -e "${RED}错误: Docker Compose未安装${NC}"
        echo "请先安装Docker Compose"
        exit 1
    fi

    echo -e "${GREEN}✓ Docker已安装${NC}"
}

# 检查.env文件
check_env() {
    if [ ! -f .env ]; then
        echo -e "${YELLOW}警告: .env文件不存在${NC}"
        echo "正在从.env.example创建.env文件..."
        cp .env.example .env
        echo -e "${YELLOW}请编辑.env文件配置必要的环境变量后重新运行此脚本${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ 环境变量配置文件存在${NC}"
}

# 检查服务代码是否存在
check_services() {
    local missing_services=()

    if [ ! -f "services/java-service-1/pom.xml" ] && [ ! -f "services/java-service-1/build.gradle" ]; then
        missing_services+=("java-service-1")
    fi

    if [ ! -f "services/java-service-2/pom.xml" ] && [ ! -f "services/java-service-2/build.gradle" ]; then
        missing_services+=("java-service-2")
    fi

    if [ ! -f "services/vue-frontend/package.json" ]; then
        missing_services+=("vue-frontend")
    fi

    if [ ! -f "services/react-frontend/package.json" ]; then
        missing_services+=("react-frontend")
    fi

    if [ ! -f "services/python-service/requirements.txt" ]; then
        missing_services+=("python-service")
    fi

    if [ ${#missing_services[@]} -gt 0 ]; then
        echo -e "${YELLOW}警告: 以下服务的代码可能缺失:${NC}"
        for service in "${missing_services[@]}"; do
            echo "  - $service"
        done
        echo -e "${YELLOW}请参考SETUP.md将服务代码复制到对应目录${NC}"
        read -p "是否继续部署? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✓ 所有服务代码已就位${NC}"
    fi
}

# 停止并删除旧容器
cleanup() {
    echo "正在停止旧容器..."
    docker-compose down
    echo -e "${GREEN}✓ 旧容器已停止${NC}"
}

# 构建并启动服务
build_and_start() {
    echo "正在构建并启动所有服务..."
    echo "这可能需要几分钟时间，请耐心等待..."

    docker-compose up -d --build

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ 服务启动成功${NC}"
    else
        echo -e "${RED}✗ 服务启动失败${NC}"
        exit 1
    fi
}

# 等待服务就绪
wait_for_services() {
    echo "等待服务启动..."
    sleep 10

    echo -e "\n当前服务状态:"
    docker-compose ps
}

# 显示服务信息
show_info() {
    echo -e "\n==================================="
    echo -e "${GREEN}部署完成!${NC}"
    echo "==================================="
    echo -e "\n服务访问地址:"
    echo "  Java服务1:   http://localhost:8080"
    echo "  Java服务2:   http://localhost:8081"
    echo "  Vue前端:     http://localhost:3000"
    echo "  React前端:   http://localhost:3001"
    echo "  Python服务:  http://localhost:5000"
    echo "  数据库:      localhost:3306"
    echo "  Redis:       localhost:6379"
    echo -e "\n常用命令:"
    echo "  查看日志:     docker-compose logs -f [service-name]"
    echo "  停止服务:     docker-compose down"
    echo "  重启服务:     docker-compose restart"
    echo "  查看状态:     docker-compose ps"
    echo "==================================="
}

# 主函数
main() {
    cd "$(dirname "$0")/.."  # 切换到项目根目录

    check_docker
    check_env
    check_services
    cleanup
    build_and_start
    wait_for_services
    show_info
}

main "$@"
