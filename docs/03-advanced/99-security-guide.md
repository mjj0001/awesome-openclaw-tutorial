# OpenClaw 安全指南

> 💡 **本章目标**：了解OpenClaw的安全机制、已知安全事件和最佳实践，保护你的数据和隐私

---

## 📋 目录

- [安全模型](#安全模型)
- [已知安全事件](#已知安全事件)
- [Skills安全](#skills安全)
- [安全最佳实践](#安全最佳实践)

---

## 安全模型

OpenClaw的安全模型建立在「默认不信任」的基础上，但创始人Peter Steinberger坦言："This is all vibe code. Prompt injection hasn't been solved. There are absolute risks."

### 默认不信任机制

OpenClaw对所有入站消息的默认态度是：不可信。具体体现在以下几个机制：

#### DM配对保护

当一个未知的用户通过任何消息渠道（WhatsApp、Telegram等）给你的OpenClaw发私信时，系统不会处理消息。取而代之的是返回一个配对码（pairing code），只有在你手动批准后，该用户的消息才会被处理。

这防止了陌生人滥用你的Agent（以及你的API额度）。

#### 群组沙箱模式

在群组环境中，OpenClaw默认运行在沙箱模式：

- 每个群组的会话互相隔离
- MEMORY.md（长期记忆）只在私聊的main session中加载，群组看不到
- 可以配置requireMention，只有@提及时才响应

#### 工具访问控制

配置项说明：

| 配置项 | 作用 |
|--------|------|
| **allowlist** | 白名单模式。只允许列出的工具被调用，其他一律禁止 |
| **denylist** | 黑名单模式。禁止列出的工具，其他允许 |
| **browser** | 开关 - 可完全禁用浏览器自动化能力 |
| **canvas** | 开关 - 可禁用Canvas可视化 |
| **nodes** | 开关 - 可禁用对本地设备节点的控制（如摄像头、录屏） |

### v2026.3.7新增：Gateway认证要求

最新版本引入了一个Breaking Change：Gateway认证现在要求显式设置gateway.auth.mode。你必须明确选择token或password认证方式，不再有「无认证」的默认选项。

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

**注意**：如果你从旧版本升级到v2026.3.7且没有配置认证，Gateway将拒绝启动。这是一个有意为之的设计，强制所有用户设置认证。

### v2026.3.8新增：ACP身份验证

OpenClaw v2026.3.8 引入了 ACP（Agent Authentication & Provenance）身份验证机制：

- **完整的 Agent 审计追踪**：记录所有 Agent 操作
- **增强的身份验证**：30+ 元数据和认证相关修复
- **权限混乱终结**：改进权限处理，结束"permission chaos"
- **部署焦虑减少**：12个新安全功能，提升可靠性

**配置示例**:

```json
{
  "security": {
    "acp": {
      "enabled": true,
      "auditTrail": true,
      "strictMode": true
    }
  }
}
```

---

## 已知安全事件

在不到5个月的历史中，OpenClaw已经经历了至少8起重大安全事件。

### CVE-2026-25253：远程代码执行漏洞

| 项目 | 详情 |
|------|------|
| **CVE编号** | CVE-2026-25253 |
| **CVSS评分** | 8.8/10（高危） |
| **类型** | 远程代码执行（RCE） |
| **原理** | WebSocket origin header绕过。攻击者可以伪造origin header连接到暴露的Gateway，在OpenClaw实例上执行任意代码 |
| **影响范围** | 所有暴露到公网且未配置认证的OpenClaw实例 |
| **状态** | 已修复（v2026.3.2加固了WebSocket origin检查） |

**注意**：这个漏洞的危害极大：攻击者可以远程在你的服务器上执行任何命令，包括读取文件、安装恶意软件、窃取API Key等。如果你还在运行v2026.3.2之前的版本，请立即升级。

### ClawJacked 零点击漏洞（CVE-2026-25253增强版）

| 项目 | 详情 |
|------|------|
| **CVE编号** | CVE-2026-25253 |
| **CVSS评分** | 8.8/10（高危） |
| **攻击类型** | 零点击 / 远程代码执行（RCE） |
| **发现时间** | 2026年3月 |
| **报告方** | Oasis Security |
| **命名** | "ClawJacked"攻击链 |
| **状态** | 已修复（v2026.2.26） |

**攻击原理**:

1. **零点击攻击向量**：攻击者只需诱导用户访问恶意网站，无需任何额外用户交互（无需下载文件、安装插件或点击特殊链接）

2. **根本原因**：
   - `gatewayUrl` 参数缺乏 proper 验证
   - WebSocket 连接缺少 Origin header 验证
   - 无条件信任 `localhost` 连接

3. **攻击机制**：
   - 恶意网站脚本尝试连接本地 OpenClaw 服务
   - 使用暴力破解获取访问权限
   - 在毫秒级窃取认证令牌
   - 实现用户无感知的远程代码执行

**防护措施**:

- ✅ **立即升级**到 v2026.2.26 或更高版本
- ✅ 配置防火墙，限制本地部署的入站连接
- ✅ 启用 Gateway 认证（v2026.3.7 已强制要求）
- ✅ 定期检查审计日志，检测异常连接

### ClawHavoc供应链攻击

详见本指南[Skills安全](#skills安全)章节。这是OpenClaw历史上影响最广的安全事件，135,000+设备受到影响，ClawHub约20%的Skills在高峰期被确认为恶意。

### Anthropic封杀OAuth

2026年1月，Anthropic官方封禁了Claude Pro/Max订阅账户通过OAuth连接OpenClaw的能力。

- 许多用户收到账户警告或被直接锁定
- 部分用户的订阅被取消且无法恢复
- 目前唯一合法的连接方式：使用Anthropic API Key（按量付费）

这不算传统意义上的「安全事件」，但对大量用户造成了实质损失。如果你还在用OAuth方式连接Anthropic，请立即切换到API Key方式。

**正确的配置方式（API Key）**：

```json
{
  "env": {
    "ANTHROPIC_API_KEY": "sk-ant-your-key-here"
  }
}
```

### 谷歌封号事件

2026年2月初，谷歌大规模封禁OpenClaw用户的Google账号。受影响的用户描述：

> "每月花250美元使用Gemini API，被封却毫无预警"

封禁范围包括Gmail、Google Drive、Google Calendar等全部Google服务。部分用户的OpenClaw通过Gmail Skill大量调用Google API，触发了滥用检测。

**核心建议**：如果你的OpenClaw使用了Google相关Skill，建议：

1. 使用专门的Google Workspace账号而非个人主账号
2. 控制API调用频率，避免触发滥用检测
3. 重要数据做好备份

GitHub Issue #14203记录了大量受影响用户的反馈。

### 工信部安全预警（2026年3月）

中国工业和信息化部发布关于 AI Agent 工具的安全预警，特别指出：

- **风险提示**: OpenClaw 等自主执行型 AI 工具存在供应链安全风险
- **监管建议**: 企业用户应建立 AI Agent 使用审批和审计机制
- **数据安全**: 警惕通过 Agent 渠道的数据泄露风险
- **合规要求**: 金融、政务等敏感行业需谨慎评估使用风险

**建议**:
- 企业用户应制定 AI Agent 安全使用规范
- 对接入的 Skills 进行安全审查
- 建立异常行为监控和告警机制

### 恶意 npm 包伪装攻击

**事件描述**:

攻击者发布伪装成合法 OpenClaw Skill 的恶意 npm 包，通过以下方式进行攻击：

1. **包名伪装**: 使用与热门 Skill 相似的名称（如 `openclaw-tool-kit` → `openclaw-tools-kit`）
2. **描述抄袭**: 复制正版 Skill 的描述和文档
3. **后门植入**: 安装后在系统中植入后门，窃取 API Key 和敏感数据

**防护措施**:

- ❌ 不要随意安装来源不明的 npm 包
- ✅ 优先从 ClawHub 官方仓库安装
- ✅ 安装前检查包的发布者和下载量
- ✅ 查看 GitHub 源码，确认无恶意代码
- ✅ 使用 `npm audit` 检测已知漏洞

### 30,000+台未认证暴露实例

安全研究者通过互联网扫描发现，超过30,000台OpenClaw实例暴露在公网上且未配置任何认证。

这些实例的Gateway端口（默认18789）对任何人开放，意味着：

- 任何人都可以连接并向你的Agent发送指令
- 你的API额度可能被消耗殆尽
- 你的个人数据（邮件、文件、消息记录）可能被读取

结合CVE-2026-25253，攻击者可以在你的服务器上执行任意代码。

**注意**：如果你的OpenClaw部署在云服务器上，请立即检查：

1. Gateway是否只绑定了localhost
2. 防火墙是否开放了18789端口
3. 是否配置了认证（v2026.3.7已强制要求）

---

## Skills安全

### ClawHavoc供应链攻击

ClawHavoc供应链攻击是OpenClaw历史上最严重的安全事件之一。每个「养虾人」都应该了解。

#### 时间线

| 日期 | 事件 |
|------|------|
| 1月27日 | 首个恶意Skill出现在ClawHub上，伪装成专业工具 |
| 1月28-30日 | 攻击者快速上传大量恶意Skill，利用ClawHub缺乏审查机制的漏洞 |
| 1月31日 | 攻击全面爆发，多名用户报告异常行为 |
| 2月1日 | Koi Security正式命名该攻击为「ClawHavoc」 |
| 2月上旬 | 社区展开大规模审计和清理 |

#### 攻击规模

| 指标 | 数据 |
|------|------|
| 当时ClawHub技能总数 | 约2,857个 |
| 初步确认恶意Skills | 341个（约12%） |
| 后续扫描发现的恶意Skills | 800+（约20%） |
| 可追溯到同一协调行动的 | 335个 |
| 受影响设备 | 135,000+ |

**注意**：ClawHub当时约20%的Skills被确认为恶意。这意味着如果你随机安装5个Skill，大概率至少有1个是恶意的。

#### 攻击手法

攻击者的手法相当精密：

1. 上传看似专业的Skill，名称和描述都很正常（如「advanced-code-review」「smart-scheduler」）
2. 诱导用户安装后，Skill会建议安装一个「helper agent」来增强功能
3. 实际植入的是 Atomic macOS Stealer（AMOS）信息窃取木马
4. 更危险的是：攻击专门针对OpenClaw的持久记忆文件（SOUL.md和MEMORY.md），篡改Agent的长期行为指令

**篡改SOUL.md意味着你的Agent被「洗脑」了**。它的核心行为准则被改写，可能在后续所有交互中执行恶意操作，而你完全不知情。

#### 安全建议

**1. 安装前审查源码**

永远不要盲目安装ClawHub上的Skill。去GitHub查看源码，确认SKILL.md中没有可疑的指令。特别注意任何要求额外安装「helper」或「agent」的内容。

**2. 使用SecureClaw扫描**

社区推出了开源安全工具SecureClaw，可以扫描已安装的Skills检查恶意内容。

```bash
# 安装SecureClaw
npm install -g secureclaw

# 扫描已安装的skills
secureclaw scan ~/.openclaw/skills/
```

虽然不能100%防护，但能拦住已知的攻击模式。

**3. 优先使用精选列表**

参考 awesome-openclaw-skills 项目（31.4K Stars）的精选列表，而不是直接在ClawHub上随意搜索。精选列表已经过滤掉了大量垃圾和恶意Skill。

**4. 定期检查SOUL.md和MEMORY.md**

养成习惯，定期检查这两个文件有没有被异常修改。如果发现不认识的内容，立即回滚并排查所有已安装的Skill。

**关键认知**：OpenClaw的Skill本质上是受信任代码。一旦安装，它就拥有和你的OpenClaw实例相同的权限。没有沙箱隔离，没有权限分级。这和npm生态早期面临的问题一模一样，但后果可能更严重，因为OpenClaw可以访问你的邮件、日历、消息和文件系统。

---

## 安全最佳实践

### 1. API密钥安全

**必须做到**：

```bash
# ✅ 使用环境变量
export OPENAI_API_KEY="sk-xxx"

# ✅ 设置文件权限
chmod 600 ~/.openclaw/config.json

# ✅ 不要提交到Git
echo ".openclaw/config.json" >> .gitignore

# ✅ 定期轮换密钥
# 每3个月更换一次API密钥
```

**绝对不要**：

```bash
# ❌ 明文存储在代码中
const apiKey = "sk-1234567890abcdef";

# ❌ 提交到公开仓库
git add config.json
git push

# ❌ 分享配置文件
# 不要把包含API密钥的配置文件发给别人
```

### 2. 数据隐私

**敏感数据处理**：

```json
{
  "privacy": {
    "enabled": true,
    "rules": [
      {
        "type": "phone",
        "action": "mask",
        "pattern": "\\d{11}"
      },
      {
        "type": "email",
        "action": "mask"
      },
      {
        "type": "idcard",
        "action": "block"
      }
    ]
  }
}
```

**文件访问控制**：

```json
{
  "files": {
    "allowPaths": [
      "~/Documents/OpenClaw",
      "~/Desktop"
    ],
    "denyPaths": [
      "~/.ssh",
      "~/Documents/Private",
      "~/Documents/Finance",
      "~/Documents/Medical"
    ]
  }
}
```

### 3. 网络安全

**使用HTTPS**：

```json
{
  "gateway": {
    "ssl": {
      "enabled": true,
      "cert": "/path/to/cert.pem",
      "key": "/path/to/key.pem"
    }
  }
}
```

**IP白名单**：

```json
{
  "gateway": {
    "allowIPs": [
      "127.0.0.1",
      "192.168.1.0/24"
    ]
  }
}
```

### 4. 审计日志

**启用审计**：

```json
{
  "audit": {
    "enabled": true,
    "logLevel": "info",
    "logFile": "~/.openclaw/logs/audit.log",
    "retention": 90
  }
}
```

**定期检查**：

```bash
# 查看最近的操作
tail -n 100 ~/.openclaw/logs/audit.log

# 搜索敏感操作
grep "delete" ~/.openclaw/logs/audit.log
grep "upload" ~/.openclaw/logs/audit.log
```

### 5. 备份策略（v2026.3.8新增）

OpenClaw v2026.3.8 引入了原生备份工具：

```bash
# 创建完整备份
openclaw backup create

# 验证备份完整性
openclaw backup verify <backup-file>

# 恢复备份
openclaw backup restore <backup-file>
```

**建议备份策略**：

- 每周自动备份配置和记忆文件
- 重要操作前手动创建备份点
- 将备份存储在安全的位置（加密云存储或外部硬盘）
- 定期测试备份恢复流程

---

## 相关资源

- [第8章：Skills扩展](08-skills-extension.md) - Skills使用和管理
- [附录F：避坑指南与最佳实践](../../appendix/F-best-practices.md) - 完整的避坑指南
- [附录N：Skills生态说明](../../appendix/N-skills-ecosystem.md) - Skills生态系统介绍
- [OpenClaw官方安全公告](https://github.com/openclaw/openclaw/security/advisories)

---

**最后更新**：2026年3月13日
**适用版本**：OpenClaw v2026.3.8
**新增内容**：ClawJacked漏洞、工信部预警、npm包攻击、ACP身份验证、备份工具
