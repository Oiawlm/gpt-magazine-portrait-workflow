# GPT Magazine Portrait Workflow

一套基于 Codex 生图能力和 GPT Image 效果基准的人物杂志写真资产化工作流：配置一次，之后把同一人物的多角度照片交给 Codex，就按仓库内置风格资产生成杂志写真。

它不是通用 AI 生图工具，也不是前端项目。它的目标很具体：用户提供一个人物的多角度参考图，复用本仓库里的风格资产、提示词规则和任务模板，经由 Claude Code / Doubao-Seed-2.0-Pro 做图片理解和提示词队列整理，由 Codex 调度、最终生图和落盘，生成高质量杂志写真。

当前稳定 MVP 使用 `assets/inbox/` 作为默认图片入口；用户把照片放入该目录后触发工作流。纯拖图即跑是最终目标，只有当前 Codex 环境能把拖入图片附件暴露为本地路径时才走这条路线。

**仓库定位**：资产库 + 工作流文档 + Codex skill 草案 + 默认脚本。当前版本是 MVP，不是独立软件。

## 先看这三件事

### 1. 这是什么

把同一个人的 3-5 张多角度照片交给 Codex，触发本仓库的 `gpt-magazine-portrait` 工作流，生成带杂志封面、写真、男刊、高奢、生活方式气质的人物图片。当前稳定 MVP 的交付方式是把照片放入 `assets/inbox/`；纯拖图即跑是后续在环境支持时使用的路线。

### 2. 你需要什么

- Codex 具备可用生图能力：当前账号/组织需要有 Codex 图片生成权限和可用额度；没有这项能力只能跑启动链路，不能完整出图。
- Claude Code 已通过 CC Switch，或等价方式接入 Doubao-Seed-2.0-Pro。
- 同一个人的 3-5 张多角度照片，建议包含正脸、45 度侧脸、侧脸或半身/全身照。

注意：这里说的 Codex 生图能力，是 Codex 当前会话本身可用的生图能力；标准路线不要求用户配置 OpenAI API Key。仓库脚本只能检查文件、模板和任务队列格式，不能自动验证你的账号是否有 Codex 图片生成权限和额度，也不能自动验证 Doubao 是否已接入。

### 3. 你不需要做什么

- 不需要重新收集风格图，仓库已带风格参考资产。
- 不需要手动填写人物名、目录、路径、生成张数或“是否开始”。
- 不使用浏览器自动化、ChatGPT 网页版或 GPT 桌面端。
- 不使用 DeepSeek V4 Pro。

## 快速开始
本项目的最终目标是“配置一次，之后拖图即跑”。在当前 Codex Desktop 无法稳定暴露拖入附件路径的情况下，稳定 MVP 使用仓库内固定图片入口 `assets/inbox/`。普通用户不需要填写人物名、生成张数或任务参数。

如果你只想验证仓库脚本能不能跑，不消耗生图额度，先看 [无生图快速测试](docs/QUICKSTART_TEST.md)。

### 配置一次

如果你会用 git，运行：

```powershell
git clone https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git
cd gpt-magazine-portrait-workflow
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\check_workflow_prereqs.ps1
```

