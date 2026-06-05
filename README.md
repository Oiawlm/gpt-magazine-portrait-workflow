# AI Magazine Portrait Workflow

一套基于 GPT Image 的人物杂志写真资产化工作流。

它不是通用 AI 生图工具，也不是前端项目。它的目标很具体：用户准备一个人物的多角度参考图，复用本仓库里的风格资产、提示词规则和任务模板，经由 Claude Code / Doubao-Seed-2.0-Pro 做图片理解和提示词整理，由 Codex 调度、确认、落盘，最终用 GPT Image / ChatGPT Plus 生成高质量杂志写真。

## 你能用它做什么

- 固定一个人物形象，生成多种杂志封面、写真、男刊、高奢、生活方式风格图片。
- 直接使用仓库自带的风格参考库，不用重新收集海报和参考图。
- 把每次生图任务沉淀成任务队列、人物资料、运行记录和可复用提示词规则。
- 配合 `skills/gpt-magazine-portrait/`，逐步把流程变成 Codex 可执行的自动化工作流。

## 项目结构

```text
assets/
  style-reference/        风格参考库、聚类结果、style pack
  characters/             良子、嘎子人物资料、参考图、生成样张
  source-notes/           早期提示词和对话记录
  source-images/          根目录补充图片素材
docs/
  WORKFLOW.md             完整工作流
  STANDARD.md             目录、命名、任务、反馈规范
  PROMPT_RULES.md         提示词规则
  GPT_IMAGE_GUIDE.md      GPT Image 执行说明
  AGENT_ROLES.md          Codex / Claude Code / Doubao / DeepSeek 分工
skills/
  gpt-magazine-portrait/  Codex skill 草案和脚本
templates/                人物资料、风格包、任务队列模板
workflow-runs/            已跑过的任务队列和风格谱系
output-records/           试跑记录、复盘和交接记录
```

## 工具分工

| 工具 | 负责什么 |
|---|---|
| GPT Image / ChatGPT Plus | 最终生图 |
| Claude Code + Doubao-Seed-2.0-Pro | 读人物图、读风格图、提取风格、生成提示词队列 |
| DeepSeek V4 Pro | 只做文本整理和文档总结，不能读图 |
| Codex | 调度流程、审核任务、保存文件、更新记录、维护仓库 |
| 用户 | 提供人物参考图、确认是否生图、做审美反馈 |

## 最短使用流程

### 1. 克隆仓库

```powershell
git clone https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git
cd gpt-magazine-portrait-workflow
```

如果你已经在本地：

```powershell
cd D:\Download\agent_vault\ai-magazine-portrait-workflow
```

### 2. 创建一个新人物目录

用仓库里的 skill 脚本创建目录：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\make_character_dirs.ps1 -CharacterName "xiaoming"
```

执行后会得到：

```text
assets/characters/xiaoming/
  reference/      放人物多角度参考图
  generated/      放最终生成图
  tasks/          放任务队列 JSON
  xiaoming.md     人物资料模板
```

### 3. 放入人物多角度图片

把这个人的参考图放入：

```text
assets/characters/xiaoming/reference/
```

建议至少准备：

- 正脸
- 45 度侧脸
- 正侧脸
- 全身或半身

图片越稳定，人物一致性越好。

### 4. 填写人物资料

编辑：

```text
assets/characters/xiaoming/xiaoming.md
```

重点写清楚：

- 年龄、性别、体型
- 脸型、五官、发型
- 气质
- 不可改变项

不可改变项很重要，比如“不要瘦身”“不要改变发型”“不要变成另一个人”。

### 5. 让 Claude Code / Doubao 生成任务队列

把下面这段复制给 Claude Code：

```text
请接手 gpt-magazine-portrait-workflow 项目。

先阅读：
1. PROJECT_GUIDE.md
2. README.md
3. docs/WORKFLOW.md
4. docs/PROMPT_RULES.md
5. docs/AGENT_ROLES.md
6. skills/gpt-magazine-portrait/SKILL.md

当前任务：
我已经把新人物多角度参考图放在：
assets/characters/<人物名>/reference/

人物资料在：
assets/characters/<人物名>/<人物名>.md

