<#
.SYNOPSIS
验证生成任务队列JSON格式是否符合规范
.DESCRIPTION
检查任务队列中的每个任务是否包含所有必填字段，格式是否正确
.PARAMETER QueuePath
任务队列JSON文件路径
.EXAMPLE
.\validate_queue.ps1 -QueuePath "..\workflow-runs\2026-06-05-style-pack-v1\first_round_prompt_queue.json"
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$QueuePath
)
# 必填字段列表
$requiredFields = @(
    "task_id",
    "character",
    "style_pack_id",
    "reference_character_image",
    "reference_style_images",
    "core_identity_constraints",
    "final_prompt_zh",
    "negative_prompt_zh",
    "output_filename",
    "status",
    "priority"
)
# 可选字段列表
$optionalFields = @(
    "style_pack_name",
    "style_adaptation_notes",
    "belongs_to_style_line"
)
try {
    if (-not (Test-Path $QueuePath)) {
        throw "文件不存在: $QueuePath"
    }
    # 读取并解析JSON。支持两种队列格式：
    # 1. 根节点就是任务数组
    # 2. 根节点包含 tasks 字段，实际任务在 tasks 数组中
    $content = Get-Content -Path $QueuePath -Encoding UTF8 -Raw
    $json = $content | ConvertFrom-Json
    if ($json.PSObject.Properties["tasks"]) {
        $tasks = @($json.tasks)
    }
    else {
        $tasks = @($json)
    }
    if (-not $tasks -or $tasks.Count -eq 0) {
        throw "任务队列为空"
    }
    Write-Host "正在验证任务队列: $QueuePath"
    Write-Host "共找到 $($tasks.Count) 个任务`n"
    $errorCount = 0
    # 逐个验证任务
    for ($i = 0; $i -lt $tasks.Count; $i++) {
        $task = $tasks[$i]
        $taskNumber = $i + 1
        $missingFields = @()
        foreach ($field in $requiredFields) {
            if (-not $task.PSObject.Properties[$field] -or $null -eq $task.$field -or $task.$field -eq "") {
                $missingFields += $field
            }
        }
        if ($missingFields.Count -gt 0) {
            $errorCount++
            Write-Warning "任务 $taskNumber (ID: $($task.task_id)) 缺少必填字段: $($missingFields -join ', ')"
        }
        else {
            # 检查可选字段
            $missingOptional = @()
            foreach ($field in $optionalFields) {
                if (-not $task.PSObject.Properties[$field] -or $null -eq $task.$field -or $task.$field -eq "") {
                    $missingOptional += $field
                }
            }

            if ($missingOptional.Count -eq $optionalFields.Count) {
                Write-Host "任务 $taskNumber (ID: $($task.task_id)): 格式正确（无可选扩展字段）"
            }
            elseif ($missingOptional.Count -gt 0) {
                Write-Host "任务 $taskNumber (ID: $($task.task_id)): 格式正确，缺少可选字段: $($missingOptional -join ', ')"
            }
            else {
                Write-Host "任务 $taskNumber (ID: $($task.task_id)): 格式正确，包含所有可选扩展字段 ✅"
            }
        }
    }
    Write-Host "`n验证完成！"
    if ($errorCount -gt 0) {
        Write-Error "发现 $errorCount 个错误，请修正后再使用"
        exit 1
    }
    else {
        Write-Host "所有任务格式正确 ✅"
        exit 0
    }
}
catch {
    Write-Error "验证失败: $_"
    exit 1
}
