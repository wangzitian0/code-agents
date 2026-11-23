<!-- WS_STATIC_START adapter=rules-v2 inputs=ae4b17ac99d9623241e356fd2418aad68b34176fdc1a0b60b7a4a0ba94e46ce0 -->
<!-- Generated file: do not edit by hand. These rules are maintained in the owner's rule source and re-rendered here. -->

## Engineering discipline

- **Measure the physical system first.** Inspect the system with read-only probes (`time cmd`, process chains, file locks) before proposing architecture. Never combine validation and mutation in one command. Measure, read the result, then decide.
- **Green does not prove truth.** The tested system writes its own unit tests, CI, and issue states. Cross-check critical conclusions against two external sources not written by this repository.
- **Tests must be falsifiable.** Never hide assertions inside `if` branches or accept tautologies. Source-text `indexOf` matches against prose are not integration tests. Avoid duplicate test function names that shadow earlier tests. Make every new test fail under a relevant mutation; fake tests are CRITICAL merge blockers.
- **Falsifiable documentation and assertions:** State test requirements, error messages, and specifications in concrete ASD-STE100 terms without vague qualifiers.
- **One source of truth:** Keep one authoritative definition per core fact. Repeated hardcoding and scattered configuration invite drift.
- **Clean up during migration:** After the new mechanism is live and equivalence is proved, remove its predecessor, obsolete files, and dead code in the same change. Define contracts first and derive CI from them.
- **Deletion can leave guards green and empty:** A guard for an old structure can stop checking anything after deletion. Check each guard and remove it or redirect it to the new structure; green tests alone do not prove safe deletion.
- **Fix an owner hold by deletion:** Delete the rule or gate branch that holds non-production work. Do not add logic that reads a command to permit it. Such logic lets unsafe commands through.
- **Define guard scope from what it must govern, not from today's passing tree.** Let the guard fail on existing violations, then repair them. A guard never seen failing is not yet evidence of protection.
- **Worktree self-sufficiency:** Every worktree must resolve its dependencies, toolchain, skills, and configuration internally. Tools and tests must not navigate upward with `../..` to locate files in parent checkouts.
- **Local and remote test segregation:** Before a PR, run only the focused tests of the change in one process (`pytest <file>::<test> -x`). The full suite, parallel runs and coverage run on remote CI only.
- **Bounded file reads:** Pass `StartLine` and `EndLine` (`<= 800` lines per call) when reading existing files with `read_file` or `view_file`.

## Production reservation

The single definition of the production reservation. Other tiers, skills and gates point here.

- **Only a production change returns to the owner.** A production change alters what production runs or stores (deploy, promote or apply to production; production secret write; manual production data write or deletion; production DNS, route or host change; unrecallable release; or scheduled unapproved production code). Each Repo tier names its production paths. A path can be a merge or a release-checkout pull.
- **Approval:** the owner approves the exact commit SHA or release tag of each production change, and is present when it runs. A "deploy" reply covers only the release that it names. Immediately before a production dispatch, get a live reply from the owner.
- **Self-guard:** an edit that removes, narrows or redefines the production reservation needs the owner's approval of its head SHA. This includes an edit that makes fewer production runs wait for the owner (deploy-path approval check, production job classification, or production environment settings). It also covers removing or weakening a pin of this section, its pin test, or the required check that runs the test.
- **Everything else is the agent's:** in any repository the owner owns, every non-production change (including `dev_env` outside the self-guard), staging and canary deploy, release tag, rule text, skill, gate/release code, and required-check edit. Before merging gate or release code, an independent read-only reviewer inspects the head SHA and states whether the gate gets stricter, equal or looser. A looser edit in the self-guard follows the self-guard.
- **Every other hold is a defect:** a rule, skill, label or gate holding non-production work for the owner is a defect. Do the work, then fix the hold. `ws_owner_scope` fails on it.

# AI Agent Instructions — Claude Code Agents

> **Repository Archetype**: `agent-interface` (AI Control Plane & Client Interfaces)
> **Rule Carrier**: `AGENTS.md` is generated. Do not edit it by hand.
> **Merge Authority**: Standard PRs with clean tests and review passing may be merged by agents per workspace standing grant.

## Context & Role

- **Project**: AI Control Plane - Interfaces & MCP Adapters
- **Scope**: Interface layer for local AI context and tooling adapters.

## Guidelines

1. **Rule Carrier**: `AGENTS.md` is the single generated rule carrier. Do not create separate rule files.
2. **MCP Standards**: Ensure all interfaces and adapters comply with Model Context Protocol standards.
3. **Decoupling**: Do NOT hardcode private server IPs or private domains in client code.
4. **Testing**: Run the focused checks of the change. CI checks shell syntax and JSON only.
<!-- WS_STATIC_END -->
