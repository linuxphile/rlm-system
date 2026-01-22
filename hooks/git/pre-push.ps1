#===============================================================================
# RLM System Pre-Push Hook (PowerShell)
#
# Prevents pushes to main/master branches unless executed by authorized agents
# (devops or orchestrator).
#
# Installation:
#   Copy to .git/hooks/ and use the pre-push wrapper script
#   Or use install-hooks.ps1
#
# How it works:
#   - Checks if pushing to main or master branch
#   - If so, requires RLM_AGENT environment variable to be set to
#     'devops' or 'orchestrator'
#   - Blocks push with helpful error message if unauthorized
#
# For manual overrides (human developers), set:
#   $env:RLM_AGENT="human"; git push origin main
#===============================================================================

$ErrorActionPreference = "Stop"

# Protected branches
$ProtectedBranches = @("main", "master")

# Authorized agents that can push to protected branches
$AuthorizedAgents = @("devops", "orchestrator", "human")

# Read stdin for push information
# Format: <local ref> <local sha> <remote ref> <remote sha>
$input | ForEach-Object {
    $parts = $_ -split '\s+'
    if ($parts.Count -ge 3) {
        $remoteRef = $parts[2]

        # Extract branch name from remote ref
        # e.g., refs/heads/main -> main
        if ($remoteRef -match "refs/heads/(.+)$") {
            $branch = $Matches[1]

            # Check if pushing to a protected branch
            if ($branch -in $ProtectedBranches) {
                # Get current agent from environment variable
                $currentAgent = $env:RLM_AGENT
                if (-not $currentAgent) {
                    $currentAgent = "unknown"
                }

                # Check if agent is authorized
                $isAuthorized = $currentAgent -in $AuthorizedAgents

                if (-not $isAuthorized) {
                    Write-Host ""
                    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Red
                    Write-Host "║                    PUSH BLOCKED                               ║" -ForegroundColor Red
                    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Red
                    Write-Host ""
                    Write-Host "Branch: " -NoNewline -ForegroundColor Yellow
                    Write-Host "$branch (protected)"
                    Write-Host "Agent:  " -NoNewline -ForegroundColor Yellow
                    Write-Host "$currentAgent"
                    Write-Host ""
                    Write-Host "Pushing to " -NoNewline
                    Write-Host "$branch" -NoNewline -ForegroundColor Red
                    Write-Host " is restricted to authorized agents only."
                    Write-Host ""
                    Write-Host "Authorized agents: " -NoNewline
                    Write-Host "devops" -NoNewline -ForegroundColor Green
                    Write-Host ", " -NoNewline
                    Write-Host "orchestrator" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "If you are an authorized agent, set the RLM_AGENT environment variable:"
                    Write-Host '  $env:RLM_AGENT="devops"' -ForegroundColor Green
                    Write-Host '  $env:RLM_AGENT="orchestrator"' -ForegroundColor Green
                    Write-Host ""
                    Write-Host "For human developers performing manual operations:"
                    Write-Host "  `$env:RLM_AGENT=`"human`"; git push origin $branch" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "Recommended workflow:" -ForegroundColor Yellow
                    Write-Host "  1. Create a feature branch: git checkout -b feature/my-change"
                    Write-Host "  2. Make your changes and commit"
                    Write-Host "  3. Push feature branch: git push -u origin feature/my-change"
                    Write-Host "  4. Create a pull request for review"
                    Write-Host "  5. Let devops/orchestrator agent merge after approval"
                    Write-Host ""
                    exit 1
                }
                else {
                    Write-Host "✓ " -NoNewline -ForegroundColor Green
                    Write-Host "Push to $branch authorized (agent: $currentAgent)"
                }
            }
        }
    }
}

exit 0
