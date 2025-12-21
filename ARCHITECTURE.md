# Architecture: AI Control Plane

## 1. 核心理念 (Core Philosophy)

**AI Control Plane** 是一个运行在本地或私有云环境中的**智能上下文网关**。

它的核心使命是解耦 **AI User Interface** (TUI/IDE) 与 **Capabilities** (Tools/Services)。通过一层统一的控制平面，实现：
1.  **Write Once, Run Everywhere**: 工具层（MCP Server）只需接入 Control Plane，即可被所有前端（Cursor, Claude, Gemini CLI）复用。
2.  **Universal Docker Runtime**: 所有的依赖、环境、运行时都被封装在 Control Plane 的容器化架构中，用户本地只需一个 Docker Run。
3.  **Recursive Intelligence**: 任何接入的节点既可以是 Server 也可以是 Client。例如，Gemini CLI 可以作为一个 MCP Server 挂载到 Control Plane，供 Claude Code 调用以获取 Google Search 的能力。

## 2. 系统分层 (System Layering)

系统采用严格的四层架构设计：

```mermaid
graph TD
    subgraph "Layer 1: Interfaces (Clients)"
        A[Cursor / IDEs]
        B[Claude Code / CLI]
        C[Gemini CLI]
        D[TUI Terminals]
    end

    subgraph "Layer 2: Control Plane (Gateway & Mesh)"
        E[Unified Gateway]
        F[Auth & Audit]
        G[Router & LB]
        H[Observability]
    end

    subgraph "Layer 3: Orchestration & Agents"
        I[Workflow Engine]
        J[Agent: Reviewer]
        K[Agent: Architect]
    end

    subgraph "Layer 4: Runtime & Adapters"
        L[Docker Runtime (Sandboxed)]
        M[Local Process Adapter]
        N[Remote Service Adapter]
    end

    A --> E
    B --> E
    C --> E
    D --> E
    E --> I
    E --> L
    I --> L
    L --> M
    L --> N
```

### Layer 1: Interfaces (接入层)
**目标**：提供极致的、一致的接入体验。
*   **协议兼容**：原生支持 MCP (Model Context Protocol) over SSE/Stdio/WebSocket。
*   **Zero Config**：客户端只需配置单一 Endpoint（例如 `ws://localhost:9999/mcp`），无需关心底层是 Python 还是 Node.js 实现。
*   **支持列表**：
    *   Claude Code
    *   Cursor / Cursor CLI
    *   Gemini CLI
    *   Antigravity / Codex

### Layer 2: Control Plane (核心网关层)
**目标**：管理连接、安全与可观测性。
*   **统一路由**：将 `/mcp/git` 路由到 Git 容器，将 `/mcp/db` 路由到 Postgres Adapter。
*   **递归网关**：支持 "Client as Server" 模式。Control Plane 可以反向连接一个 TUI 实例，将其能力暴露给其他 Agent。
*   **安全沙箱**：控制哪些 AI 可以访问哪些本地路径（Read-Only vs Read-Write）。
*   **审计日志**：记录所有 AI 对本地基础设施的操作（"Who executed `rm -rf`?"）。

### Layer 3: Orchestration (编排与 Agent 层)
**目标**：处理复杂任务流。
*   **Workflow Engine**：定义多步操作（e.g., "Code Review" = Git Pull -> Linter -> LLM Review -> Report）。
*   **State Management**：维护长会话的上下文状态。

### Layer 4: Runtimes & Adapters (执行与适配层)
**目标**：屏蔽异构基础设施的差异。
*   **Container Runtime**：
    *   核心机制：Control Plane 控制宿主机 Docker/Podman Socket。
    *   功能：动态拉取、启动、销毁 Tool 容器（Python/JS/Go 环境隔离）。
*   **Local Adapters**：
    *   用于连接宿主机原生进程（如连接本地运行的 Postgres, Redis, 或 k8s cluster）。
*   **Legacy Adapters**：
    *   将旧的 API/CLI 工具封装为 MCP 协议。

## 3. 部署视图 (Deployment View)

为了满足运维和使用者的“易用性”挑战，核心交付物为一个 Docker Compose 栈或单体镜像。

```yaml
# 概念性 docker-compose.yml
services:
  control-plane:
    image: ai-control-plane:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock # 允许编排兄弟容器
      - ./config:/app/config # 声明式配置
      - ~/.ssh:/root/.ssh:ro # 使得 Git MCP 能复用宿主机凭证
    ports:
      - "9999:9999" # 统一 MCP 入口
```

## 4. 关键设计决策 (Key Design Decisions)

### 4.1 递归设计 (Recursion)
*   **决策**：不区分“绝对的工具”和“绝对的客户端”。
*   **场景**：
    1.  Claude Code (Client) 连接到 Control Plane。
    2.  Control Plane 启动 Gemini CLI (作为 Docker 容器)。
    3.  Gemini CLI 被包装成一个 MCP Server。
    4.  Claude Code 请求 "Search Web"，Control Plane 路由给 Gemini CLI 执行。

### 4.2 声明式配置 (Declarative Configuration)
基础设施即代码 (IaC) 风格的配置：

```yaml
# config.yaml
version: "1.0"
mesh:
  - name: "git-capability"
    source: "docker://mcp/git:latest"
    permissions: ["read", "write"]
    
  - name: "linear-ticket"
    source: "python-local://./adapters/linear.py"
    
  - name: "senior-architect"
    source: "agent://workflows/architect.yml"
```

## 5. 面向利益相关者的价值 (Stakeholder Value)

*   **架构师**：清晰的分层，解耦了模型提供商（OpenAI/Anthropic/Google）与工具实现。
*   **AI 工程师**：专注于写 Tool/Agent 逻辑，无需关心如何分发给 Cursor 或 Claude 用户。
*   **运维人员**：一个 Docker 镜像解决所有依赖问题，无污染宿主机环境。
*   **使用者**：`docker run` 之后，所有工具瞬间具备全栈能力。
