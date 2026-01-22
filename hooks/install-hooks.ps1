#===============================================================================
# RLM System Git Hooks Installer (PowerShell)
#
# Installs RLM git hooks into the target repository's .git/hooks directory.
#
# Usage:
#   .\install-hooks.ps1 [target-repo-path]
#
# If no path is provided, installs to the current directory's .git/hooks.
#===============================================================================

param(
    [Parameter(Position = 0)]
    [string]$TargetRepo = "."
)

$ErrorActionPreference = "Stop"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Resolve target repository path
$TargetRepo = Resolve-Path $TargetRepo

# Verify target is a git repository
if (-not (Test-Path (Join-Path $TargetRepo ".git"))) {
    Write-Host "Error: " -NoNewline -ForegroundColor Red
    Write-Host "$TargetRepo is not a git repository"
    Write-Host "Please run this script from within a git repository or provide a path to one."
    exit 1
}

$HooksDir = Join-Path $TargetRepo ".git\hooks"

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║              RLM Git Hooks Installer                          ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "Target repository: $TargetRepo"
Write-Host "Hooks directory:   $HooksDir"
Write-Host ""

# Create hooks directory if it doesn't exist
if (-not (Test-Path $HooksDir)) {
    New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
}

# Install pre-push hook
Write-Host "Installing pre-push hook..." -ForegroundColor Yellow

$PrePushPath = Join-Path $HooksDir "pre-push"
$PrePushPs1Path = Join-Path $HooksDir "pre-push.ps1"

# Backup existing hooks if they exist
if (Test-Path $PrePushPath) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupName = "pre-push.backup.$timestamp"
    Copy-Item $PrePushPath (Join-Path $HooksDir $backupName)
    Write-Host "  ⚠ " -NoNewline -ForegroundColor Yellow
    Write-Host "Existing pre-push hook backed up to: $backupName"
}

if (Test-Path $PrePushPs1Path) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupName = "pre-push.ps1.backup.$timestamp"
    Copy-Item $PrePushPs1Path (Join-Path $HooksDir $backupName)
    Write-Host "  ⚠ " -NoNewline -ForegroundColor Yellow
    Write-Host "Existing pre-push.ps1 backed up to: $backupName"
}

# Copy PowerShell hook script
Copy-Item (Join-Path $ScriptDir "git\pre-push.ps1") $PrePushPs1Path -Force
Write-Host "  ✓ " -NoNewline -ForegroundColor Green
Write-Host "pre-push.ps1 installed"

# Create wrapper script that Git will execute
# This wrapper calls the PowerShell script
$wrapperContent = @'
#!/bin/sh
# RLM System Pre-Push Hook Wrapper
# This script calls the PowerShell hook for cross-platform compatibility

# Determine which PowerShell to use
if command -v pwsh > /dev/null 2>&1; then
    POWERSHELL="pwsh"
elif command -v powershell > /dev/null 2>&1; then
    POWERSHELL="powershell"
else
    # Fall back to bash version if PowerShell not available
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    if [ -f "$SCRIPT_DIR/pre-push.bash" ]; then
        exec "$SCRIPT_DIR/pre-push.bash" "$@"
    else
        echo "Warning: Neither PowerShell nor bash hook available"
        exit 0
    fi
fi

# Get the directory where this script is located
HOOK_DIR="$(cd "$(dirname "$0")" && pwd)"

# Execute PowerShell hook, passing stdin through
exec $POWERSHELL -NoProfile -ExecutionPolicy Bypass -File "$HOOK_DIR/pre-push.ps1"
'@

Set-Content -Path $PrePushPath -Value $wrapperContent -NoNewline
Write-Host "  ✓ " -NoNewline -ForegroundColor Green
Write-Host "pre-push wrapper installed"

# Also copy the bash version for systems without PowerShell
$bashSource = Join-Path $ScriptDir "git\pre-push"
if (Test-Path $bashSource) {
    Copy-Item $bashSource (Join-Path $HooksDir "pre-push.bash") -Force
    Write-Host "  ✓ " -NoNewline -ForegroundColor Green
    Write-Host "pre-push.bash fallback installed"
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              Installation Complete!                           ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "The following protections are now active:"
Write-Host ""
Write-Host "  pre-push" -NoNewline -ForegroundColor Yellow
Write-Host ": Blocks pushes to main/master unless RLM_AGENT is set"
Write-Host "            to 'devops', 'orchestrator', or 'human'"
Write-Host ""
Write-Host "Usage for agents:" -ForegroundColor Blue
Write-Host "  Authorized agents should set RLM_AGENT before git operations:"
Write-Host ""
Write-Host '    $env:RLM_AGENT="devops"'
Write-Host "    git push origin main"
Write-Host ""
Write-Host "Usage for human developers:" -ForegroundColor Blue
Write-Host "  For manual overrides (use sparingly):"
Write-Host ""
Write-Host '    $env:RLM_AGENT="human"; git push origin main'
Write-Host ""
Write-Host "Recommended workflow:" -ForegroundColor Blue
Write-Host "  1. Work on feature branches"
Write-Host "  2. Create pull requests"
Write-Host "  3. Let devops/orchestrator merge to main"
Write-Host ""
