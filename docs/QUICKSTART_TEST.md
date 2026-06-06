# 无生图快速测试

这个测试用于确认仓库克隆后能正常执行 MVP 的基础脚本和队列校验。它不会调用 GPT Image，也不会生成图片。

## 前提

在仓库根目录执行以下命令。Windows PowerShell 可直接使用。

## 1. 创建测试人物目录

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\make_character_dirs.ps1 -CharacterName "demo_character"
```

预期生成：

```text
assets/characters/demo_character/
├── reference/
├── generated/
├── tasks/
└── demo_character.md
```

## 2. 检查目录是否存在

```powershell
Test-Path .\assets\characters\demo_character\reference
Test-Path .\assets\characters\demo_character\generated
Test-Path .\assets\characters\demo_character\tasks
Test-Path .\assets\characters\demo_character\demo_character.md
```

四行结果都应为 `True`。

## 3. 校验任务模板

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\templates\generation_task.template.json
```

预期结果：脚本能识别模板中的示例任务，并提示必填字段完整。

## 4. 校验历史任务队列

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\workflow-runs\2026-06-05-style-pack-v1\first_round_prompt_queue.json
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\workflow-runs\2026-06-05-style-pack-v1\second_round_prompt_queue.json
```

预期结果：两个队列都通过必填字段校验。

## 5. 可选：检查所有 JSON 可解析

```powershell
$repo = (Get-Location).Path
Get-ChildItem -LiteralPath $repo -Recurse -File -Filter *.json | ForEach-Object {
  Get-Content -LiteralPath $_.FullName -Encoding UTF8 -Raw | ConvertFrom-Json | Out-Null
  $_.FullName
}
```

如果命令没有报错，说明仓库内 JSON 文件语法有效。

## 6. 清理测试目录

```powershell
Remove-Item -LiteralPath .\assets\characters\demo_character -Recurse -Force
```

只删除本次测试创建的 `demo_character` 目录。

## 测试结论

以上步骤通过后，说明仓库的最小可用流程已经可执行：

1. 能创建新人物目录。
2. 能读取任务模板。
3. 能校验任务队列。
4. 能进入后续“上传人物参考图 -> Codex 生成多视图 -> 生成任务队列 -> Codex 生图”的主流程。
