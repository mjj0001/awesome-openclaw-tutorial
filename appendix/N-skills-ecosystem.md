# OpenClaw Skills 生态说明

## 📊 Skills 分类统计（2026年3月）

### 📦 内置 Skills（预装）

**数量**: 49个
**位置**: OpenClaw 安装包自带
**特点**: 开箱即用，无需安装
**类型**: 文件管理、知识管理、日程管理、自动化等

**说明**: 这些 Skills 在安装 OpenClaw 时就已经包含，可以直接使用，无需额外安装。

**查看命令**:

```bash
openclaw skills list --builtin
```

---

### 🏪 ClawHub 官方 Skills

**数量**: 93个（包含49个内置）
**位置**: ClawHub 官方仓库
**特点**: 官方维护，质量保证
**安装**: `clawhub install <skill-name>`

**说明**: ClawHub 是 OpenClaw 官方的 Skills 市场，提供经过官方审核和维护的高质量 Skills。

**访问方式**:
```bash
# 搜索 Skills
clawhub search <关键词>

# 安装 Skills
clawhub install <skill-name>

# 查看已安装
openclaw skills list
```

---

### 🌐 跨平台 Skills 生态（2026年新趋势）

2026年初，AI Agent Skills 市场呈现爆发式增长，出现了多个跨平台技能生态系统：

#### Skills.sh（Vercel出品）

- **数量**: 87,000+ Skills
- **出品**: Vercel
- **上线**: 2026年1月
- **特点**:
  - 开放的 Agent Skills 生态系统
  - CLI 工具：`npx skills`
  - 支持 Claude Code、Cursor、Codex 等 37+ AI 编码工具
  - 开源代码库：vercel-labs/skills
- **官网**: https://skills.sh

**安装方式**:
```bash
# 使用 npx 安装
npx skills install <skill-name>

# 搜索技能
npx skills search <关键词>
```

#### SkillsMP（Agent Skills Marketplace）

- **数量**: 400,000+ Agent Skills
- **特点**:
  - 使用开放的 SKILL.md 标准格式
  - 兼容 Claude Code、OpenAI Codex CLI、ChatGPT
  - 从 GitHub 聚合技能
  - 智能搜索和分类过滤
  - 2025年12月开始爆发式增长
- **官网**: https://skillsmp.com

**快速增长数据**:
- 2025年12月：约6.6万技能
- 2026年1月22日单日新增：20,218个技能
- 2026年3月：达到40万+技能

#### MCP 生态融合

**MCP（Model Context Protocol）** 是 Anthropic 推出的开放标准，用于 LLM 与外部数据源/工具的安全双向连接。

**MCP Server 目录**:

| 平台 | MCP Server 数量 | 特点 |
|------|----------------|------|
| AI Agents List | 593+ | 按类型、语言、范围分类 |
| API Tracker | 110 | 官方集成和参考实现 |
| mcp.so | 1,800+ | MiniMax 出品，TTS/图像/视频生成 |
| GitHub 官方仓库 | 参考实现 | 社区贡献的服务器集合 |

**MCP 与 Skills 的融合**:
- MCP Server 可以被封装为 Skill
- Skills 可以调用 MCP 协议的工具
- 两个生态正在快速融合

**资源链接**:
- MCP 官方仓库：https://github.com/modelcontextprotocol/servers
- AI Agents List：https://aiagentslist.com/mcp-servers

---

### 🌐 社区 Skills（扩展）

**数量**: 1715+个
**位置**: GitHub 社区贡献
**特点**: 功能丰富，需要筛选
**安装**: 手动安装或通过 GitHub

**说明**: 社区开发者贡献的 Skills，涵盖各种场景和需求。质量参差不齐，使用前建议查看评价和文档。

**安装方式**:
```bash
# 从 GitHub 克隆
git clone https://github.com/user/skill-name ~/.openclaw/skills/skill-name

# 或使用 clawhub（如果已发布）
clawhub install community/skill-name
```

---

### 🏢 企业级 Skills（百度千帆）

**数量**: 1715个
**位置**: 百度千帆平台
**特点**: 企业级质量，覆盖20+行业
**适用**: 企业用户、行业应用

**说明**: 百度千帆提供的企业级 Skills 生态，专为企业场景设计，包含行业解决方案。

**行业覆盖**:

- 金融、医疗、教育、零售
- 制造、物流、客服、营销
- 等 20+ 行业

---

### 🤖 Agent 社交网络

#### InStreet 实例街（中国版 Agent 社交网络）

- **上线时间**: 2026年3月9日
- **开发团队**: 字节跳动旗下扣子（Coze）团队
- **定位**: 全球首个专为 AI Agent 设计的中文社交网络
- **官网**: https://instreet.coze.site

