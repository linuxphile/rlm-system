# RLM System - Hooks

This directory contains all hooks for the RLM (Recursive Language Model) multi-agent system, including Git hooks for repository protection and Claude Code hooks for sub-agent context management.

## Directory Structure

```
hooks/
├── git/                    # Git hooks
│   ├── pre-push           # Bash pre-push hook
│   └── pre-push.ps1       # PowerShell pre-push hook
├── claude/                 # Claude Code hooks (TypeScript)
│   ├── src/
│   │   ├── types.ts       # Type definitions
│   │   ├── utils.ts       # Utility functions
│   │   ├── subagent-start.ts  # SubagentStart hook
│   │   ├── subagent-stop.ts   # SubagentStop hook
│   │   └── index.ts       # Module exports
│   ├── dist/              # Compiled JavaScript (generated)
│   ├── config.yaml        # Hook configuration
│   ├── package.json       # NPM configuration
│   └── tsconfig.json      # TypeScript configuration
├── install.sh             # Unified installer (bash)
├── install.ps1            # Unified installer (PowerShell)
└── README.md              # This file
```

## Installation

### Quick Install

Install all hooks to the current directory:

```bash
# macOS/Linux
./hooks/install.sh

# Windows PowerShell
.\hooks\install.ps1
```

### Install to a Different Project

```bash
# macOS/Linux
./hooks/install.sh /path/to/target/project

# Windows PowerShell
.\hooks\install.ps1 C:\path\to\target\project
```

### Selective Installation

```bash
# Git hooks only
./install.sh --git-only

# Claude Code hooks only
./install.sh --claude-only

# PowerShell equivalents
.\install.ps1 -GitOnly
.\install.ps1 -ClaudeOnly
```

### Requirements

- **Git hooks**: Git repository (`.git` directory)
- **Claude Code hooks**: Node.js 18+ and npm

## Git Hooks

### pre-push

Protects `main` and `master` branches from unauthorized pushes. Only allows pushes when the `RLM_AGENT` environment variable is set to an authorized agent.

**Authorized agents:**
- `orchestrator` - Primary orchestration agent
- `devops` - DevOps and deployment agent
- `human` - Human override

**Usage:**

```bash
# Bash/Zsh
export RLM_AGENT=devops
git push origin main

# Windows PowerShell
$env:RLM_AGENT = "devops"
git push origin main
```

**Bypass (not recommended):**

```bash
git push --no-verify origin main
```

## Claude Code Hooks

The Claude Code hooks enable the RLM multi-agent system by ensuring sub-agents spawn in isolated context windows with proper agent definitions and response schemas.

### SubagentStart

Triggered when a sub-agent is spawned via the Task tool. This hook:

1. **Detects agent type** from the task description or explicit `subagent_type`
2. **Loads agent definition** from the corresponding markdown file in `agents/`
3. **Determines task type** (analysis, implementation, review, or standard)
4. **Injects context** including:
   - Full agent definition (capabilities, tools, guidelines)
   - Appropriate response schema template
   - Session and parent context

**Agent Detection:**

The hook automatically detects which agent to use based on keywords in the task description:

| Agent | Keywords |
|-------|----------|
| `cloud_infra` | aws, azure, gcp, terraform, kubernetes, k8s, docker, cloud |
| `frontend` | react, vue, angular, css, html, ui, frontend, component |
| `mobile` | ios, android, react native, flutter, mobile, swift, kotlin |
| `security` | security, vulnerability, penetration, audit, compliance |
| `devops` | ci/cd, pipeline, deploy, jenkins, github actions, devops |
| ... | See `utils.ts` for full mapping |

**Task Type Detection:**

| Task Type | Triggers |
|-----------|----------|
| `analysis` | "analyze", "review", "assess", "audit", "evaluate" |
| `implementation` | "implement", "create", "build", "develop", "add" |
| `review` | "review", "check", "validate", "verify" |
| `standard` | Default for other tasks |

### SubagentStop

Triggered when a sub-agent completes or errors. This hook:

1. **Validates response** against the expected YAML schema
2. **Extracts cross-domain flags** for routing to other agents
3. **Reports status** (success, partial, blocked, error)

**Validation Results:**

- `valid` - Response matches expected schema
- `invalid_schema` - Response has wrong structure
- `missing_required` - Required fields are missing
- `no_yaml` - No YAML response block found
- `subagent_error` - Sub-agent encountered an error

### Response Schemas

Sub-agents should return structured YAML responses. Example:

