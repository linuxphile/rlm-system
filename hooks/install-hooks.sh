#!/bin/bash
#===============================================================================
# RLM System Git Hooks Installer
#
# Installs RLM git hooks into the target repository's .git/hooks directory.
# Supports both bash and PowerShell hooks for cross-platform compatibility.
#
# Usage:
#   ./install-hooks.sh [target-repo-path]
#
# If no path is provided, installs to the current directory's .git/hooks.
#===============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target repository
TARGET_REPO="${1:-.}"
TARGET_REPO="$(cd "$TARGET_REPO" && pwd)"

# Verify target is a git repository
if [[ ! -d "$TARGET_REPO/.git" ]]; then
    echo -e "${RED}Error:${NC} $TARGET_REPO is not a git repository"
    echo "Please run this script from within a git repository or provide a path to one."
    exit 1
fi

HOOKS_DIR="$TARGET_REPO/.git/hooks"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              RLM Git Hooks Installer                          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Target repository: $TARGET_REPO"
echo "Hooks directory:   $HOOKS_DIR"
echo ""

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Install pre-push hook
echo -e "${YELLOW}Installing pre-push hook...${NC}"

# Backup existing hooks
for hook_file in pre-push pre-push.ps1 pre-push.bash; do
    if [[ -f "$HOOKS_DIR/$hook_file" ]]; then
        backup_name="${hook_file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$HOOKS_DIR/$hook_file" "$HOOKS_DIR/$backup_name"
        echo -e "  ${YELLOW}⚠${NC} Existing $hook_file backed up to: $backup_name"
    fi
done

# Copy bash hook as fallback
cp "$SCRIPT_DIR/git/pre-push" "$HOOKS_DIR/pre-push.bash"
chmod +x "$HOOKS_DIR/pre-push.bash"
echo -e "  ${GREEN}✓${NC} pre-push.bash installed"

# Copy PowerShell hook if it exists
if [[ -f "$SCRIPT_DIR/git/pre-push.ps1" ]]; then
    cp "$SCRIPT_DIR/git/pre-push.ps1" "$HOOKS_DIR/pre-push.ps1"
    echo -e "  ${GREEN}✓${NC} pre-push.ps1 installed"
fi

# Create unified wrapper script that Git will execute
cat > "$HOOKS_DIR/pre-push" << 'EOF'
#!/bin/sh
#===============================================================================
# RLM System Pre-Push Hook Wrapper
# Automatically selects bash or PowerShell implementation based on environment
#===============================================================================

# Get the directory where this script is located
HOOK_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if we're on Windows (Git Bash, MSYS, Cygwin) and PowerShell is preferred
if [ -f "$HOOK_DIR/pre-push.ps1" ]; then
    # Try to use PowerShell if available
    if command -v pwsh > /dev/null 2>&1; then
        exec pwsh -NoProfile -ExecutionPolicy Bypass -File "$HOOK_DIR/pre-push.ps1"
    elif command -v powershell.exe > /dev/null 2>&1; then
        exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$HOOK_DIR/pre-push.ps1"
    fi
fi

# Fall back to bash implementation
if [ -f "$HOOK_DIR/pre-push.bash" ]; then
    exec "$HOOK_DIR/pre-push.bash" "$@"
fi

# If neither exists, something went wrong
echo "Error: No pre-push hook implementation found in $HOOK_DIR"
exit 1
EOF

chmod +x "$HOOKS_DIR/pre-push"
echo -e "  ${GREEN}✓${NC} pre-push wrapper installed"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Installed hooks:"
echo "  - pre-push (wrapper)"
echo "  - pre-push.bash (bash implementation)"
if [[ -f "$HOOKS_DIR/pre-push.ps1" ]]; then
    echo "  - pre-push.ps1 (PowerShell implementation)"
fi
echo ""
echo "The following protections are now active:"
echo ""
echo -e "  ${YELLOW}pre-push${NC}: Blocks pushes to main/master unless RLM_AGENT is set"
echo "            to 'devops', 'orchestrator', or 'human'"
echo ""
echo -e "${BLUE}Usage for agents:${NC}"
echo "  Authorized agents should set RLM_AGENT before git operations:"
echo ""
echo "  Bash/Zsh:"
echo "    export RLM_AGENT=devops"
echo "    git push origin main"
echo ""
echo "  PowerShell:"
echo '    $env:RLM_AGENT="devops"'
echo "    git push origin main"
echo ""
echo -e "${BLUE}Usage for human developers:${NC}"
echo "  For manual overrides (use sparingly):"
echo ""
echo "  Bash/Zsh:"
echo "    RLM_AGENT=human git push origin main"
echo ""
echo "  PowerShell:"
echo '    $env:RLM_AGENT="human"; git push origin main'
echo ""
echo -e "${BLUE}Recommended workflow:${NC}"
echo "  1. Work on feature branches"
echo "  2. Create pull requests"
echo "  3. Let devops/orchestrator merge to main"
echo ""
