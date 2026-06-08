<#
.SYNOPSIS
调用 Claude Code 生成第一轮提示词队列
.DESCRIPTION
本脚本由 Codex 在多视图参考图生成成功后调用。它会读取当前 run manifest，
生成一份 Claude Code / Doubao-Seed-2.0-Pro 交接提示词，并在本机存在
claude CLI 时尝试用 `claude -p` 非交互执行。

脚本不会生图，不会调用浏览器、ChatGPT 网页版或 GPT 桌面端，也不会使用 DeepSeek。
.PARAMETER CharacterRoot
可选。人物目录路径，例如 assets/characters/character-20260608-111744。
未提供时自动选择最近一个包含 runs/*-manifest.json 的人物目录。
.PARAMETER RunManifest
可选。指定 run manifest JSON。提供后优先使用。
.PARAMETER ClaudeCommand
可选。Claude Code CLI 命令，默认 claude。
.PARAMETER ClaudeModel
可选。传给 claude --model 的模型名。默认不传，依赖用户已通过 CC Switch 选好 Doubao-Seed-2.0-Pro。
.PARAMETER NoInvoke
只生成交接提示词，不启动 Claude Code。
.EXAMPLE
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\invoke_claude_prompt_queue.ps1
.EXAMPLE
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\invoke_claude_prompt_queue.ps1 -NoInvoke
#>
param(
    [string]$CharacterRoot = "",
    [string]$RunManifest = "",
    [string]$ClaudeCommand = "claude",
    [string]$ClaudeModel = "",
    [switch]$NoInvoke
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).Path

function Convert-ToRepoPath {
    param([string]$Path)
    $resolved = (Resolve-Path -LiteralPath $Path).Path
    if ($resolved.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return ($resolved.Substring($repoRoot.Length + 1) -replace "\\", "/")
    }
    return $resolved
}

function Resolve-RepoPath {
    param([string]$Path)
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    }
    $windowsPath = $Path.Replace([char]47, [System.IO.Path]::DirectorySeparatorChar)
    return (Join-Path $repoRoot $windowsPath)
}

if ([string]::IsNullOrWhiteSpace($RunManifest)) {
    if ([string]::IsNullOrWhiteSpace($CharacterRoot)) {
        $charactersRoot = Join-Path $repoRoot "assets\characters"
        $characterDirs = Get-ChildItem -LiteralPath $charactersRoot -Directory
        $characterDirs = $characterDirs | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "runs") }

        $manifestCandidates = @()
        foreach ($dir in $characterDirs) {
            $manifestCandidates += Get-ChildItem -LiteralPath (Join-Path $dir.FullName "runs") -Filter "*-manifest.json" -File -ErrorAction SilentlyContinue
        }

        $latestManifest = $manifestCandidates | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $latestManifest) {
            throw "未找到 run manifest。请先运行 start_character_run.ps1，并成功生成多视图参考图。"
        }
        $RunManifest = $latestManifest.FullName
    }
    else {
        $characterRootPath = Resolve-RepoPath -Path $CharacterRoot
        $runsPath = Join-Path $characterRootPath "runs"
        $manifestFiles = Get-ChildItem -LiteralPath $runsPath -Filter "*-manifest.json" -File
        $latestManifest = $manifestFiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1

        if (-not $latestManifest) {
            throw "指定人物目录下未找到 runs/*-manifest.json：$CharacterRoot"
        }
        $RunManifest = $latestManifest.FullName
    }
}

$manifestPath = Resolve-RepoPath -Path $RunManifest
if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "run manifest 不存在：$RunManifest"
}

$manifest = Get-Content -LiteralPath $manifestPath -Encoding UTF8 -Raw | ConvertFrom-Json
$character = $manifest.character
$runId = $manifest.run_id
$characterRootPath = Resolve-RepoPath -Path $manifest.directories.character_root
$tasksDir = Resolve-RepoPath -Path $manifest.directories.tasks
$stageStatusPath = Resolve-RepoPath -Path $manifest.expected_outputs.stage_status
$queuePath = Resolve-RepoPath -Path $manifest.expected_outputs.first_round_queue
$multiviewPath = Resolve-RepoPath -Path $manifest.expected_outputs.multiview_reference
$profilePath = Join-Path $characterRootPath "$character.md"
$templatePath = Join-Path $repoRoot "templates\generation_task.template.json"
$styleReferenceDir = Join-Path $repoRoot "assets\style-reference"

if (-not (Test-Path -LiteralPath $multiviewPath)) {
    throw "未找到 AI 标准化多视图参考图：$($manifest.expected_outputs.multiview_reference)。必须先由 Codex 生图能力成功生成多视图，不能使用原图拼版 fallback。"
}

if (-not (Test-Path -LiteralPath $profilePath)) {
    throw "未找到人物 Markdown：$(Convert-ToRepoPath -Path $profilePath)"
}

if (-not (Test-Path -LiteralPath $templatePath)) {
    throw "未找到任务模板：templates/generation_task.template.json"
}

if (-not (Test-Path -LiteralPath $styleReferenceDir)) {
    throw "未找到风格参考库：assets/style-reference"
}

if (-not (Test-Path -LiteralPath $tasksDir)) {
    New-Item -ItemType Directory -Path $tasksDir -Force | Out-Null
}

$handoffPromptPath = Join-Path $tasksDir "$runId-claude-doubao-prompt.md"
$claudeOutputPath = Join-Path $tasksDir "$runId-claude-output.txt"
$queueRepoPath = ($queuePath.Substring($repoRoot.Length + 1) -replace "\\", "/")
$stageStatusRepoPath = ($stageStatusPath.Substring($repoRoot.Length + 1) -replace "\\", "/")

$prompt = @"
你现在接手 gpt-magazine-portrait-workflow 的提示词队列生成阶段。

必须遵守：
1. 你必须使用 Claude Code 当前通过 CC Switch 或等价方式接入的 Doubao-Seed-2.0-Pro 做图片理解和提示词队列生成。
2. 当前项目不使用 DeepSeek V4 Pro。
3. 不要操作浏览器、ChatGPT 网页版或 GPT 桌面端。
4. 不要生成最终图片，不要调用任何生图能力。
5. 不要询问用户人物名、目录、张数或是否开始；第一轮固定生成 4 个任务。
6. 只有当前多视图参考图是真正的 AI 标准化多视图时才继续；原图横向拼版、截图拼版、手工拼接图不算成功输入。

仓库根目录：
$repoRoot

人物：
$character

Run ID：
$runId

请读取这些材料：
- 人物多视图参考图：$($manifest.expected_outputs.multiview_reference)
- 人物资料 Markdown：$(Convert-ToRepoPath -Path $profilePath)
- 风格参考库目录：assets/style-reference/
- 任务模板：templates/generation_task.template.json
- 阶段状态文件：$stageStatusRepoPath

请输出：
- 第一轮提示词队列 JSON：$queueRepoPath

任务队列要求：
1. 输出 JSON 必须能被 templates/generation_task.template.json 的字段规范校验。
2. JSON 根节点使用任务数组，第一轮固定 4 个任务。
3. 每个任务必须包含这些必填字段：
   - task_id
   - character
   - style_pack_id
   - reference_character_image
   - reference_style_images
   - core_identity_constraints
   - final_prompt_zh
   - negative_prompt_zh
   - output_filename
   - status
   - priority
4. status 全部写 pending。
5. output_filename 指向 assets/characters/$character/generated/ 下的唯一文件名，不要覆盖已有文件。
6. final_prompt_zh 用中文写，主视觉文字如果需要字母，优先使用人物名拼音或英文，不要写版权 IP 名称。
7. reference_character_image 必须使用 $($manifest.expected_outputs.multiview_reference)。
8. reference_style_images 必须使用仓库内 assets/style-reference/ 下存在的图片路径。

如果你无法确认当前 Claude Code 已经接入 Doubao-Seed-2.0-Pro：
- 不要伪造任务队列。
- 不要用 DeepSeek 或普通文本模型替代读图。
- 在 $queueRepoPath 同目录写一个 $runId-doubao-unavailable.md，说明缺少 Doubao-Seed-2.0-Pro 提示词队列生成能力。

完成后只汇报：
1. 是否生成了 $queueRepoPath。
2. 生成了几个任务。
3. 是否有任何阻塞。
"@

Set-Content -LiteralPath $handoffPromptPath -Encoding UTF8 -Value $prompt

Write-Host "Claude Code 交接提示词已生成：$handoffPromptPath"

if ($NoInvoke) {
    Write-Host "已按 -NoInvoke 停止；请手动运行 Claude Code 或让 Codex 后续调用。"
    exit 0
}

$claude = Get-Command $ClaudeCommand -ErrorAction SilentlyContinue
if (-not $claude) {
    Write-Host "未找到 Claude Code CLI：$ClaudeCommand"
    Write-Host "请安装 Claude Code，并通过 CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。"
    Write-Host "可复制提示词文件给 Claude Code：$handoffPromptPath"
    exit 2
}

$argsList = @(
    "--add-dir", $repoRoot,
    "--permission-mode", "acceptEdits",
    "-p",
    $prompt
)

if (-not [string]::IsNullOrWhiteSpace($ClaudeModel)) {
    $argsList = @("--model", $ClaudeModel) + $argsList
}

Write-Host "正在调用 Claude Code 生成提示词队列..."
& $ClaudeCommand @argsList | Tee-Object -FilePath $claudeOutputPath
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    throw "Claude Code 调用失败，退出码：$exitCode。输出已保存：$claudeOutputPath"
}

if (-not (Test-Path -LiteralPath $queuePath)) {
    throw "Claude Code 已返回，但未生成任务队列：$queueRepoPath。请查看输出：$claudeOutputPath"
}

$validator = Join-Path $repoRoot "skills\gpt-magazine-portrait\scripts\validate_queue.ps1"
& powershell -ExecutionPolicy Bypass -File $validator -QueuePath $queuePath

Write-Host "Claude Code 提示词队列生成并校验通过：$queuePath"

