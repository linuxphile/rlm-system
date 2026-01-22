#!/bin/bash
# Wrapper for standard agents (no merge/rebase)
export RLM_AGENT_LEVEL="standard"
exec "$(dirname "$0")/validate-bash.sh"
