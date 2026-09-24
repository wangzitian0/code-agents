<!-- WS_STATIC_START adapter=rules-v2 inputs=2f788da368e3c1c97d72e62954497fc861287fabc06396d26a06618da85c8bb7 -->
<!-- Generated file: do not edit by hand. These rules are maintained in the owner's rule source and re-rendered here. -->

## Engineering discipline

- **Measure the physical system first.** Before an abstract architecture proposal, inspect the system with read-only probes such as `time cmd`, process chains, and file-descriptor locks. A conceptually neat story without physical evidence is insufficient. A probe must not write. Do not combine validation and action in one command: a POST permission probe can create a resource, and a trial commit can leave a real commit. Measure, read the result, then decide, with a stop point between these steps.
- **Green does not prove truth.** The tested system writes its own unit tests, CI, and issue states. Cross-check critical conclusions against two external sources not written by this repository.
- **Tests must be falsifiable.** Do not hide assertions in `if (exists)` or `if (code != 0)` so failures run zero assertions. Do not accept tautologies such as `typeof null === 'object'` or `result !== undefined || true`. Source-text `indexOf` matches against prose are not integration tests. Duplicate test function identifiers can silently shadow earlier tests (Python `def` and duplicate JS function/const/export names); duplicate string titles in `test()` or `it()` instead run both. A green count is not coverage evidence. Make a new test fail under a relevant mutation. A read-only reviewer treats such fake-test patterns as CRITICAL merge blockers.
- **One source of truth:** Keep one authoritative definition for each core fact. Repeated hardcoding and scattered configuration invite drift.
- **Clean up during migration:** After the new mechanism is live and equivalence is proved, remove its predecessor, obsolete files, and dead code in the same change. Define contracts first and derive CI from them.
- **Deletion can leave guards green and empty:** A guard for an old structure can stop checking anything after deletion. Check each guard and remove it or redirect it to the new structure; green tests alone do not prove safe deletion.
- **Define guard scope from what it must govern, not from today's passing tree.** Let the guard fail on existing violations, then repair them. A guard never seen failing is not yet evidence of protection.

# AI Agent Instructions — Claude Code Agents

> **Repository Archetype**: `agent-interface` (AI Control Plane & Client Interfaces)
> **Rule Carrier**: `AGENTS.md` is generated; `CLAUDE.md` is a symlink to it. Do not edit either by hand.
> **Merge Authority**: Standard PRs with clean tests and review passing may be merged by agents per workspace standing grant.

## Context & Role

- **Project**: AI Control Plane - Interfaces & MCP Adapters
- **Scope**: Interface layer for local AI context and tooling adapters.

## Guidelines

1. **Rule Carrier**: `CLAUDE.md` is a symlink to the generated `AGENTS.md`. Do not create separate rule files.
2. **MCP Standards**: Ensure all interfaces and adapters comply with Model Context Protocol standards.
3. **Decoupling**: Do NOT hardcode private server IPs or private domains in client code.
4. **Testing**: Run container-based or local tests before declaring completion.
<!-- WS_STATIC_END -->
