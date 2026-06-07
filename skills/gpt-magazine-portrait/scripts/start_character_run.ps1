<#
.SYNOPSIS
按默认路径启动一次新人物写真工作流
.DESCRIPTION
Codex 在收到用户拖入的人物照片后调用本脚本。脚本会自动创建人物目录、
复制原始参考图、创建固定子目录，并生成 run manifest。用户不需要手动填写
人物名、路径或任务参数；这些由 Codex 和脚本按 MVP 默认值处理。
.PARAMETER SourceImagePath
用户拖入或 Codex 已定位到的原始人物照片路径，可传入多个。
.PARAMETER SourceImageDirectory
可选。未传入 SourceImagePath 时默认扫描 assets/inbox/，这是当前稳定 MVP 的默认图片入口。
.PARAMETER CharacterName
可选。未提供时自动生成 character-YYYYMMDD-HHMMSS。
.PARAMETER RunId
可选。未提供时自动生成 run-YYYYMMDD-HHMMSS。
.PARAMETER AllowOverwrite
允许覆盖同名复制文件。默认不覆盖，会自动追加序号。
.EXAMPLE
.\start_character_run.ps1 -SourceImagePath "D:\input\front.png","D:\input\side.png"
.EXAMPLE
powershell -ExecutionPolicy Bypass -Command "& '.\skills\gpt-magazine-portrait\scripts\start_character_run.ps1' -SourceImagePath 'D:\input\front.png','D:\input\side.png','D:\input\three-quarter.png'"
#>
param(
    [string[]]$SourceImagePath = @(),
    [string]$SourceImageDirectory = "",
    [string]$CharacterName = "",
    [string]$RunId = "",
    [switch]$AllowOverwrite
)

$ErrorActionPreference = "Stop"
$imageExtensions = @(".png", ".jpg", ".jpeg", ".webp", ".bmp", ".gif")

function Convert-ToSafeName {
    param([string]$Value)

    $safe = $Value.Trim().ToLowerInvariant()
    $safe = $safe -replace "\s+", "-"
    $safe = $safe -replace "[^\p{L}\p{N}\-_\.]", "-"
    $safe = $safe -replace "-+", "-"
    $safe = $safe.Trim("-")

    if ([string]::IsNullOrWhiteSpace($safe)) {
        return "character"
    }

    return $safe
}

function Get-UniquePath {
    param(
        [string]$Directory,
        [string]$FileName
    )

    $candidate = Join-Path $Directory $FileName
    if ($AllowOverwrite -or -not (Test-Path -LiteralPath $candidate)) {
        return $candidate
    }

    $name = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $ext = [System.IO.Path]::GetExtension($FileName)
    $index = 2

    do {
        $candidate = Join-Path $Directory ("{0}-{1:D2}{2}" -f $name, $index, $ext)
        $index++
    } while (Test-Path -LiteralPath $candidate)

    return $candidate
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).Path

if (-not $SourceImagePath -or $SourceImagePath.Count -eq 0) {
    if ([string]::IsNullOrWhiteSpace($SourceImageDirectory)) {
        $SourceImageDirectory = Join-Path $repoRoot "assets\inbox"
    }

    if (Test-Path -LiteralPath $SourceImageDirectory) {
        $SourceImagePath = @(
            Get-ChildItem -LiteralPath $SourceImageDirectory -File |
                Where-Object { $imageExtensions -contains $_.Extension.ToLowerInvariant() } |
                Sort-Object Name |
                Select-Object -ExpandProperty FullName
        )
    }
}

if (-not $SourceImagePath -or $SourceImagePath.Count -eq 0) {
    throw "未找到人物原始图片。当前稳定 MVP 默认从 assets/inbox/ 读取 3-5 张人物照片；如果当前 Codex 环境能暴露拖图本地路径，也可通过 -SourceImagePath 传入。请确认 assets/inbox/ 中已有图片，或当前环境提供了可用图片路径。"
}

if ($SourceImagePath.Count -lt 3) {
    Write-Warning "建议提供同一人物的 3-5 张多角度照片；当前只检测到 $($SourceImagePath.Count) 张。"
}

if ([string]::IsNullOrWhiteSpace($CharacterName)) {
    $CharacterName = "character-" + (Get-Date -Format "yyyyMMdd-HHmmss")
}

