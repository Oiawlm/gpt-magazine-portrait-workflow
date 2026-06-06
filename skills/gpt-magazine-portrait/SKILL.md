---
name: gpt-magazine-portrait
description: 基于 GPT Image 的人物杂志写真工作流，配合 gpt-magazine-portrait-workflow 资产仓库使用。用于用户要求按 gpt-magazine-portrait 工作流生成杂志写真、上传多角度人物图跑一轮写真、用仓库风格资产生成提示词队列、审核人物写真任务队列并准备手动生图时。
---
## 触发场景

- 用户说“按 gpt-magazine-portrait 工作流给这个人生成杂志写真”
- 用户上传多角度人物图并要求跑一轮人物写真
- 用户要求用本仓库风格资产给新人物生成提示词队列
- 用户要求审核人物写真任务队列并准备生图

## 前置条件
1. 已经克隆 gpt-magazine-portrait-workflow 仓库到本地
2. 已经准备好人物的多角度参考图（至少正脸、45° 侧脸、正侧脸）
3. 拥有 ChatGPT Plus 账号可以使用 GPT Image
4. Claude Code 已经配置好 CC Switch 可以切换到 Doubao-Seed-2.0-Pro
## 使用流程
### 前置检查规则
1. 先检查当前人物是否已有标准化多视图参考图
2. 如果没有多视图参考图，必须先生成多视图提示词并指导用户生成多视图参考图，禁止直接进入风格队列阶段
3. 检查用户是否已经确认过类似能力，不要重复测试用户已确认跑通过的流程
4. 当前 MVP 不自动调用 GPT Image API；所有生图操作必须经过用户确认，并由用户在 ChatGPT Plus / GPT Image 中手动执行

### 第一步：创建人物资产
1. 运行 `powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\make_character_dirs.ps1 -CharacterName "人物名称"` 创建目录结构
2. 引导用户将人物多角度参考图放入 `assets/characters/<名称>/reference/` 目录（至少包含正脸、45°侧脸、正侧脸）
3. 自动生成人物资料模板，引导用户填写 `assets/characters/<名称>/<名称>.md`，重点确认不可改变项

### 第二步：生成多视图人物参考图（无多视图时必须执行）
1. 检查 `assets/characters/<名称>/reference/` 目录下是否已有标准化多视图参考图（文件名包含"多视图"或"multiview"）
2. 如果没有：
   - 读取 `templates/multiview_reference_prompt.template.md` 生成多视图提示词
   - 列出需要上传的人物参考图清单
   - 指导用户通过 GPT Image / ChatGPT Plus 生成多视图参考图
   - 提示用户将生成的多视图参考图保存到 `assets/characters/<名称>/reference/` 目录
   - 等待用户确认多视图参考图生成完成后，再进入下一步
3. **注意：本步骤由用户使用 GPT Image 完成，Doubao-Seed-2.0-Pro 不负责生成图片，仅负责后续读取参考图生成提示词**

### 第三步：生成风格包和任务队列（必须有多视图后执行）
1. 确认多视图参考图已存在
2. 从 `assets/style-reference/` 中推荐适合当前人物的风格包（可根据人物气质和性别自动筛选）
3. 调用 Doubao-Seed-2.0-Pro 读取人物图（优先使用多视图参考图）和风格参考图，结合人物资料生成提示词队列
4. 任务队列文件统一输出到 `assets/characters/<人物名>/tasks/` 目录，命名格式为 `[YYYYMMDD]-[round]-prompt_queue.json`
5. 自动运行 `powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath "任务队列路径"` 验证 JSON 格式
6. 如果验证失败，自动修正格式问题后重新验证

### 第四步：审核与确认（生图前必须执行）
1. 自动列出本轮任务详情：
   - 任务总数量
   - 每个任务的 ID、风格名称、输出路径
   - 是否覆盖已有文件
   - 预计消耗额度
2. 明确告知用户生图需要使用 GPT Image / ChatGPT Plus 额度
3. 等待用户明确确认后，才允许执行生图
4. 如果用户取消，终止流程并保存当前任务队列

### 第五步：执行生图
1. 按照用户确认的任务列表，指导用户逐条在 GPT Image / ChatGPT Plus 中生成图片
2. 每次最多处理3个任务，避免频率限制和人工保存混乱
3. 每生成一张图片，提示用户保存到任务指定的输出路径
4. 用户保存后，验证图片文件存在、大小正常、可以正常打开
5. 更新任务队列中的状态（pending → done/failed）

### 第六步：记录结果
1. 必要时使用 `templates/generation_result.template.md` 记录执行结果
2. 更新人物 Markdown 文档，添加生成图片路径
3. 更新任务队列的最终状态
4. 必要时写入 `output-records/` 运行记录
5. 当前 MVP 不要求用户逐张做复杂审美反馈
## 工具依赖
- GPT Image / ChatGPT Plus（最终生图）
- Doubao-Seed-2.0-Pro（图片理解和提示词生成）
- PowerShell 7+（脚本执行）
## 注意事项
- 生图前必须获得用户确认；当前 MVP 不提供 GPT Image API 自动批量调用
- DeepSeek V4 Pro 不能读取图片，仅用于文本整理
- 不承诺其他生图模型能达到 GPT Image 的效果
- 额度紧张时优先优化提示词，不重复测试
