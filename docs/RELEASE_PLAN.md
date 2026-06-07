# Release Plan

## 当前目标

把本仓库整理成可开源项目。用户不需要重新收集风格图，只需要准备一个人物的多角度照片，就能使用本仓库中的风格资产、提示词规范和任务模板生成高质量杂志写真。

当前公开 MVP 口径：配置一次，之后拖图即跑。普通用户不需要手动输入人物名、目录、路径、生成张数或“是否开始”；触发语和拖入照片本身视为默认执行授权。

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
3. 把同一人物的多角度照片拖给 Codex。
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

## 明天给外部试跑者的指令

只让对方验证仓库能否理解和启动，不让对方做审美反馈。

```text
请打开这个仓库并从 README 开始：
https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git

目标：只验证仓库的 MVP 使用说明能不能跑通，不评价图片审美，不设计新流程。

请按 README 的“配置一次，之后拖图即跑”流程操作：
1. 克隆仓库并进入目录。
2. 运行 README 里的前置检查命令。
3. 注意：前置检查只验证仓库文件和模板，不验证 Codex 生图能力，也不验证 Doubao 接入。
4. 准备同一人物的 3-5 张多角度照片。
5. 把这些照片拖给 Codex。
6. 如果 Codex 拿不到拖图的本地路径，把这些照片放到 assets/inbox/ 后继续。
7. 对 Codex 说：按 gpt-magazine-portrait 工作流处理这些照片。

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
5. 如果卡在多视图或提示词队列阶段，记录是缺 Codex 生图能力，还是缺 Doubao 接入。
```

## 发布后第一轮验证标准

- 新用户能理解仓库不是前端软件，而是资产化工作流。
- 新用户能完成 clone 和前置检查。
- 新用户能理解前置检查只验证仓库，不验证 Codex 生图能力或 Doubao 接入。
- 新用户能理解“拖图给 Codex + 触发语”的日常入口。
- 新用户能理解拖图路径不可用时使用 `assets/inbox/`。
- Codex 不应要求用户手动输入人物名、目录、路径、张数或是否开始。
- 流程不应引导用户去控制浏览器、ChatGPT 网页版或 GPT 桌面端。
- 如果失败，失败点应能被记录为明确的文档或脚本问题。

## 后续增强

- 增加更多新人物接入示例。
- 增加 Claude Code 任务包模板。
- 增加一键清点资产的脚本。
- 继续收敛 `gpt-magazine-portrait` Codex skill。
- 未来再继续外部风格迁移测试。
