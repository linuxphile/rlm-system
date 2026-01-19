#!/bin/bash
#===============================================================================
# RLM System Git Hooks Installer
#
# Installs RLM git hooks into the target repository's .git/hooks directory.
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

if [[ -f "$HOOKS_DIR/pre-push" ]]; then
    # Backup existing hook
    backup_name="pre-push.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOOKS_DIR/pre-push" "$HOOKS_DIR/$backup_name"
    echo -e "  ${YELLOW}⚠${NC} Existing pre-push hook backed up to: $backup_name"
fi

cp "$SCRIPT_DIR/pre-push" "$HOOKS_DIR/pre-push"
chmod +x "$HOOKS_DIR/pre-push"
echo -e "  ${GREEN}✓${NC} pre-push hook installed"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Installation Complete!                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "The following protections are now active:"
echo ""
echo "  ${YELLOW}pre-push${NC}: Blocks pushes to main/master unless RLM_AGENT is set"
echo "            to 'devops', 'orchestrator', or 'human'"
echo ""
echo -e "${BLUE}Usage for agents:${NC}"
echo "  Authorized agents should set RLM_AGENT before git operations:"
echo ""
echo "    export RLM_AGENT=devops"
echo "    git push origin main"
echo ""
echo -e "${BLUE}Usage for human developers:${NC}"
echo "  For manual overrides (use sparingly):"
echo ""
echo "    RLM_AGENT=human git push origin main"
echo ""
echo -e "${BLUE}Recommended workflow:${NC}"
echo "  1. Work on feature branches"
echo "  2. Create pull requests"
echo "  3. Let devops/orchestrator merge to main"
echo ""
