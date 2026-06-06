# Release Plan

## 当前目标

把本仓库整理成可开源项目。用户不需要重新收集风格图，只需要准备一个人物的多角度照片，就能使用本仓库中的风格资产、提示词规范和任务模板生成高质量杂志写真。

当前公开 MVP 口径：配置一次，之后拖图即跑。普通用户不需要手动输入人物名、目录、路径、生成张数或“是否开始”；触发语和拖入照片本身视为默认执行授权。

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
v0.1.0-mvp: drag-photo magazine portrait workflow
```

正文：

```markdown
## What this release contains

This is the first public MVP of `gpt-magazine-portrait-workflow`.

It provides an asset-backed workflow for generating GPT Image-style magazine portraits from multi-angle character photos:

- built-in style reference assets
- example character assets and generated samples
- prompt rules and workflow documents
- Codex skill draft
- PowerShell scripts for prerequisite checks, default character run setup, directory creation, and queue validation
- task queue templates and historical workflow runs

## Standard route

1. Clone the repository.
2. Run the prerequisite check.
3. Drag multi-angle photos of one character into Codex.
4. Trigger the `gpt-magazine-portrait` workflow.
5. Codex creates default folders, generates a multiview reference, asks Claude Code + Doubao-Seed-2.0-Pro to generate a prompt queue, validates it, then uses Codex image generation to create final magazine portraits.

## Requirements

- Codex with image generation capability
- Claude Code with CC Switch, or equivalent access to Doubao-Seed-2.0-Pro
- DeepSeek V4 Pro is optional for text-only cleanup; it cannot read images

## Important boundary

This project does not use browser automation, ChatGPT web, or GPT desktop automation as a workflow route.

## MVP limitations

- This is not a one-click desktop app or SaaS.
- It does not guarantee equivalent results on non-GPT Image-style models.
- Real image quality still depends on the provided character photos, style queue quality, and Codex image generation behavior.
```

## 明天给外部试跑者的指令

只让对方验证仓库能否理解和启动，不让对方做审美反馈。

```text
请克隆这个仓库：
https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git

目标：只验证仓库的 MVP 使用说明能不能跑通，不评价图片审美，不设计新流程。

请按 README 的“配置一次，之后拖图即跑”流程操作：
1. 克隆仓库并进入目录。
2. 运行 README 里的前置检查命令。
3. 准备同一人物的 3-5 张多角度照片。
4. 把这些照片拖给 Codex。
5. 对 Codex 说：按 gpt-magazine-portrait 工作流处理这些照片。

注意：
- 不要改仓库结构。
- 不要新增自己的风格库。
- 不要使用浏览器自动化、ChatGPT 网页版或 GPT 桌面端。
- 不要让用户手动输入人物名、目录、路径、张数或“是否开始”；这个 MVP 应该默认拖图即跑。
- 如果卡住，只记录卡在哪一步、报错原文、看不懂哪句话。

请最后反馈：
1. 哪一步卡住了，或是否能走到 Codex 准备生成图片这一步。
2. README 里哪句话看不懂。
3. 哪个脚本报错，报错原文是什么。
4. 有没有被要求做多余的手动操作。
```

## 发布后第一轮验证标准

- 新用户能理解仓库不是前端软件，而是资产化工作流。
- 新用户能完成 clone 和前置检查。
- 新用户能理解“拖图给 Codex + 触发语”的日常入口。
- Codex 不应要求用户手动输入人物名、目录、路径、张数或是否开始。
- 流程不应引导用户去控制浏览器、ChatGPT 网页版或 GPT 桌面端。
- 如果失败，失败点应能被记录为明确的文档或脚本问题。

## 后续增强

- 增加更多新人物接入示例。
- 增加 Claude Code 任务包模板。
- 增加一键清点资产的脚本。
- 继续收敛 `gpt-magazine-portrait` Codex skill。
- 未来再继续外部风格迁移测试。
