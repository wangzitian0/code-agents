# AI Agent Instructions — Claude Code Agents

> **Repository Archetype**: `agent-interface` (AI Control Plane & Client Interfaces)
> **Rule Carrier SSOT**: `AGENTS.md` is canonical; `CLAUDE.md` is a symlink to this file.
> **Merge Authority**: Standard PRs with clean tests and review passing may be merged by agents per workspace standing grant.

## Context & Role

- **Project**: AI Control Plane - Interfaces & MCP Adapters
- **Repository**: `~/zitian/claude-code-agents`
- **Git Identity**: `wangzitian0@gmail.com`
- **Scope**: Interface layer for local AI context and tooling adapters.

## Guidelines

1. **Rule Carrier SSOT**: `CLAUDE.md` is a symlink to `AGENTS.md`. Do not create separate rule files.
2. **MCP Standards**: Ensure all interfaces and adapters comply with Model Context Protocol standards.
3. **Decoupling**: Do NOT hardcode private server IPs or private domains in client code.
4. **Testing**: Run container-based or local tests before declaring completion.
