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
6. 用户把人物照片放入 `assets/inbox/` 或拖入人物照片并触发本 skill，视为授权按默认 MVP 自动执行；不要再询问人物名、张数或是否开始。
7. 第一轮默认生成 4 张最终杂志写真；后续版本再支持用户自定义数量。
8. 只有缺少关键前置条件、任务队列无法修复、输入路径不存在或输出会覆盖旧文件时，才暂停并说明原因。
9. 不要重复测试用户已确认可用的模型能力、插件能力或生图路线。
10. 当前稳定 MVP 使用 `assets/inbox/` 作为默认图片入口；最终目标仍然是拖图即跑。
11. 不要假设 Codex Desktop 一定能把对话中的图片附件保存为本地文件。只有当前工具或上下文明确提供图片路径时，才能调用 `start_character_run.ps1 -SourceImagePath ...`；否则直接运行脚本扫描 `assets/inbox/`。
12. Codex 生图能力指当前 Codex 会话自带的生图能力；使用者账号/组织必须有 Codex 图片生成权限和可用额度。标准路线不要求用户配置 OpenAI API Key 或额外接入 OpenAI API。
13. 多视图参考图必须由 Codex 生图能力生成；原图横向拼版、截图拼版或手工拼接图不算成功结果，不得写成“多视图已完成”。
14. Codex 生图工具报服务器错误、超时或不可用时，必须停在多视图阶段并提示稍后重试；不要创建 fallback 拼版，不要继续进入 Doubao 队列或最终写真。
15. 安装本 skill 只安装流程说明和脚本副本，不等于安装完整资产仓库。执行任何仓库脚本前，必须先定位 `gpt-magazine-portrait-workflow` 项目根目录；不要从 `.codex/skills/gpt-magazine-portrait/` 安装目录运行相对路径脚本。
16. 多视图生图前必须读取 `templates/multiview_reference_prompt.template.md`，并把该模板与用户原图一起用于 Codex 生图；成功或失败都要在 stage-status JSON 中记录模板路径和原图数量。

## 前置条件

1. 已克隆 `gpt-magazine-portrait-workflow` 仓库到本地。
2. Codex 具备可用生图能力；当前账号/组织有图片生成权限和可用额度。
3. Claude Code 已通过 CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro。
4. 用户已将同一人物的多角度照片放入 `assets/inbox/`，或当前 Codex 环境能把用户拖入的图片附件暴露给 agent。
5. 用户提供的照片至少包含正脸、45 度侧脸和正侧脸。

## 使用流程

### 1. 定位仓库和启动默认运行

1. 优先在当前工作目录或其父目录中定位 `gpt-magazine-portrait-workflow` 仓库根目录。根目录必须能看到 `README.md`、`assets/`、`docs/`、`skills/`。
2. 如果当前 skill 是从 `.codex/skills/gpt-magazine-portrait/` 触发的，不要把该安装目录当成项目根目录；它不包含完整资产库。
3. 找不到项目根目录时，暂停并询问用户仓库路径，不要猜路径，不要从 skill 安装目录执行仓库脚本。
4. 定位成功后，后续 PowerShell 命令都必须以项目根目录作为工作目录执行。
5. 优先检查项目根目录下的 `assets/inbox/` 是否存在 3-5 张人物照片。当前稳定 MVP 默认从这里启动。图片文件名可以任意，脚本按常见图片扩展名识别并复制重命名。
6. 新人物测试前，`assets/inbox/` 应只保留本轮同一个人物的 3-5 张照片；不要混入风格参考图、AI 生成图、海报图、截图或上一轮残留图片。
7. 如果 `assets/inbox/` 有图片，直接运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\start_character_run.ps1
```

8. 如果用户是拖图触发，且当前 Codex 环境明确暴露了图片本地路径，也可以运行：

```powershell
powershell -ExecutionPolicy Bypass -Command "& '.\skills\gpt-magazine-portrait\scripts\start_character_run.ps1' -SourceImagePath '图片路径1','图片路径2','图片路径3'"
```

9. 如果 `assets/inbox/` 没有图片，且当前 Codex 环境也没有暴露拖图路径，暂停并说明：“未在 assets/inbox/ 找到人物照片，且当前 Codex 环境无法读取拖入图片的本地路径，无法自动启动人物运行。”
10. 如果用户没有提供人物名，使用脚本自动生成的 `character-YYYYMMDD-HHMMSS`。
11. 原始图固定保存到 `reference/originals/`；不要让用户手动选择目录。
12. 人物资料 Markdown 先由 Codex 根据可观察特征自动草拟；不要要求用户手动填写。

### 2. 生成多视图参考图

1. 读取 `templates/multiview_reference_prompt.template.md`。
2. 使用 Codex 生图能力，基于用户多角度照片生成标准化多视图参考图。输出必须遵循模板里的固定结构：纯白色背景、细黑色分区、上排 4 张全身站姿、下排 4 张坐姿/特写/身体细节、右侧列 3 张头部特写和 1 个人物信息区。
3. 保存到 `assets/characters/<人物名>/reference/multiview/`，文件名建议包含 `multiview` 或 `多视图`。
4. 生成多视图后再进入提示词队列阶段；不得跳过。
5. 如果当前 Codex 会话没有生图能力，必须在这里暂停，明确说明“缺少 Codex 生图能力”，不要伪装继续执行。
6. 如果 Codex 生图工具返回服务器错误、超时或不可用，必须在这里暂停，明确说明“多视图参考图生成失败，稍后重试”，不要用原始照片拼版替代。
7. 如果 `reference/multiview/` 中只有原图横向拼版、截图拼版、手工拼接图，或只生成 4 个半身头像视角，视为多视图失败，不得进入提示词队列。
8. 记录状态时必须区分：启动链路成功、多视图生图成功、多视图生图失败。人物目录和 manifest 生成成功，只能说明启动链路成功，不能写成多视图完成。
9. 无论成功或失败，都把阶段状态写入 manifest 中 `expected_outputs.stage_status` 指定路径；必须包含 `template_path`、`source_image_count`、`stage`、`status`、`tool`、`error`、`continued_to_prompt_queue`、`continued_to_final_portraits`、`created_raw_photo_collage_fallback`。

### 3. 调用 Claude Code 生成提示词队列

1. 只有多视图阶段明确成功后，才能进入本阶段。原图拼版、截图拼版、手工拼接图或多视图失败状态都不得进入本阶段。
2. Codex 在项目根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\invoke_claude_prompt_queue.ps1
```

3. 该脚本会读取最近的 run manifest，检查多视图参考图是否存在，生成 `tasks/<run-id>-claude-doubao-prompt.md`，并在本机存在 `claude` CLI 时用 `claude -p` 调用 Claude Code。
4. Claude Code 必须通过 CC Switch 或等价方式接入 Doubao-Seed-2.0-Pro，读取：
   - 人物多视图参考图
   - 人物 Markdown
   - `assets/style-reference/` 风格参考库
   - `templates/generation_task.template.json`
5. Claude Code 输出第一轮 4 个任务的 JSON 到 manifest 中 `expected_outputs.first_round_queue` 指定路径。
6. 如果只想生成交接提示词而不启动 Claude Code，可运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\invoke_claude_prompt_queue.ps1 -NoInvoke
```

7. 如果当前环境无法调用 Claude Code + Doubao-Seed-2.0-Pro，必须在这里暂停，明确说明“缺少 Doubao 提示词队列生成能力”；不要用 DeepSeek、普通文本模型、浏览器或 ChatGPT 网页/桌面端替代。

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
