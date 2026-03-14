#!/bin/bash

# OpenClaw配置备份脚本
# 使用方法：./backup-config.sh

BACKUP_DIR="$HOME/.openclaw/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/openclaw-config-backup-$TIMESTAMP.tar.gz"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

echo "开始备份OpenClaw配置..."
echo "备份时间：$(date)"
echo "备份位置：$BACKUP_FILE"

# 备份配置文件
tar -czf "$BACKUP_FILE" -C "$HOME/.openclaw" openclaw.json

if [ $? -eq 0 ]; then
  echo "✓ 备份成功！"
  echo "备份文件：$BACKUP_FILE"
  echo "文件大小：$(du -du "$BACKUP_FILE" | cut -f1)"

  # 保留最近30天的备份
  find "$BACKUP_DIR" -name "openclaw-config-backup-*.tar.gz" -mtime +30 -delete
  echo "已清理30天前的旧备份"
else
  echo "✗ 备份失败！"
  exit 1
fi
