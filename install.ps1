#Requires -Version 5.1
<#
.SYNOPSIS
    RLM Multi-Agent System Installer for Claude Code (Windows)

.DESCRIPTION
    Installs the RLM multi-agent system with 10 specialized agents,
    7 commands, and templates for comprehensive code analysis.

.PARAMETER Scope
    Installation scope: 'User' (default) or 'Project'
    - User: Installs to ~/.claude/ (available in all projects)
    - Project: Installs to specified project directory (prompts if not provided)

.PARAMETER ProjectPath
    Path to the project directory when using -Scope Project.
    If not specified, you will be prompted to enter the path.

.EXAMPLE
    .\install.ps1
    Installs user-wide (default)

.EXAMPLE
    .\install.ps1 -Scope Project
    Prompts for project directory, then installs there

.EXAMPLE
    .\install.ps1 -Scope Project -ProjectPath C:\Projects\MyApp
    Installs to specified project directory

.EXAMPLE
    .\install.ps1 -Scope User -Verbose
    Installs user-wide with verbose output
#>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('User', 'Project')]
    [string]$Scope = 'User',

    [Parameter()]
    [string]$ProjectPath = ''
)

#===============================================================================
# Configuration
#===============================================================================

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

#===============================================================================
# Helper Functions
#===============================================================================

function Write-Banner {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        RLM Multi-Agent System Installer for Claude Code       ║" -ForegroundColor Cyan
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  12 Specialized Agents | 9 Commands | Full-Stack Analysis     ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ " -ForegroundColor Blue -NoNewline
    Write-Host $Message
}

function Confirm-Continue {
    param([string]$Message = "Proceed with installation?")
    
    $response = Read-Host "$Message [Y/n]"
    if ($response -match '^[Nn]') {
        Write-Host "Installation cancelled."
        exit 0
    }
}

#===============================================================================
# Determine Installation Paths
#===============================================================================

if ($Scope -eq 'User') {
    $ClaudeDir = Join-Path $env:USERPROFILE '.claude'
} else {
    # Project-level installation
    if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
        # Prompt for project directory
        $DefaultPath = (Get-Location).Path
        $ProjectPath = Read-Host "Enter project directory path [$DefaultPath]"
        if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
            $ProjectPath = $DefaultPath
        }
    }

    # Resolve to absolute path and validate
    try {
        $ProjectPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path
    } catch {
        Write-Error "Invalid directory: $ProjectPath"
        exit 1
    }

    if (-not (Test-Path $ProjectPath -PathType Container)) {
        Write-Error "Path is not a directory: $ProjectPath"
        exit 1
    }

    $ClaudeDir = Join-Path $ProjectPath '.claude'
}

$SkillsDir = Join-Path $ClaudeDir 'skills'
$CommandsDir = Join-Path $ClaudeDir 'commands'
$AgentsDir = Join-Path $ClaudeDir 'agents'
$TemplatesDir = Join-Path $ClaudeDir 'templates'
$RlmSkillDir = Join-Path $SkillsDir 'rlm-system'

#===============================================================================
# Main Installation
#===============================================================================

Write-Banner

Write-Host "Installation scope: $Scope"
Write-Host "Target directory: $ClaudeDir"
Write-Host ""

Confirm-Continue

Write-Host ""
Write-Info "Creating directory structure..."

# Create directories
$Directories = @(
    $SkillsDir,
    $CommandsDir,
    $AgentsDir,
    $TemplatesDir,
    $RlmSkillDir,
    (Join-Path $RlmSkillDir 'tools'),
    (Join-Path $AgentsDir 'rlm'),
    (Join-Path $CommandsDir 'rlm')
)

foreach ($Dir in $Directories) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

Write-Success "Directories created"

#-------------------------------------------------------------------------------
# Install Skill (Main Entry Point)
#-------------------------------------------------------------------------------

Write-Info "Installing RLM skill..."

$SkillSource = Join-Path $ScriptDir 'SKILL.md'
if (Test-Path $SkillSource) {
    Copy-Item $SkillSource -Destination $RlmSkillDir -Force
    Write-Success "Installed SKILL.md"
} else {
    Write-Error "SKILL.md not found in $ScriptDir"
    exit 1
}

# Copy tools config
$ToolsSource = Join-Path $ScriptDir 'tools\agent-tools.yaml'
if (Test-Path $ToolsSource) {
    Copy-Item $ToolsSource -Destination (Join-Path $RlmSkillDir 'tools') -Force
    Write-Success "Installed tools/agent-tools.yaml"
}

