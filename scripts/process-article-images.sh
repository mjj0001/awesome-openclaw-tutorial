#!/bin/bash

# OpenClaw文章图片处理脚本
# 从飞书链接下载图片并上传到图床

# 创建图片目录
IMAGE_DIR="$(dirname "$0")/../docs/03-advanced/images"
mkdir -p "$IMAGE_DIR"

echo "开始处理OpenClaw文章图片..."

# 飞书图片URL列表（从文章中提取）
declare -a IMAGE_URLS=(
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NDcyZjE1ZDVmMGZjNmQ3Y2M4OTVkMDcxZjY0NDMyZWRfbFNNNEFaSEVxSTNuc3dseXVWclpKeG53aEFucWxES2RfVG9rZW46S1A4Q2JsV1Ywb2lLakZ4N0hKb2MxNGU1bmFkXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NThhYTIwZjY0YWNlNzA5ZTZjYjY2ZGM4NGE2YWYzNzJfUlQyT3V1UnliWXliblBabHpibjJ0ellqV0dPSjZtUkRfVG9rZW46QWR6dmJ5WURib1dsdmt4aFBXT2N5a0szblJmXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NDMyN2ZiMjE5MjRhMTlmMGZkNDYxYTk4MzJjNTM2MWRfQlY2V3dBNFBxZ3lKWHhHOWR1TnRpR09WazlOSmpTandfVG9rZW46RFl1cGJTakhkb2lZblV4NEFhS2NPY0pHbktkXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YjcxZjMzMmZmNmU1MmYwOWRmNGQ2ZWUzZWM4MWFjYzlfMGR5SWRIVkNGaGdQY0JhRnk2Y2FrZEhBQk82dVppTllfVG9rZW46TWprQmJvb0RVb09sSmN4RlpNcWN6cTVBbkJnXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YjViYzg1OGExNjJjMGRiMGJlMWE3Y2RjZTBiNzlhNTdfSmlEbFhDM0VxamQ5dDNFemxVMVE3Q2hOdDh1MEVmOEZfVG9rZW46Vzc1dmJQYUZCb3B4Q3d4NlF2WmNPMjFxblFoXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ODQwN2MwZDczMDhjYjdlMjJkMTJhZDQ4ZTBlYzI0MGZfUzY2SmJzNDdNVGhYalI2c2ZvQ21UZTF0TnBFeTZJYWNfVG9rZW46SDAyOWJoRkVub3FpalJ4ejZvZmNGZHZvbktoXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZTA4YTVlNTJkNDQ1N2NiMmNiNTNmMzUwY2NiYjNlNDFfc2sxdncyRjg0UDJEcGptWk5EdmdCRE1oTGQ1UzRnNHVfVG9rZW46S0tYRWJSVU1hb0g4bUt4UkRUSmNCRGZIbjMyXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YzM4OWRjMzZhNjY3ZGI1NDZlZDNjOGE2NjMyZmE3NDlfOTc1QWtjSExyOFU5N2hyc2xTUnA3VnVRdzlRQzdwdlJfVG9rZW46V283NGJ3Z0E0b2dJQUN4U2NQa2NicnlRbmhiXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZjgxNjgwNzczYzhjMDQ0N2JlNThiYjBhZDQxM2E5MjdfcFRJbFlCOUdUVlI3cXlyYVN6ckdWeTBVeUlTd3BHTVRfVG9rZW46VVRTWWJEeWpCb3M4aEh4TmhPcGNxR1d2bnpkXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MTVkNGI4MThlYzZjM2Y2OTRhN2IxODYyNDI4MDhjYzdfN3YwdTZROEwwUlZUeTlGZTVwaTFwdTRHdVVITnN0emRfVG9yZW46Qlp2dmJMN3Z2b1Z4T0p4Y2lsYWNMbXBrbmNjXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ODE1ZTcyMDg2YzVkMzVlYjU5Mzc2YTJlNTA2Y2JiMWJfWGo3Z2d2cnJSVjJNY1QzREJ4Yk5OOTMydE5ZbTVwY1RfVG9rZW46SW1zU2JxaWYwb2NKdm14bllPdGN5emk3bkZiXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZjRhNTQ5NjdmMWQyMWNlYjYxM2UzNmJmMDc0ODNkOGRfRnBrVEZpYXNZWjMybG5ubkthSWYxdFdEN243QVN2eVlfVG9rZW46Wm04OWJMb3cyb3NFa0t4bnN3VWN1WlZwblVKXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MWFiZDE4ZDYzYWU4ZWFiY2VjZWVjMTI2NDI1NmNjN2JfbEU0WmV5OE50c3cyYnhnMFNaMEFFa29lODB2M3lMNGpfVG9rZW46VFQxTmJqclJob1VmUGd4S04xc2NaN0lubmVmXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
    "https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MTgwODMwYWEyN2ZmN2ViN2FkZDM1ZjRjNWI4NWMzZTNfWEY0UEp2QW1BclNCYlh0NjV1VGQ3RENwQkxYUlpJRFlfVG9rZW46RkVtcmI3d29sb21hdEh4T3k1R2NuNGFibnlmXzE3NzMxMTIwNDI6MTc3MzExNTY0Ml9WNA"
)

# 图片命名
declare -a IMAGE_NAMES=(
    "01-agent-architecture.png"
    "02-custom-agent.png"
    "03-workspace-files.png"
    "04-memory-search.png"
    "05-single-agent-problem.png"
    "06-multi-agent.png"
    "07-before-agent-communication.png"
    "08-after-agent-communication.png"
    "09-old-skills.png"
    "10-new-skills.png"
    "11-daily-paper.png"
    "12-tts-setup.png"
    "13-family-bot.png"
    "14-community.png"
)

# 下载图片
echo "开始下载图片..."
for i in "${!IMAGE_URLS[@]}"; do
    url="${IMAGE_URLS[$i]}"
    name="${IMAGE_NAMES[$i]}"
    output="$IMAGE_DIR/$name"

    echo "[$((i+1))/${#IMAGE_URLS[@]}] 下载: $name"
    curl -s -o "$output" "$url"

    if [ $? -eq 0 ] && [ -f "$output" ]; then
        size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null)
        echo "  ✅ 成功: $name ($(echo $size | awk '{printf "%.1fKB", $1/1024}'))"
    else
        echo "  ❌ 失败: $name"
    fi
done

echo ""
echo "图片下载完成！"
echo "图片保存位置: $IMAGE_DIR"
echo ""
echo "下一步：手动上传到图床并替换链接"
