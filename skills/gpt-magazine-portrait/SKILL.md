---
name: gpt-magazine-portrait
description: 基于 GPT Image 的人物杂志写真自动化生成工作流，配合 ai-magazine-portrait-workflow 资产仓库使用。用于用户要求按 gpt-magazine-portrait 工作流生成杂志写真、上传多角度人物图跑一轮写真、用仓库风格资产生成提示词队列、审核人物写真任务队列并准备生图时。
---
## 触发场景

- 用户说“按 gpt-magazine-portrait 工作流给这个人生成杂志写真”
- 用户上传多角度人物图并要求跑一轮人物写真
- 用户要求用本仓库风格资产给新人物生成提示词队列
- 用户要求审核人物写真任务队列并准备生图

## 前置条件
1. 已经克隆 ai-magazine-portrait-workflow 仓库到本地
2. 已经准备好人物的多角度参考图（至少正脸、45° 侧脸、正侧脸）
3. 拥有 ChatGPT Plus 账号可以使用 GPT Image
4. Claude Code 已经配置好 CC Switch 可以切换到 Doubao-Seed-2.0-Pro
## 使用流程
### 第一步：创建人物资产
1. 运行 `scripts/make_character_dirs.ps1 <人物名称>` 创建目录结构
2. 将人物参考图放入 `assets/characters/<名称>/reference/` 目录
3. 按模板填写 `assets/characters/<名称>/<名称>.md` 人物资料
### 第二步：生成风格包和任务队列
1. 从 `assets/style-reference/` 选择适合的风格包
2. 调用 Doubao-Seed-2.0-Pro 读取人物图和风格图，生成提示词队列
3. 运行 `scripts/validate_queue.ps1 <任务队列路径>` 验证 JSON 格式
### 第三步：审核与确认
1. 自动列出本轮任务：数量、任务 ID、输出路径、是否覆盖旧图
2. 等待用户确认后才执行生图
### 第四步：执行生图
1. 使用 GPT Image / ChatGPT Plus 按任务队列生图
2. 保存图片到指定输出路径
3. 验证图片文件完整性
### 第五步：记录与迭代
1. 更新人物 Markdown 文档
2. 更新任务队列状态
3. 记录用户反馈到 `output-records/`
4. 将有效规则沉淀到 `docs/PROMPT_RULES.md`
## 工具依赖
- GPT Image / ChatGPT Plus（最终生图）
- Doubao-Seed-2.0-Pro（图片理解和提示词生成）
- PowerShell 7+（脚本执行）
## 注意事项
- 生图前必须获得用户确认，禁止自动生图
- DeepSeek V4 Pro 不能读取图片，仅用于文本整理
- 不承诺其他生图模型能达到 GPT Image 的效果
- 额度紧张时优先优化提示词，不重复测试
