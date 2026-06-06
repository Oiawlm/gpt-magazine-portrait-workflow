# Automation Skill Design

## 结论

这个项目最终应该是“资产仓库 + Codex skill”的组合。

- 仓库负责保存资产、样张、风格库、模板、规范和历史运行记录。
- Skill 负责让 Codex 知道如何拿到一个新人物的多角度照片后，按固定步骤执行整套流程。

单独做 skill 不够，因为 skill 不适合塞大量图片资产。单独做仓库也不够，因为仓库只能放文件，不能让 Codex 自动知道下一步怎么跑。

## Skill 应该做什么

当用户把一个人的多角度图片交给 Codex，并说“按这个项目跑一轮人物写真工作流”时，skill 应该指导 Codex：

1. 在仓库中为新人物自动创建默认运行目录。
2. 保存用户拖入的人物参考图到固定位置。
3. 生成或整理人物核心设定。
4. 调用现有风格参考库和 style pack。
5. 把人物设定、风格包、用户需求交给 Claude Code / Doubao-Seed-2.0-Pro 生成提示词队列。
6. 读取并校验提示词队列。
7. 检查是否缺少关键前置条件或覆盖已有输出。
8. 如果不存在阻塞问题，使用 Codex 生图能力按默认数量批量生图。
9. 保存图片。
10. 更新人物 Markdown、任务队列、运行记录。
11. 如果用户主动锐评，把用户反馈写回提示词规则。

## Skill 不应该做什么

- 不内置大量图片资产。
- 不要求用户手动输入人物名、目录、张数、路径或“是否开始”。
- 不默认使用 DeepSeek V4 Pro 看图，因为它不能看图。
- 不允许用 DeepSeek V4 Pro 替代 Doubao-Seed-2.0-Pro 的图片理解职责。
- 不承诺其他生图模型能达到 GPT Image 的效果。
- 不在额度紧张时做测试图。

## 推荐 skill 名称

```text
gpt-magazine-portrait
```

## 推荐触发语

- “按 gpt-magazine-portrait 工作流给这个人生成杂志写真”
- “我上传了多角度人物图，跑一轮人物写真”
- “用这个仓库的风格资产给新人物生成提示词队列”
- “审核这一轮人物写真任务队列并准备生图”

## Skill 资源结构

Skill 本体可以很小：

```text
gpt-magazine-portrait/
  SKILL.md
  references/
    workflow.md
    prompt-rules.md
    task-schema.md
  scripts/
    validate_queue.ps1
    make_character_dirs.ps1
```

图片资产仍然放在本仓库：

```text
gpt-magazine-portrait-workflow/
  assets/
  docs/
  templates/
  workflow-runs/
```

## MVP 自动化边界

第一版 skill 不需要全自动控制所有软件。它只要把流程固定下来：

- 能接新人物图片。
- 能创建人物目录。
- 能准备 Claude Code / Doubao 任务包。
- 能审核返回的任务队列。
- 能让 Codex 执行最终生图并落盘。

## v1.1 两阶段使用模型

### 配置阶段

用户第一次使用或换电脑时执行一次：

1. 克隆 `gpt-magazine-portrait-workflow` 仓库。
2. 运行 `docs/QUICKSTART_TEST.md` 中的无生图测试。
3. 确认 Codex 具备可用生图能力。
4. 确认 Claude Code 可通过 CC Switch 或等价方式调用 Doubao-Seed-2.0-Pro。
5. 记录仓库路径，便于后续新 Codex 窗口直接复用。

### 日常拖图生成阶段

用户隔天或隔一段时间再次使用时，只需要把人物多角度照片拖给 Codex，并输入触发语：

```text
按 gpt-magazine-portrait 工作流处理这些照片，生成 6 张高级杂志写真。
```

Codex 应执行：

1. 找到已配置的仓库路径。
2. 调用 `start_character_run.ps1` 创建默认人物目录并保存用户上传的原始照片。
3. 使用 Codex 生图能力生成该人物多视图参考图。
4. 将多视图参考图、人物资料、风格参考图交给 Claude Code / Doubao-Seed-2.0-Pro。
5. 读取 Claude Code 输出的任务队列 JSON 和 Markdown。
6. 运行 `validate_queue.ps1` 校验任务队列。
7. 检查输出是否会覆盖已有文件；如不会覆盖，直接由 Codex 生成最终杂志写真并保存到 `generated/`。
8. 如果用户没有指定张数，第一轮默认生成 4 张。
9. 更新人物 Markdown、任务状态和运行记录。

触发语和拖入照片本身视为执行授权；公开 MVP 不再二次询问人物名、路径、张数或是否开始。只有缺少 Codex 生图能力、缺少 Doubao 接入、队列校验无法修复、输入路径不存在或输出会覆盖旧文件时，才暂停并说明原因。

## 默认路径

```text
assets/characters/<auto-character-id>/
  reference/
    originals/    用户拖入的原始照片
    multiview/    Codex 生成的多视图参考图
  generated/      最终杂志写真
  tasks/          Doubao 生成的任务队列
  runs/           run manifest
  <auto-character-id>.md
```

## 当前优先级

1. 先把仓库推到 GitHub。
2. 让 Claude Code 接手继续完善 README、模板和 skill 设计。
3. 将当前 skill 草案收敛为可安装/可触发的 Codex skill。
4. 最后用一个新人物跑一次端到端验证。
