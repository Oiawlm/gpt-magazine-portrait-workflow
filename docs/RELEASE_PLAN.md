# Release Plan

## 当前目标

把本仓库整理成可开源项目。用户不需要重新收集风格图，只需要准备一个人物的多角度照片，就能使用本仓库中的风格资产、提示词规范和任务模板生成高质量杂志写真。

当前公开 MVP 口径：配置一次，之后通过 `assets/inbox/` 默认入口启动人物运行；纯拖图即跑是最终目标，只有当前 Codex 环境能暴露拖入图片本地路径时才走纯拖图路线。普通用户不需要手动输入人物名、目录、路径、生成张数或“是否开始”；触发语和放入 `assets/inbox/` 的照片本身视为默认执行授权。

注意：本文后面的各版本说明是历史 release 留档，用于维护者回溯问题。普通用户和外部试跑者应以当前 `README.md` 的快速开始为准；如果历史版本记录与当前入口口径不同，以 `README.md`、`PROJECT_GUIDE.md` 和 `docs/WORKFLOW.md` 当前内容为准。

## 入口优先级

- 普通用户入口只有仓库 README。用户打开仓库后，应直接通过 README 理解项目、克隆仓库并开始使用。
- `docs/` 是深入说明和维护资料，不是第一入口。
- GitHub Release 是维护者版本留档、问题回溯和反馈定位工具，不是普通用户的使用教程入口。
- 外部试跑者也应从仓库 README 开始，而不是从 Release 页面开始。

## 已完成

- 创建独立仓库目录。
- 写入 README、工作流、规范、Agent 分工和 Codex 生图执行指南。
- 放入风格参考库。
- 放入良子、嘎子人物资料和生成样张。
- 放入历史任务队列、人物风格谱系和运行记录。
- 保留嘎子红绳镜面 `MODERN` 成功样张。
- 取消谢孟伟/XIEMENGWEI 红绳重做任务，当前不继续消耗生图额度。

## 开源前检查

1. 确认 README 能让用户明白项目不是前端工具，而是资产化工作流。
2. 确认 `assets/` 中资产分类清楚。
3. 确认 `templates/` 足够用户接入新人物。
4. 确认 `docs/WORKFLOW.md` 能从上传人物图一路走到保存结果。
5. 确认任务 JSON 都能解析。
6. 初始化 Git 仓库并提交首版。
7. 选择 GitHub 仓库名并推送。
8. 设计配套 Codex skill，让 Codex 能按本仓库资产和规范自动跑新人物写真流程。
9. 确认公开工作流前置条件写清楚：Codex 生图能力、Claude Code、CC Switch 或等价 Doubao-Seed-2.0-Pro 接入。

## GitHub 仓库信息

仓库名：

```text
gpt-magazine-portrait-workflow
```

仓库简介：

```text
Codex + Doubao workflow for generating GPT Image-style magazine portraits from multi-angle character photos.
```

推荐 topics：

```text
codex
gpt-image
ai-image-generation
portrait-generation
magazine-cover
prompt-engineering
doubao
workflow
powershell
character-reference
```

## v0.1.0-mvp Release 文案

标题：

```text
v0.1.0-mvp：拖图即跑的人物杂志写真工作流
```

正文：