# Copy hooks
$HooksDir = Join-Path $RlmSkillDir 'hooks'
if (-not (Test-Path $HooksDir)) {
    New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
}
$PrePushSource = Join-Path $ScriptDir 'hooks\pre-push'
$InstallHooksSource = Join-Path $ScriptDir 'hooks\install-hooks.sh'
if (Test-Path $PrePushSource) {
    Copy-Item $PrePushSource -Destination $HooksDir -Force
    Write-Success "Installed hooks/pre-push"
}
if (Test-Path $InstallHooksSource) {
    Copy-Item $InstallHooksSource -Destination $HooksDir -Force
    Write-Success "Installed hooks/install-hooks.sh"
}

#-------------------------------------------------------------------------------
# Install Agents
#-------------------------------------------------------------------------------

Write-Info "Installing agents..."

$AgentFiles = @(
    'orchestrator.md',
    'cloud-infra.md',
    'microservices.md',
    'frontend.md',
    'mobile.md',
    'design-ux.md',
    'aiml.md',
    'devops.md',
    'security.md',
    'observability.md',
    'data-eng.md',
    'product-manager.md'
)

foreach ($Agent in $AgentFiles) {
    $SourcePath = Join-Path $ScriptDir "agents\$Agent"
    if (Test-Path $SourcePath) {
        Copy-Item $SourcePath -Destination (Join-Path $AgentsDir 'rlm') -Force
        Write-Success "Installed agent: $Agent"
    } else {
        Write-Warning "Agent file not found: $Agent"
    }
}

#-------------------------------------------------------------------------------
# Install Commands
#-------------------------------------------------------------------------------

Write-Info "Installing commands..."

$CommandFiles = @(
    'review.md',
    'frontend.md',
    'mobile.md',
    'design.md',
    'security.md',
    'incident.md',
    'compare.md',
    'prd.md',
    'implement.md'
)

foreach ($Cmd in $CommandFiles) {
    $SourcePath = Join-Path $ScriptDir "commands\$Cmd"
    if (Test-Path $SourcePath) {
        Copy-Item $SourcePath -Destination (Join-Path $CommandsDir 'rlm') -Force
        Write-Success "Installed command: $Cmd"
    } else {
        Write-Warning "Command file not found: $Cmd"
    }
}

#-------------------------------------------------------------------------------
# Install Templates
#-------------------------------------------------------------------------------

Write-Info "Installing templates..."

$TemplateFiles = @(
    'review-report.md',
    'security-report.md',
    'frontend-report.md',
    'incident-rca.md',
    'prd.md'
)

foreach ($Tmpl in $TemplateFiles) {
    $SourcePath = Join-Path $ScriptDir "templates\$Tmpl"
    if (Test-Path $SourcePath) {
        Copy-Item $SourcePath -Destination $TemplatesDir -Force
        Write-Success "Installed template: $Tmpl"
    } else {
        Write-Warning "Template file not found: $Tmpl"
    }
}

#-------------------------------------------------------------------------------
# Create/Update CLAUDE.md Configuration
#-------------------------------------------------------------------------------

Write-Info "Creating Claude configuration..."

$ClaudeMdPath = Join-Path $ClaudeDir 'CLAUDE.md'

$RlmSection = @'

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
'@

if (Test-Path $ClaudeMdPath) {
    $ExistingContent = Get-Content $ClaudeMdPath -Raw
    if ($ExistingContent -match 'RLM Multi-Agent System') {
        Write-Warning "RLM section already exists in CLAUDE.md, skipping..."
    } else {
        Add-Content -Path $ClaudeMdPath -Value $RlmSection
        Write-Success "Updated CLAUDE.md with RLM configuration"
    }
} else {
    $FullContent = @"
# Claude Code Configuration
$RlmSection
"@
    Set-Content -Path $ClaudeMdPath -Value $FullContent
    Write-Success "Created CLAUDE.md with RLM configuration"
}

#-------------------------------------------------------------------------------
# Configure Write Permissions (allowedTools)
#-------------------------------------------------------------------------------

Write-Info "Configuring write permissions..."
Write-Host ""
Write-Host "RLM agents generate output files (PRDs, reports, etc.)."
Write-Host "To avoid permission prompts, we can pre-authorize write patterns."
Write-Host ""

# Default patterns for RLM outputs
$DefaultPatterns = @(
    "Write(PRD-*.md)",
    "Write(*-report.md)",
    "Write(*-rca.md)",
    "Write(docs/**)",
    "Edit(PRD-*.md)",
    "Edit(*-report.md)",
    "Edit(*-rca.md)",
    "Edit(docs/**)"
)

Write-Host "Default patterns:"
foreach ($Pattern in $DefaultPatterns) {
    Write-Host "  - $Pattern"
}
Write-Host ""

