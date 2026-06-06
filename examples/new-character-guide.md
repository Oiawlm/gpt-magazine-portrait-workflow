# 新人物接入示例

本文以虚拟人物 `xiaoming` 为例，演示当前 MVP 的完整接入流程。这个流程不调用 GPT Image API，也不要求 Codex 自动生图；正式出图仍由用户在 ChatGPT Plus / GPT Image 中手动完成。

## 1. 创建人物目录

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\make_character_dirs.ps1 -CharacterName "xiaoming"
```

执行后会生成：

```text
assets/characters/xiaoming/
├── reference/
├── generated/
├── tasks/
└── xiaoming.md
```

## 2. 准备人物原始参考图

将同一个人的多角度照片放入：

```text
assets/characters/xiaoming/reference/
```

建议至少包含：

```text
reference/
├── 01-front.png
├── 02-three-quarter.png
├── 03-side.png
└── 04-full-body.png
```

## 3. 生成多视图参考图

正式生成杂志写真前，先用 GPT Image 生成一张多视图参考图，目的是锁定人物一致性。

操作方式：

1. 打开 ChatGPT Plus / GPT Image。
2. 上传 `reference/` 中的人物多角度照片。
3. 复制 `templates/multiview_reference_prompt.template.md` 中的提示词。
4. 生成多视图参考图。
5. 保存到：

```text
assets/characters/xiaoming/reference/00-xiaoming-multiview-reference.png
```

后续任务队列中的 `reference_character_image` 优先指向这张多视图参考图。

## 4. 填写人物资料

编辑：

```text
assets/characters/xiaoming/xiaoming.md
```

示例：

```markdown
# 人物资料：xiaoming

## 基本信息
- 姓名：xiaoming
- 性别：男
- 年龄：28岁
- 体型：匀称偏瘦

## 面部特征
- 黑色短发
- 单眼皮
- 鼻梁较高
- 右脸有一颗小痣

## 气质定位
- 清爽、城市感、适合休闲和轻商务风格

## 不可改变项
- 必须保留右脸小痣
- 发型保持短发
- 不要生成女性化五官
```

## 5. 生成任务队列

将以下内容交给支持图片输入的 Claude Code / Doubao-Seed-2.0-Pro 会话：

1. `assets/characters/xiaoming/reference/00-xiaoming-multiview-reference.png`
2. `assets/characters/xiaoming/xiaoming.md`
3. 选定的风格参考图，例如 `assets/style-reference/13425113610152897.jpeg`
4. `templates/generation_task.template.json`

要求它输出任务队列，并保存到：

```text
assets/characters/xiaoming/tasks/20260606-first-round.json
```

任务队列最小示例：

```json
[
  {
    "task_id": "XM001",
    "character": "xiaoming",
    "style_pack_id": "SP001",
    "style_pack_name": "soft city portrait",
    "reference_character_image": "assets/characters/xiaoming/reference/00-xiaoming-multiview-reference.png",
    "reference_style_images": [
      "assets/style-reference/13425113610152897.jpeg"
    ],
    "core_identity_constraints": "男性，28岁，黑色短发，单眼皮，鼻梁较高，右脸有一颗小痣，气质清爽城市感，不得女性化，不得改变脸型和发型。",
    "style_adaptation_notes": "参考风格图的构图、光影、排版密度和杂志质感，不照抄具体人物。",
    "final_prompt_zh": "请基于人物多视图参考图生成一张城市杂志写真。人物为28岁东亚男性，黑色短发，单眼皮，鼻梁较高，右脸有一颗小痣，保持清爽城市感。画面为半身肖像，柔和自然光，干净背景，杂志封面质感，排版克制，主视觉文字使用 XIAOMING，高清细节。",
    "negative_prompt_zh": "女性化，脸型改变，发型改变，小痣消失，卡通，动漫，低清晰度，肢体变形，多余人物，文字乱码，水印。",
    "output_filename": "assets/characters/xiaoming/generated/xiaoming_20260606_soft_city_portrait.png",
    "status": "pending",
    "priority": "high",
    "belongs_to_style_line": "soft_city_portrait"
  }
]
```

## 6. 校验任务队列

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\skills\gpt-magazine-portrait\scripts\validate_queue.ps1 -QueuePath .\assets\characters\xiaoming\tasks\20260606-first-round.json
```

校验通过后，再进入生图。校验不代表提示词质量一定好，只代表 JSON 格式和必填字段满足工作流要求。

## 7. 确认并手动出图

生图前先列出本轮信息：

```text
任务数量：1
任务ID：XM001
角色：xiaoming
输出路径：assets/characters/xiaoming/generated/
是否覆盖旧图：否
执行方式：ChatGPT Plus / GPT Image 手动出图
```

用户确认后：

1. 打开 ChatGPT Plus / GPT Image。
2. 上传 `00-xiaoming-multiview-reference.png`。
3. 复制任务队列中的 `final_prompt_zh` 和 `negative_prompt_zh`。
4. 生成图片。
5. 将结果保存为任务中的 `output_filename`。

## 8. 记录结果

出图完成后只做必要记录：

1. 确认图片已保存到 `generated/`。
2. 将任务状态从 `pending` 改为 `done` 或 `failed`。
3. 在人物 Markdown 中补充生成图片路径。
4. 必要时在 `output-records/` 写一条运行记录。

当前 MVP 不要求用户做复杂反馈，也不要求记录“保留/淘汰/人物像不像”等审美评价。
