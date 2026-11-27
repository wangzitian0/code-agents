# AI Agent Instructions — Claude Code Agents

> **Repository Archetype**: `agent-interface` (AI Control Plane & Client Interfaces)
> **Authority**: This repository owns its own `AGENTS.md` directly.
> **Merge Authority**: Standard PRs with clean tests and review passing may be merged by agents per workspace standing grant.

## Production reservation

The single definition of the production reservation. Other tiers, skills and gates point here.

- **Only a production change returns to the owner.** A production change alters what production runs or stores (deploy, promote or apply to production; production secret write; manual production data write or deletion; production DNS, route or host change; unrecallable release; or scheduled unapproved production code). Each Repo tier names its production paths. A path can be a merge or a release-checkout pull.
- **Approval:** the owner approves the exact commit SHA or release tag of each production change, and is present when it runs. A "deploy" reply covers only the release that it names. Immediately before a production dispatch, get a live reply from the owner.
- **Self-guard:** an edit that removes, narrows or redefines the production reservation needs the owner's approval of its head SHA. This includes an edit that makes fewer production runs wait for the owner (deploy-path approval check, production job classification, or production environment settings). It also covers removing or weakening a pin of this section, its pin test, or the required check that runs the test.
- **Everything else is the agent's:** in any repository the owner owns, every non-production change (including `dev_env` outside the self-guard), staging and canary deploy, release tag, rule text, skill, gate/release code, and required-check edit. Before merging gate or release code, an independent read-only reviewer inspects the head SHA and states whether the gate gets stricter, equal or looser. A looser edit in the self-guard follows the self-guard.
- **Every other hold is a defect:** a rule, skill, label or gate holding non-production work for the owner is a defect. Do the work, then fix the hold. `ws_owner_scope` fails on it.

## Context & Role

- **Project**: AI Control Plane - Interfaces & MCP Adapters
- **Scope**: Interface layer for local AI context and tooling adapters.

## Guidelines

1. **Rule Carrier**: `AGENTS.md` is the repository rule file. Do not create duplicate rule files.
2. **MCP Standards**: Ensure all interfaces and adapters comply with Model Context Protocol standards.
3. **Decoupling**: Do NOT hardcode private server IPs or private domains in client code.
4. **Testing**: Run container-based or local tests before declaring completion.