```markdown
## 这个版本包含什么

这是 `gpt-magazine-portrait-workflow` 的第一个公开 MVP 版本。

它提供一套带资产库的人物杂志写真工作流：用户准备同一人物的多角度照片，仓库复用内置风格参考、提示词规则、任务模板和 Codex skill 草案，生成接近 GPT Image 审美基准的人物杂志写真。

- 内置风格参考资产
- 良子、嘎子示例人物资产和生成样张
- 提示词规则和完整工作流文档
- `gpt-magazine-portrait` Codex skill 草案
- PowerShell 脚本：前置检查、默认人物运行启动、目录创建、任务队列校验
- 任务队列模板和历史运行记录

## 标准路线

1. 克隆仓库。
2. 运行前置检查。
3. 当前稳定 MVP：把同一人物的多角度照片放入 `assets/inbox/`；如果当前 Codex 环境能暴露拖图本地路径，也可以直接拖给 Codex。
4. 触发 `gpt-magazine-portrait` 工作流。
5. Codex 自动创建默认目录，生成多视图参考图。
6. Claude Code + Doubao-Seed-2.0-Pro 读取人物图和风格库，生成提示词队列。
7. Codex 校验队列，并使用 Codex 生图能力生成最终杂志写真。

## 前置要求

- Codex 具备可用的生图能力
- Claude Code 已通过 CC Switch，或等价方式接入 Doubao-Seed-2.0-Pro
- 当前工作流不使用 DeepSeek V4 Pro

## 重要边界

本项目不把浏览器自动化、ChatGPT 网页版或 GPT 桌面端自动化作为工作流路线。

## MVP 限制

- 这不是一键桌面软件，也不是 SaaS。
- 不保证其他生图模型能达到同等效果。
- 最终图片质量仍取决于人物参考照片、提示词队列质量和 Codex 生图表现。
```

## v0.1.1 Release 文案

定位：

```text
外部试跑反馈修复版
```

标题：

```text
v0.1.1：MVP 入口和外部能力边界修复
```

正文：

```markdown
## 这个版本修了什么

`v0.1.1` 是基于外部 MVP 试跑反馈做的可用性修复版。

这次不新增风格资产，不做生图效果优化，不改变标准路线；重点修复普通用户按 README 试跑时遇到的入口问题。

## 主要修复

- 明确 `check_workflow_prereqs.ps1` 只检查仓库文件、模板和队列校验脚本，不代表 Codex 生图能力或 Doubao 接入已经配置成功。
- 新增 `assets/inbox/` 脚本兜底入口；后续 `v0.1.2` 已进一步明确它不是普通用户主流程。
- `start_character_run.ps1` 支持无 `-SourceImagePath` 时自动扫描 `assets/inbox/`。
- 修正 PowerShell 多路径参数说明，推荐使用 `-Command` 方式传数组路径。
- 修复新 PowerShell 脚本在旧版 `powershell.exe` 下中文输出乱码的问题。
- README、SKILL、WORKFLOW、QUICKSTART_TEST 同步说明：多视图生成依赖 Codex 生图能力，提示词队列生成依赖 Claude Code + Doubao-Seed-2.0-Pro。

## 仍然没有做什么

- 没有验证真实生图效果。
- 没有验证真实 Doubao 调用。
- 没有把项目做成一键软件或 SaaS。
- 没有引入浏览器自动化、ChatGPT 网页版或 GPT 桌面端路线。
- 当前工作流仍不使用 DeepSeek V4 Pro。

## 用户入口

普通用户仍然只需要从仓库 README 开始，不需要先阅读 Release 页面。

Release 只用于维护者版本留档、问题回溯和反馈定位。
```

## v0.1.2 Release 文案

定位：

```text
拖图入口收敛修复版
```

标题：

```text
v0.1.2：收敛拖图即跑主入口
```

正文：

```markdown
## 这个版本修了什么

`v0.1.2` 修正公开 MVP 的用户入口口径：普通用户只需要把图片拖给 Codex，不需要把图片放进仓库目录。

## 主要修复

- README 的日常使用路径改为“拖图给 Codex + 触发语”。
- `assets/inbox/` 降级为开发者自测、无生图 quickstart 或环境兜底，不再作为普通用户主流程。
- SKILL、WORKFLOW、AUTOMATION_SKILL_DESIGN 同步要求：Codex 应从本轮拖入附件读取本地路径，并传给 `start_character_run.ps1 -SourceImagePath ...`。
- 如果当前 Codex 环境不能暴露拖入图片路径，流程应停在输入读取阶段并说明环境限制，不应把额外文件夹操作转嫁给用户。

## 不变内容

- 标准路线仍然是 Codex 主控和最终生图。
- 提示词队列仍然依赖 Claude Code + Doubao-Seed-2.0-Pro。
- 不使用浏览器自动化、ChatGPT 网页版、GPT 桌面端或 DeepSeek V4 Pro。
```

