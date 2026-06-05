# 2026-06-05 第一轮人物写真 GPT 临时路线执行记录

## 背景

第一轮提示词队列来自 `ai-portrait-workflow/runs/2026-06-05-style-pack-v1/`，共 3 个任务。原计划优先使用 Codex 内置生图能力；执行时内置生图工具触发额度/频率限制，因此按用户确认临时切换到 ChatGPT Plus 浏览器路线。

这次切换只影响执行层，不改变正式工作流：豆包负责吸收风格并产出提示词，Claude Code/Codex 负责整理队列和校验，Codex 在用户确认后执行生图并落盘。

## 生成结果

| 任务ID | 人物 | 风格包 | 输出文件 |
|--------|------|--------|----------|
| T001 | 良子 | SP003 柔暖近景生活感肖像 | `D:\Download\agent_vault\人物资料库\良子\images\liangzi_sp003_life_portrait.png` |
| T002 | 良子 | SP004 松弛半身生活场景版式 | `D:\Download\agent_vault\人物资料库\良子\images\liangzi_sp004_casual_lifestyle.png` |
| T003 | 嘎子 | SP001 硬朗男刊侧颜角色海报 | `D:\Download\agent_vault\人物资料库\嘎子\images\gazi_sp001_mens_magazine_poster.png` |

## 已同步记录

- `FIRST_ROUND_PROMPT_QUEUE.md` 已将 3 个任务状态改为 `done`，并补充输出路径、执行方式和完成时间。
- `first_round_prompt_queue.json` 已同步结构化状态和输出路径。
- `良子.md` 已新增第 12、13 条自动化试跑记录。
- `嘎子.md` 已新增第 14 条自动化试跑记录。

## 后续注意

- ChatGPT 浏览器路线只是临时 fallback，后续仍优先使用 Codex 内置生图能力，除非用户明确切换。
- 下一轮如果继续扩风格包，应先基于这 3 张做人工评价，再决定是否调整提示词或进入批量扩展。
- 图中文字仍需要人工肉眼确认；模型可能会出现错字、边缘裁切或细节漂移。
