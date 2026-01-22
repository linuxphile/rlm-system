#!/bin/bash
#===============================================================================
# RLM System - Bash Command Validator
#
# Validates bash commands based on agent permission level.
# Used as a PreToolUse hook to enforce per-agent restrictions.
#
# Environment variables:
#   RLM_AGENT_LEVEL - Permission level: "readonly", "standard", "privileged"
#
# Exit codes:
#   0 - Allow command
#   2 - Block command (with message to stderr)
#===============================================================================

set -e

# Read the tool input from stdin (JSON format)
INPUT=$(cat)

# Extract the command from the JSON input
# Claude Code passes: {"tool_input": {"command": "..."}}
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"command"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//' || echo "")

if [[ -z "$COMMAND" ]]; then
    # Can't parse command, allow it (fail open for usability)
    exit 0
fi

# Get agent level from environment, default to standard
LEVEL="${RLM_AGENT_LEVEL:-standard}"

#-------------------------------------------------------------------------------
# Blocked patterns for all agents
#-------------------------------------------------------------------------------
ALWAYS_BLOCKED=(
    "rm -rf /"
    "sudo "
    "chmod 777"
    "mkfs"
    "> /dev/"
)

for pattern in "${ALWAYS_BLOCKED[@]}"; do
    if [[ "$COMMAND" == *"$pattern"* ]]; then
        echo "BLOCKED: Command contains dangerous pattern: $pattern" >&2
        exit 2
    fi
done

#-------------------------------------------------------------------------------
# Read-only agents (security, product-manager)
# No git write operations, no file modifications
#-------------------------------------------------------------------------------
if [[ "$LEVEL" == "readonly" ]]; then
    READONLY_BLOCKED=(
        "git add"
        "git commit"
        "git push"
        "git pull"
        "git merge"
        "git rebase"
        "git cherry-pick"
        "git reset"
        "git checkout -b"
        "git switch -c"
    )

    for pattern in "${READONLY_BLOCKED[@]}"; do
        if [[ "$COMMAND" == *"$pattern"* ]]; then
            echo "BLOCKED: Read-only agent cannot execute: $pattern" >&2
            exit 2
        fi
    done
fi

#-------------------------------------------------------------------------------
# Standard agents (most domain agents)
# No merge/rebase to protected branches
#-------------------------------------------------------------------------------
if [[ "$LEVEL" == "standard" ]]; then
    STANDARD_BLOCKED=(
        "git merge"
        "git rebase"
        "git push origin main"
        "git push origin master"
        "git push upstream main"
        "git push upstream master"
    )

    for pattern in "${STANDARD_BLOCKED[@]}"; do
        if [[ "$COMMAND" == *"$pattern"* ]]; then
            echo "BLOCKED: Standard agent cannot execute: $pattern (use devops or orchestrator)" >&2
            exit 2
        fi
    done
fi

#-------------------------------------------------------------------------------
# Privileged agents (orchestrator, devops)
# Still blocked from force push and branch deletion
#-------------------------------------------------------------------------------
if [[ "$LEVEL" == "privileged" ]]; then
    PRIVILEGED_BLOCKED=(
        "git push --force"
        "git push -f "
        "git branch -D main"
        "git branch -D master"
        "git branch -d main"
        "git branch -d master"
        "git push origin --delete main"
        "git push origin --delete master"
    )

    for pattern in "${PRIVILEGED_BLOCKED[@]}"; do
        if [[ "$COMMAND" == *"$pattern"* ]]; then
            echo "BLOCKED: Even privileged agents cannot execute: $pattern" >&2
            exit 2
        fi
    done
fi

# Command is allowed
exit 0