请使用 Claude Code 当前可用的 Doubao-Seed-2.0-Pro 做图片理解，读取这个人物参考图，并结合 assets/style-reference/ 中的风格资产，生成第一轮人物杂志写真任务队列。

要求：
1. 不要生图。
2. 不要新增图片资源。
3. 不要做风格迁移试跑。
4. 只生成任务队列 JSON 和人工可读 Markdown。
5. 每个任务必须包含 task_id、character、style_pack_id、reference_character_image、reference_style_images、core_identity_constraints、final_prompt_zh、negative_prompt_zh、output_filename、status、priority。
6. 第一轮建议 3 到 5 个任务，不要贪多。
7. 任务状态全部写 pending。
8. 输出到 assets/characters/<人物名>/tasks/。
9. 完成后运行 skills/gpt-magazine-portrait/scripts/validate_queue.ps1 验证任务队列。
```

把 `<人物名>` 替换成你的目录名，例如 `xiaoming`。

### 6. 校验任务队列

Claude Code 生成任务队列后，运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\assets\characters\xiaoming\tasks\first_round_prompt_queue.json
```

通过后再进入下一步。

### 7. 生图前必须确认

在真正调用 GPT Image 前，Codex 必须先列出：

- 本轮生成几张
- 每个任务 ID
- 使用哪些人物参考图
- 使用哪些风格参考图
- 输出文件路径
- 是否覆盖旧文件

用户确认后才允许生图。

### 8. 用 GPT Image / ChatGPT Plus 生图

推荐执行方式：

1. Codex 读取任务队列。
2. Codex 逐条提交给 GPT Image / ChatGPT Plus。
3. 每生成一张，保存到任务指定路径。
4. 保存后检查图片文件存在、大小正常、能打开。
5. 更新人物 Markdown 和任务状态。

不要为了测试而生图。额度紧张时，先改提示词和任务队列。

### 9. 用户锐评并写回规则

生图完成后，用户评价每张图：

- 人物像不像
- 风格高级不高级
- 文字有没有错
- 哪些方向值得扩展
- 哪些方向不要再做

Codex 需要把这些反馈写回：

```text
docs/PROMPT_RULES.md
assets/characters/<人物名>/<人物名>.md
output-records/
```

## Codex Skill 用法

本仓库包含一个 skill 草案：

```text
skills/gpt-magazine-portrait/
```

它现在提供：

- `SKILL.md`：Codex 执行这套工作流时的说明
- `scripts/make_character_dirs.ps1`：创建新人物目录
- `scripts/validate_queue.ps1`：校验任务队列 JSON

之后可以把这个 skill 安装到 Codex skills 目录，让 Codex 在用户说“按 gpt-magazine-portrait 工作流跑这个人”时自动触发。

## 效果展示

| 参考图 | 生成效果图 | 风格 |
|---|---|---|
| ![良子参考图](assets/characters/良子/images/00-良子-多视角参考图.png) | ![秋日休闲复古风](assets/characters/良子/images/01-秋日休闲复古风.png) | 秋日休闲复古风 |
| ![嘎子参考图](assets/characters/嘎子/images/00-嘎子-多视角参考图.png) | ![红绳镜面西装封面](assets/characters/嘎子/images/11-红绳镜面西装封面.png) | 杂志封面风 |

更多效果见 [assets/SHOWCASE.md](assets/SHOWCASE.md)。

## 常见问题

### 为什么最终生图推荐 GPT Image？

这套风格资产和提示词经验是围绕 GPT Image / ChatGPT Plus 试出来的。其他模型可以参考流程，但不保证同样效果。

### DeepSeek V4 Pro 能不能读图？

不能。它只适合文本整理、规则总结、文档改写，不负责图像理解。

### 第一轮应该生成多少张？

建议 3 到 5 张。先验证人物一致性和风格方向，不要一上来批量铺太多。

### 文字总是漂移怎么办？

减少小字要求，明确最大主视觉文字；如果画面很好但文字错了，优先在同一 GPT Image 对话里定向编辑。

## 贡献

欢迎提交 Issue 和 PR。贡献前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
