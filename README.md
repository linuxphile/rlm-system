# RLM Multi-Agent System for Claude Code

A **Recursive Language Model (RLM)** inspired multi-agent system for comprehensive analysis and implementation of cloud-native, microservices, AI/ML, and full-stack systems.

Based on the MIT CSAIL paper ["Recursive Introspection: Teaching Foundation Models to Self-Improve"](https://arxiv.org/html/2512.24601v1) by Zhang, Kraska, and Khattab (2025).

## How This Implements the RLM Paper

The RLM paper proposes that language models can improve themselves through **recursive decomposition**, **specialized reasoning**, and **cross-validation**. This system applies those principles to software architecture:

| RLM Paper Concept | Implementation in This System |
|-------------------|-------------------------------|
| **Recursive Decomposition** | The orchestrator breaks complex full-stack reviews into specialized sub-agent tasks, each operating on a filtered subset of the codebase |
| **Specialized Reasoning** | 12 domain-expert agents (frontend, security, devops, etc.) each apply deep expertise to their area rather than one model trying to know everything |
| **Cross-Validation** | Automatic validation between agents catches integration issues (API contracts, design tokens, auth flows) that single-domain analysis would miss |
| **Iterative Refinement** | The `/rlm implement` workflow creates → validates → refines code across multiple agents, with security review and cross-domain checks |
| **Hierarchical Coordination** | The orchestrator acts as a meta-model coordinating specialized sub-models, synthesizing findings into prioritized recommendations |

### The Recursive Architecture

```
User Request (e.g., "review this codebase")
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                     ORCHESTRATOR                             │
│  • Analyzes project structure                                │
│  • Selects relevant agents                                   │
│  • Filters context per agent's domain                        │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│              12 SPECIALIZED AGENTS (parallel)                │
│                                                              │
│  cloud_infra    → sees *.tf, kubernetes/, Dockerfile        │
│  microservices  → sees src/**/*.go, api/, services/         │
│  frontend       → sees *.tsx, package.json, vite.config     │
│  security       → sees **/* (full context - can't filter)   │
│  ... 8 more agents with scoped context                      │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│              CROSS-VALIDATION (recursive refinement)         │
│                                                              │
│  • API contracts match between backend ↔ frontend?          │
│  • Design tokens consistent across web ↔ mobile?            │
│  • Auth flows complete across all clients?                  │
│  • Monitoring coverage spans all services?                  │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│              SYNTHESIZED REPORT                              │
│                                                              │
│  Prioritized findings: Critical → High → Medium → Low       │
│  Cross-domain issues highlighted                            │
│  Implementation roadmap generated                           │
└─────────────────────────────────────────────────────────────┘
```

The "recursive" aspect comes from:
1. **Hierarchical decomposition** - Complex problems broken into simpler sub-problems
2. **Scoped context windows** - Each recursion level works on a reduced problem space
3. **Cross-validation loops** - Findings from one agent validate/contradict another
4. **Synthesis back up the hierarchy** - Individual findings recomposed into holistic insights

## Features

- **12 Specialized Agents** for domain-specific analysis and implementation
- **9 Slash Commands** for common workflows
- **Cross-Domain Validation** to catch integration issues
- **Git Branch Protection** via pre-push hooks
- **PRD-to-Implementation** workflow with `/rlm prd` and `/rlm implement`
- **Structured Output** with YAML schemas for consistent, parseable results
- **Consolidated Permissions** in `agent-tools.yaml` for maintainability

## Quick Start

### Installation

#### Mac/Linux

```bash
cd rlm-system
chmod +x install.sh

# User-wide installation (recommended)
./install.sh --user

# Or project-only installation
./install.sh --project
```

#### Windows (PowerShell)

```powershell
cd rlm-system

# User-wide installation (recommended)
.\install.ps1 -Scope User

# Or project-only installation
.\install.ps1 -Scope Project
```

### Usage

After installation, in Claude Code:

```
/rlm review ./src
```

Or conversationally:

```
Review my codebase using the RLM system, focusing on security
```

## Commands

| Command | Description |
|---------|-------------|
| `/rlm review [path]` | Comprehensive full-stack review |
| `/rlm frontend [path]` | Web frontend performance & quality audit |
| `/rlm mobile [path]` | Mobile app analysis (iOS/Android/cross-platform) |
| `/rlm design [path]` | Design system health check & accessibility audit |
| `/rlm security [path]` | Security vulnerability scan |
| `/rlm incident "<desc>"` | Incident investigation & root cause analysis |
| `/rlm compare <a> <b>` | Architecture comparison/diff |
| `/rlm prd "<product>"` | Generate a Product Requirements Document |
| `/rlm implement <prd>` | Implement features from a PRD |

## Agents

### Infrastructure Layer
- **cloud_infra** - AWS/GCP/Azure, Terraform, Kubernetes, networking, cost optimization
- **devops** - CI/CD pipelines, deployments, SLOs, DORA metrics, GitOps

### Backend Layer
- **microservices** - APIs, distributed systems, communication patterns, resilience
- **data_eng** - Data pipelines, streaming, ETL, data quality, governance
- **aiml** - Model serving, MLOps, feature engineering, LLM systems

### Frontend Layer
- **frontend** - React/Vue/Angular, Web Vitals, bundling, accessibility
- **mobile** - iOS (Swift), Android (Kotlin), React Native, Flutter
- **design_ux** - Design systems, tokens, WCAG compliance, accessibility

### Cross-Cutting
- **security** - OWASP Top 10, compliance, secrets, supply chain (sees full context)
- **observability** - Metrics, logs, traces, SLIs/SLOs, alerting

### Coordination
- **orchestrator** - Coordinates agents, validates cross-domain, synthesizes findings
- **product_manager** - PRD creation, requirements definition, user research

## Agent Capabilities

### Git Operations

Implementation agents have git write access for feature development:

| Agent | Git Capabilities |
|-------|-----------------|
| **orchestrator** | Full access including merge, rebase, tag |
| **devops** | Full access including merge, rebase, tag, cherry-pick |
| cloud_infra, microservices, frontend, mobile, design_ux, aiml, data_eng | Branch, commit, push (no merge) |
| security, observability, product_manager | Read-only |

### CLI Tools

Agents have access to domain-specific CLI tools:

| Tool | Agents |
|------|--------|
| `gh` (GitHub CLI) | orchestrator, devops, security, observability |
| `firebase` | cloud_infra, frontend, mobile, devops, observability |
| `terraform` | cloud_infra |
| `kubectl`, `helm` | cloud_infra |
| `npm`, `npx` | frontend, mobile, design_ux, microservices, devops |

## Branch Protection

### Pre-Push Hook

The system includes a git pre-push hook that prevents unauthorized pushes to `main`/`master`:

```bash
# Install hooks in your project
./hooks/install-hooks.sh /path/to/your/project
```

**How it works:**
- Blocks pushes to protected branches unless `RLM_AGENT` environment variable is set
- Only `devops`, `orchestrator`, or `human` can push to main/master
- Other agents must create feature branches and PRs

**For authorized agents:**
```bash
export RLM_AGENT=devops
git push origin main
```

**For human developers:**
```bash
RLM_AGENT=human git push origin main
```

### Blocked Patterns

The following git operations are blocked for all agents:
- Direct pushes to main/master
- Force pushes (`--force`, `-f`)
- Deleting protected branches
- Hard resets to origin/main or origin/master

## Cross-Domain Validation

The orchestrator automatically validates findings across agents:

| Check | Agents | Purpose |
|-------|--------|---------|
| API Contracts | microservices ↔ frontend, mobile | Ensure APIs match client expectations |
| Design Tokens | design_ux ↔ frontend, mobile | Verify implementation matches design |
| Auth Flows | security ↔ frontend, mobile | Validate auth across all clients |
| Performance | frontend, mobile ↔ cloud_infra | Ensure infra supports perf goals |
| Monitoring | observability ↔ all | Verify coverage across components |

## Directory Structure

After installation:

```
~/.claude/                          # User-wide (or .claude/ for project)
├── CLAUDE.md                       # Configuration with RLM docs
├── settings.json                   # Claude Code settings
├── skills/
│   └── rlm-system/
│       ├── SKILL.md                # Main entry point
│       ├── tools/
│       │   └── agent-tools.yaml    # Consolidated permissions
│       └── hooks/
│           ├── pre-push            # Branch protection hook
│           └── install-hooks.sh    # Hook installer
├── agents/
│   └── rlm/                        # 12 agent definitions
├── commands/
│   └── rlm/                        # 9 command definitions
└── templates/                      # 5 report templates
```

## Workflow: PRD to Implementation

The RLM system supports end-to-end feature development:

```bash
# 1. Generate a PRD
/rlm prd "Voice ordering system for restaurants"

# 2. Review the generated PRD
# (Creates: ./docs/prd-voice-ordering-20250119.md)

# 3. Implement from the PRD
/rlm implement ./docs/prd-voice-ordering-20250119.md --dry-run

# 4. Execute implementation (after reviewing plan)
/rlm implement ./docs/prd-voice-ordering-20250119.md
```

The implementation workflow:
1. **PRD Analysis** - Extract requirements and implementation signals
2. **Codebase Discovery** - Detect existing patterns and frameworks
3. **Phase Planning** - Create execution phases with dependencies
4. **Implementation** - Coordinate agents (data → API → frontend → tests)
5. **Security Review** - Automated security scan of changes
6. **Cross-Validation** - Verify integration across domains

## Example Output

```markdown
## Analyzing Project Structure

**Detected Components:**
- Infrastructure: ✓ (Terraform, Kubernetes)
- Backend Services: ✓ (Go microservices)
- Frontend (Web): ✓ (Next.js)
- Mobile Apps: ✗
- Design System: ✓ (Storybook)

**Selected Agents:** cloud_infra, microservices, frontend, design_ux, security, observability, devops

## Synthesized Findings

### Critical (Fix Immediately)
- [security] Hardcoded AWS credentials in config/settings.py:23
- [security] SQL injection vulnerability in api/users.py:78

### High Priority (This Sprint)
- [frontend] Initial bundle 287KB exceeds 200KB target
- [microservices] No circuit breaker on payment-service calls
- [observability] Missing correlation IDs in distributed traces

### Medium (Next Sprint)
- [design_ux] 5 components have contrast ratio < 4.5:1
- [cloud_infra] RDS instances could use reserved pricing (save ~$400/mo)
- [devops] Pipeline takes 18 minutes, could parallelize to ~8 minutes

### Cross-Domain Issues
- [microservices ↔ frontend] API v2 endpoint not called by frontend (dead code?)
- [design_ux ↔ mobile] Button border-radius inconsistent (8px vs 12px)
```

## Customization

### Adding Custom Agents

Create a new agent file in `agents/`:

```markdown
---
name: custom-agent
description: Specializes in your domain...
tools: Read, Write, Edit, Grep, Glob, Bash, WebSearch
bash_permissions: tools/agent-tools.yaml#custom_agent
model: inherit
---

You are the Custom Agent specializing in...

## Capabilities
...

## Analysis Framework
...

## Output Schema
```yaml
custom_analysis:
  findings: ...
```
```

Then add permissions to `tools/agent-tools.yaml`:

```yaml
custom_agent:
  tools:
    - view
    - bash_tool
    - web_search
  bash_allowed:
    - "your-cli-tool *"
    - "grep -rn 'pattern' *"
  context_filter:
    - "your-domain/**/*"
```

### Adding Custom Commands

Create a new command file in `commands/`:

```markdown
# Command: /rlm custom

## Usage
/rlm custom [path]

## Agents Invoked
1. **custom-agent** (primary)
2. **security** (always)

## Workflow
...
```

## Troubleshooting

### Commands not recognized

Ensure Claude reads the SKILL.md first:
```
Read ~/.claude/skills/rlm-system/SKILL.md then run /rlm review
```

### Missing agent context

Explicitly reference the agent:
```
Using the security agent from RLM, analyze my authentication code
```

### Installation issues

Verify the directory structure:
```bash
# Mac/Linux
ls -la ~/.claude/skills/rlm-system/

# Windows
dir $env:USERPROFILE\.claude\skills\rlm-system\
```

### Hook not blocking pushes

Ensure the hook is installed and executable:
```bash
ls -la .git/hooks/pre-push
# Should show: -rwxr-xr-x ... pre-push
```

## License

MIT License - See LICENSE file for details.

## Credits

- Based on ["Recursive Introspection: Teaching Foundation Models to Self-Improve"](https://arxiv.org/html/2512.24601v1) (Zhang, Kraska, Khattab - MIT CSAIL, 2025)
- Built for use with Claude Code by Anthropic
