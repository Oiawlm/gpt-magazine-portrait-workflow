# 2026-06-05 Claude Code 人物写真任务包整理交接

## 目标

把现有人物写真生图资料整理成可批量执行的任务包。Claude Code 不负责最终生图，不负责最终视觉质检；只负责文本、目录、Markdown/JSON/CSV 和引用检查。

## 模型使用规则

- Claude Code 可通过 CC Switch 切换 DeepSeek V4 Pro、Doubao-Seed-2.0-Pro、豆包 4.2.0。
- DeepSeek V4 Pro 是纯文本模型，不能收发图片；只能做文本整理、结构化、清洗、命名和脚本。
- 如果 Claude Code 当前切到豆包模型且会话支持图片输入，才可以让豆包读取三视图和海报参考图，生成风格提示词。

## 输入资料

- 良子人物资料：`D:\Download\agent_vault\人物资料库\良子\良子.md`
- 良子图片目录：`D:\Download\agent_vault\人物资料库\良子\images\`
- 嘎子人物资料：`D:\Download\agent_vault\人物资料库\嘎子\嘎子.md`
- 嘎子图片目录：`D:\Download\agent_vault\人物资料库\嘎子\images\`
- 良子提示词聊天记录：`D:\Download\agent_vault\生成符合三视图风格的提示词，良子Doubao-Seed-2.0-Pro.md`
- 嘎子提示词聊天记录：`D:\Download\agent_vault\根据三视图生成杂志封面风格的提示词，嘎子Doubao-Seed-2.0-Pro.md`
- 多视角参考图聊天记录：`D:\Download\agent_vault\生成多视角参考图聊天记录版本1Doubao-Seed-2.0-Pro.md`

## 输出要求

为每个人物整理一个任务包文件，建议放在对应人物目录：

- `D:\Download\agent_vault\人物资料库\良子\generation_tasks.json`
- `D:\Download\agent_vault\人物资料库\嘎子\generation_tasks.json`

JSON 建议字段：

```json
{
  "character": "良子",
  "reference_image": "images/00-良子-多视角参考图.png",
  "core_prompt": "",
  "styles": [
    {
      "id": "01",
      "name": "秋日休闲复古风",
      "style_prompt": "",
      "output": "images/01-秋日休闲复古风.png",
      "status": "done",
      "notes": ""
    }
  ]
}
```

## 注意事项

- 不要覆盖原图，不要删除文件。
- 不要修改 `_system`、密钥、软件配置或项目外文件。
- 如果发现 Markdown 图片引用和实际文件不一致，只记录问题并给出修复建议，除非用户明确要求修复。
- 嘎子 1-10 曾被用户判定不满意，11-13 相对满意；整理任务包时保留这个评价信息。
- Codex 额度紧张，不要要求 Codex 重复验证已有生图能力；需要生图时先列清单给用户确认。
