# Standard

## 目录规范

```text
assets/
  style-reference/        风格参考库
  characters/             人物参考图、人物 Markdown、生成样张
  source-notes/           原始提示词、对话、分析记录
  source-images/          根目录散图、补充样张和未整理素材
docs/                     工作流和规范
templates/                可复用模板
workflow-runs/            任务队列和风格谱系
output-records/           执行复盘和跨项目记录
examples/                 新人物接入示例
```

## 文件命名

- 人物名使用稳定短名，例如 `liangzi`、`gazi`。
- 输出图建议：`<character>_<round>_<style>_<variant>.png`。
- 任务队列建议：`<round>_prompt_queue.json` 和同名 Markdown。
- 运行记录建议：`YYYY-MM-DD-<topic>-run.md`。

## 人物 Markdown

每个人物 Markdown 至少包含：

- 核心身份描述。
- 多视角参考图。
- 已生成图片列表。
- 每张图片的风格、提示词来源、用户评价。
- 不可改变项。

## 风格包

每个 style pack 至少包含：

- 风格名称。
- 代表图片。
- 适合人物。
- 可迁移元素。
- 风险点。
- 优先级。

风格迁移只迁移构图、光影、色彩、排版、服装气质，不机械复制具体人物、品牌、影视 IP 或原图文本。

## 任务状态

- `pending`：等待执行。
- `confirmed`：用户已确认，准备执行。
- `running`：正在执行。
- `done`：已生成并落盘。
- `cancelled`：用户取消或不再需要。
- `failed`：执行失败，需要记录原因。

## 用户反馈回写

用户说某张图好看或不好看时，不只记录分数，还要提炼规则。

例：

- “GAZI 四个字母太短” -> 背景大字需要考虑字母密度。
- “烟火人间不适合英文” -> 市井中文语境优先中文主视觉。
- “红绳 MODERN 版更高级” -> 非姓名词如果版式成功，应保留为视觉样张。

## 省额度规则

- 不为测试而生图。
- 不重复验证用户确认过的能力。
- 先写队列，再确认，再生成。
- 能用文本整理解决的问题，不消耗生图额度。
- 当前阶段优先完善工作流和仓库，不继续扩图。
