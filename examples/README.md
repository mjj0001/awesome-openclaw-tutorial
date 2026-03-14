# OpenClaw 示例文件

这个目录包含了 OpenClaw 的各种配置文件、自动化脚本和 Skills 开发示例。

## 📁 目录结构

```
examples/
├── configs/              # 配置文件示例
│   ├── basic-config.json           # 基础配置（新手入门）
│   ├── multi-model-config.json     # 多模型配置
│   ├── multi-agent-config.json     # 多Agent配置
│   └── feishu-config.json          # 飞书Bot配置
├── automation/           # 自动化脚本
│   ├── daily-report.sh             # 每日AI日报生成
│   ├── backup-config.sh            # 配置备份
│   ├── batch-process-files.sh      # 批量文件处理
│   └── website-monitor.sh          # 网站内容监控
└── skills/               # Skills开发示例
    ├── custom-skill-template.js    # 自定义Skill模板
    └── weather-skill-example.js    # 天气查询示例
```

## 📋 配置文件说明

### basic-config.json
最简单的配置，适合新手入门：
- Token认证
- 单个Agent
- 基础配置

**使用方法：**
```bash
cp examples/configs/basic-config.json ~/.openclaw/openclaw.json
# 编辑配置文件，填入你的token和API密钥
```

### multi-model-config.json
多模型配置，不同场景使用不同模型：
- DeepSeek：日常使用，成本低
- Kimi：长文档处理
- GPT-4：复杂推理任务

**使用方法：**
```bash
cp examples/configs/multi-model-config.json ~/.openclaw/openclaw.json
# 根据需要修改模型配置
```

### multi-agent-config.json
多Agent配置，专业分工：
- 工作助手：处理工作相关事务
- 个人助手：日常对话和娱乐
- 代码助手：编程相关任务
- 内容助手：内容创作

**使用方法：**
```bash
cp examples/configs/multi-agent-config.json ~/.openclaw/openclaw.json
# 根据需求调整各Agent的配置
```

### feishu-config.json
飞书Bot完整配置：
- 飞书应用配置
- 认证设置
- Agent配置

**使用方法：**
```bash
cp examples/configs/feishu-config.json ~/.openclaw/openclaw.json
# 填入你的飞书应用信息
```

## 🤖 自动化脚本说明

### daily-report.sh
每天自动生成AI行业日报并发送到指定平台。

**使用方法：**
```bash
# 1. 赋予执行权限
chmod +x examples/automation/daily-report.sh

# 2. 编辑脚本，配置你的API和通知方式
vim examples/automation/daily-report.sh

# 3. 添加到crontab（每天早上9点执行）
crontab -e
# 添加以下行：
0 9 * * * /path/to/examples/automation/daily-report.sh
```

### backup-config.sh
自动备份OpenClaw配置文件。

**使用方法：**
```bash
# 1. 赋予执行权限
chmod +x examples/automation/backup-config.sh

# 2. 手动执行备份
./examples/automation/backup-config.sh

# 3. 添加到crontab（每天凌晨2点备份）
crontab -e
# 添加以下行：
0 2 * * * /path/to/examples/automation/backup-config.sh
```

### batch-process-files.sh
批量处理文件的脚本模板。

**使用方法：**
```bash
# 1. 赋予执行权限
chmod +x examples/automation/batch-process-files.sh

# 2. 根据需求修改脚本中的处理逻辑
vim examples/automation/batch-process-files.sh

# 3. 执行脚本
./examples/automation/batch-process-files.sh ./input ./output
```

### website-monitor.sh
监控网站内容变化，发现变化时发送通知。

**使用方法：**
```bash
# 1. 赋予执行权限
chmod +x examples/automation/website-monitor.sh

# 2. 执行监控
./examples/automation/website-monitor.sh "https://example.com" "关键词" feishu

# 3. 添加到crontab（每小时检查一次）
crontab -e
# 添加以下行：
0 * * * * /path/to/examples/automation/website-monitor.sh "https://example.com" "关键词" feishu
```

## 🔧 Skills开发说明

### custom-skill-template.js
完整的Skill开发模板，包含所有生命周期钩子和最佳实践。

**使用方法：**
```bash
# 1. 复制模板
cp examples/skills/custom-skill-template.js ~/.openclaw/skills/my-skill.js

# 2. 编辑模板，实现你的功能
vim ~/.openclaw/skills/my-skill.js

# 3. 在 openclaw.json 中注册Skill
{
  "skills": {
    "my-skill": {
      "enabled": true,
      "path": "~/.openclaw/skills/my-skill.js"
    }
  }
}
```

### weather-skill-example.js
实用的天气查询Skill示例，展示如何：
- 解析用户意图
- 调用外部API
- 格式化响应
- 错误处理

**使用方法：**
```bash
# 1. 复制示例
cp examples/skills/weather-skill-example.js ~/.openclaw/skills/weather-query.js

# 2. 配置API密钥（可选）
vim ~/.openclaw/openclaw.json
# 添加：
{
  "skills": {
    "weather-query": {
      "apiKey": "your-weather-api-key"
    }
  }
}

# 3. 重启OpenClaw
openclaw gateway restart
```

## ⚠️ 注意事项

1. **配置文件安全**：
   - 不要将包含API密钥的配置文件提交到Git
   - 使用环境变量存储敏感信息
   - 定期轮换密钥

2. **脚本权限**：
   - 执行前务必检查脚本内容
   - 只运行可信来源的脚本
   - 使用`chmod +x`赋予执行权限

3. **Skill开发**：
   - 遵循OpenClaw Skill规范
   - 添加完整的错误处理
   - 编写清晰的文档

4. **自动化任务**：
   - 测试脚本后再添加到crontab
   - 确保脚本有正确的日志记录
   - 定期检查执行日志

## 📚 更多资源

- [OpenClaw官方文档](https://docs.openclaw.ai)
- [Skill开发指南](docs/03-advanced/08-skills-extension.md)
- [配置文件完整指南](appendix/L-config-file-structure.md)
- [常见问题](appendix/E-common-problems.md)

## 💡 贡献

欢迎提交你的示例和配置！请参考[贡献指南](../README.md)。
