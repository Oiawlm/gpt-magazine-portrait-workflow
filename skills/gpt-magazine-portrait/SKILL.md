---
name: gpt-magazine-portrait
description: 基于 gpt-magazine-portrait-workflow 资产仓库的人物杂志写真工作流。用于用户要求按 gpt-magazine-portrait 工作流处理多角度人物照片、生成多视图参考图、调用 Claude Code + Doubao-Seed-2.0-Pro 生成提示词队列、审核队列、由 Codex 生图能力生成并保存最终杂志写真时。
---

## 硬约束

1. Codex 是主控和最终生图执行者，负责生成多视图参考图、最终杂志写真、保存文件和记录结果。
2. Claude Code + CC Switch 或等价接入方式用于调用 Doubao-Seed-2.0-Pro。
3. Doubao-Seed-2.0-Pro 负责读取人物多视图参考图和风格参考图，生成提示词队列。
4. 当前工作流不使用 DeepSeek V4 Pro；不要把它作为任务队列、文本整理、fallback 或可选步骤。
5. 不得把控制浏览器、操作 ChatGPT 网页版或 GPT 桌面端作为工作流、fallback、增强能力或未来规划。
6. 用户拖入人物照片并触发本 skill，视为授权按默认 MVP 自动执行；不要再询问人物名、路径、张数或是否开始。
7. 第一轮默认生成 4 张最终杂志写真；后续版本再支持用户自定义数量。
8. 只有缺少关键前置条件、任务队列无法修复、输入路径不存在或输出会覆盖旧文件时，才暂停并说明原因。
9. 不要重复测试用户已确认可用的模型能力、插件能力或生图路线。

## 前置条件

1. 已克隆 `gpt-magazine-portrait-workflow` 仓库到本地。
2. Codex 具备可用生图能力。
3. Claude Code 已通过 CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。
4. 用户提供同一人物的多角度照片，至少包含正脸、45 度侧脸和正侧脸。

## 使用流程

### 1. 定位仓库和启动默认运行

1. 优先在当前工作目录或其父目录中定位 `gpt-magazine-portrait-workflow` 仓库；找不到时再询问仓库路径。
2. 运行：

```powershell
powershell -ExecutionPolicy Bypass -Command "& '.\skills\gpt-magazine-portrait\scripts\start_character_run.ps1' -SourceImagePath '图片路径1','图片路径2','图片路径3'"
```

3. 如果当前 Codex 环境能拿到拖入图片的本地路径，直接把这些路径传给 `-SourceImagePath`。
4. 如果当前 Codex 环境不能把拖入图片暴露为本地路径，引导用户把图片放到 `assets/inbox/`，然后运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\start_character_run.ps1
```

5. 如果用户没有提供人物名，使用脚本自动生成的 `character-YYYYMMDD-HHMMSS`。
6. 原始图固定保存到 `reference/originals/`；不要让用户手动选择目录。
7. 人物资料 Markdown 先由 Codex 根据可观察特征自动草拟；不要要求用户手动填写。

### 2. 生成多视图参考图

1. 读取 `templates/multiview_reference_prompt.template.md`。
2. 使用 Codex 生图能力，基于用户多角度照片生成标准化多视图参考图。
3. 保存到 `assets/characters/<人物名>/reference/multiview/`，文件名建议包含 `multiview` 或 `多视图`。
4. 生成多视图后再进入提示词队列阶段；不得跳过。
5. 如果当前 Codex 会话没有生图能力，必须在这里暂停，明确说明“缺少 Codex 生图能力”，不要伪装继续执行。

### 3. 生成提示词队列

1. 选择 `assets/style-reference/` 中适合人物气质的风格参考图。
2. 将以下材料交给 Claude Code / Doubao-Seed-2.0-Pro：
   - 人物多视图参考图
   - 人物 Markdown
   - 风格参考图
   - `templates/generation_task.template.json`
3. 要求 Claude Code 输出任务队列 JSON 到 `assets/characters/<人物名>/tasks/`。
4. 第一轮默认生成 4 个任务。
5. 任务队列命名建议：`[run-id]-first-round-prompt_queue.json`。
6. 如果当前环境无法调用 Claude Code + Doubao-Seed-2.0-Pro，必须在这里暂停，明确说明“缺少 Doubao 提示词队列生成能力”。

### 4. 校验和自动执行前检查

1. 运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath "任务队列路径"
```

2. 如果校验失败，先修正 JSON 格式和必填字段。
3. 检查人物参考图、风格参考图和输出目录是否存在。
4. 检查 `output_filename` 是否会覆盖已有文件。
5. 如果不会覆盖且前置条件完整，直接进入生图；不要二次询问用户是否开始。

### 5. Codex 生图和落盘

1. Codex 按任务队列逐张生成最终杂志写真。
2. 第一轮默认 4 张；如状态不稳定，可由 Codex 内部分批处理，但不要让用户手动选择批次。
3. 保存图片到任务指定输出路径。
4. 验证图片文件存在、大小正常、可以打开。
5. 更新任务状态为 `done` 或 `failed`。

### 6. 记录结果

1. 更新人物 Markdown，追加生成图片路径。
2. 更新任务队列状态。
3. 必要时使用 `templates/generation_result.template.md` 写运行记录到 `output-records/`。
4. 只记录必要结果；不要要求用户逐张做复杂审美反馈，除非用户主动提供。
