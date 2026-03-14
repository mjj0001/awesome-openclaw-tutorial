#!/bin/bash

# 网站内容监控脚本
# 监控指定网站的内容变化，发现变化时发送通知
# 使用方法：./website-monitor.sh <url> <keyword> <notification_method>

if [ $# -lt 2 ]; then
  echo "使用方法：./website-monitor.sh <url> <keyword> [notification_method]"
  echo "示例：./website-monitor.sh https://example.com '新产品发布' feishu"
  exit 1
fi

URL="$1"
KEYWORD="$2"
NOTIFICATION="${3:-console}"
HASH_FILE="/tmp/website-monitor-$(echo "$URL" | md5sum | cut -d' ' -f1).hash"

echo "监控网站：$URL"
echo "关键词：$KEYWORD"
echo "通知方式：$NOTIFICATION"

# 获取网页内容
CURRENT_CONTENT=$(curl -s "$URL" | grep -o "$KEYWORD" | head -1)

# 计算内容哈希
CURRENT_HASH=$(echo "$CURRENT_CONTENT" | md5sum | cut -d' ' -f1)

# 检查是否有历史记录
if [ -f "$HASH_FILE" ]; then
  PREVIOUS_HASH=$(cat "$HASH_FILE")

  # 比较哈希值
  if [ "$CURRENT_HASH" != "$PREVIOUS_HASH" ]; then
    echo "⚠ 发现变化！关键词 '$KEYWORD' 出现"
    echo "时间：$(date)"

    # 发送通知
    case "$NOTIFICATION" in
      feishu)
        # 发送飞书通知
        echo "发送飞书通知..."
        # curl -X POST "https://open.feishu.cn/open-apis/bot/v2/hook/your-webhook" \
        #   -H "Content-Type: application/json" \
        #   -d "{\"msg_type\":\"text\",\"content\":{\"text\":\"网站 $URL 发现变化：$KEYWORD\"}}"
        ;;
      console)
        # 控制台通知
        echo "📢 通知：网站 $URL 发现变化：$KEYWORD"
        ;;
    esac
  else
    echo "✓ 无变化"
  fi
else
  echo "首次运行，建立基准"
fi

# 保存当前哈希
echo "$CURRENT_HASH" > "$HASH_FILE"
