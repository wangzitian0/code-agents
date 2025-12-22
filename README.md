# AI Control Plane

**The Infrastructure Layer for Local AI Context.**

[![Status](https://img.shields.io/badge/Status-Pre--Alpha-orange)](https://github.com/your-repo)
[![Docker](https://img.shields.io/badge/Runtime-Docker-blue)](https://www.docker.com/)
[![Protocol](https://img.shields.io/badge/Protocol-MCP-green)](https://modelcontextprotocol.io/)

AI Control Plane 是一个**本地 AI 基础设施网关**。它通过 Docker 容器化技术，将分散的工具（Git, Databases, Cloud CLIs）统一封装为标准化的 MCP 服务，并供所有 AI 前端（Cursor, Claude, Gemini）共享使用。

> **"One Gateway to rule them all."** —— 不再需要在每个 AI 工具中重复配置 API Key 和环境。

## 核心特性

- **🐳 Docker Native**: 所有工具依赖（Python, Node, Go）运行在容器中，零污染宿主机。
- **🔌 Write Once, Use Everywhere**: 配置一次 Git MCP，Cursor 和 Claude 同时拥有代码库读写能力。
- **🔄 Recursive Capabilities**: 让 AI 工具互相调用（例如：让 Claude 调用 Gemini CLI 进行联网搜索）。

## 架构概览

详细架构请参阅 [ARCHITECTURE.md](./ARCHITECTURE.md)。

*   **Layer 1: Interfaces** (Cursor, Claude Code, TUIs)
*   **Layer 2: Control Plane** (Routing, Auth, Observability)
*   **Layer 3: Orchestration** (Agents, Workflows)
*   **Layer 4: Runtimes** (Docker, Local Processes)

## 快速开始 (Pre-Alpha)

### 前置要求

*   Docker / Podman
*   Node.js (用于客户端 CLI)

### 开发环境设置

**Mise** 统一管理工具版本和任务：

```bash
# 1. 安装 mise（一次性）
curl https://mise.run | sh

# 2. 进入项目目录
cd code-agents

# 3. 一键设置环境（自动安装工具 + 检查设置 + 启动服务）
mise run ready

# 常用命令
mise run gemini                # 启动 Gemini（后台服务 + 前台 Gemini，使用 gemini -y -s）
mise run start                 # 只启动后台服务（不启动 Gemini）
mise run status                # 查看服务状态
mise run logs                  # 查看日志
mise run stop-services         # 停止服务
mise run clean                 # 清理临时文件
```

### 启动 Control Plane

```bash
# 1. 启动核心网关 (Coming Soon)
docker-compose up -d

# 2. 你的本地 MCP 入口现已就绪
# Endpoint: ws://localhost:9999/mcp
```

### 接入 TUI

#### Claude Code / Cursor
只需在配置文件中指向本地 Control Plane：

```json
{
  "mcpServers": {
    "control-plane": {
      "command": "docker",
      "args": ["exec", "-i", "ai-control-plane", "mcp-bridge"]
    }
  }
}
```

## 贡献

我们正在构建未来的 AI 本地基础设施。请查看 `ARCHITECTURE.md` 了解设计理念。

## License

MIT
