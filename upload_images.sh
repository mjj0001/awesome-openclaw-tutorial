#!/bin/bash

# 图片下载和上传脚本
# 从飞书链接下载图片并上传到图床

INPUT_FILE="Openclaw史上最简单教程，小白一键部署.md"
OUTPUT_FILE="Openclaw史上最简单教程，小白一键部署_新.md"
URL_MAPPING="url_mapping.txt"

# 创建临时目录
mkdir -p temp_images

# 提取所有飞书图片链接
echo "正在提取图片链接..."
grep -o 'https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=[^)]*' "$INPUT_FILE" > all_urls.txt

# 去重
sort -u all_urls.txt > unique_urls.txt

echo "找到 $(wc -l < unique_urls.txt) 张唯一图片"

# 清空映射文件
> "$URL_MAPPING"

# 下载并上传每张图片
counter=1
while IFS= read -r url; do
    echo "处理第 $counter 张图片..."

    # 下载图片
    filename="temp_images/image_${counter}.png"
    curl -s -o "$filename" "$url"

    # 上传到图床 (使用 sm.ms 图床)
    # 注意：需要安装 jq 来解析 JSON
    if [ -f "$filename" ]; then
        response=$(curl -s -X POST "https://sm.ms/api/v2/upload" \
            -H "Authorization: YOUR_API_KEY" \
            -F "smfile=@$filename")

        new_url=$(echo "$response" | jq -r '.data.url')

        if [ "$new_url" != "null" ] && [ -n "$new_url" ]; then
            echo "$url|$new_url" >> "$URL_MAPPING"
            echo "  ✓ 上传成功: $new_url"
        else
            echo "  ✗ 上传失败，保留原链接"
            echo "$url|$url" >> "$URL_MAPPING"
        fi
    fi

    counter=$((counter + 1))
done < unique_urls.txt

# 替换文档中的链接
echo "正在替换文档中的链接..."
cp "$INPUT_FILE" "$OUTPUT_FILE"

while IFS='|' read -r old_url new_url; do
    sed -i "s|$old_url|$new_url|g" "$OUTPUT_FILE"
done < "$URL_MAPPING"

# 清理
rm -rf temp_images all_urls.txt unique_urls.txt

echo "完成！新文档已保存为: $OUTPUT_FILE"
