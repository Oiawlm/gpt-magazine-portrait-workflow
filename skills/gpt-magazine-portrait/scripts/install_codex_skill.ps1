<#
.SYNOPSIS
Install the bundled gpt-magazine-portrait skill into the local Codex skills directory.
.DESCRIPTION
Copies skills/gpt-magazine-portrait from this repository to the user's Codex skills directory.
This is optional for the MVP: users can still open the repository in Codex and run the workflow
without installing the skill.
.PARAMETER CodexHome
Optional Codex home directory. Defaults to $env:CODEX_HOME, then $HOME\.codex.
.PARAMETER Force
Replace an existing installed gpt-magazine-portrait skill.
.EXAMPLE
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\install_codex_skill.ps1
.EXAMPLE
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\install_codex_skill.ps1 -Force
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$CodexHome = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$skillRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).Path

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $CodexHome = $env:CODEX_HOME
    } else {
        $CodexHome = Join-Path $HOME ".codex"
    }
}

$skillsDir = Join-Path $CodexHome "skills"
$targetDir = Join-Path $skillsDir "gpt-magazine-portrait"

if (-not (Test-Path -LiteralPath (Join-Path $skillRoot "SKILL.md"))) {
    throw "Missing skill file: $skillRoot\SKILL.md"
}

if (-not (Test-Path -LiteralPath (Join-Path $repoRoot "README.md"))) {
    throw "Run this script from inside the gpt-magazine-portrait-workflow repository."
}

if ((Test-Path -LiteralPath $targetDir) -and -not $Force) {
    throw "Codex skill already exists: $targetDir. Re-run with -Force to replace it."
}

if ($PSCmdlet.ShouldProcess($targetDir, "Install gpt-magazine-portrait skill")) {
    if (-not (Test-Path -LiteralPath $skillsDir)) {
        New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
    }

    if (Test-Path -LiteralPath $targetDir) {
        Remove-Item -LiteralPath $targetDir -Recurse -Force
    }

    Copy-Item -LiteralPath $skillRoot -Destination $targetDir -Recurse -Force

    Write-Host "Codex skill installed to: $targetDir"
    Write-Host "Open a new Codex session, then use the trigger phrase from README.md."
}
