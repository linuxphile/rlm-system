#!/bin/bash
# Wrapper for privileged agents (orchestrator, devops)
export RLM_AGENT_LEVEL="privileged"
exec "$(dirname "$0")/validate-bash.sh"
