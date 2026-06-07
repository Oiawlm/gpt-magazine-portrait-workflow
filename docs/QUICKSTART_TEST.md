# 无生图快速测试

这个测试用于确认仓库克隆后能正常执行 MVP 的基础脚本和队列校验。它不会调用 GPT Image，也不会生成图片。

## 前提

在仓库根目录执行以下命令。Windows PowerShell 可直接使用。

## 1. 检查仓库前置条件

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\check_workflow_prereqs.ps1
```

预期结果：脚本能找到关键目录、模板和校验脚本，并成功校验任务模板。

注意：这个检查只证明仓库本地文件可用，不证明 Codex 生图能力或 Doubao 接入已经可用。

## 2. 启动一次默认测试运行

```powershell
$tmpImage = Join-Path $env:TEMP "gmpw-demo-source.png"
"demo image placeholder" | Set-Content -LiteralPath $tmpImage -Encoding UTF8
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\start_character_run.ps1 -CharacterName "demo_character" -RunId "run-demo-test" -SourceImagePath $tmpImage
```

预期生成：

```text
assets/characters/demo_character/
├── reference/
│   ├── originals/
│   └── multiview/
├── generated/
├── tasks/
├── runs/
└── demo_character.md
```

## 3. 检查目录是否存在

```powershell
Test-Path .\assets\characters\demo_character\reference\originals
Test-Path .\assets\characters\demo_character\reference\multiview
Test-Path .\assets\characters\demo_character\generated
Test-Path .\assets\characters\demo_character\tasks
Test-Path .\assets\characters\demo_character\runs\run-demo-test-manifest.json
Test-Path .\assets\characters\demo_character\demo_character.md
```

六行结果都应为 `True`。

## 3.1 可选：测试开发者 inbox 兜底

`assets/inbox/` 只用于开发者自测、无生图 quickstart 或环境兜底，不是公开 MVP 的普通用户入口。需要验证脚本默认扫描能力时，可以临时把测试图片放到：

```text
assets/inbox/
```

脚本在没有 `-SourceImagePath` 参数时会自动扫描该目录。真实用户使用时应直接把 3-5 张同一人物的多角度照片拖给 Codex，由 Codex 读取附件路径并传给 `-SourceImagePath`。

PowerShell 传多个路径时，建议使用 `-Command` 调用方式：

```powershell
powershell -ExecutionPolicy Bypass -Command "& '.\skills\gpt-magazine-portrait\scripts\start_character_run.ps1' -SourceImagePath 'D:\input\front.png','D:\input\side.png','D:\input\three-quarter.png'"
```

## 4. 校验任务模板

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\templates\generation_task.template.json
```

预期结果：脚本能识别模板中的示例任务，并提示必填字段完整。

## 5. 校验历史任务队列

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\workflow-runs\2026-06-05-style-pack-v1\first_round_prompt_queue.json
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\workflow-runs\2026-06-05-style-pack-v1\second_round_prompt_queue.json
```

预期结果：两个队列都通过必填字段校验。

## 6. 可选：检查所有 JSON 可解析

```powershell
$repo = (Get-Location).Path
Get-ChildItem -LiteralPath $repo -Recurse -File -Filter *.json | ForEach-Object {
  Get-Content -LiteralPath $_.FullName -Encoding UTF8 -Raw | ConvertFrom-Json | Out-Null
  $_.FullName
}
```

如果命令没有报错，说明仓库内 JSON 文件语法有效。

## 7. 清理测试目录

```powershell
Remove-Item -LiteralPath .\assets\characters\demo_character -Recurse -Force
Remove-Item -LiteralPath $tmpImage -Force
```

只删除本次测试创建的 `demo_character` 目录。

## 测试结论

以上步骤通过后，说明仓库的最小可用流程已经可执行：

1. 能检查仓库前置条件。
2. 能按默认路径启动新人物运行。
3. 能复制用户拖入图片到 `reference/originals/`。
4. 能读取任务模板。
5. 能校验任务队列。
6. 能进入后续“拖入人物参考图 -> Codex 生成多视图 -> Doubao 生成任务队列 -> Codex 自动生图”的主流程入口；真正生成图片仍需要 Codex 生图能力和 Doubao 接入。
