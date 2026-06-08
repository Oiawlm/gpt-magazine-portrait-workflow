# Agent Roles

## Codex

负责主控、工程化整理和最终生图：

- 维护仓库结构。
- 审核任务队列。
- 按默认目录和默认数量自动执行新人物第一轮任务。
- 使用 Codex 生图能力生成多视图参考图和最终杂志写真。
- 保存生成图片。
- 更新人物 Markdown、任务队列和运行记录。
- 把用户反馈写回规则。
- 多视图成功后，优先运行 `skills/gpt-magazine-portrait/scripts/invoke_claude_prompt_queue.ps1` 调用 Claude Code 生成提示词队列。

Codex 不应在额度紧张时做无意义测试。

Codex 不得把控制浏览器、操作 ChatGPT 网页版或 GPT 桌面端作为本项目工作流、fallback 或未来规划。

## Claude Code

负责长文本整理和模型切换协作：

- 通过 CC Switch 或等价方式选择 Doubao-Seed-2.0-Pro。
- 接收 Codex 通过 `invoke_claude_prompt_queue.ps1` 生成的任务说明。
- 生成风格包、任务队列、复盘草案。
- 适合处理较长 Markdown 和 JSON 文件。

标准提示词队列生成路线要求 Claude Code 能接入 Doubao-Seed-2.0-Pro；没有 CC Switch 时，需要具备等价的 Doubao-Seed-2.0-Pro 接入方式。

如果本机存在 `claude` CLI，Codex 应优先用 `claude -p` 非交互调用 Claude Code。不要把“复制长提示词给 Claude Code”作为默认路线；它只是在 CLI 不可用时的降级说明。

## Doubao-Seed-2.0-Pro

负责图片理解和风格提取：

- 读取人物多视角图。
- 读取风格参考图。
- 进行质量筛选、风格聚类、style pack 定稿。
- 生成符合人物设定的具体提示词。

它是提示词生成和风格理解主力。

## DeepSeek V4 Pro

当前不使用。

本项目的标准流程不把 DeepSeek V4 Pro 作为任务队列、文本整理、fallback 或可选步骤。需要文字整理时，仍由 Codex 或 Claude Code 在当前执行上下文中完成；图片理解和提示词队列继续依赖 Doubao-Seed-2.0-Pro。

## Codex 生图能力 / GPT Image 效果基准

负责最终视觉结果：

- 最终执行由 Codex 生图能力完成。
- 风格和提示词经验以 GPT Image 效果为基准。
- 其他模型可以参考流程，但不保证同等效果。
- 文字漂移时优先尝试定向修正。
- 生成图必须落盘并记录。

## 用户

用户负责关键审美判断：

- 提供同一人物的多角度参考图。
- 判断人物是否像。
- 判断风格是否高级。
- 指出文字、构图、气质的问题。
- 在默认 MVP 之外，需要扩展、重跑或覆盖旧图时作出决定。

用户反馈是规则更新的来源，不是简单评价。
