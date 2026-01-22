#!/bin/bash
# Wrapper for read-only agents (security, product-manager)
export RLM_AGENT_LEVEL="readonly"
exec "$(dirname "$0")/validate-bash.sh"
