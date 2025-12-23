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

**Asdf** 管理工具版本，**Makefile** 管理任务：

```bash
# 一键设置（自动安装 asdf + 工具 + 环境）
cd code-agents
make ready

# 首次运行会自动安装 asdf 和所有工具
# 如果提示需要重新加载 shell，运行: source ~/.zshrc 然后再次 make ready

# 常用命令
make gemini         # 启动 Gemini（后台服务 + 前台 Gemini，使用 gemini -y -s）
make start          # 检查设置并启动服务（不启动 Gemini）
make status         # 查看服务状态
make logs           # 查看日志
make stop-services  # 停止服务
make clean          # 清理临时文件
make help           # 显示所有可用命令
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