## v0.1.3 Release 文案

定位：

```text
附件路径能力边界修复版
```

标题：

```text
v0.1.3：明确拖图即跑的附件路径前置条件
```

正文：

```markdown
## 这个版本修了什么

`v0.1.3` 明确了“拖图即跑”的真实技术前置：当前 Codex 环境必须能把用户拖入的图片附件暴露给 agent，至少提供可传给脚本的本地文件路径。

## 主要修复

- README 不再暗示所有 Codex Desktop 环境都能自动读取拖入图片路径。
- SKILL 明确禁止在没有工具支持时声称可以把对话图片保存为本地临时文件。
- WORKFLOW、AUTOMATION_SKILL_DESIGN、PROJECT_GUIDE 同步说明：如果没有附件路径能力，流程停在输入读取阶段。
- 继续保持普通用户主流程为“直接拖图给 Codex”，不把 `assets/inbox/` 或任何文件夹操作转嫁给用户。

## 不变内容

- 用户目标仍然是拖图即跑。
- Codex 仍然是主控和最终生图执行者。
- 提示词队列仍然依赖 Claude Code + Doubao-Seed-2.0-Pro。
- 不使用浏览器自动化、ChatGPT 网页版、GPT 桌面端或 DeepSeek V4 Pro。
```

## v0.1.4 Release 文案

定位：

```text
稳定默认入口修复版
```

标题：

```text
v0.1.4：将 assets/inbox 设为当前稳定图片入口
```

正文：

```markdown
## 这个版本修了什么

`v0.1.4` 把当前可运行 MVP 的默认图片入口调整为 `assets/inbox/`。用户把同一人物的 3-5 张多角度照片放进这个目录后，Codex 可以直接运行脚本启动人物工作流。

## 主要修复

- README 明确区分“最终目标：拖图即跑”和“当前稳定 MVP：assets/inbox 默认入口”。
- SKILL 默认先扫描 `assets/inbox/`；只有当前 Codex 环境明确暴露拖图本地路径时，才走 `-SourceImagePath` 路线。
- WORKFLOW、AUTOMATION_SKILL_DESIGN、PROJECT_GUIDE、ASSET_MANIFEST、QUICKSTART_TEST 同步 `assets/inbox/` 当前入口地位。
- 脚本错误提示改为提示检查 `assets/inbox/` 或可用图片路径。

## 不变内容

- 拖图即跑仍是最终目标。
- Codex 仍然是主控和最终生图执行者。
- 提示词队列仍然依赖 Claude Code + Doubao-Seed-2.0-Pro。
- 不使用浏览器自动化、ChatGPT 网页版、GPT 桌面端或 DeepSeek V4 Pro。
```

## v0.1.5 Release 文案

定位：

```text
输入规则澄清版
```

标题：

```text
v0.1.5：澄清 Codex 生图能力和 inbox 文件名规则
```

正文：

```markdown
## 这个版本修了什么

`v0.1.5` 澄清两个容易误解的点：标准路线不要求用户配置 OpenAI API Key；`assets/inbox/` 中的客户图片文件名可以任意。

## 主要修复

- README 明确：Codex 生图能力指当前 Codex 会话自带的生图能力，不是 OpenAI API 前置要求。
- SKILL 和 PROJECT_GUIDE 同步说明：不要把缺少 Codex 生图能力误写成用户必须接 API。
- README、SKILL、WORKFLOW、ASSET_MANIFEST 明确：`assets/inbox/` 中的图片文件名可以是微信导出名、截图名、相机原始名等任意名称；脚本按常见图片扩展名识别并复制重命名。

## 不变内容

- 当前稳定 MVP 仍使用 `assets/inbox/` 作为默认图片入口。
- 拖图即跑仍是最终目标。
- Codex 仍然是主控和最终生图执行者。
- 提示词队列仍然依赖 Claude Code + Doubao-Seed-2.0-Pro。
```

## v0.1.6 Release 文案

定位：

```text
生图权限前置澄清版
```

