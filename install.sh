#!/bin/bash

#===============================================================================
# RLM Multi-Agent System Installer for Claude Code
# Supports: macOS, Linux
# Usage: ./install.sh [--user | --project]
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default installation scope
INSTALL_SCOPE="user"
PROJECT_DIR=""

#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------

print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║        RLM Multi-Agent System Installer for Claude Code       ║"
    echo "║                                                               ║"
    echo "║  12 Specialized Agents | 9 Commands | Full-Stack Analysis     ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --user                 Install user-wide (default) - available in all projects"
    echo "  --project [path]       Install in specified project directory (prompts if not provided)"
    echo "  --help                 Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --user              # Install for all Claude Code projects"
    echo "  $0 --project           # Prompts for project directory"
    echo "  $0 --project /path/to/project  # Install in specified project"
    echo ""
}

#-------------------------------------------------------------------------------
# Parse Arguments
#-------------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
    case $1 in
        --user)
            INSTALL_SCOPE="user"
            shift
            ;;
        --project)
            INSTALL_SCOPE="project"
            shift
            # Check if next argument is a path (not another flag)
            if [[ $# -gt 0 && ! "$1" =~ ^-- ]]; then
                PROJECT_DIR="$1"
                shift
            fi
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

#-------------------------------------------------------------------------------
# Determine Installation Paths
#-------------------------------------------------------------------------------

if [[ "$INSTALL_SCOPE" == "user" ]]; then
    # User-wide installation
    CLAUDE_DIR="$HOME/.claude"
else
    # Project-level installation
    if [[ -z "$PROJECT_DIR" ]]; then
        # Prompt for project directory
        echo ""
        read -p "Enter project directory path [$(pwd)]: " PROJECT_DIR
        if [[ -z "$PROJECT_DIR" ]]; then
            PROJECT_DIR="$(pwd)"
        fi
    fi

    # Expand to absolute path
    PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || {
        print_error "Invalid directory: $PROJECT_DIR"
        exit 1
    }

    CLAUDE_DIR="$PROJECT_DIR/.claude"
fi

SKILLS_DIR="$CLAUDE_DIR/skills"
COMMANDS_DIR="$CLAUDE_DIR/commands"
AGENTS_DIR="$CLAUDE_DIR/agents"
TEMPLATES_DIR="$CLAUDE_DIR/templates"

RLM_SKILL_DIR="$SKILLS_DIR/rlm-system"

#-------------------------------------------------------------------------------
# Main Installation
#-------------------------------------------------------------------------------

print_banner

echo "Installation scope: ${INSTALL_SCOPE}"
echo "Target directory: ${CLAUDE_DIR}"
echo ""

# Confirm installation
read -p "Proceed with installation? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
print_info "Creating directory structure..."

# Create directories
mkdir -p "$SKILLS_DIR"
mkdir -p "$COMMANDS_DIR"
mkdir -p "$AGENTS_DIR"
mkdir -p "$TEMPLATES_DIR"
mkdir -p "$RLM_SKILL_DIR"

print_success "Directories created"

#-------------------------------------------------------------------------------
# Install Skill (Main Entry Point)
#-------------------------------------------------------------------------------

print_info "Installing RLM skill..."

cp "$SCRIPT_DIR/SKILL.md" "$RLM_SKILL_DIR/"
print_success "Installed SKILL.md"

# Copy tools config
mkdir -p "$RLM_SKILL_DIR/tools"
cp "$SCRIPT_DIR/tools/agent-tools.yaml" "$RLM_SKILL_DIR/tools/"
print_success "Installed tools/agent-tools.yaml"

# Copy hooks
mkdir -p "$RLM_SKILL_DIR/hooks"
cp "$SCRIPT_DIR/hooks/git/pre-push" "$RLM_SKILL_DIR/hooks/"
cp "$SCRIPT_DIR/hooks/git/pre-push.ps1" "$RLM_SKILL_DIR/hooks/"
cp "$SCRIPT_DIR/hooks/install-hooks.sh" "$RLM_SKILL_DIR/hooks/"
chmod +x "$RLM_SKILL_DIR/hooks/pre-push" "$RLM_SKILL_DIR/hooks/install-hooks.sh"
print_success "Installed hooks (pre-push, pre-push.ps1, install-hooks.sh)"

#-------------------------------------------------------------------------------
# Install Agents
#-------------------------------------------------------------------------------

print_info "Installing agents..."

AGENT_FILES=(
    "orchestrator.md"
    "cloud-infra.md"
    "microservices.md"
    "frontend.md"
    "mobile.md"
    "design-ux.md"
    "aiml.md"
    "devops.md"
    "security.md"
    "observability.md"
    "product-manager.md"
    "data-eng.md"
)

mkdir -p "$AGENTS_DIR/rlm"

for agent in "${AGENT_FILES[@]}"; do
    if [[ -f "$SCRIPT_DIR/agents/$agent" ]]; then
        cp "$SCRIPT_DIR/agents/$agent" "$AGENTS_DIR/rlm/"
        print_success "Installed agent: $agent"
    else
        print_warning "Agent file not found: $agent"
    fi
done

#-------------------------------------------------------------------------------
# Install Commands
#-------------------------------------------------------------------------------

print_info "Installing commands..."

COMMAND_FILES=(
    "review.md"
    "frontend.md"
    "mobile.md"
    "design.md"
    "security.md"
    "incident.md"
    "compare.md"
    "prd.md"
    "implement.md"
)

mkdir -p "$COMMANDS_DIR/rlm"

for cmd in "${COMMAND_FILES[@]}"; do
    if [[ -f "$SCRIPT_DIR/commands/$cmd" ]]; then
        cp "$SCRIPT_DIR/commands/$cmd" "$COMMANDS_DIR/rlm/"
        print_success "Installed command: $cmd"
    else
        print_warning "Command file not found: $cmd"
    fi
done

#-------------------------------------------------------------------------------
# Install Templates
#-------------------------------------------------------------------------------

print_info "Installing templates..."

TEMPLATE_FILES=(
    "review-report.md"
    "security-report.md"
    "frontend-report.md"
    "incident-rca.md"
    "prd.md"
)

for tmpl in "${TEMPLATE_FILES[@]}"; do
    if [[ -f "$SCRIPT_DIR/templates/$tmpl" ]]; then
        cp "$SCRIPT_DIR/templates/$tmpl" "$TEMPLATES_DIR/"
        print_success "Installed template: $tmpl"
    else
        print_warning "Template file not found: $tmpl"
    fi
done

#-------------------------------------------------------------------------------
# Create/Update CLAUDE.md Configuration
#-------------------------------------------------------------------------------

print_info "Creating Claude configuration..."

CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

# Create or append to CLAUDE.md
if [[ -f "$CLAUDE_MD" ]]; then
    # Check if RLM section already exists
    if grep -q "RLM Multi-Agent System" "$CLAUDE_MD"; then
        print_warning "RLM section already exists in CLAUDE.md, skipping..."
    else
        cat >> "$CLAUDE_MD" << 'EOF'

---

## RLM Multi-Agent System

The RLM (Recursive Language Model) multi-agent system is available for comprehensive code analysis.

### Available Commands

- `/rlm review [path]` - Full-stack codebase review
- `/rlm frontend [path]` - Web frontend performance & quality audit
- `/rlm mobile [path]` - Mobile app analysis (iOS/Android/cross-platform)
- `/rlm design [path]` - Design system health check & accessibility audit
- `/rlm security [path]` - Security vulnerability scan
- `/rlm incident "<description>"` - Incident investigation & RCA
- `/rlm compare <before> <after>` - Architecture comparison/diff
- `/rlm prd "<product>"` - Generate product requirements document
- `/rlm implement <prd-path>` - Implement features from a PRD

### Usage

When using RLM commands, first read the skill definition:
- Skill: `skills/rlm-system/SKILL.md`
- Agents: `agents/rlm/*.md`
- Commands: `commands/rlm/*.md`

### Agents Available

1. **orchestrator** - Coordination and synthesis
2. **cloud-infra** - AWS/GCP/Azure, Terraform, Kubernetes
3. **microservices** - APIs, service architecture, resilience
4. **frontend** - React/Vue/Angular, Web Vitals, bundling
5. **mobile** - iOS/Android/React Native/Flutter
6. **design-ux** - Design systems, accessibility, tokens
7. **aiml** - ML/AI systems, MLOps, LLMs
8. **devops** - CI/CD, deployments, SRE
9. **security** - AppSec, compliance, secrets
10. **observability** - Monitoring, logging, tracing
11. **data-eng** - Pipelines, streaming, data quality
EOF
        print_success "Updated CLAUDE.md with RLM configuration"
    fi
else
    cat > "$CLAUDE_MD" << 'EOF'
# Claude Code Configuration

## RLM Multi-Agent System

The RLM (Recursive Language Model) multi-agent system is available for comprehensive code analysis.

### Available Commands

- `/rlm review [path]` - Full-stack codebase review
- `/rlm frontend [path]` - Web frontend performance & quality audit
- `/rlm mobile [path]` - Mobile app analysis (iOS/Android/cross-platform)
- `/rlm design [path]` - Design system health check & accessibility audit
- `/rlm security [path]` - Security vulnerability scan
- `/rlm incident "<description>"` - Incident investigation & RCA
- `/rlm compare <before> <after>` - Architecture comparison/diff
- `/rlm prd "<product>"` - Generate product requirements document
- `/rlm implement <prd-path>` - Implement features from a PRD

### Usage

When using RLM commands, first read the skill definition:
- Skill: `skills/rlm-system/SKILL.md`
- Agents: `agents/rlm/*.md`
- Commands: `commands/rlm/*.md`

### Agents Available

1. **orchestrator** - Coordination and synthesis
2. **cloud-infra** - AWS/GCP/Azure, Terraform, Kubernetes
3. **microservices** - APIs, service architecture, resilience
4. **frontend** - React/Vue/Angular, Web Vitals, bundling
5. **mobile** - iOS/Android/React Native/Flutter
6. **design-ux** - Design systems, accessibility, tokens
7. **aiml** - ML/AI systems, MLOps, LLMs
8. **devops** - CI/CD, deployments, SRE
9. **security** - AppSec, compliance, secrets
10. **observability** - Monitoring, logging, tracing
11. **data-eng** - Pipelines, streaming, data quality
EOF
    print_success "Created CLAUDE.md with RLM configuration"
fi

#-------------------------------------------------------------------------------
# Configure Permissions (allow/ask/deny)
#-------------------------------------------------------------------------------

print_info "Configuring write permissions..."
echo ""
echo "RLM agents generate output files (PRDs, reports, etc.)."
echo "To avoid permission prompts, we can pre-authorize write patterns."
echo ""

# Default patterns for RLM outputs (Write/Edit permissions)
DEFAULT_WRITE_PATTERNS=(
    "Write(PRD-*.md)"
    "Write(*-report.md)"
    "Write(*-rca.md)"
    "Write(docs/**)"
    "Edit(PRD-*.md)"
    "Edit(*-report.md)"
    "Edit(*-rca.md)"
    "Edit(docs/**)"
)

# Bash permissions from RLM agent-tools.yaml
BASH_ALLOW_PATTERNS=(
    # File system
    "Bash(find:*)"
    "Bash(ls:*)"
    "Bash(cat:*)"
    "Bash(head:*)"
    "Bash(tail:*)"
    "Bash(wc:*)"
    "Bash(du:*)"
    "Bash(tree:*)"
    "Bash(grep:*)"
    # Git operations
    "Bash(git status:*)"
    "Bash(git log:*)"
    "Bash(git diff:*)"
    "Bash(git show:*)"
    "Bash(git blame:*)"
    "Bash(git add:*)"
    "Bash(git commit:*)"
    "Bash(git pull:*)"
    "Bash(git fetch:*)"
    "Bash(git branch:*)"
    "Bash(git checkout:*)"
    "Bash(git switch:*)"
    "Bash(git stash:*)"
    "Bash(git tag:*)"
    "Bash(git restore:*)"
    "Bash(git cherry-pick:*)"
    # Node.js
    "Bash(npm:*)"
    "Bash(npx:*)"
    "Bash(node:*)"
    # GitHub CLI
    "Bash(gh repo:*)"
    "Bash(gh pr:*)"
    "Bash(gh issue:*)"
    "Bash(gh run:*)"
    "Bash(gh workflow:*)"
    "Bash(gh release:*)"
    "Bash(gh secret list:*)"
    "Bash(gh variable list:*)"
    "Bash(gh api:*)"
    # Infrastructure tools
    "Bash(terraform:*)"
    "Bash(kubectl:*)"
    "Bash(helm:*)"
    "Bash(docker inspect:*)"
    "Bash(docker ps:*)"
    "Bash(docker images:*)"
    "Bash(hadolint:*)"
    "Bash(firebase:*)"
    "Bash(gcloud:*)"
    # Python
    "Bash(pip-audit:*)"
    "Bash(safety:*)"
    "Bash(python:*)"
    "Bash(python3:*)"
    "Bash(pip:*)"
    "Bash(pip3:*)"
    # Other tools
    "Bash(infracost:*)"
    "Bash(make:*)"
    "Bash(mkdir:*)"
    "Bash(cp:*)"
    "Bash(mv:*)"
    "Bash(chmod:*)"
    "Bash(curl:*)"
    "Bash(source:*)"
)

BASH_ASK_PATTERNS=(
    "Bash(git push:*)"
    "Bash(git merge:*)"
    "Bash(git rebase:*)"
)

BASH_DENY_PATTERNS=(
    "Bash(git push origin main:*)"
    "Bash(git push origin master:*)"
    "Bash(git push upstream main:*)"
    "Bash(git push upstream master:*)"
    "Bash(git push --force:*)"
    "Bash(git push -f:*)"
    "Bash(git push --force-with-lease:*)"
    "Bash(git reset --hard:*)"
    "Bash(git branch -d main:*)"
    "Bash(git branch -d master:*)"
    "Bash(git branch -D main:*)"
    "Bash(git branch -D master:*)"
    "Bash(git push origin --delete main:*)"
    "Bash(git push origin --delete master:*)"
    "Bash(rm -rf /:*)"
    "Bash(sudo:*)"
    "Bash(chmod 777:*)"
    "Bash(dd if=:*)"
    "Bash(mkfs:*)"
    "Bash(kill -9:*)"
    "Bash(pkill -9:*)"
    "Bash(killall:*)"
)

echo "Default write patterns:"
for pattern in "${DEFAULT_WRITE_PATTERNS[@]}"; do
    echo "  - $pattern"
done
echo ""
echo "Bash allow patterns: ${#BASH_ALLOW_PATTERNS[@]} commands"
echo "Bash ask patterns: ${#BASH_ASK_PATTERNS[@]} commands (require approval)"
echo "Bash deny patterns: ${#BASH_DENY_PATTERNS[@]} commands (blocked)"
echo ""

# Ask for additional write patterns
ADDITIONAL_WRITE_PATTERNS=()
read -p "Add custom write patterns? (comma-separated, or press Enter to skip): " CUSTOM_INPUT
if [[ -n "$CUSTOM_INPUT" ]]; then
    IFS=',' read -ra CUSTOM_ARRAY <<< "$CUSTOM_INPUT"
    for pattern in "${CUSTOM_ARRAY[@]}"; do
        # Trim whitespace
        pattern=$(echo "$pattern" | xargs)
        if [[ -n "$pattern" ]]; then
            # Add Write() wrapper if not present
            if [[ ! "$pattern" =~ ^(Write|Edit)\( ]]; then
                ADDITIONAL_WRITE_PATTERNS+=("Write($pattern)")
                ADDITIONAL_WRITE_PATTERNS+=("Edit($pattern)")
            else
                ADDITIONAL_WRITE_PATTERNS+=("$pattern")
            fi
        fi
    done
fi

# Combine all allow patterns (write + bash)
ALL_ALLOW_PATTERNS=("${DEFAULT_WRITE_PATTERNS[@]}" "${ADDITIONAL_WRITE_PATTERNS[@]}" "${BASH_ALLOW_PATTERNS[@]}")

#-------------------------------------------------------------------------------
# Create settings.json for Claude Code
#-------------------------------------------------------------------------------

SETTINGS_FILE="$CLAUDE_DIR/settings.json"
WRITE_SETTINGS=true

if [[ -f "$SETTINGS_FILE" ]]; then
    echo ""
    print_warning "settings.json already exists at $SETTINGS_FILE"
    read -p "Overwrite with new settings? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        WRITE_SETTINGS=false
        print_info "Keeping existing settings.json"
        echo ""
        echo "To manually add RLM permissions, merge these into your settings.json:"
        echo "  See: $SCRIPT_DIR/.claude/settings.json"
        echo ""
    fi
fi

if [[ "$WRITE_SETTINGS" == true ]]; then
    # Build JSON arrays for permissions
    build_json_array() {
        local -n arr=$1
        local result=""
        for i in "${!arr[@]}"; do
            if [[ $i -eq 0 ]]; then
                result="\"${arr[$i]}\""
            else
                result="$result,
      \"${arr[$i]}\""
            fi
        done
        echo "$result"
    }

    ALLOW_JSON=$(build_json_array ALL_ALLOW_PATTERNS)
    ASK_JSON=$(build_json_array BASH_ASK_PATTERNS)
    DENY_JSON=$(build_json_array BASH_DENY_PATTERNS)

    cat > "$SETTINGS_FILE" << EOF
{
  "permissions": {
    "allow": [
      $ALLOW_JSON
    ],
    "ask": [
      $ASK_JSON
    ],
    "deny": [
      $DENY_JSON
    ]
  }
}
EOF
    print_success "Created settings.json with RLM permissions"
    echo ""
    echo "Permissions configured:"
    echo "  - Allow: ${#ALL_ALLOW_PATTERNS[@]} patterns (auto-approved)"
    echo "  - Ask: ${#BASH_ASK_PATTERNS[@]} patterns (require approval)"
    echo "  - Deny: ${#BASH_DENY_PATTERNS[@]} patterns (blocked)"
fi

#-------------------------------------------------------------------------------
# Summary
#-------------------------------------------------------------------------------

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo "Installed to: $CLAUDE_DIR"
echo ""
echo "Directory structure:"
echo "  $CLAUDE_DIR/"
echo "  ├── CLAUDE.md"
echo "  ├── settings.json (with permissions: allow/ask/deny)"
echo "  ├── skills/rlm-system/"
echo "  │   ├── SKILL.md"
echo "  │   ├── tools/"
echo "  │   └── hooks/"
echo "  ├── agents/rlm/ (12 agents)"
echo "  ├── commands/rlm/ (9 commands)"
echo "  └── templates/ (5 templates)"
echo ""
echo -e "${YELLOW}Quick Start:${NC}"
echo "  1. Open Claude Code in any project"
echo "  2. Try: /rlm review ./src"
echo "  3. Or ask: 'Review my codebase using the RLM system'"
echo ""
echo -e "${BLUE}Available Commands:${NC}"
echo "  /rlm review [path]     - Full-stack analysis"
echo "  /rlm frontend [path]   - Web audit"
echo "  /rlm mobile [path]     - Mobile analysis"
echo "  /rlm design [path]     - Design system check"
echo "  /rlm security [path]   - Security scan"
echo "  /rlm incident \"...\"    - Incident RCA"
echo "  /rlm compare a b       - Architecture diff"
echo "  /rlm prd \"...\"         - Generate PRD"
echo "  /rlm implement <prd>   - Implement from PRD"
echo ""
echo -e "${BLUE}Git Hooks (Optional):${NC}"
echo "  To install branch protection hooks in a project:"
echo "  $SCRIPT_DIR/hooks/install-hooks.sh /path/to/your/project"
echo ""
echo "  This installs a pre-push hook that:"
echo "  - Blocks pushes to main/master by unauthorized agents"
echo "  - Allows only devops and orchestrator agents to push to protected branches"
echo ""
