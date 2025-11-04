#!/bin/bash

# 数据备份脚本

set -e

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${DATE}"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

echo "开始备份..."

# 备份数据库
echo "备份数据库..."
docker-compose exec -T database mysqldump -u root -p"${DATABASE_ROOT_PASSWORD}" --all-databases > "${BACKUP_DIR}/${BACKUP_NAME}_database.sql"

# 备份docker volumes
echo "备份数据卷..."
docker run --rm -v gaza_database-data:/data -v "$(pwd)/${BACKUP_DIR}":/backup ubuntu tar czf "/backup/${BACKUP_NAME}_volumes.tar.gz" /data

# 备份配置文件
echo "备份配置文件..."
tar czf "${BACKUP_DIR}/${BACKUP_NAME}_config.tar.gz" .env docker-compose.yml nginx/

echo "备份完成! 文件保存在: ${BACKUP_DIR}/${BACKUP_NAME}_*"
echo "可以删除旧的备份文件以节省空间"
