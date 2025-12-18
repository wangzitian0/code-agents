# Code Agents 系统设计文档

## 核心目标

**通过 MCP 服务提供统一的能力，让不同的 AI 入口使用相同的功能**

## 架构设计

```
code-agents/
├── mcp-servers/              # MCP 服务器实现和管理
│   ├── local/               # 本地实现的服务器（TypeScript）
│   │   ├── code-review/
│   │   ├── code-generation/
│   │   └── testing/
│   ├── external/            # 外部引入的服务器（GitHub 开源）
│   │   ├── python/         # Python 实现的服务器
│   │   │   ├── github-mcp-server-1/
│   │   │   └── github-mcp-server-2/
│   │   └── js/             # JavaScript/TypeScript 实现的服务器
│   │       ├── github-mcp-server-3/
│   │       └── ...
│   └── registry.yml        # 服务器注册表（统一管理）
│
├── mcp-configs/             # MCP 服务器配置（各工具如何连接）
│   ├── cursor/              # Cursor 的 MCP 配置
│   ├── gemini-cli/         # Gemini CLI 的 MCP 配置
│   ├── claude-code/        # Claude Code 的 MCP 配置
│   └── ...
│
├── specs/                    # 规范层（SSOT）
│   ├── slash-commands/      # slash 命令规范（通过 MCP 实现）
│   └── capabilities/        # 能力规范
│
└── scripts/                  # 工具脚本
    ├── install-mcp.sh       # 安装 MCP 服务器配置到各工具
    └── add-mcp-server.sh   # 添加外部 MCP 服务器
```

## 输入输出定义

### 输入

1. **MCP 服务器**（`mcp-servers/`）
   - **本地实现**（TypeScript）：团队自己开发的服务器
   - **外部引入**（Python/JS）：GitHub 开源服务器
   - **混合工作流**：Python 和 JS 服务器可以同时运行

2. **MCP 配置**（`mcp-configs/{tool}/`）
   - 各工具如何连接 MCP 服务器
   - 工具特定的 MCP 配置

### 输出

1. **统一的 MCP 服务**
   - 所有 AI 工具通过 MCP 协议访问相同功能
   - 语言无关：Python 和 JS 服务器可以同时运行
   - 不需要为每个工具单独适配

2. **工具中的 MCP 配置**
   - Cursor: `.cursor/mcp.json` 或配置
   - Gemini CLI: MCP 服务器配置
   - Claude Code: MCP 服务器配置

## 用法

### 1. 团队使用

```bash
# 安装 MCP 服务器配置到项目
~/zitian/code-agents/scripts/install-mcp.sh --target . --tools cursor,gemini-cli,claude-code
```

**结果**：各工具连接到相同的 MCP 服务器，获得统一的能力

### 2. 使用 MCP 服务

所有 AI 工具通过 MCP 协议调用相同的服务：
- `/review` → MCP 代码审查服务
- `/test` → MCP 测试服务
- `/generate` → MCP 代码生成服务

### 3. 添加外部 MCP 服务器

```bash
# 从 GitHub 添加 Python MCP 服务器
~/zitian/code-agents/scripts/add-mcp-server.sh \
  --source github.com/user/python-mcp-server \
  --language python \
  --name my-python-server

# 从 GitHub 添加 JS MCP 服务器
~/zitian/code-agents/scripts/add-mcp-server.sh \
  --source github.com/user/js-mcp-server \
  --language js \
  --name my-js-server
```

**结果**：服务器添加到 `mcp-servers/external/`，自动注册到 `registry.yml`

### 4. 混合工作流

- Python 和 TypeScript 服务器可以同时运行
- 通过 MCP 协议统一访问，语言对用户透明
- 在 `registry.yml` 中统一管理所有服务器

## 关键设计决策

1. **MCP 优先**：核心能力通过 MCP 服务提供，而不是配置文件
2. **统一接口**：所有工具通过 MCP 协议访问相同功能
3. **语言无关**：支持 Python 和 TypeScript 混合工作流
4. **外部集成**：支持引入 GitHub 开源 MCP 服务器
5. **版本锁定**：MCP 服务器版本和配置版本明确锁定

## 工具优先级

- **P0**: cursor, gemini-cli, claude-code
- **P1**: codex, antigravity
- **P2**: copilot 等其他工具
