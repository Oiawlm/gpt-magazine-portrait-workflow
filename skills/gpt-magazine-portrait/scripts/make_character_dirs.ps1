<#
.SYNOPSIS
为新人物创建标准目录结构
.DESCRIPTION
自动创建人物资料所需的目录结构，包括参考图、生成图、任务队列等目录
.PARAMETER CharacterName
人物名称，建议使用拼音或英文名，不要有空格和特殊字符
.EXAMPLE
.\make_character_dirs.ps1 -CharacterName "liangzi"
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$CharacterName
)
$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..\..")).Path
$charactersPath = Join-Path $repoRoot "assets\characters"
$basePath = Join-Path $charactersPath $CharacterName
$directories = @(
    "reference",
    "reference\originals",
    "reference\multiview",
    "generated",
    "tasks",
    "runs"
)
try {
    # 创建基础目录
    if (-not (Test-Path $basePath)) {
        New-Item -ItemType Directory -Path $basePath -Force | Out-Null
        Write-Host "创建基础目录: $basePath"
    }
    # 创建子目录
    foreach ($dir in $directories) {
        $fullPath = Join-Path $basePath $dir
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            Write-Host "创建子目录: $fullPath"
        }
    }
    # 复制人物资料模板
    $templatePath = Join-Path $repoRoot "templates\character_profile.template.md"
    $outputPath = Join-Path $basePath "$CharacterName.md"
    if (-not (Test-Path $outputPath)) {
        Copy-Item -Path $templatePath -Destination $outputPath
        Write-Host "创建人物资料模板: $outputPath"
    }
    Write-Host "`n人物目录结构创建完成！"
    Write-Host "原始参考图默认目录: $basePath\reference\originals\"
    Write-Host "多视图参考图默认目录: $basePath\reference\multiview\"
    Write-Host "人物资料模板: $outputPath"
}
catch {
    Write-Error "创建目录失败: $_"
    exit 1
}
