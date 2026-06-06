<#
.SYNOPSIS
检查 gpt-magazine-portrait 工作流的本地仓库前置条件
.DESCRIPTION
本脚本只检查仓库文件、模板和校验脚本是否存在并可运行；不会调用生图能力，
不会调用 Doubao，也不会操作浏览器或 ChatGPT 桌面端。
.EXAMPLE
.\check_workflow_prereqs.ps1
#>

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).Path

$requiredPaths = @(
    "README.md",
    "PROJECT_GUIDE.md",
    "docs/WORKFLOW.md",
    "docs/AGENT_ROLES.md",
    "docs/STANDARD.md",
    "templates/multiview_reference_prompt.template.md",
    "templates/generation_task.template.json",
    "assets/style-reference",
    "assets/characters",
    "skills/gpt-magazine-portrait/SKILL.md",
    "skills/gpt-magazine-portrait/scripts/validate_queue.ps1",
    "skills/gpt-magazine-portrait/scripts/start_character_run.ps1"
)

$missing = @()
foreach ($path in $requiredPaths) {
    $fullPath = Join-Path $repoRoot $path
    if (-not (Test-Path -LiteralPath $fullPath)) {
        $missing += $path
    }
}

if ($missing.Count -gt 0) {
    Write-Error "Missing required paths: $($missing -join ', ')"
    exit 1
}

$templateQueue = Join-Path $repoRoot "templates/generation_task.template.json"
$validator = Join-Path $repoRoot "skills/gpt-magazine-portrait/scripts/validate_queue.ps1"
& powershell -ExecutionPolicy Bypass -File $validator -QueuePath $templateQueue

Write-Host ""
Write-Host "Prerequisite check passed."
Write-Host "Required external capabilities:"
Write-Host "- Codex image generation capability for multiview reference and final images."
Write-Host "- Claude Code + CC Switch, or equivalent access to Doubao-Seed-2.0-Pro, for image understanding and prompt queues."
Write-Host "- DeepSeek V4 Pro is optional for text-only cleanup; it cannot read images."
Write-Host "Forbidden route: browser automation, ChatGPT web, or GPT desktop automation."
