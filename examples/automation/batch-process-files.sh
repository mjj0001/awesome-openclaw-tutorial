#!/bin/bash

# 批量处理文件脚本
# 使用方法：./batch-process-files.sh <source_directory> <target_directory>

if [ $# -lt 2 ]; then
  echo "使用方法：./batch-process-files.sh <源目录> <目标目录>"
  echo "示例：./batch-process-files.sh ./input ./output"
  exit 1
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"

# 创建目标目录
mkdir -p "$TARGET_DIR"

echo "开始批量处理文件..."
echo "源目录：$SOURCE_DIR"
echo "目标目录：$TARGET_DIR"

# 处理所有文件
for file in "$SOURCE_DIR"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    echo "处理文件：$filename"

    # 这里可以添加你的处理逻辑
    # 示例：复制文件到目标目录
    cp "$file" "$TARGET_DIR/"

    # 示例：使用AI工具处理文件
    # openclaw chat "请处理文件 $filename，生成摘要和关键信息"

    # 示例：使用OpenClaw处理
    # RESULT=$(openclaw file "$file" "分析这个文件的内容")
    # echo "$RESULT" > "$TARGET_DIR/${filename}.analysis.txt"
  fi
done

echo "✓ 处理完成！"
echo "处理文件数：$(ls -1 "$TARGET_DIR" | wc -l)"
