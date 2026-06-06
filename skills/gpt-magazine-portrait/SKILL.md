---
name: gpt-magazine-portrait
description: 基于 gpt-magazine-portrait-workflow 资产仓库的人物杂志写真工作流。用于用户要求按 gpt-magazine-portrait 工作流处理多角度人物照片、生成多视图参考图、调用 Claude Code + Doubao-Seed-2.0-Pro 生成提示词队列、审核队列、由 Codex 生图能力生成并保存最终杂志写真时。
---

## 硬约束

1. Codex 是主控和最终生图执行者，负责生成多视图参考图、最终杂志写真、保存文件和记录结果。
2. Claude Code + CC Switch 或等价接入方式用于调用 Doubao-Seed-2.0-Pro。
3. Doubao-Seed-2.0-Pro 负责读取人物多视图参考图和风格参考图，生成提示词队列。
4. DeepSeek V4 Pro 只能做文本整理、结构化、改写和检查；不能读图，不能替代 Doubao-Seed-2.0-Pro。
5. 不得把控制浏览器、操作 ChatGPT 网页版或 GPT 桌面端作为工作流、fallback、增强能力或未来规划。
6. 生图前必须列出任务数量、风格、输出路径、是否覆盖旧图，并等待用户确认。
7. 不要重复测试用户已确认可用的模型能力、插件能力或生图路线。

## 前置条件

1. 已克隆 `gpt-magazine-portrait-workflow` 仓库到本地。
2. Codex 具备可用生图能力。
3. Claude Code 已通过 CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。
4. 用户提供同一人物的多角度照片，至少包含正脸、45 度侧脸和正侧脸。

## 使用流程

### 1. 定位仓库和创建人物目录

1. 确认当前工作目录是 `gpt-magazine-portrait-workflow` 仓库，或询问用户仓库路径。
2. 运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\make_character_dirs.ps1 -CharacterName "人物名称"
```

3. 将用户提供的多角度照片保存到 `assets/characters/<人物名>/reference/`。
4. 填写或补全 `assets/characters/<人物名>/<人物名>.md` 中的人物基本信息和不可改变项。

### 2. 生成多视图参考图

1. 读取 `templates/multiview_reference_prompt.template.md`。
2. 使用 Codex 生图能力，基于用户多角度照片生成标准化多视图参考图。
3. 保存到 `assets/characters/<人物名>/reference/`，文件名建议包含 `multiview` 或 `多视图`。
4. 生成多视图后再进入提示词队列阶段；不得跳过。

### 3. 生成提示词队列

1. 选择 `assets/style-reference/` 中适合人物气质的风格参考图。
2. 将以下材料交给 Claude Code / Doubao-Seed-2.0-Pro：
   - 人物多视图参考图
   - 人物 Markdown
   - 风格参考图
   - `templates/generation_task.template.json`
3. 要求 Claude Code 输出任务队列 JSON 到 `assets/characters/<人物名>/tasks/`。
4. 任务队列命名建议：`[YYYYMMDD]-[round]-prompt_queue.json`。

### 4. 校验和确认

1. 运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath "任务队列路径"
```

2. 如果校验失败，先修正 JSON 格式和必填字段。
3. 生图前向用户列出：
   - 任务总数
   - 每个任务 ID、人物、风格
   - 输出路径
   - 是否覆盖旧图
   - 预计生图数量和额度消耗
4. 等用户明确确认后再生图。

### 5. Codex 生图和落盘

1. Codex 按用户确认的任务队列逐张生成最终杂志写真。
2. 每次最多处理 3 个任务，避免状态混乱。
3. 保存图片到任务指定输出路径。
4. 验证图片文件存在、大小正常、可以打开。
5. 更新任务状态为 `done` 或 `failed`。

### 6. 记录结果

1. 更新人物 Markdown，追加生成图片路径。
2. 更新任务队列状态。
3. 必要时使用 `templates/generation_result.template.md` 写运行记录到 `output-records/`。
4. 只记录必要结果；不要要求用户逐张做复杂审美反馈，除非用户主动提供。