如果你不会用 git，打开仓库页面，点击绿色 **Code** 按钮，选择 **Download ZIP**，下载后解压。然后在解压后的项目根目录打开 PowerShell，运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\check_workflow_prereqs.ps1
```

ZIP 解压后的文件夹名可能是 `gpt-magazine-portrait-workflow-main`，这是正常的；只要里面能看到 `README.md`、`assets/`、`docs/`、`skills/`，就是项目根目录。

这个命令只代表“仓库文件和模板正常”，不代表 Codex 生图能力或 Doubao 接入已经可用。

### 当前稳定 MVP

把同一个人物的 3-5 张多角度照片放入：

```text
assets/inbox/
```

图片文件名可以是任意名称，例如微信导出的文件名、截图文件名或相机原始文件名；脚本只要求它们是常见图片扩展名，例如 `.png`、`.jpg`、`.jpeg`、`.webp`。

每次测试新人物前，先确认 `assets/inbox/` 里只有本轮这个人的照片。不要混入风格参考图、海报图、AI 生成图、截图或上一轮残留图片；否则 Codex 会把它们也当作人物参考输入。

然后用 Codex 打开这个项目根目录，也就是能看到 `README.md`、`assets/`、`docs/`、`skills/` 的那个文件夹。在 Codex 里发一句：

```text
按 gpt-magazine-portrait 工作流处理这些照片。
```

Codex 会自动扫描 `assets/inbox/`，调用 `start_character_run.ps1` 创建人物运行目录。用户不需要手动填写人物名、目录名、生成张数或“是否开始”。

如果当前 Codex 环境能把拖入图片附件暴露为本地路径，也可以直接拖图给 Codex；这是最终目标路线。当前稳定 MVP 先以 `assets/inbox/` 保证流程能真实启动。

Codex 默认执行：

1. 自动创建人物运行目录。
2. 读取并保存 `assets/inbox/` 中的原始照片。
3. 用 Codex 生图能力生成 AI 标准化多视图参考图。
4. 让 Claude Code + Doubao-Seed-2.0-Pro 读取多视图和风格库，生成第一轮 4 个任务。
5. 校验任务队列。
6. 由 Codex 自动生成最终杂志写真并保存。
7. 更新人物资料、任务状态和运行 manifest。

多视图这一步必须读取并使用仓库内置提示词：

```text
templates/multiview_reference_prompt.template.md
```

Codex 应把这份模板和 `assets/inbox/` 里的同一人物原图一起用于生图。无论成功或失败，都应在本轮 `runs/*-stage-status.json` 里记录使用的模板路径、原图数量、状态和错误原因。

## 小白只测多视图

如果只是帮忙测试，不要跑完整流程。按下面做：

1. 用 GitHub **Download ZIP** 下载仓库并解压。
2. 打开解压后的内层项目文件夹，确认能看到 `README.md`、`assets/`、`docs/`、`skills/`。
3. 打开 `assets/inbox/`，删除里面除 `.gitkeep` 之外的旧图片。
4. 放入同一个人物的 3-5 张照片，只放真人原始照片，不放海报、风格图、AI 图或截图。
5. 用 Codex 打开这个项目文件夹。
6. 对 Codex 发送：

```text
按 gpt-magazine-portrait 工作流处理这些照片。先只执行到“读取 templates/multiview_reference_prompt.template.md，并用这份提示词和 assets/inbox/ 里的原图生成 AI 标准化多视图参考图，保存到 reference/multiview/”这一步。无论成功或失败，都把阶段状态写入 runs/*-stage-status.json。不要继续生成提示词队列，也不要生成最终写真。
```

反馈时只需要看三件事：

- 是否读取并使用了 `templates/multiview_reference_prompt.template.md`。
- 是否生成了真正的 AI 标准化多视图参考图。
- 如果失败，`runs/*-stage-status.json` 是否记录了错误，并且没有创建原图拼版 fallback。

触发语和图片本身视为本轮执行授权；MVP 默认不再二次询问人物名、目录、张数或是否开始。只有缺少关键前置条件，或即将覆盖已有输出文件时，Codex 才停下来说明问题。

如果 Codex 当前没有生图能力，或生图工具返回服务器错误、超时、不可用，流程会停在“生成多视图参考图失败”，稍后重试。原图横向拼版不算多视图参考图成功结果，不得继续进入 Doubao 提示词队列或最终写真生成。如果 Claude Code / Doubao-Seed-2.0-Pro 不可用，流程会停在“生成提示词队列”。这些情况不是脚本错误，而是外部能力未就绪或临时失败。

请把下面三种状态分开判断：

| 状态 | 含义 | 能否继续 |
|---|---|---|
| 启动链路成功 | `assets/inbox/` 被扫描，人物目录、原图副本和 manifest 已生成 | 不能代表多视图成功 |
| 多视图生图成功 | Codex 生图能力生成了 AI 标准化 reference sheet，并保存到 `reference/multiview/` | 可以进入 Doubao 队列 |
| 多视图生图失败 | Codex 生图能力不可用、服务器错误、超时，或目录里只有原图拼版 | 停止，稍后重试 |

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
  GPT_IMAGE_GUIDE.md      Codex 生图执行说明
  AGENT_ROLES.md          Codex / Claude Code / Doubao 分工
skills/
  gpt-magazine-portrait/  Codex skill 草案和脚本
templates/                人物资料、风格包、任务队列模板
workflow-runs/            已跑过的任务队列和风格谱系
output-records/           试跑记录、复盘和交接记录
```

注意：`assets/characters/*/generation_tasks.json` 是早期人物风格记录，用来展示已有风格探索历史；它不是 `validate_queue.ps1` 的标准任务队列输入。标准任务队列请参考 `templates/generation_task.template.json` 和 `workflow-runs/*/*prompt_queue.json`。

## 工具分工

| 工具 | 负责什么 |
|---|---|
| Codex | 主控流程、创建默认目录、审核任务、最终生图、保存文件、记录结果 |
| Claude Code + Doubao-Seed-2.0-Pro | 读人物图、读风格图、提取风格、生成提示词队列 |
| 用户 | 提供人物参考图；后续可选给审美反馈 |

## v0.1.0-mvp 版本重要说明
当前为首个开源MVP版本，有以下客观限制，请知晓：
1. **Codex 生图依赖**：标准路线要求 Codex 具备可用的生图能力，用于生成多视图参考图和最终杂志写真。
2. **Doubao 依赖**：自动生成任务队列需要 Claude Code 已配置 CC Switch，或通过等价方式接入 Doubao-Seed-2.0-Pro。
3. **DeepSeek 边界**：当前工作流不使用 DeepSeek V4 Pro；不要把它作为任务队列、文本整理、fallback 或可选步骤写入本项目流程。
4. **禁止 UI 自动化路线**：本项目不使用控制浏览器、操作 ChatGPT 网页版或 GPT 桌面端作为工作流、fallback 或未来规划。
5. **效果基准**：本工作流的提示词和风格优化以 GPT Image 效果为基准，使用其他生图模型效果不做保证。

默认目录结构：

```text
assets/characters/<auto-character-id>/
  reference/
    originals/    → 用户拖入的原始照片
    multiview/    → Codex 生成的多视图参考图
  generated/      → 最终杂志写真
  tasks/          → Doubao 生成的任务队列
  runs/           → 本轮运行 manifest
  <auto-character-id>.md
```

### 多视图参考图
**这步是人物不崩的核心，由 Codex 生图能力生成：**
1. 读取提示词：`templates/multiview_reference_prompt.template.md`
2. 使用你准备的多角度人物照片作为参考
3. 生成包含"正面+左侧面+右侧面+三分之四侧脸"的多视图参考图
4. 保存到 `assets/characters/<auto-character-id>/reference/multiview/` 目录

⚠️ 重要提示：Doubao-Seed 只负责读图，不负责生成这张图。多视图参考图必须是 Codex 生图能力生成的 AI 标准化 reference sheet；把原始照片横向拼在一起的图片只是拼版，不算成功结果。如果 Codex 生图服务器错误或超时，必须停在这里并提示稍后重试，不要创建拼版 fallback，不要继续任务队列或最终写真。

### 任务队列
Claude Code 会通过 Doubao-Seed-2.0-Pro 自动：
- 调用 Doubao-Seed-2.0-Pro 读图
- 结合风格库生成提示词
- 输出第一轮 4 个任务到 `assets/characters/<auto-character-id>/tasks/`
- 自动运行校验脚本验证格式

### 自动生图
队列校验通过后，Codex 按任务队列逐张生成图片，并把结果保存到 `generated/` 目录。本项目不使用控制浏览器、操作 ChatGPT 网页版或 GPT 桌面端作为执行路线。

### 记录结果
生成完成后：
1. 将图片保存到任务指定目录。
2. 更新任务状态和人物资料。
3. 必要时把执行结果写入 `output-records/`。

---

## 完整详细流程
如果需要更多控制，可以按下面的完整流程操作：

<details>
<summary>点击展开完整流程</summary>

### 完整流程1：准备阶段
- 1.1 克隆仓库到本地
- 1.2 运行 `check_workflow_prereqs.ps1`
- 1.3 当前稳定 MVP：用户把同一人物多角度照片放入 `assets/inbox/`；如果当前环境暴露拖图本地路径，也可以直接拖给 Codex
- 1.4 Codex 调用 `start_character_run.ps1` 创建默认运行目录并复制原图

### 完整流程2：多视图生成
- 2.1 使用多视图提示词模板
- 2.2 通过 Codex 生图能力生成标准化多视图参考图
- 2.3 保存到 `reference/multiview/` 作为核心参考；如果生成失败，停止并提示稍后重试，原图拼版不算成功

### 完整流程3：人物资料完善
- 3.1 Codex 根据用户原图和多视图自动草拟人物资料
- 3.2 记录可观察到的面部特征和体型
- 3.3 明确气质定位和适合风格
- 3.4 列出不可改变的核心特征

### 完整流程4：任务队列生成
- 4.1 选择适合的风格包
- 4.2 调用 Doubao-Seed 读取人物图和风格图
- 4.3 生成结构化任务队列JSON
- 4.4 运行校验脚本验证格式正确性

### 完整流程5：自动执行前检查
- 5.1 检查任务 JSON 是否通过校验
- 5.2 检查人物参考图和风格参考图是否存在
- 5.3 检查输出文件是否会覆盖旧文件
- 5.4 若不会覆盖且前置条件完整，直接进入 Codex 生图

### 完整流程6：Codex 生图执行
- 6.1 Codex 按任务队列逐条生成图片
- 6.2 每生成一张立即保存到指定路径
- 6.3 验证文件完整性和可访问性
- 6.4 实时更新任务状态

### 完整流程7：记录结果
- 7.1 更新人物 Markdown，添加生成图片路径
- 7.2 更新任务队列的最终状态
- 7.3 记录执行结果到 output-records

</details>

## Codex Skill 用法

本仓库包含一个 skill 草案：

```text
skills/gpt-magazine-portrait/
```

它现在提供：

- `SKILL.md`：Codex 执行这套工作流时的说明
- `scripts/check_workflow_prereqs.ps1`：检查仓库前置条件
- `scripts/install_codex_skill.ps1`：可选，把本仓库 skill 安装到本机 Codex skills 目录
- `scripts/start_character_run.ps1`：按默认目录启动新人物运行并复制拖入图片
- `scripts/make_character_dirs.ps1`：创建新人物目录
- `scripts/validate_queue.ps1`：校验任务队列 JSON

当前仓库内的 skill 是流程说明和脚本集合。MVP 阶段不安装也可以用：用 Codex 打开项目根目录后，发送“按 gpt-magazine-portrait 工作流处理这些照片”即可。

如果你想配置一次、后续在新 Codex 会话里更容易触发，可以可选安装到本机 Codex skills 目录：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\install_codex_skill.ps1
```

如果本机已经安装过旧版本，要覆盖安装：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\install_codex_skill.ps1 -Force
```

安装只会把 skill 说明和脚本副本复制到本机 Codex skills 目录，不会复制本仓库的 `assets/` 风格库、人物样张和模板。安装后仍然要用 Codex 打开项目根目录，也就是能看到 `README.md`、`assets/`、`docs/`、`skills/` 的那个文件夹；照片仍放 `assets/inbox/`，不要在 `.codex/skills/gpt-magazine-portrait/` 里运行仓库脚本。

安装后建议重新打开 Codex 新会话，再用项目根目录和 `assets/inbox/` 跑当前稳定 MVP。

## 无生图测试

如果你只是想确认仓库脚本和模板能运行，不需要准备人物照片，也不需要消耗生图额度。见 [docs/QUICKSTART_TEST.md](docs/QUICKSTART_TEST.md)。

## 效果展示

### 完整流程对比（三列直观展示）
**流程：用户原始照片 → AI生成标准化多视图参考图 → 最终杂志写真**
| 用户原始参考照片 | AI生成多视图参考图（锁定人物一致性） | 最终生成效果 |
|------------------|----------------------------------------|--------------|
| <img src="assets/examples/liangzi_raw/image-1.png" width="80"> <img src="assets/examples/liangzi_raw/image-2.png" width="80"> <img src="assets/examples/liangzi_raw/image-3.png" width="80"> | <img src="assets/characters/良子/images/00-良子-多视角参考图.png" width="250"> | <img src="assets/characters/良子/images/10-试跑-港口硬朗西装风.png" width="250"> <br> 港口硬朗西装风 |
| <img src="assets/examples/gazi_raw/195fc7e9567d5c6addc659277e02d50f.png" width="80"> <img src="assets/examples/gazi_raw/1b084ddab188eba4fe5c691f38160ce1.png" width="80"> <img src="assets/examples/gazi_raw/1c13035c651e9c145c481540e4359cb5.png" width="80"> | <img src="assets/characters/嘎子/images/00-嘎子-多视角参考图.png" width="250"> | <img src="assets/characters/嘎子/images/11-红绳镜面西装封面.png" width="250"> <br> 红绳镜面西装封面 |

### 更多风格效果
#### 良子其他风格
| 未来都市机能风 | 新中式武侠风 | 海岛轻奢度假风 |
|----------------|--------------|----------------|
| <img src="assets/characters/良子/images/02-未来都市机能风.png" width="250"> | <img src="assets/characters/良子/images/04-新中式武侠风.png" width="250"> | <img src="assets/characters/良子/images/06-海岛轻奢度假风.png" width="250"> |

#### 嘎子其他风格
| 极简近景肖像封面 | 报纸纪实侧颜封面 | 男士杂志海报 |
|----------------|--------------|----------------|
| <img src="assets/characters/嘎子/images/12-极简近景肖像封面.png" width="250"> | <img src="assets/characters/嘎子/images/13-报纸纪实侧颜封面.png" width="250"> | <img src="assets/characters/嘎子/images/gazi_sp001_mens_magazine_poster.png" width="250"> |

更多效果见 [assets/SHOWCASE.md](assets/SHOWCASE.md)。

## 常见问题

### 为什么强调 Codex 生图能力？

这套风格资产和提示词经验以 GPT Image 效果为基准，但本项目的标准执行路线是由 Codex 直接完成多视图参考图和最终图片生成，不使用 ChatGPT 网页版或桌面端操作。

### DeepSeek V4 Pro 在这个流程里用不用？

不用。当前标准工作流只使用 Codex、Claude Code 和 Doubao-Seed-2.0-Pro；DeepSeek V4 Pro 不进入本项目执行路线。

### 第一轮应该生成多少张？

建议 3 到 5 张。先验证人物一致性和风格方向，不要一上来批量铺太多。

### 文字总是漂移怎么办？

减少小字要求，明确最大主视觉文字；必要时让 Codex 基于同一任务做定向修正，不要无限重跑。

## 贡献

欢迎提交 Issue 和 PR。贡献前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 贡献者
- [Oiawlm](https://github.com/Oiawlm) - 项目发起与核心开发，流程设计、风格资产整理、经验沉淀

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
