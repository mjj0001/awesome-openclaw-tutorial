#!/usr/bin/env python3
"""
从 Issue 中提取项目信息，用 AI 格式化，创建项目文件夹并更新 README。
"""

import json
import os
import re
import subprocess
import sys
from pathlib import Path

from openai import OpenAI

# ── 读取环境变量 ──────────────────────────────────────────────
issue_title = os.environ["ISSUE_TITLE"]
issue_body = os.environ["ISSUE_BODY"]
issue_number = os.environ["ISSUE_NUMBER"]
issue_author = os.environ["ISSUE_AUTHOR"]
api_key = os.environ["AI_API_KEY"]
base_url = os.environ["AI_BASE_URL"] or "https://api.openai.com/v1"
model = os.environ["AI_MODEL"] or "gpt-4o"

repo_root = Path(os.getcwd())
projects_dir = repo_root / "projects"
readme_path = repo_root / "README.md"

# ── Step 1: AI 解析 Issue 内容 ────────────────────────────────
client = OpenAI(api_key=api_key, base_url=base_url)

system_prompt = """你是一个项目信息提取助手。用户会提交一段自由格式的项目介绍，
你需要从中提取结构化信息并返回 JSON。

请提取以下字段（如果用户没写某项，用合理的默认值）：
- name: 项目名称（简短，用于文件夹名，只允许英文/数字/连字符/下划线）
- display_name: 项目展示名称（中文也可以）
- description: 一句话项目描述（50字以内）
- long_description: 详细项目介绍（保留原始内容的精华）
- link: 项目链接（GitHub 仓库地址或网页地址）
- category: 项目分类，必须是以下之一:
  - "配置示例" (配置文件、部署模板)
  - "技能扩展" (Skills/插件/扩展)
  - "实战案例" (使用场景、效率工具、自动化工作流)
  - "教程资源" (教程、指南、学习资料)
  - "工具集成" (API集成、第三方工具对接)
- author: 提交者
- install_command: 安装命令（如果能从内容推断出来）
- usage_tips: 使用技巧/示例对话

只返回 JSON，不要返回其他任何内容。"""

user_prompt = f"""Issue 标题: {issue_title}

Issue 内容:
{issue_body}

提交者: {issue_author}"""

print("🔍 正在用 AI 解析 Issue 内容...")
response = client.chat.completions.create(
    model=model,
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt},
    ],
    temperature=0.1,
)

# 兼容不同 API 返回格式
if isinstance(response, str):
    content = response.strip()
elif hasattr(response, "choices"):
    content = response.choices[0].message.content.strip()
elif hasattr(response, "content"):
    content = response.content.strip()
else:
    content = str(response).strip()
# 去掉可能的 markdown 代码块包裹
if content.startswith("```"):
    content = re.sub(r"^```\w*\n?", "", content)
    content = re.sub(r"\n?```$", "", content)

data = json.loads(content)
print(f"✅ 解析完成: {data['name']} ({data['category']})")

# 保存供后续步骤使用
with open("/tmp/project_data.json", "w") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# ── Step 2: 创建项目文件夹 ────────────────────────────────────
projects_dir.mkdir(exist_ok=True)
project_dir = projects_dir / data["name"]
project_dir.mkdir(exist_ok=True)

# 生成 README.md
readme_content = f"""# {data['display_name']}

> {data['description']}

**分类**: {data['category']}
**提交者**: @{data['author']}
**来源**: [Issue #{issue_number}](https://github.com/xianyu110/awesome-openclaw-tutorial/issues/{issue_number})

---

## 项目介绍

{data['long_description']}

"""

if data.get("link"):
    readme_content += f"""## 项目链接

- **主页**: {data['link']}

"""

if data.get("install_command"):
    readme_content += f"""## 快速安装

```bash
{data['install_command']}
```

"""

if data.get("usage_tips"):
    readme_content += f"""## 使用示例

{data['usage_tips']}

"""

readme_content += """---

*此项目由 AI 自动从 Issue 提取生成，如需修改请提交 PR。*
"""

(project_dir / "README.md").write_text(readme_content, encoding="utf-8")
print(f"📁 已创建项目文件夹: {project_dir}")

# ── Step 3: 更新 README.md ────────────────────────────────────
readme_text = readme_path.read_text(encoding="utf-8")

# 构造新增条目
new_entry = f"- [{data['display_name']}]({project_dir.relative_to(repo_root)}/README.md) - {data['description']}"

# 根据分类决定插入位置
category_sections = {
    "配置示例": ("### 📦 配置示例（开箱即用）", "### 🎬 实战场景"),
    "技能扩展": ("### 🔌 Skills 与插件", "### 🎬 实战场景"),
    "实战案例": ("### 🎬 实战场景", "---"),
    "教程资源": ("### 📚 社区教程与资源", None),
    "工具集成": ("### 🔗 工具与集成", "### 🎬 实战场景"),
}

category, (section_start, section_end) = data["category"], category_sections.get(
    data["category"], ("### 🎬 实战场景", "---")
)

# 检查分类区块是否存在
if section_start not in readme_text:
    # 需要创建新的分类区块
    insert_pos = readme_text.find("---\n\n## 🤝 贡献指南")
    if insert_pos == -1:
        insert_pos = readme_text.find("---\n\n## 📮 联系方式")
    if insert_pos == -1:
        print("❌ 无法找到合适的插入位置")
        sys.exit(1)

    new_section = f"""{section_start}

{new_entry}

"""
    readme_text = readme_text[:insert_pos] + new_section + "---\n\n" + readme_text[insert_pos:]
    print(f"📝 已在 README 中创建新分类区块: {category}")
else:
    # 在已有区块中追加
    start_idx = readme_text.find(section_start)
    if section_end:
        end_idx = readme_text.find(section_end, start_idx)
    else:
        end_idx = readme_text.find("---\n\n## 🤝 贡献指南", start_idx)
        if end_idx == -1:
            end_idx = readme_text.find("---\n\n## 📮 联系方式", start_idx)

    if end_idx == -1 or start_idx == -1:
        print(f"❌ 无法定位分类区块: {category}")
        sys.exit(1)

    # 在该区块的最后一条目后插入
    section_text = readme_text[start_idx:end_idx]
    last_entry_match = re.search(r"(^- .+$)", section_text, re.MULTILINE)
    if last_entry_match:
        insert_idx = start_idx + last_entry_match.end()
    else:
        insert_idx = start_idx + len(section_start) + 1

    readme_text = readme_text[:insert_idx] + "\n" + new_entry + readme_text[insert_idx:]
    print(f"📝 已在 README 区块「{category}」中添加条目")

readme_path.write_text(readme_text, encoding="utf-8")

# ── Step 4: 创建分支并提交 ────────────────────────────────────
branch_name = f"add-project-{issue_number}"
subprocess.run(["git", "checkout", "-b", branch_name], check=True)
subprocess.run(["git", "add", str(project_dir), str(readme_path)], check=True)
subprocess.run(
    ["git", "commit", "-m", f"feat: 添加项目 {data['display_name']} (Issue #{issue_number})"],
    check=True,
)
subprocess.run(["git", "push", "origin", branch_name], check=True)

print(f"🚀 已推送分支: {branch_name}")
print("✅ 完成！等待 PR 创建步骤...")