标题：

```text
v0.1.6：明确完整出图需要 Codex 图片生成权限
```

正文：

```markdown
## 这个版本修了什么

`v0.1.6` 明确完整运行本工作流需要使用者自己的 Codex 账号/组织具备图片生成权限和可用额度。没有这项能力时，仓库只能验证启动链路，不能完成多视图和最终写真生成。

## 主要修复

- README、SKILL、WORKFLOW、PROJECT_GUIDE 明确：Codex 生图能力是完整流程前置条件。
- 继续澄清：标准路线不要求用户配置 OpenAI API Key 或额外接入 OpenAI API。
- 外部验证者如果没有 Codex 图片生成权限，只能验证 `assets/inbox/` 启动链路，不能验证端到端出图。

## 不变内容

- 当前稳定 MVP 仍使用 `assets/inbox/` 作为默认图片入口。
- `assets/inbox/` 中图片文件名可以任意，只要是常见图片扩展名。
- 拖图即跑仍是最终目标。
- 提示词队列仍然依赖 Claude Code + Doubao-Seed-2.0-Pro。
```

## v0.1.7 Release 文案

定位：

```text
入口口径收敛版
```

标题：

```text
v0.1.7：收敛 README 首屏和接手文档的 inbox MVP 口径
```

正文：

```markdown
## 这个版本修了什么

`v0.1.7` 修正 README 首屏、Claude Code 接手提示和 release 维护文档中的入口表述，避免新用户误以为当前版本已经稳定支持纯拖图即跑。

## 主要修复

- README 第一屏明确：当前稳定 MVP 使用 `assets/inbox/` 作为默认图片入口。
- 继续保留纯拖图即跑作为最终目标，但明确只有当前 Codex 环境能暴露拖入图片本地路径时才走这条路线。
- `docs/HANDOFF_TO_CLAUDE_CODE.md` 和 `docs/CLAUDE_CODE_NEXT_PROMPT.md` 同步当前入口口径，避免接手 agent 继续按旧理解执行。
- `docs/RELEASE_PLAN.md` 明确 release 文档是维护者历史留档，普通用户和外部试跑者以 README 当前快速开始为准。

## 不变内容

- 完整出图仍要求使用者自己的 Codex 账号/组织具备图片生成权限和可用额度。
- 标准路线不要求用户配置 OpenAI API Key。
- 提示词队列仍然依赖 Claude Code + CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。
- 当前工作流不使用 DeepSeek V4 Pro。
- 不使用浏览器自动化、ChatGPT 网页版或 GPT 桌面端。
```

## v0.1.8 Release 文案

定位：

```text
多视图失败处理收敛版
```

标题：

```text
v0.1.8：明确多视图失败时不得用拼版 fallback 冒充成功
```

正文：

```markdown
## 这个版本修了什么

`v0.1.8` 收敛外部测试暴露出的多视图失败处理问题：Codex 生图工具服务器错误、超时或不可用时，流程必须停在多视图阶段，不能用原始照片拼版冒充 AI 标准化多视图参考图。

## 主要修复

- README、SKILL、WORKFLOW 明确：多视图参考图必须由 Codex 生图能力生成。
- 原图横向拼版、截图拼版或手工拼接图不算成功结果。
- Codex 生图工具报服务器错误、超时或不可用时，停止流程并提示稍后重试。
- 不得创建 fallback 拼版，不得把拼版保存为正式多视图结果，不得继续进入 Doubao 队列或最终写真。
- 外部测试指令补充：如果 `reference/multiview/` 中出现的是原图拼版，测试结论写“不通过”。

## 不变内容

- 当前稳定 MVP 仍使用 `assets/inbox/` 作为默认图片入口。
- 完整出图仍要求使用者自己的 Codex 账号/组织具备图片生成权限和可用额度。
- 标准路线不要求用户配置 OpenAI API Key。
- 提示词队列仍然依赖 Claude Code + CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。
- 当前工作流不使用 DeepSeek V4 Pro。
```

## 明天给外部试跑者的指令

