#!/bin/bash

# 日志查看脚本

if [ -z "$1" ]; then
    echo "查看所有服务日志..."
    docker-compose logs -f --tail=100
else
    echo "查看 $1 服务日志..."
    docker-compose logs -f --tail=100 "$1"
fi
