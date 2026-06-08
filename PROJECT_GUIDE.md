# GPT Magazine Portrait Workflow 项目指南

## 项目定位

本项目是用于开源发布的人物杂志写真自动化工作流仓库。它包含流程文档、规范、模板、风格参考资产、人物样张、运行记录和可复用提示词经验。

本项目不做前端集成，不提供一键 SaaS，不承诺所有生图模型都有同样效果。标准执行路线由 Codex 生图能力完成最终出图，视觉质量以 GPT Image 效果为基准。

## 主要入口

- `README.md`：项目介绍和快速开始。
- `docs/QUICKSTART_TEST.md`：无生图快速测试，用于验证新克隆仓库的最小可用流程。
- `docs/WORKFLOW.md`：完整工作流。
- `docs/STANDARD.md`：目录、命名、任务和反馈规范。
- `docs/AGENT_ROLES.md`：Codex、Claude Code、Doubao、GPT Image 的分工。
- `docs/GPT_IMAGE_GUIDE.md`：Codex 生图执行说明和 GPT Image 效果基准。
- `docs/PROMPT_RULES.md`：提示词规则和已验证经验。
- `docs/AUTOMATION_SKILL_DESIGN.md`：配套 Codex skill 的设计方向。
- `docs/HANDOFF_TO_CLAUDE_CODE.md`：交接给 Claude Code 的当前状态和下一步。
- `docs/CLAUDE_CODE_NEXT_PROMPT.md`：可直接复制给 Claude Code 的下一步指令。
- `skills/gpt-magazine-portrait/SKILL.md`：配套 Codex skill 主文档。
- `skills/gpt-magazine-portrait/scripts/`：前置检查、可选 skill 安装、默认运行启动、人物目录创建和任务队列校验脚本。
- `templates/`：人物资料、任务队列、风格包模板。
- `assets/`：随仓库发布的风格参考、人物资产和生成样张。
- `assets/inbox/`：当前稳定 MVP 的默认图片入口；用户把 3-5 张人物照片放入此目录后触发工作流。
- `assets/ASSET_MANIFEST.md`：资产清单。
- `workflow-runs/`：历史任务包和风格谱系。
- `docs/RELEASE_PLAN.md`：维护者发布计划、GitHub 仓库信息、release 文案和外部试跑指令；包含历史版本记录，普通用户入口和当前执行口径仍以 README 为准。

## 目录边界