if ([string]::IsNullOrWhiteSpace($RunId)) {
    $RunId = "run-" + (Get-Date -Format "yyyyMMdd-HHmmss")
}

$characterSlug = Convert-ToSafeName -Value $CharacterName
$characterRoot = Join-Path $repoRoot "assets\characters\$characterSlug"
$referenceRoot = Join-Path $characterRoot "reference"
$originalsDir = Join-Path $referenceRoot "originals"
$multiviewDir = Join-Path $referenceRoot "multiview"
$generatedDir = Join-Path $characterRoot "generated"
$tasksDir = Join-Path $characterRoot "tasks"
$runsDir = Join-Path $characterRoot "runs"

$dirs = @(
    $characterRoot,
    $referenceRoot,
    $originalsDir,
    $multiviewDir,
    $generatedDir,
    $tasksDir,
    $runsDir
)

foreach ($dir in $dirs) {
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

$templatePath = Join-Path $repoRoot "templates\character_profile.template.md"
$profilePath = Join-Path $characterRoot "$characterSlug.md"
if ((Test-Path -LiteralPath $templatePath) -and -not (Test-Path -LiteralPath $profilePath)) {
    Copy-Item -LiteralPath $templatePath -Destination $profilePath
}

$copiedImages = @()
$imageIndex = 1

foreach ($source in $SourceImagePath) {
    if ([string]::IsNullOrWhiteSpace($source)) {
        continue
    }

    $resolved = Resolve-Path -LiteralPath $source -ErrorAction Stop
    $extension = [System.IO.Path]::GetExtension($resolved.Path)

    if ([string]::IsNullOrWhiteSpace($extension)) {
        $extension = ".png"
    }

    $targetName = "{0:D2}-source{1}" -f $imageIndex, $extension.ToLowerInvariant()
    $targetPath = Get-UniquePath -Directory $originalsDir -FileName $targetName
    Copy-Item -LiteralPath $resolved.Path -Destination $targetPath -Force:$AllowOverwrite

    $copiedImages += [pscustomobject]@{
        source_path = $resolved.Path
        repo_path = ($targetPath.Substring($repoRoot.Length + 1) -replace "\\", "/")
    }
    $imageIndex++
}

$manifestPath = Join-Path $runsDir "$RunId-manifest.json"
$manifest = [pscustomobject]@{
    character = $characterSlug
    run_id = $RunId
    created_at = (Get-Date).ToString("s")
    default_image_count = 4
    repo_root = $repoRoot
    directories = [pscustomobject]@{
        character_root = ($characterRoot.Substring($repoRoot.Length + 1) -replace "\\", "/")
        originals = ($originalsDir.Substring($repoRoot.Length + 1) -replace "\\", "/")
        multiview = ($multiviewDir.Substring($repoRoot.Length + 1) -replace "\\", "/")
        tasks = ($tasksDir.Substring($repoRoot.Length + 1) -replace "\\", "/")
        generated = ($generatedDir.Substring($repoRoot.Length + 1) -replace "\\", "/")
        runs = ($runsDir.Substring($repoRoot.Length + 1) -replace "\\", "/")
    }
    copied_source_images = $copiedImages
    expected_outputs = [pscustomobject]@{
        multiview_reference = ("assets/characters/{0}/reference/multiview/{0}-multiview-reference.png" -f $characterSlug)
        first_round_queue = ("assets/characters/{0}/tasks/{1}-first-round-prompt_queue.json" -f $characterSlug, $RunId)
        generated_dir = ("assets/characters/{0}/generated/" -f $characterSlug)
    }
    next_agent_steps = @(
        "Codex：把多视图参考图生成到 expected_outputs.multiview_reference 指定路径。",
        "Claude Code + Doubao-Seed-2.0-Pro：生成第一轮 4 个任务的提示词队列，并写入 expected_outputs.first_round_queue 指定路径。",
        "Codex：校验任务队列；如果不会覆盖旧文件且外部能力可用，继续生成最终图片。"
    )
}

$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

Write-Host "人物运行目录已初始化。"
Write-Host "人物目录名: $characterSlug"
Write-Host "Run ID: $RunId"
Write-Host "已复制原图数量: $($copiedImages.Count)"
Write-Host "Manifest: $manifestPath"
