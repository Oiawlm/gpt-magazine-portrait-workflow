# AI Magazine Portrait Workflow 项目指南

## 项目定位

本项目是用于开源发布的人物杂志写真自动化工作流仓库。它包含流程文档、规范、模板、风格参考资产、人物样张、运行记录和可复用提示词经验。

本项目不做前端集成，不提供一键 SaaS，不承诺所有生图模型都有同样效果。最终出图效果以 GPT Image / ChatGPT Plus 为主。

## 主要入口

- `README.md`：项目介绍和快速开始。
- `docs/WORKFLOW.md`：完整工作流。
- `docs/STANDARD.md`：目录、命名、任务和反馈规范。
- `docs/AGENT_ROLES.md`：Codex、Claude Code、Doubao、DeepSeek、GPT Image 的分工。
- `docs/GPT_IMAGE_GUIDE.md`：GPT Image 执行说明。
- `docs/PROMPT_RULES.md`：提示词规则和已验证经验。
- `docs/AUTOMATION_SKILL_DESIGN.md`：配套 Codex skill 的设计方向。
- `docs/HANDOFF_TO_CLAUDE_CODE.md`：交接给 Claude Code 的当前状态和下一步。
- `skills/gpt-magazine-portrait/SKILL.md`：配套 Codex skill 主文档。
- `skills/gpt-magazine-portrait/scripts/`：人物目录创建和任务队列校验脚本。
- `templates/`：人物资料、任务队列、风格包模板。
- `assets/`：随仓库发布的风格参考、人物资产和生成样张。
- `assets/ASSET_MANIFEST.md`：资产清单。
- `workflow-runs/`：历史任务包和风格谱系。
- `docs/RELEASE_PLAN.md`：开源前发布计划。

## 目录边界

- 本项目是独立开源仓库目录，不要把 `agent_vault` 其他项目混进来。
- 原始工作区中的 `人物资料库`、`风格参考库` 只作为复制来源，不在本项目中反向修改。
- 新增资产应放入 `assets/` 对应子目录，并同步更新清单或人物 Markdown。
- 生图前必须列出任务 ID、输出路径、是否覆盖旧图，并等待用户确认。
- 当前阶段优先完善仓库和文档，不继续消耗生图额度。
- 谢孟伟/XIEMENGWEI 红绳重做任务已取消，不再执行。

## 检查方式

本项目当前是文档和资产项目，没有构建命令。修改后至少执行：

```powershell
Get-ChildItem -LiteralPath "D:\Download\agent_vault\ai-magazine-portrait-workflow" -Recurse -File | Select-Object FullName,Length,LastWriteTime
$pattern = ('TO' + 'DO:' + '|TB' + 'D:' + '|待' + '补：' + '|未' + '完成：')
Get-ChildItem -LiteralPath "D:\Download\agent_vault\ai-magazine-portrait-workflow" -Recurse -File -Filter *.md | Select-String -Pattern $pattern
Get-ChildItem -LiteralPath "D:\Download\agent_vault\ai-magazine-portrait-workflow\assets" -Recurse -File | Measure-Object
```

如果更新了任务 JSON，还要执行：

```powershell
Get-ChildItem -LiteralPath "D:\Download\agent_vault\ai-magazine-portrait-workflow" -Recurse -File -Filter *.json | ForEach-Object { Get-Content -LiteralPath $_.FullName -Encoding UTF8 -Raw | ConvertFrom-Json | Out-Null; $_.FullName }
```

## 剩余风险

- GPT Image 对文字有漂移概率，尤其是大型背景字、小字和中文标语。
- 风格迁移不是简单抄参考图，必须提取构图、光影、色彩、字体、服装和气质。
- DeepSeek V4 Pro 不能收发图片，只适合文本整理。
- Codex 额度有限，不能为测试而生图。