```yaml
---
status: success
summary: "Completed security audit of authentication module"
findings:
  - severity: high
    description: "SQL injection vulnerability in login endpoint"
    location: "src/auth/login.ts:45"
    recommendation: "Use parameterized queries"
cross_domain:
  - agent: devops
    reason: "Requires CI/CD pipeline update for security scanning"
---
```

## Configuration

### Claude Code Hook Configuration

Edit `hooks/claude/config.yaml`:

```yaml
rlm:
  settings:
    verbose: false              # Enable verbose logging
    track_cross_domain: true    # Extract cross-domain flags
    validate_responses: true    # Validate YAML responses

  agent_detection:
    enabled: true               # Auto-detect agent from description
    fallback: general           # Default agent if detection fails
```

### Environment Variables

| Variable | Description |
|----------|-------------|
| `RLM_ROOT` | Root directory of the RLM system |
| `RLM_HOOKS_DIR` | Hooks directory path |
| `RLM_AGENTS_DIR` | Agents definitions directory |
| `RLM_AGENT` | Current agent identity (for git hooks) |
| `RLM_VERBOSE` | Enable verbose logging |

## Development

### Building TypeScript Hooks

```bash
cd hooks/claude
npm install
npm run build

# Watch mode for development
npm run watch
```

### Testing Hooks

```bash
# Test SubagentStart with sample input
echo '{"session_id":"test","subagent_type":"security","subagent_prompt":"Audit the auth module"}' | node dist/subagent-start.js

# Test SubagentStop with sample input
echo '{"session_id":"test","subagent_result":"---\nstatus: success\n---"}' | node dist/subagent-stop.js
```

### Adding New Agent Types

1. Create agent definition in `agents/<agent_type>.md`
2. Add keywords to `AGENT_KEYWORDS` in `hooks/claude/src/utils.ts`
3. Update `AgentType` in `hooks/claude/src/types.ts`
4. Rebuild: `npm run build`

## Troubleshooting

### Git hook not running

1. Verify hook is executable: `ls -la .git/hooks/pre-push`
2. Check for shebang line at top of file
3. Ensure no `.sample` extension

### Claude Code hooks not triggering

1. Verify hooks are configured in `.claude/settings.json`:
   ```json
   {
     "hooks": {
       "SubagentStart": [...],
       "SubagentStop": [...]
     }
   }
   ```
2. Restart Claude Code after installation
3. Check Node.js is available: `node --version`

### TypeScript compilation errors

1. Install dependencies: `cd hooks/claude && npm install`
2. Check Node.js version: `node --version` (requires 18+)
3. Clear and rebuild: `rm -rf dist && npm run build`

### Agent not detected correctly

1. Check task description contains relevant keywords
2. Use explicit `subagent_type` parameter in Task tool
3. Verify agent definition exists in `agents/` directory

### PowerShell execution policy

If PowerShell blocks script execution:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Claude Code Instance                         │
│                                                                  │
│  ┌──────────────┐    Task Tool    ┌──────────────────────────┐ │
│  │   Parent     │ ──────────────> │    SubagentStart Hook    │ │
│  │   Agent      │                 │  - Detect agent type     │ │
│  │              │                 │  - Load definition       │ │
│  └──────────────┘                 │  - Inject context        │ │
│         ▲                         └───────────┬──────────────┘ │
│         │                                     │                 │
│         │                                     ▼                 │
│         │                         ┌──────────────────────────┐ │
│         │                         │    Sub-Agent Instance    │ │
│         │                         │  (Isolated Context)      │ │
│         │                         │  - Agent definition      │ │
│         │                         │  - Response schema       │ │
│         │                         │  - Task-specific tools   │ │
│         │                         └───────────┬──────────────┘ │
│         │                                     │                 │
│         │                                     ▼                 │
│         │                         ┌──────────────────────────┐ │
│         │                         │    SubagentStop Hook     │ │
│         │                         │  - Validate response     │ │
│         └─────────────────────────│  - Extract cross-domain  │ │
│           Structured Response     │  - Report status         │ │
│                                   └──────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## What Gets Installed

After installation, your project will contain:

### Git Hooks (in `.git/hooks/`)

| File | Purpose |
|------|---------|
| `pre-push` | Wrapper script (Git calls this) |
| `pre-push.ps1` | PowerShell implementation |
| `pre-push.bash` | Bash implementation |

### Claude Code Hooks (in `.claude/`)

| File | Purpose |
|------|---------|
| `settings.json` | Claude Code configuration with hooks |
| `rlm-env.sh` | Environment variables (bash) |
| `rlm-env.ps1` | Environment variables (PowerShell) |

## License

Part of the RLM System. See repository root for license information.
