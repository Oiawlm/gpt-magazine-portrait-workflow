# 2026-06-05 第二轮 MVP 生图执行记录

## 背景

本次目标是快速跑通人物写真自动化最小闭环：第二轮提示词队列 -> ChatGPT Plus 浏览器临时 fallback 生图 -> 图片落盘 -> 人物资料库回写 -> 队列状态更新。

执行前，用户追加要求：在原定 3 张基础上，给良子也生成一张红绳镜面西装封面，因此本次实际执行 4 张。

## 执行任务

| 任务ID | 人物 | 风格 | 输出文件 | 状态 |
|--------|------|------|----------|------|
| T004 | 良子 | 复古市井纪实升级版 | `D:\Download\agent_vault\人物资料库\良子\images\liangzi_v2_retro_street_documentary.png` | done |
| T005 | 良子 | 港口硬朗西装高级版 | `D:\Download\agent_vault\人物资料库\良子\images\liangzi_v2_portrait_suit_archive.png` | done |
| T009 | 嘎子 | 红绳镜面西装 GAZI 背景版 | `D:\Download\agent_vault\人物资料库\嘎子\images\gazi_v2_red_rope_mirror_suit_gazi_logo.png` | done |
| T012 | 良子 | 红绳镜面西装 LIANGZI 背景版 | `D:\Download\agent_vault\人物资料库\良子\images\liangzi_v2_red_rope_mirror_suit_liangzi_logo.png` | done |

## 结果观察

- T004 人物一致性强，LIANGZI 主视觉清楚，复古市井夜景质感成立。
- T005 画面质量和人物一致性较好，但主视觉文字漂移为 `URBAN PULSE`，未严格遵循 `LIANGZI`，后续需加强“背景最大文字只能是人物拼音”的约束。
- T009 初稿背景大字漂移为 `MODERN`；后续在同一 ChatGPT 页面做定向编辑，选用 `GAZI` 候选 2 覆盖保存。
- T012 红绳镜面版式成功迁移到良子，`LIANGZI` 主视觉清楚，适合作为良子反差高奢方向样张。

## 已同步记录

- `SECOND_ROUND_PROMPT_QUEUE.md` 已将 T004、T005、T009、T012 更新为 `done`。
- `second_round_prompt_queue.json` 已同步输出路径、执行方式、完成时间和执行备注。
- `良子.md` 已新增第 14、15、16 条 MVP 二轮记录。
- `嘎子.md` 已新增第 15 条 MVP 二轮记录。

## 后续提示词修正点

- 红绳镜面类提示词不要同时要求 `MODERN ISSUE`、`ARCHIVE`、`SILENCE IS STYLE` 等小字，否则模型容易把这些词放大成主视觉。
- 对主视觉文字应使用更强约束：画面最大背景字只能是人物拼音，其他英文如果无法准确作为小字则全部省略。
- 对于文字已经漂移但画面很好的图，可以在同一 ChatGPT 页面进行定向编辑，比直接重跑更有效。

## 用户复盘补充

- 嘎子红绳镜面图中，`GAZI` 只有四个字母，作为背景超大字时版式密度不足；原先漂移出的 `MODERN` 虽不符合姓名要求，但字母数量更多、挤压感更强，视觉上更高级，应作为成功样张保留。
- 后续需要重做嘎子红绳镜面修正版，背景大字优先使用嘎子本名拼音 `XIEMENGWEI`，或分组为 `XIE MENG WEI`，用更长字母串恢复类似 `MODERN` 的密集版式。
- 原 `MODERN` 版当前未在 `D:\Download\agent_vault\人物资料库\嘎子\images\` 中确认存在；如果能从 ChatGPT 历史重新导出，应补回人物资料库，不覆盖 `GAZI` 版。
- 良子的市井烟火类封面不适合机械改成英文或拼音。类似“烟火人间”的中文生活感主题，主视觉应优先保留中文；高奢、男刊、镜面红绳、商业时尚类再优先英文或拼音。
