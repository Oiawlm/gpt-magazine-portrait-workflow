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
    "assets/inbox",
    "skills/gpt-magazine-portrait/SKILL.md",
    "skills/gpt-magazine-portrait/scripts/validate_queue.ps1",
    "skills/gpt-magazine-portrait/scripts/start_character_run.ps1",
    "skills/gpt-magazine-portrait/scripts/install_codex_skill.ps1"
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

$startRunScript = Join-Path $repoRoot "skills/gpt-magazine-portrait/scripts/start_character_run.ps1"
$startRunContent = Get-Content -LiteralPath $startRunScript -Encoding UTF8 -Raw
$requiredStartRunPatterns = @(
    "stage_status_rules",
    "multiview_failure_policy",
    "allow_raw_photo_collage_fallback = `$false",
    "allow_continue_to_doubao_queue = `$false",
    "allow_continue_to_final_portraits = `$false",
    "不要创建拼版 fallback"
)

$missingStartRunPatterns = @()
foreach ($pattern in $requiredStartRunPatterns) {
    if ($startRunContent -notlike "*$pattern*") {
        $missingStartRunPatterns += $pattern
    }
}

if ($missingStartRunPatterns.Count -gt 0) {
    Write-Error "多视图失败策略缺失或被弱化: $($missingStartRunPatterns -join ', ')"
    exit 1
}

$multiviewTemplate = Join-Path $repoRoot "templates/multiview_reference_prompt.template.md"
$multiviewTemplateContent = Get-Content -LiteralPath $multiviewTemplate -Encoding UTF8 -Raw
$requiredTemplatePatterns = @(
    "不要把输入原图简单横向拼接成拼版",
    "fallback collage",
    "必须是 AI 标准化多视图参考图，而不是原始照片拼版"
)

$missingTemplatePatterns = @()
foreach ($pattern in $requiredTemplatePatterns) {
    if ($multiviewTemplateContent -notlike "*$pattern*") {
        $missingTemplatePatterns += $pattern
    }
}

if ($missingTemplatePatterns.Count -gt 0) {
    Write-Error "多视图提示词模板缺少禁止拼版规则: $($missingTemplatePatterns -join ', ')"
    exit 1
}

Write-Host ""
Write-Host "多视图失败策略检查已通过。"
Write-Host "仓库本地检查已通过。"
Write-Host "注意：本脚本只检查仓库文件、模板和队列校验脚本；不会验证以下外部能力："
Write-Host "- Codex 是否具备生图能力。"
Write-Host "- Claude Code 是否已通过 CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。"
Write-Host "- 当前 Codex 环境是否能把拖入图片暴露为本地文件路径。"
Write-Host "当前工作流不使用 DeepSeek V4 Pro。"
Write-Host "禁止路线：浏览器自动化、ChatGPT 网页版、GPT 桌面端自动化。"