# Ask for additional patterns
$AdditionalPatterns = @()
$CustomInput = Read-Host "Add custom write patterns? (comma-separated, or press Enter to skip)"
if (-not [string]::IsNullOrWhiteSpace($CustomInput)) {
    $CustomArray = $CustomInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
    foreach ($Pattern in $CustomArray) {
        # Add Write() wrapper if not present
        if ($Pattern -notmatch '^(Write|Edit)\(') {
            $AdditionalPatterns += "Write($Pattern)"
            $AdditionalPatterns += "Edit($Pattern)"
        } else {
            $AdditionalPatterns += $Pattern
        }
    }
}

# Combine all patterns
$AllPatterns = $DefaultPatterns + $AdditionalPatterns

#-------------------------------------------------------------------------------
# Create settings.json for Claude Code
#-------------------------------------------------------------------------------

$SettingsPath = Join-Path $ClaudeDir 'settings.json'
$WriteSettings = $true

if (Test-Path $SettingsPath) {
    Write-Host ""
    Write-Warning "settings.json already exists at $SettingsPath"
    $Response = Read-Host "Overwrite with new settings? [y/N]"
    if ($Response -notmatch '^[Yy]') {
        $WriteSettings = $false
        Write-Info "Keeping existing settings.json"
        Write-Host ""
        Write-Host "To manually add write permissions, add this to your settings.json:"
        Write-Host ""
        Write-Host '  "allowedTools": ['
        for ($i = 0; $i -lt $AllPatterns.Count; $i++) {
            if ($i -eq ($AllPatterns.Count - 1)) {
                Write-Host "    `"$($AllPatterns[$i])`""
            } else {
                Write-Host "    `"$($AllPatterns[$i])`","
            }
        }
        Write-Host '  ]'
        Write-Host ""
    }
}

if ($WriteSettings) {
    $Settings = @{
        allowedTools = $AllPatterns
        skills = @{
            'rlm-system' = @{
                enabled = $true
                path = 'skills/rlm-system/SKILL.md'
            }
        }
        commands = @{
            rlm = @{
                enabled = $true
                path = 'commands/rlm/'
            }
        }
        agents = @{
            rlm = @{
                enabled = $true
                path = 'agents/rlm/'
            }
        }
    }

    $Settings | ConvertTo-Json -Depth 4 | Set-Content -Path $SettingsPath
    Write-Success "Created settings.json with write permissions"
    Write-Host ""
    Write-Host "Authorized patterns:"
    foreach ($Pattern in $AllPatterns) {
        Write-Host "  - $Pattern"
    }
}

#-------------------------------------------------------------------------------
# Summary
#-------------------------------------------------------------------------------

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              Installation Complete!                           ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "Installed to: $ClaudeDir"
Write-Host ""
Write-Host "Directory structure:"
Write-Host "  $ClaudeDir\"
Write-Host "  ├── CLAUDE.md"
Write-Host "  ├── settings.json (with allowedTools for auto-permissions)"
Write-Host "  ├── skills\rlm-system\"
Write-Host "  │   ├── SKILL.md"
Write-Host "  │   ├── tools\"
Write-Host "  │   └── hooks\"
Write-Host "  ├── agents\rlm\ (12 agents)"
Write-Host "  ├── commands\rlm\ (9 commands)"
Write-Host "  └── templates\ (5 templates)"
Write-Host ""
Write-Host "Quick Start:" -ForegroundColor Yellow
Write-Host "  1. Open Claude Code in any project"
Write-Host "  2. Try: /rlm review ./src"
Write-Host "  3. Or ask: 'Review my codebase using the RLM system'"
Write-Host ""
Write-Host "Available Commands:" -ForegroundColor Cyan
Write-Host "  /rlm review [path]     - Full-stack analysis"
Write-Host "  /rlm frontend [path]   - Web audit"
Write-Host "  /rlm mobile [path]     - Mobile analysis"
Write-Host "  /rlm design [path]     - Design system check"
Write-Host "  /rlm security [path]   - Security scan"
Write-Host '  /rlm incident "..."    - Incident RCA'
Write-Host "  /rlm compare a b       - Architecture diff"
Write-Host '  /rlm prd "..."         - Generate PRD'
Write-Host "  /rlm implement <prd>   - Implement from PRD"
Write-Host ""
Write-Host "Git Hooks (Optional):" -ForegroundColor Cyan
Write-Host "  To install branch protection hooks in a project (requires bash/WSL):"
Write-Host "  bash $ClaudeDir\skills\rlm-system\hooks\install-hooks.sh /path/to/project"
Write-Host ""
Write-Host "  This installs a pre-push hook that:"
Write-Host "  - Blocks pushes to main/master by unauthorized agents"
Write-Host "  - Allows only devops and orchestrator agents to push to protected branches"
Write-Host ""
