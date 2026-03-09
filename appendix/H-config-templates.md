# 附录H：配置文件模板和示例

> 📝 **开箱即用**：复制这些配置模板，快速开始使用OpenClaw

---

## 📋 目录

- [基础配置模板](#基础配置模板)
- [API配置模板](#api配置模板)
- [多平台集成配置](#多平台集成配置)
- [Skills配置模板](#skills配置模板)
- [自动化配置模板](#自动化配置模板)
- [高级配置模板](#高级配置模板)

---

## 🎯 基础配置模板

### 1. 最小配置（新手推荐）

**文件位置**：`~/.openclaw/config.json`

```json
{
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "127.0.0.1"
  },
  "models": {
    "default": "deepseek-chat",
    "providers": {
      "deepseek": {
        "apiKey": "YOUR_DEEPSEEK_API_KEY",
        "baseURL": "https://api.deepseek.com"
      }
    }
  },
  "workspace": {
    "path": "~/Documents/OpenClaw"
  }
}
```

**使用说明**：
1. 替换 `YOUR_DEEPSEEK_API_KEY` 为你的API密钥
2. 保存到 `~/.openclaw/config.json`
3. 运行 `openclaw gateway run`

---

### 2. 完整基础配置

```json
{
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "127.0.0.1",
    "ssl": {
      "enabled": false
    },
    "cors": {
      "enabled": true,
      "origins": ["http://localhost:3000"]
    }
  },
  "models": {
    "default": "deepseek-chat",
    "streaming": true,
    "timeout": 60000,
    "providers": {
      "deepseek": {
        "apiKey": "YOUR_DEEPSEEK_API_KEY",
        "baseURL": "https://api.deepseek.com",
        "models": {
          "deepseek-chat": {
            "maxTokens": 4000,
            "temperature": 0.7
          }
        }
      }
    }
  },
  "workspace": {
    "path": "~/Documents/OpenClaw",
    "autoCreate": true
  },
  "files": {
    "searchPaths": [
      "~/Documents",
      "~/Desktop"
    ],
    "excludePaths": [
      "~/.ssh",
      "~/Documents/Private"
    ],
    "excludePatterns": [
      "node_modules",
      ".git",
      "*.log"
    ]
  },
  "cache": {
    "enabled": true,
    "ttl": 3600,
    "maxSize": 1000
  },
  "logging": {
    "level": "info",
    "file": "~/.openclaw/logs/gateway.log"
  }
}
```

---

## 🔑 API配置模板

### 1. 单一API配置（DeepSeek）

```json
{
  "models": {
    "default": "deepseek-chat",
    "providers": {
      "deepseek": {
        "apiKey": "sk-xxx",
        "baseURL": "https://api.deepseek.com",
        "models": {
          "deepseek-chat": {
            "maxTokens": 4000,
            "temperature": 0.7
          },
          "deepseek-coder": {
            "maxTokens": 8000,
            "temperature": 0.2
          }
        }
      }
    }
  }
}
```

---

### 2. 多API配置（推荐）

```json
{
  "models": {
    "default": "deepseek-chat",
    "code": "deepseek-coder",
    "longContext": "kimi",
    "vision": "gpt-4-vision",
    "providers": {
      "deepseek": {
        "apiKey": "sk-xxx",
        "baseURL": "https://api.deepseek.com",
        "models": {
          "deepseek-chat": {
            "maxTokens": 4000,
            "temperature": 0.7
          },
          "deepseek-coder": {
            "maxTokens": 8000,
            "temperature": 0.2
          }
        }
      },
      "moonshot": {
        "apiKey": "sk-xxx",
        "baseURL": "https://api.moonshot.cn",
        "models": {
          "kimi": {
            "maxTokens": 200000,
            "temperature": 0.7
          }
        }
      },
      "openai": {
        "apiKey": "sk-xxx",
        "baseURL": "https://api.openai.com",
        "models": {
          "gpt-4-vision": {
            "maxTokens": 4000,
            "temperature": 0.7
          }
        }
      }
    }
  }
}
```

---

### 3. 中转API配置

```json
{
  "models": {
    "default": "gpt-3.5-turbo",
    "providers": {
      "relay": {
        "apiKey": "YOUR_RELAY_API_KEY",
        "baseURL": "https://api.relay-service.com/v1",
        "models": {
          "gpt-3.5-turbo": {
            "maxTokens": 4000,
            "temperature": 0.7
          },
          "gpt-4": {
            "maxTokens": 8000,
            "temperature": 0.7
          },
          "claude-3-opus": {
            "maxTokens": 4000,
            "temperature": 0.7
          }
        }
      }
    }
  }
}
```

---

### 4. 智能路由配置

```json
{
  "models": {
    "routing": {
      "enabled": true,
      "rules": [
        {
          "condition": "tokens < 500",
          "model": "deepseek-chat",
          "description": "简单任务"
        },
        {
          "condition": "tokens >= 500 && tokens < 2000",
          "model": "gpt-3.5-turbo",
          "description": "中等任务"
        },
        {
          "condition": "tokens >= 2000",
          "model": "gpt-4",
          "description": "复杂任务"
        },
        {
          "condition": "hasImage",
          "model": "gpt-4-vision",
          "description": "图片理解"
        },
        {
          "condition": "isCode",
          "model": "deepseek-coder",
          "description": "代码生成"
        }
      ]
    }
  }
}
```

---

## 📱 多平台集成配置

### 1. 飞书Bot配置

```json
{
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "cli_xxx",
      "appSecret": "xxx",
      "verificationToken": "xxx",
      "encryptKey": "xxx",
      "webhookUrl": "https://your-domain.com/webhook/feishu",
      "features": {
        "streaming": true,
        "fileUpload": true,
        "imageRecognition": true
      },
      "filters": {
        "onlyMentions": true,
        "ignoreGroups": ["闲聊群"],
        "keywords": ["openclaw", "帮助"]
      }
    }
  }
}
```

---

### 2. 企业微信Bot配置

```json
{
  "channels": {
    "wecom": {
      "enabled": true,
      "corpId": "ww123456",
      "agentId": "1000001",
      "secret": "xxx",
      "token": "xxx",
      "encodingAESKey": "xxx",
      "webhookUrl": "https://your-domain.com/webhook/wecom",
      "features": {
        "fileUpload": true,
        "imageRecognition": true
      }
    }
  }
}
```

---

### 3. 钉钉Bot配置

```json
{
  "channels": {
    "dingtalk": {
      "enabled": true,
      "appKey": "xxx",
      "appSecret": "xxx",
      "agentId": "xxx",
      "webhookUrl": "https://your-domain.com/webhook/dingtalk",
      "features": {
        "fileUpload": true
      }
    }
  }
}
```

---

### 4. Telegram Bot配置

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11",
      "webhookUrl": "https://your-domain.com/webhook/telegram",
      "features": {
        "streaming": true,
        "fileUpload": true,
        "imageRecognition": true
      },
      "allowedUsers": [
        123456789,
        987654321
      ]
    }
  }
}
```

---

### 5. 多Agent配置

```json
{
  "agents": {
    "work": {
      "name": "工作助手",
      "model": "gpt-4",
      "workspace": "~/Documents/Work",
      "channels": ["feishu"],
      "systemPrompt": "你是一个专业的工作助手，帮助处理工作相关的任务。",
      "skills": [
        "@openclaw/skill-file-search",
        "@openclaw/skill-calendar",
        "@openclaw/skill-email"
      ]
    },
    "personal": {
      "name": "个人助手",
      "model": "deepseek-chat",
      "workspace": "~/Documents/Personal",
      "channels": ["telegram"],
      "systemPrompt": "你是一个友好的个人助手，帮助处理日常生活中的各种问题。",
      "skills": [
        "@openclaw/skill-web-search",
        "@openclaw/skill-weather",
        "@openclaw/skill-news"
      ]
    },
    "code": {
      "name": "代码助手",
      "model": "deepseek-coder",
      "workspace": "~/Projects",
      "channels": ["telegram"],
      "systemPrompt": "你是一个专业的编程助手，精通多种编程语言。",
      "skills": [
        "@openclaw/skill-github",
        "@openclaw/skill-code-review",
        "@openclaw/skill-documentation"
      ]
    }
  }
}
```

---

## 🧩 Skills配置模板

### 1. 基础Skills配置

```json
{
  "skills": {
    "enabled": true,
    "autoUpdate": false,
    "directory": "~/.openclaw/skills",
    "installed": [
      "@openclaw/skill-file-search",
      "@openclaw/skill-web-search",
      "@openclaw/skill-calendar"
    ],
    "priority": [
      "@openclaw/skill-file-search",
      "@openclaw/skill-web-search",
      "@openclaw/skill-calendar"
    ]
  }
}
```

---

### 2. Skills详细配置

```json
{
  "skills": {
    "enabled": true,
    "autoUpdate": true,
    "updateSchedule": "0 3 * * 0",
    "directory": "~/.openclaw/skills",
    "registry": {
      "@openclaw/skill-calendar": {
        "version": "1.1.0",
        "enabled": true,
        "config": {
          "provider": "apple",
          "defaultCalendar": "工作"
        }
      }
    }
  }
}
```

---

## 🔄 自动化配置模板

### 1. 定时任务配置

```json
{
  "automation": {
    "enabled": true,
    "tasks": [
      {
        "name": "每日AI日报",
        "schedule": "0 9 * * *",
        "action": "sendMessage",
        "params": {
          "channel": "feishu",
          "message": "请生成今天的AI行业日报"
        }
      },
      {
        "name": "每周工作总结",
        "schedule": "0 18 * * 5",
        "action": "sendMessage",
        "params": {
          "channel": "feishu",
          "message": "请生成本周的工作总结"
        }
      },
      {
        "name": "定时备份",
        "schedule": "0 2 * * *",
        "action": "runCommand",
        "params": {
          "command": "tar -czf ~/backups/openclaw-$(date +%Y%m%d).tar.gz ~/.openclaw"
        }
      }
    ]
  }
}
```

---

### 2. 网站监控配置

```json
{
  "monitoring": {
    "enabled": true,
    "sites": [
      {
        "name": "OpenClaw官网",
        "url": "https://openclaw.ai",
        "interval": 3600,
        "selector": ".version",
        "notify": {
          "channel": "feishu",
          "message": "OpenClaw官网有更新：{content}"
        }
      },
      {
        "name": "Claude API",
        "url": "https://www.anthropic.com/news",
        "interval": 7200,
        "selector": "article:first-child",
        "notify": {
          "channel": "telegram",
          "message": "Claude有新动态：{title}"
        }
      }
    ]
  }
}
```

---

### 3. 文件监控配置

```json
{
  "fileWatcher": {
    "enabled": true,
    "watches": [
      {
        "path": "~/Documents/Invoices",
        "pattern": "*.pdf",
        "action": "processInvoice",
        "notify": {
          "channel": "feishu",
          "message": "新发票已处理：{filename}"
        }
      },
      {
        "path": "~/Downloads",
        "pattern": "*.zip",
        "action": "autoExtract",
        "destination": "~/Documents/Extracted"
      }
    ]
  }
}
```

---

## ⚙️ 高级配置模板

### 1. 性能优化配置

```json
{
  "performance": {
    "cache": {
      "enabled": true,
      "type": "redis",
      "redis": {
        "host": "localhost",
        "port": 6379,
        "db": 0,
        "ttl": 3600
      }
    },
    "rateLimit": {
      "enabled": true,
      "maxRequests": 100,
      "window": 60000
    },
    "concurrency": {
      "maxConcurrent": 10,
      "queue": {
        "enabled": true,
        "maxSize": 100
      }
    }
  }
}
```

---

### 2. 安全配置

```json
{
  "security": {
    "authentication": {
      "enabled": true,
      "type": "jwt",
      "secret": "YOUR_SECRET_KEY",
      "expiresIn": "7d"
    },
    "authorization": {
      "enabled": true,
      "roles": {
        "admin": {
          "permissions": ["*"]
        },
        "user": {
          "permissions": [
            "read:files",
            "write:files",
            "execute:skills"
          ]
        }
      }
    },
    "encryption": {
      "enabled": true,
      "algorithm": "aes-256-gcm",
      "key": "YOUR_ENCRYPTION_KEY"
    },
    "firewall": {
      "enabled": true,
      "allowIPs": [
        "127.0.0.1",
        "192.168.1.0/24"
      ],
      "denyIPs": []
    }
  }
}
```

---

### 3. 监控和日志配置

```json
{
  "monitoring": {
    "enabled": true,
    "metrics": {
      "enabled": true,
      "port": 9090,
      "path": "/metrics"
    },
    "healthCheck": {
      "enabled": true,
      "port": 8080,
      "path": "/health"
    },
    "alerts": {
      "enabled": true,
      "channels": ["email", "feishu"],
      "rules": [
        {
          "metric": "cpu_usage",
          "threshold": 80,
          "duration": 300,
          "message": "CPU使用率超过80%"
        },
        {
          "metric": "memory_usage",
          "threshold": 90,
          "duration": 300,
          "message": "内存使用率超过90%"
        },
        {
          "metric": "error_rate",
          "threshold": 5,
          "duration": 60,
          "message": "错误率过高"
        }
      ]
    }
  },
  "logging": {
    "level": "info",
    "format": "json",
    "outputs": [
      {
        "type": "file",
        "path": "~/.openclaw/logs/gateway.log",
        "rotation": {
          "maxSize": "10M",
          "maxFiles": 10,
          "compress": true
        }
      },
      {
        "type": "console",
        "colorize": true
      }
    ]
  }
}
```

---

### 4. 备份和恢复配置

```json
{
  "backup": {
    "enabled": true,
    "schedule": "0 2 * * *",
    "destination": "~/openclaw-backups",
    "retention": {
      "daily": 7,
      "weekly": 4,
      "monthly": 12
    },
    "include": [
      "~/.openclaw/config.json",
      "~/.openclaw/skills",
      "~/.openclaw/data"
    ],
    "exclude": [
      "~/.openclaw/logs",
      "~/.openclaw/cache"
    ],
    "compression": {
      "enabled": true,
      "algorithm": "gzip"
    },
    "encryption": {
      "enabled": true,
      "key": "YOUR_BACKUP_ENCRYPTION_KEY"
    },
    "remote": {
      "enabled": false,
      "type": "s3",
      "bucket": "openclaw-backups",
      "region": "us-east-1",
      "accessKeyId": "xxx",
      "secretAccessKey": "xxx"
    }
  }
}
```

---

## 📦 完整配置示例

### 生产环境配置

```json
{
  "gateway": {
    "mode": "production",
    "port": 18789,
    "bind": "0.0.0.0",
    "ssl": {
      "enabled": true,
      "cert": "/etc/ssl/certs/openclaw.crt",
      "key": "/etc/ssl/private/openclaw.key"
    },
    "cors": {
      "enabled": true,
      "origins": ["https://openclaw.yourdomain.com"]
    }
  },
  "models": {
    "default": "deepseek-chat",
    "code": "deepseek-coder",
    "longContext": "kimi",
    "streaming": true,
    "timeout": 60000,
    "routing": {
      "enabled": true,
      "rules": [
        {
          "condition": "tokens < 500",
          "model": "deepseek-chat"
        },
        {
          "condition": "tokens >= 500 && tokens < 2000",
          "model": "gpt-3.5-turbo"
        },
        {
          "condition": "tokens >= 2000",
          "model": "gpt-4"
        }
      ]
    },
    "providers": {
      "deepseek": {
        "apiKey": "${DEEPSEEK_API_KEY}",
        "baseURL": "https://api.deepseek.com"
      },
      "moonshot": {
        "apiKey": "${MOONSHOT_API_KEY}",
        "baseURL": "https://api.moonshot.cn"
      },
      "openai": {
        "apiKey": "${OPENAI_API_KEY}",
        "baseURL": "https://api.openai.com"
      }
    }
  },
  "workspace": {
    "path": "/data/openclaw/workspace",
    "autoCreate": true
  },
  "files": {
    "searchPaths": [
      "/data/openclaw/documents"
    ],
    "excludePaths": [
      "/data/openclaw/private"
    ],
    "index": {
      "enabled": true,
      "incremental": true,
      "schedule": "0 2 * * *"
    }
  },
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "${FEISHU_APP_ID}",
      "appSecret": "${FEISHU_APP_SECRET}",
      "features": {
        "streaming": true,
        "fileUpload": true
      }
    }
  },
  "skills": {
    "enabled": true,
    "autoUpdate": true,
    "updateSchedule": "0 3 * * 0"
  },
  "automation": {
    "enabled": true,
    "tasks": [
      {
        "name": "每日日报",
        "schedule": "0 9 * * *",
        "action": "sendMessage",
        "params": {
          "channel": "feishu",
          "message": "生成今日AI日报"
        }
      }
    ]
  },
  "performance": {
    "cache": {
      "enabled": true,
      "type": "redis",
      "redis": {
        "host": "localhost",
        "port": 6379
      }
    }
  },
  "security": {
    "authentication": {
      "enabled": true,
      "type": "jwt",
      "secret": "${JWT_SECRET}"
    },
    "firewall": {
      "enabled": true,
      "allowIPs": ["10.0.0.0/8"]
    }
  },
  "monitoring": {
    "enabled": true,
    "metrics": {
      "enabled": true,
      "port": 9090
    },
    "alerts": {
      "enabled": true,
      "channels": ["email"]
    }
  },
  "logging": {
    "level": "info",
    "format": "json",
    "outputs": [
      {
        "type": "file",
        "path": "/var/log/openclaw/gateway.log",
        "rotation": {
          "maxSize": "10M",
          "maxFiles": 10
        }
      }
    ]
  },
  "backup": {
    "enabled": true,
    "schedule": "0 2 * * *",
    "destination": "/backup/openclaw",
    "retention": {
      "daily": 7,
      "weekly": 4,
      "monthly": 12
    }
  }
}
```

---

## 🔧 配置工具

### 配置验证脚本

```bash
#!/bin/bash
# 文件名：validate-config.sh

CONFIG_FILE="$HOME/.openclaw/config.json"

echo "验证配置文件：$CONFIG_FILE"

# 检查文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ 配置文件不存在"
  exit 1
fi

# 验证JSON格式
if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
  echo "❌ JSON格式错误"
  exit 1
fi

echo "✅ JSON格式正确"

# 检查必需字段
required_fields=("gateway" "models" "workspace")
for field in "${required_fields[@]}"; do
  if ! jq -e ".$field" "$CONFIG_FILE" >/dev/null 2>&1; then
    echo "❌ 缺少必需字段：$field"
    exit 1
  fi
  echo "✅ 字段存在：$field"
done

echo "✅ 配置验证通过"
```

### 配置生成器

```bash
#!/bin/bash
# 文件名：generate-config.sh

echo "OpenClaw 配置生成器"
echo "===================="

# 询问基本信息
read -p "选择部署模式 (local/cloud): " mode
read -p "Gateway端口 (默认18789): " port
port=${port:-18789}

read -p "选择默认模型 (deepseek-chat/gpt-3.5-turbo): " model
model=${model:-deepseek-chat}

read -p "输入API密钥: " api_key

# 生成配置
cat > ~/.openclaw/config.json << EOF
{
  "gateway": {
    "mode": "$mode",
    "port": $port,
    "bind": "127.0.0.1"
  },
  "models": {
    "default": "$model",
    "providers": {
      "deepseek": {
        "apiKey": "$api_key",
        "baseURL": "https://api.deepseek.com"
      }
    }
  },
  "workspace": {
    "path": "~/Documents/OpenClaw"
  }
}
EOF

echo "✅ 配置文件已生成：~/.openclaw/config.json"
```

---

## 📚 相关资源

- [第2章：环境搭建](../docs/01-basics/02-installation.md)
- [第11章：高级配置](../docs/03-advanced/11-advanced-configuration.md)
- [附录E：常见问题](E-common-problems.md)
- [附录F：最佳实践](F-best-practices.md)

---

**最后更新**：2026年2月14日
