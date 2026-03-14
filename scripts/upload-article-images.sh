#!/bin/bash
# 上传OpenClaw文章图片到图床

set -e

echo "📤 上传OpenClaw文章图片到图床"
echo "========================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 图床 API 配置
UPLOAD_API="https://upload.maynor1024.live/upload"
IMAGE_DIR="docs/03-advanced/images"

# 检查图片目录
if [ ! -d "$IMAGE_DIR" ]; then
    echo -e "${RED}❌ 图片目录不存在: $IMAGE_DIR${NC}"
    exit 1
fi

# 统计图片数量
IMAGE_COUNT=$(find "$IMAGE_DIR" -type f -name "*.png" | wc -l | tr -d ' ')
echo -e "${BLUE}📊 发现 $IMAGE_COUNT 张图片待上传${NC}"
echo ""

# 创建上传记录文件
UPLOAD_LOG="$IMAGE_DIR/upload-log.json"
echo "{" > "$UPLOAD_LOG"
echo '  "upload_time": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",' >> "$UPLOAD_LOG"
echo '  "images": [' >> "$UPLOAD_LOG"

UPLOADED=0
FAILED=0
FIRST=true

# 遍历所有图片
find "$IMAGE_DIR" -type f -name "*.png" | sort | while read -r IMAGE_PATH; do
    IMAGE_NAME=$(basename "$IMAGE_PATH")

    echo -e "${YELLOW}⏳ 上传中: $IMAGE_NAME${NC}"

    # 上传图片
    RESPONSE=$(curl -s -F "file=@$IMAGE_PATH" "$UPLOAD_API" 2>&1)

    # 检查上传结果
    if echo "$RESPONSE" | grep -q "src"; then
        # 提取 src 路径
        IMAGE_SRC=$(echo "$RESPONSE" | grep -o '"/file/[^"]*"' | tr -d '"' | head -1)

        if [ -n "$IMAGE_SRC" ]; then
            # 构建完整 URL
            IMAGE_URL="https://upload.maynor1024.live${IMAGE_SRC}"

            echo -e "${GREEN}✅ 上传成功: $IMAGE_NAME${NC}"
            echo -e "${BLUE}   URL: $IMAGE_URL${NC}"
            echo ""

            # 记录到日志
            if [ "$FIRST" = true ]; then
                FIRST=false
            else
                echo "," >> "$UPLOAD_LOG"
            fi

            echo "    {" >> "$UPLOAD_LOG"
            echo "      \"filename\": \"$IMAGE_NAME\"," >> "$UPLOAD_LOG"
            echo "      \"url\": \"$IMAGE_URL\"" >> "$UPLOAD_LOG"
            echo -n "    }" >> "$UPLOAD_LOG"

            UPLOADED=$((UPLOADED + 1))
        else
            echo -e "${RED}❌ 上传失败: $IMAGE_NAME (无法提取 URL)${NC}"
            echo ""
            FAILED=$((FAILED + 1))
        fi
    else
        echo -e "${RED}❌ 上传失败: $IMAGE_NAME${NC}"
        echo -e "${RED}   响应: $RESPONSE${NC}"
        echo ""
        FAILED=$((FAILED + 1))
    fi

    # 避免请求过快
    sleep 1
done

# 完成日志文件
echo "" >> "$UPLOAD_LOG"
echo "  ]" >> "$UPLOAD_LOG"
echo "}" >> "$UPLOAD_LOG"

echo ""
echo "========================"
echo -e "${GREEN}✅ 上传完成！${NC}"
echo -e "   成功: $UPLOADED 张"
echo -e "   失败: $FAILED 张"
echo ""
echo -e "${BLUE}📝 上传记录已保存到: $UPLOAD_LOG${NC}"
