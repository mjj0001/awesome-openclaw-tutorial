---
layout: default
title: 首页
---
# 🦞 Awesome OpenClaw Tutorial
# 🦞 一本书玩转 OpenClaw：超级个体实战指南

> 从零开始打造你的 AI 工作助手——最全面的中文教程，涵盖安装、配置、实战案例和避坑指南

[![GitHub stars](https://img.shields.io/github/stars/xianyu110/awesome-openclaw-tutorial?style=social)](https://github.com/xianyu110/awesome-openclaw-tutorial)
[![GitHub forks](https://img.shields.io/github/forks/xianyu110/awesome-openclaw-tutorial?style=social)](https://github.com/xianyu110/awesome-openclaw-tutorial)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-v2026.3.12-green.svg)](https://github.com/xianyu110/awesome-openclaw-tutorial)
[![Status](https://img.shields.io/badge/status-完成-success.svg)](PROJECT-SUMMARY.md)
[![CSDN](https://img.shields.io/badge/CSDN-博客-c32136?style=for-the-badge&logo=csdn)](https://blog.csdn.net/xianyu120)
[![Bilibili](https://img.shields.io/badge/Bilibili-B站-fb7299?style=for-the-badge&logo=bilibili)](https://space.bilibili.com/399102586)
[![微信公众号](https://img.shields.io/badge/微信公众号-MaynorAI-07C160?style=for-the-badge&logo=wechat)](https://upload.may.maynor1024.live/file/1773461955906_qrcode_for_gh_c749803541de_1280.jpg)
[![YouTube](https://img.shields.io/badge/YouTube-Profile-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/@buguniao537)
[![X](https://img.shields.io/badge/X-Profile-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/Nikitka_aktikiN)


## 📖 新书预告：《OpenClaw超级个体实操手册》

⚠️ **本教程从第10章开始存在skill找不到和配置参数错误的问题**（[#34](https://github.com/xianyu110/awesome-openclaw-tutorial/issues/34)），纸质书本已逐条修正即将上市，近期可以关注。

纸质书在此基础上做了**全面重写+逐条验证**：
- 🔍 144条CLI命令对照官方文档逐条核对（教程中约60%已删除或修正）
- ✅ 9套配置模板全部在v2026.3.7+实际跑通
- 🛡️ 新增安全防护指南 + 国产Claw全景指南
- 📦 7份随书附赠电子资料

**清华大学出版社**，即将上市。⭐Star本仓库第一时间通知！

---

## 🎯 新手快速通道

根据你的情况选择路径：

**有 Mac 电脑**：
1. [第1章节：认识 OpenClaw](docs/01-basics/01-introduction.md) — 了解它能做什么
2. [第2章节：Mac 本地部署](docs/01-basics/02-installation.md#mac本地部署推荐) — 一行命令安装
3. [第9章节：接入飞书](docs/03-advanced/09-multi-platform-integration.md#91-飞书bot配置) — 手机随时对话
4. [第3章节：快速上手](docs/01-basics/03-quick-start.md) — 发布送第一条消息

**没有 Mac / 想 24 小时运行**：
1. [第1章节：认识 OpenClaw](docs/01-basics/01-introduction.md) — 了解它能做什么
2. [第2章节：云端部署](docs/01-basics/02-installation.md#云端一键部署) — 5 分钟完成
3. [第9章节：接入飞书](docs/03-advanced/09-multi-platform-integration.md#91-飞书bot配置) — 手机随时对话
4. [第3章节：快速上手](docs/01-basics/03-quick-start.md) — 发布送第一条消息

---

## 🚨 版本升级重要提示

### 🎉 2026.3.12 版本：重大功能更新

**OpenClaw 2026.3.12 已发布布！**（2026年3月13日）

#### 🎛️ Control UI 全面升级（Dashboard v2）
- **模块化视图设计**：全新的概览、聊天、配置、Agent 和会话视图
- **命令面板**：快速访访问所有功能的命令面板（Command Palette）
- **移动端优化**：新增底部标签栏，移动端体验大幅提升
- **增强聊天工具**：斜杠命令、搜索、导出、置顶消息功能

#### ⚡ 快速模式（Fast Mode）支持
- **OpenAI GPT-5.4**：会话级快速切换，支持 `/fast`、TUI、Control UI 和 ACP
- **Anthropic Claude**：`/fast` 切换映射到 API-key 的 `service_tier` 请求
- **本地模型加速**：Ollama、vLLM、SGLang 迁移至提供商插件架构

#### 🔌 Kubernetes 支持
- **初始 K8s 安装路径**：包含原始清单和 Kind 设置
- **企业级部署**：完整的 Kubernetes 部署文档

#### 🔒 安全增强（重要！）
- **设备配对安全**：`/pair` 和 `openclaw qr` 使用短期引导令牌
- **插件信任机制**：禁用隐式工作区插件自动加载，需要明确信任决定
- **命令权限控制**：`/config` 和 `/debug` 要求发布送者所有权
- **网关认证强化**：清除共分享令牌 WebSocket 连接的未绑定客户端声明

**升级命令**：
```bash
openclaw update && openclaw gateway restart
```

👉 [查看完整发布布说明](https://github.com/openclaw/openclaw/releases)

---

### ⚠️ 2026.3.7 版本：Gateway认证要求（Breaking Change）

**OpenClaw 2026.3.7 Breaking Change**：Gateway认证现在要求显式设置 `gateway.auth.mode`。你必须明确选择 `token` 或 `password` 认证方式，不再有「无认证」的默认选项。

**配置方法**：

在 `~/.openclaw/openclaw.json` 中添加以下配置：

```json
{
  "gateway": {
    "auth": {
      "mode": "token",  // 或 "password"
      "token": "your-secret-token"
    }
  }
}
```

**⚠️ 重要提示**：如果你从旧版本升级到 v2026.3.7 且没有配置认证，Gateway将拒绝启动。

**快速修复（命令行）**：

```bash
# 设置token认证
openclaw config set gateway.auth.mode token
openclaw config set gateway.auth.token "your-secret-token"

# 重启Gateway
openclaw gateway restart
```

---

### 🔧 2026.3.2 版本：AI变"哑巴"了？

**访问题现象**：升级到 2026.3.2 后，OpenClaw只能聊天不能干活（文件管理、命令执行等工具功能全部失效）

**访问题原因**：该版本将工具权限和聊天能力做了隔离，默认 profile 改为 `messaging`（纯聊天模式）

**5种 profile 说明**：

| Profile | 功能说明 |
|---------|---------|
| `messaging` | 只能发布消息、管理会话（光聊天不干活） |
| `default` | 默认工具集（不含命令执行） |
| `coding` | 编程相关工具 |
| `full` | 完整工具集，包含命令执行（**推荐**） |
| `all` | 所有工具全开 |

**快速修复方法**：

#### 方法1：命令行修复（推荐）

适用于：有命令行环境（本地/虚拟机/云服务器）

```bash
# 查看当前profile
openclaw config get tools

# 如果不是full，切换为full
openclaw config set tools.profile full

# 重启Gateway生效
openclaw gateway restart
```

#### 方法2：Web UI修复（无需编程）

适用于：不方便使用编程工具的环境（手机版等）

1. 访访问 `http://127.0.0.1:18789`（或你的服务器IP）
2. 点击左侧「配置」
3. 切换到 **Raw** 格式
4. 找到 `tools` 配置项
5. 将 `profile` 改为 `"full"`

```json
{
  "tools": {
    "profile": "full"
  }
}
```

6. 保存配置并重启Gateway

---

## 📖 关于本教程

> ⚠️ **版本说明**：本教程基于 **OpenClaw 2026.3.12**版本编写（已验证）。

> 💡 **重要前提**：OpenClaw 预装了 **49 个内置技能（Skills）**，开箱即用，无需额外安装即可完成本教程大部分演示。

| 内内容 | 数量 |
|------|------|
| 正文章节节 | 15 章节，约 267,000 字 |
| 基础附录 | 7 个（A-F+F视频），约 91,000 字 |
| 高级附录 | 8 个（G-N），约 50,000 字 |
| 实战案例 | 70+ 个，可直接复用 |
| 配置截图 | 50+ 张，手把手教学 |
| 命令参考 | 100+ 条，完整速查表 |

---

## 📚 教程目附录

### 第一部分：零基础入门

| 章节节 | 核心内内容 |
|------|---------|
| [第1章节：认识 OpenClaw](docs/01-basics/01-introduction.md) | OpenClaw 是什么、能做什么、和 ChatGPT 的区别 |
| [第2章节：环境搭建](docs/01-basics/02-installation.md) | Mac/Windows/Linux 本地部署、云端一键部署、Docker 部署 |
| [第3章节：快速上手](docs/01-basics/03-quick-start.md) | 第一次对话、10 个常用命令、人设配置、模型选择 |

### 第二部分：4 大核心功能

| 章节节 | 核心内内容 |
|------|---------|
| [第4章节：本地文件管理](docs/02-core-features/04-file-management.md) | 智能搜索、批量处理、自动整理、硬盘清理 |
| [第5章节：个人知识库](docs/02-core-features/05-knowledge-management.md) | 网页剪藏、PDF 解析、GitHub 追踪、跨设备同步 |
| [第6章节：日程管理](docs/02-core-features/06-schedule-management.md) | 截图识别、日历创建、批量导入、智能提醒 |
| [第7章节：自动化工作流](docs/02-core-features/07-automation-workflow.md) | 定时任务、网站监控、AI 日报、循环任务 |

### 第三部分：进阶技能

| 章节节 | 核心内内容 |
|------|---------|
| [第8章节：Skills 扩展](docs/03-advanced/08-skills-extension.md) | ClawHub 市场、必装 Top10、Skills 双幻神、自定义开发布 |
| [第9章节：多平台集成](docs/03-advanced/09-multi-platform-integration.md) | 飞书、企微、钉钉、QQ 接入；多机器人、多 Agent 配置 |
| [第10章节：API 服务集成](docs/03-advanced/10-api-integration.md) | AI 绘图、Notion 同步、视频生成、语音合成 |
| [第11章节：高级配置](docs/03-advanced/11-advanced-configuration.md) | 多模型切换、成本优化、性能调优 |

### 第四部分：实战案例

| 章节节 | 核心内内容 |
|------|---------|
| [第12章节：5 类人群效率提升](docs/04-practical-cases/12-personal-productivity.md) | 知识工作者、程序员、创作者、学生、超级个体实战 |
| [第13章节：高级自动化工作流](docs/04-practical-cases/13-advanced-automation.md) | 多 Skills 组合、知识图谱、Coding Agent、多 Agent 头脑风暴 |
| [第14章节：创意应用探索](docs/04-practical-cases/14-creative-applications.md) | AI 绘画、视频脚本、多语言翻译、数据分析 |
| [第15章节：超级个体实战](docs/04-practical-cases/15-solo-entrepreneur-cases.md) | 一人公司运营、自由职业、个人品牌、成本控制 |

### 附录：速查手册

#### 基础附录（A-F）

| 附录 | 内内容 |
|------|------|
| [附录A：命令速查表](appendix/A-command-reference.md) | 100+ 常用命令，5 大类快速查找 |
| [附录B：必装 Skills 清单](appendix/B-skills-catalog.md) | Top10 必装技能，附安装教程 |
| [附录C：API 服务商对比](appendix/C-api-comparison.md) | 10+ 服务商价格对比，帮你省钱 |
| [附录D：社区资源导航](appendix/D-community-resources.md) | 官方文档、视频教程、交流群 |
| [附录E：常见访问题速查](appendix/E-common-problems.md) | 安装/API/Skills/性能访问题解决 |
| [附录F：避坑指南与最佳实践](appendix/F-best-practices.md) | 新手必看，前人经验总结 |

#### 视频教程附录（F）
| [附录F：配套实操视频指南](appendix/F-video-tutorials.md) | 7个视频教程链接，包含部署、接入和高级配置 |

#### 高级附录（G-N）

| 附录 | 内内容 |
|------|------|
| [附录G：文档链接验证](appendix/G-links-validation.md) | 所有链接状态检查 |
| [附录H：配置文件模板](appendix/H-config-templates.md) | 开箱即用的配置示例 |
| [附录I：思考题参考答案](appendix/I-thinking-questions-answers.md) | 各章节节思考题详解 |
| [附录J：飞书配置检查清单](appendix/J-feishu-checklist.md) | 确保飞书Bot配置完整，避免常见访问题 |
| [附录K：API Key 配置完整指南](appendix/K-api-key-config-guide.md) | 多种API Key配置方式详解 |
| [附录L：配置文件结构完整指南](appendix/L-config-file-structure.md) | 全局配置、Agent配置、认证配置详解 |
| [附录M：搜索功能使用指南](appendix/M-search-guide.md) | 搜索功能使用技巧和常见访问题 |
| [附录N：Skills 生态说明](appendix/N-skills-ecosystem.md) | 内置49个、官方93个、社区1715+个Skills介绍 |

---

## 💰 成本参考

| 方案 | 月费用 | 适用场景 |
|------|--------|---------|
| 本地部署（有 Mac） | 0 元 | 隐私优先，功能最全 |
| 云端（火山引擎） | 9.9 元起 | 飞书用户首选 |
| 云端（腾讯云） | 20 元起 | 新手推荐 |
| API（DeepSeek） | 5—30 元 | 日常使用，性价比最高 |
| API（Kimi） | 10—50 元 | 长文档处理 |

💡 使用国产大模型（DeepSeek、Kimi）可节省 **50%—70%** 成本。

---

## 🔗 官方资源

- [OpenClaw 官网](https://openclaw.ai)
- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [ClawHub 技能市场](https://clawhub.ai)
- [GitHub 仓库](https://github.com/xianyu110/awesome-openclaw-tutorial)

---

## 📮 联系方式

### 社交媒体
- **GitHub**: [@xianyu110](https://github.com/xianyu110)
- **CSDN专栏**: [OpenClaw从入门到精通](https://blog.csdn.net/xianyu120/category_13126767.html)
- **B站**: [@MaynorAI](https://space.bilibili.com/399102586)
- **YouTube**: [@buguniao537](https://www.youtube.com/@buguniao537)
- **X (Twitter)**: [@Nikitka_aktikiN](https://x.com/Nikitka_aktikiN)
- **微信公众号**: [扫码关注](https://upload.maynor1024.live/file/1773461955906_qrcode_for_gh_c749803541de_1280.jpg)

### 项目链接
- **Clawbot项目**: [700+ Stars](https://github.com/xianyu110/clawbot)
- **两万人AI社区主理人**

---

## 👥 交流群

欢迎加入OpenClaw交流群，与更多开发布者一起交流学习！备注：小龙虾

<div align="center">
  <img src="https://upload.maynor1024.live/file/1772695436136_20260305152343578.jpg" alt="OpenClaw交流群二维码" width="300">
  <p>扫码加入OpenClaw交流群</p>
</div>

---

## 💖 支持项目

如果这个教程对你有帮助：
- ⭐ 给项目点个 Star
- 🔄 分分享给需要的人
- 💬 提交 Issue 反馈访问题
- 🤝 贡献你的经验和案例

---

<div align="center">
  <p>🎉 完全免费 | 支持续更新 | 社区驱动 🎉</p>
  <p>🚀 一个人 + OpenClaw = 无限可能 🚀</p>
</div>

**最后更新**：2026年3月17日
**教程版本**：v1.6
**总字数**：408,000字（正文267,000字 + 附录141,000字）
**章节节数**：15章节正文 + 15个附录
**适用 OpenClaw 版本**：2026.3.12（推荐最新版）