**核心数据（上线3天）**:
- 17,000+ Agent
- 22,000+ 帖子
- 120,000+ 点赞

**核心特点**:
1. **纯 AI 社交生态**
   - 只允许 AI 智能体发帖、互动
   - 人类用户只能旁观，不能直接参与
   - 活跃用户是被称为"电子龙虾"的 AI Agent

2. **功能板块**
   - Skill 分享区
   - 打工圣体
   - 思辨大讲坛
   - 多个专业论坛板块

3. **接入方式**
   - 任何 Agent 都可以接入
   - 开放注册
   - 支持 OpenClaw 智能体

**产业背景**:
- 2026年初全民"养虾"热潮兴起
- 深圳龙岗区发布"龙虾十条"政策
- 券商分析师集体分享"养龙虾"教程
- AI 智能体实现从交互到主动执行的突破

---

## 📈 总计

| 类型 | 数量 | 质量 | 推荐度 |
|------|------|------|--------|
| 内置 Skills | 49个 | ⭐⭐⭐⭐⭐ | 必用 |
| ClawHub 官方 | 93个 | ⭐⭐⭐⭐⭐ | 强烈推荐 |
| Skills.sh | 87,000+ | ⭐⭐⭐⭐ | 跨平台推荐 |
| SkillsMP | 400,000+ | ⭐⭐⭐ | 按需选择 |
| MCP Server | 1,800+ | ⭐⭐⭐⭐ | 扩展能力强 |
| 社区 Skills | 1,715+个 | ⭐⭐⭐ | 按需选择 |
| 企业级 Skills | 1,715个 | ⭐⭐⭐⭐⭐ | 企业推荐 |
| **总计** | **~492,000+** | - | - |

---

## 🎯 推荐安装

### Top 20 必装 Skills

详见 [第8章：Skills扩展](../../docs/03-advanced/08-skills-extension.md)

### 新手推荐

1. **从内置 Skills 开始** - 熟悉基本功能
2. **安装 Top 5 核心 Skills** - 扩展核心能力
3. **根据需求选择社区 Skills** - 满足特定场景
4. **探索 MCP Server** - 获取更多扩展能力

---

## 💡 使用建议

### 选择 Skills 的原则

1. **优先使用内置 Skills** - 稳定可靠
2. **官方 Skills 次之** - 质量保证
3. **跨平台 Skills 考虑兼容性** - Skills.sh、SkillsMP 等
4. **MCP Server 用于扩展** - 特定功能集成
5. **社区 Skills 谨慎选择** - 查看评价和文档
6. **企业用户考虑企业级 Skills** - 专业支持

### 跨平台 Skills 的优势

- **通用性**: 一个 Skill 可以在多个 Agent 平台使用
- **可移植性**: 方便在不同工具间迁移
- **社区活跃**: 更新频繁，问题解决快速
- **标准化**: 使用统一的 SKILL.md 格式

### 避免过度安装

- ❌ 不要一次性安装太多 Skills
- ✅ 按需安装，逐步扩展
- ✅ 定期清理不用的 Skills
- ✅ 关注 Skills 更新
- ✅ 优先使用跨平台标准格式的 Skills

### 安全注意事项

**重要**: 2026年1月发生了 [ClawHavoc 供应链攻击事件](../../docs/03-advanced/99-security-guide.md#clawhavoc供应链攻击)，ClawHub 约20%的 Skills 被确认为恶意。

- ✅ 安装前审查源码
- ✅ 使用精选列表（如 awesome-openclaw-skills）
- ✅ 定期检查 SOUL.md 和 MEMORY.md 是否被篡改
- ✅ 使用 SecureClaw 等安全工具扫描
- ❌ 不要盲目安装不明来源的 Skills

---

## 🔗 相关链接

- [第8章：Skills扩展](../../docs/03-advanced/08-skills-extension.md) - 详细的 Skills 使用指南
- [安全指南：Skills安全](../../docs/03-advanced/99-security-guide.md#skills安全) - Skills 安全最佳实践
- [ClawHub 市场](https://clawhub.com) - 官方 Skills 市场
- [Skills.sh](https://skills.sh) - Vercel 出品的跨平台 Skills 生态
- [SkillsMP](https://skillsmp.com) - 40万+ Agent Skills 市场
- [MCP 官方仓库](https://github.com/modelcontextprotocol/servers) - Model Context Protocol 服务器
- [InStreet 实例街](https://instreet.coze.site) - 中国版 Agent 社交网络
- [Skills 开发文档](https://docs.openclaw.ai/skills) - 开发自己的 Skills

---

**最后更新**: 2026年3月13日
**数据来源**: OpenClaw 官方统计、Skills.sh、SkillsMP、MCP 官方仓库
