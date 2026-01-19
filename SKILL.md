# RLM Multi-Agent System Skill

## Overview

A Recursive Language Model (RLM) inspired multi-agent system for comprehensive analysis of cloud-native, microservices, AI/ML, and frontend systems. Based on the MIT CSAIL paper by Zhang, Kraska, and Khattab (2025).

This skill enables Claude to decompose complex technical analysis tasks across 11 specialized sub-agents, each with domain-specific expertise and tool permissions.

## Trigger Patterns

Use this skill when users request:

- **System reviews**: "review my codebase", "analyze this project", "audit my application"
- **Frontend audits**: "check frontend performance", "audit web vitals", "review React code"
- **Mobile analysis**: "analyze my iOS app", "review Android code", "check mobile performance"
- **Design reviews**: "audit design system", "check accessibility", "review components"
- **Security scans**: "security audit", "find vulnerabilities", "check for secrets"
- **Architecture reviews**: "review microservices", "analyze API design", "check infrastructure"
- **Incident investigation**: "investigate outage", "root cause analysis", "debug incident"
- **ML/AI reviews**: "review ML pipeline", "audit model serving", "check MLOps"
- **Product requirements**: "write a PRD", "create product requirements", "define product specs"

## Commands

| Command                         | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| `/rlm review [path]`            | Comprehensive full-stack review                  |
| `/rlm frontend [path]`          | Web frontend performance & quality audit         |
| `/rlm mobile [path]`            | Mobile app analysis (iOS/Android/cross-platform) |
| `/rlm design [path]`            | Design system health check & accessibility audit |
| `/rlm security [path]`          | Security vulnerability scan                      |
| `/rlm infra [path]`             | Cloud infrastructure review                      |
| `/rlm api [path]`               | Microservices & API design review                |
| `/rlm ml [path]`                | AI/ML systems & MLOps review                     |
| `/rlm data [path]`              | Data engineering & pipelines review              |
| `/rlm incident <desc>`          | Incident investigation & RCA                     |
| `/rlm compare <before> <after>` | Architecture comparison/diff                     |
| `/rlm prd "<product>"`          | Create Product Requirements Document             |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     ORCHESTRATOR AGENT                          │
│  Analyzes → Decomposes → Executes → Validates → Synthesizes    │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ INFRASTRUCTURE│   │    BACKEND    │   │   FRONTEND    │
│───────────────│   │───────────────│   │───────────────│
│ • cloud_infra │   │ • microservices│  │ • frontend    │
│ • devops      │   │ • data_eng    │   │ • mobile      │
│               │   │ • aiml        │   │ • design_ux   │
└───────────────┘   └───────────────┘   └───────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
                    ┌───────────────┐
                    │ CROSS-CUTTING │
                    │───────────────│
                    │ • security    │
                    │ • observability│
                    └───────────────┘
```

## Sub-Agents

| Agent             | Domain               | Key Capabilities                                  |
| ----------------- | -------------------- | ------------------------------------------------- |
| `cloud_infra`     | Cloud Infrastructure | AWS/GCP/Azure, Terraform, K8s, networking, cost   |
| `microservices`   | Service Architecture | APIs, DDD, communication patterns, resilience     |
| `aiml`            | AI/ML Systems        | Model serving, MLOps, features, LLM systems       |
| `devops`          | DevOps/SRE           | CI/CD, deployments, SLOs, DORA metrics            |
| `security`        | Security             | OWASP, compliance, secrets, supply chain          |
| `observability`   | Observability        | Metrics, logs, traces, RUM, alerting              |
| `data_eng`        | Data Engineering     | Pipelines, streaming, quality, governance         |
| `frontend`        | Web Development      | React/Vue/Angular, performance, bundling          |
| `mobile`          | Mobile Development   | iOS, Android, React Native, Flutter               |
| `design_ux`       | Design/UX            | Design systems, accessibility, components         |
| `product_manager` | Product Management   | PRDs, requirements, user research, prioritization |

## Usage

### Basic Review

```
User: Review my codebase at /path/to/project
Claude: [Reads SKILL.md, then orchestrates sub-agents based on detected content]
```

### Targeted Audit

```
User: /rlm frontend ./src
Claude: [Invokes frontend agent with full tool permissions for web analysis]
```

### Incident Investigation

```
User: /rlm incident "API latency spike at 2pm, users seeing 504 errors"
Claude: [Starts with observability agent, traces through affected services]
```

## Workflow

1. **ANALYZE**: Scan context to determine structure and relevant domains
2. **PLAN**: Select appropriate sub-agents and determine execution order
3. **EXECUTE**: Invoke sub-agents with filtered context and tool permissions
4. **VALIDATE**: Cross-check findings between agents (API↔Frontend, Design↔Implementation)
5. **SYNTHESIZE**: Combine findings into prioritized recommendations
6. **REPORT**: Generate structured output using templates

## File Structure

```
rlm-system/
├── SKILL.md                 # This file
├── agents/                  # Sub-agent definitions
│   ├── orchestrator.md      # Main coordination logic
│   ├── cloud-infra.md
│   ├── microservices.md
│   ├── frontend.md
│   ├── mobile.md
│   ├── design-ux.md
│   ├── aiml.md
│   ├── devops.md
│   ├── security.md
│   ├── observability.md
│   ├── data-eng.md
│   └── product-manager.md   # Product management & PRDs
├── commands/                # Slash command definitions
│   ├── review.md
│   ├── frontend.md
│   ├── mobile.md
│   ├── design.md
│   ├── security.md
│   ├── incident.md
│   ├── compare.md
│   └── prd.md               # PRD creation command
├── tools/                   # Tool configurations
│   └── agent-tools.yaml
└── templates/               # Output templates
    ├── review-report.md
    ├── security-report.md
    ├── frontend-report.md
    ├── incident-rca.md
    └── prd-template.md      # PRD document template
```

## Cross-Domain Validation

The orchestrator performs automatic cross-validation:

| Check         | Agents                           | Purpose                                 |
| ------------- | -------------------------------- | --------------------------------------- |
| API Contracts | microservices ↔ frontend, mobile | Ensure API matches client expectations  |
| Design Tokens | design_ux ↔ frontend, mobile     | Verify implementation matches design    |
| Auth Flows    | security ↔ frontend, mobile      | Validate auth across all clients        |
| Performance   | frontend, mobile ↔ cloud_infra   | Ensure infra supports performance goals |
| Monitoring    | observability ↔ all              | Verify coverage across all components   |

## Output Format

All agents produce structured YAML output that can be:

- Aggregated by the orchestrator
- Cross-referenced for conflicts
- Rendered into reports
- Used for tracking over time

See `templates/` for output formats.

## Getting Started

1. Upload or provide path to codebase
2. Use a command like `/rlm review` or describe what you want analyzed
3. Claude will read relevant agent definitions and execute analysis
4. Receive prioritized findings with actionable recommendations

## Notes

- Security agent always gets full context (needs to see everything)
- Frontend/mobile agents coordinate for shared code opportunities
- Design agent validates implementation across all UI platforms
- Observability agent checks RUM coverage for frontend/mobile