只让对方验证仓库能否启动并走到多视图阶段，不让对方做审美反馈，不让对方继续 Doubao 队列或最终写真。

```text
请打开这个仓库并从 README 开始：
https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git

目标：只验证仓库的 MVP 使用说明能不能跑到“Codex 生成 AI 标准化多视图参考图并保存”。不评价图片审美，不设计新流程。

请按 README 的当前稳定 MVP 流程操作：
1. 克隆仓库并进入目录。
2. 运行 README 里的前置检查命令。
3. 注意：前置检查只验证仓库文件和模板，不验证 Codex 生图能力，也不验证 Doubao 接入。
4. 准备同一人物的 3-5 张多角度照片。
5. 把这些照片放入 assets/inbox/。
6. 对 Codex 说：按 gpt-magazine-portrait 工作流处理这些照片。先只执行到“生成 AI 标准化多视图参考图并保存到 reference/multiview/”这一步，不要继续生成提示词队列，也不要生成最终写真。

注意：
- 不要改仓库结构。
- 不要新增自己的风格库。
- 不要使用浏览器自动化、ChatGPT 网页版或 GPT 桌面端。
- 不要让用户手动输入人物名、目录、路径、张数或“是否开始”。
- 当前稳定 MVP 使用 assets/inbox/；拖图即跑仍是最终目标，但这轮先验证固定入口能否真实启动。
- 多视图参考图必须是 Codex 生图能力生成的 AI 标准化 reference sheet；原图横向拼版、截图拼版或手工拼接图不算成功。
- 如果 Codex 生图工具服务器错误、超时或不可用，请停在多视图阶段并记录失败，不要创建拼版 fallback，不要继续进入 Doubao 队列或最终写真。
- 如果卡住，只记录卡在哪一步、报错原文、看不懂哪句话。

请最后反馈：
1. 哪一步卡住了，或是否能走到 Codex 准备生成图片这一步。
2. README 里哪句话看不懂。
3. 哪个脚本报错，报错原文是什么。
4. 有没有被要求做多余的手动操作。
5. 是否成功生成 AI 标准化多视图参考图。
6. 如果 `reference/multiview/` 里出现的是原图横向拼版，请写：不通过，生成了拼版 fallback，不是 AI 标准化多视图。
7. 如果卡在多视图阶段，记录是缺 Codex 生图能力，还是 Codex 生图工具服务器错误、超时或不可用。
```

## 发布后第一轮验证标准

- 新用户能理解仓库不是前端软件，而是资产化工作流。
- 新用户能完成 clone 和前置检查。
- 新用户能理解前置检查只验证仓库，不验证 Codex 生图能力或 Doubao 接入。
- 新用户能理解当前稳定 MVP 使用 `assets/inbox/` 作为默认图片入口。
- 新用户能理解拖图即跑是最终目标，当前环境能暴露拖图路径时才走纯拖图路线。
- Codex 不应要求用户手动输入人物名、目录、路径、张数或是否开始。
- 流程不应引导用户去控制浏览器、ChatGPT 网页版或 GPT 桌面端。
- 原图拼版不应被写成多视图参考图成功结果。
- 如果失败，失败点应能被记录为明确的文档或脚本问题。

## v0.1.1 后下一轮验证标准

- 新用户能理解 `check_workflow_prereqs.ps1` 只检查本地仓库，不检查外部 AI 能力。
- 新用户把 3-5 张人物照片放入 `assets/inbox/` 后，不需要再手动输入人物名、目录、张数或是否开始。
- `start_character_run.ps1` 在默认 `assets/inbox/` 方式和 `-SourceImagePath` 方式下都能启动人物运行。
- Codex 没有生图能力时，流程能清楚停在“生成多视图参考图”。
- Doubao 不可用时，流程能清楚停在“生成提示词队列”。

## 后续增强

- 增加更多新人物接入示例。
- 增加 Claude Code 任务包模板。
- 增加一键清点资产的脚本。
- 继续收敛 `gpt-magazine-portrait` Codex skill。
- 未来再继续外部风格迁移测试。