- 本项目是独立开源仓库目录，不要把 `agent_vault` 其他项目混进来。
- 普通用户可通过 `git clone` 或 GitHub **Download ZIP** 获取仓库；ZIP 解压目录名可能带 `-main`，只要包含 `README.md`、`assets/`、`docs/`、`skills/` 就视为项目根目录。
- 运行公开 MVP 时，用户应在 Codex 中打开项目根目录后再发送触发语；不要假设用户知道需要先把 Codex 工作目录切到仓库目录。
- 安装 `gpt-magazine-portrait` 到本机 Codex skills 目录是可选增强，不是公开 MVP 的必经步骤；安装脚本为 `skills/gpt-magazine-portrait/scripts/install_codex_skill.ps1`。
- `agent_vault` 是作者的原始工作区名，新用户不需要创建或拥有这个目录。
- 原始工作区中的 `人物资料库`、`风格参考库` 只作为历史复制来源；对外发布后应使用仓库内的 `assets/characters/` 和 `assets/style-reference/`。
- 新增资产应放入 `assets/` 对应子目录，并同步更新清单或人物 Markdown。
- 用户把人物照片放入 `assets/inbox/` 或拖入人物照片并触发 `gpt-magazine-portrait` 工作流，视为授权按默认 MVP 自动执行；正常新人物运行不再二次确认。
- 当前稳定 MVP 使用 `assets/inbox/` 作为默认图片入口；拖图即跑是最终目标，只有当前 Codex 环境能把拖入图片附件暴露为本地文件路径时才走纯拖图路线。
- 不要声称可以在没有工具支持时把对话图片自动保存到临时目录。
- 默认路径为 `assets/characters/<auto-character-id>/reference/originals/`、`reference/multiview/`、`tasks/`、`generated/`、`runs/`。
- 只有缺少关键前置能力、任务队列无法修复、输入路径不存在或输出会覆盖旧图时，才暂停并说明原因。
- `check_workflow_prereqs.ps1` 只检查仓库文件和模板，不证明 Codex 生图能力、Doubao 接入或拖图路径暴露能力可用。
- 本项目标准路线由 Codex 生图能力执行最终出图；不要把控制浏览器、操作 ChatGPT 网页版或 GPT 桌面端写入工作流、计划、fallback 或未来规划。
- Codex 生图能力指当前 Codex 会话自带的生图能力；使用者账号/组织必须有 Codex 图片生成权限和可用额度。标准路线不要求用户配置 OpenAI API Key 或额外接入 OpenAI API。
- 多视图参考图必须由 Codex 生图能力生成；原图横向拼版、截图拼版或手工拼接图不算成功结果。Codex 生图工具服务器错误、超时或不可用时，停在多视图阶段并提示稍后重试，不得创建拼版 fallback，不得继续进入 Doubao 队列或最终写真。
- 验证和汇报时必须区分“启动链路成功”“多视图生图成功”“多视图生图失败”。人物目录、原图副本和 manifest 生成成功，只代表启动链路成功，不代表多视图参考图已成功。
- `start_character_run.ps1` 生成的 run manifest 必须保留多视图失败策略；不要移除 `stage_status_rules` 或 `multiview_failure_policy`，它们用于阻止接手 agent 把原图拼版当作 fallback。
- 提示词队列生成标准路线依赖 Claude Code + CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro；当前工作流不使用 DeepSeek V4 Pro。
- 当前阶段优先完善仓库和文档，不继续消耗生图额度。
- 谢孟伟/XIEMENGWEI 红绳重做任务已取消，不再执行。

## 检查方式

本项目当前是文档和资产项目，没有构建命令。修改后至少执行：

```powershell
$repo = (Get-Location).Path
Get-ChildItem -LiteralPath $repo -Recurse -File | Select-Object FullName,Length,LastWriteTime
$pattern = ('TO' + 'DO:' + '|TB' + 'D:' + '|待' + '补：' + '|未' + '完成：')
Get-ChildItem -LiteralPath $repo -Recurse -File -Filter *.md | Select-String -Pattern $pattern
Get-ChildItem -LiteralPath (Join-Path $repo "assets") -Recurse -File | Measure-Object
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\check_workflow_prereqs.ps1
```

如果更新了任务 JSON，还要执行：

```powershell
$repo = (Get-Location).Path
Get-ChildItem -LiteralPath $repo -Recurse -File -Filter *.json | ForEach-Object { Get-Content -LiteralPath $_.FullName -Encoding UTF8 -Raw | ConvertFrom-Json | Out-Null; $_.FullName }
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\templates\generation_task.template.json
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\workflow-runs\2026-06-05-style-pack-v1\first_round_prompt_queue.json
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\workflow-runs\2026-06-05-style-pack-v1\second_round_prompt_queue.json
```

## 剩余风险

- Codex 生图能力可能出现文字漂移，尤其是大型背景字、小字和中文标语。
- Codex 生图工具可能临时返回服务器错误；这时多视图阶段应明确失败并稍后重试，不能用原图拼版替代。
- 风格迁移不是简单抄参考图，必须提取构图、光影、色彩、字体、服装和气质。
- 当前工作流不使用 DeepSeek V4 Pro；不要把它写入执行路线、fallback 或可选步骤。
- Codex 额度有限，不能为测试而生图。
- 公开 MVP 的当前稳定入口是 `assets/inbox/`；不要把人物名、目录、张数和“是否开始”变成用户必填项。拖图即跑仍是最终目标。
- `templates/generation_task.template.json` 必须保持合法 JSON；字段说明写入 `_field_notes`，不要使用 `/* ... */` 注释。
