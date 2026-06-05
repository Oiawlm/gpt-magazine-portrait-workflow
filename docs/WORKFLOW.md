# Workflow

## 目标

把一个人物的多角度参考图，转化为一组高质量杂志写真图片。流程重点不是一次性赌图，而是建立“资产 -> 风格包 -> 任务队列 -> GPT Image 出图 -> 用户反馈 -> 规则更新”的闭环。

## 阶段 1：人物资料准备

1. 为人物创建目录：`assets/characters/<name>/`。
2. 放入正脸、侧脸、背面或多角度参考图。
3. 编写人物 Markdown，记录体型、五官、发型、气质、不可改变项。
4. 如需要，可先用 GPT Image 生成一张多视角参考图，作为后续固定身份的核心参考。

## 阶段 2：风格资产准备

1. 使用 `assets/style-reference/` 中的高质量风格参考图。
2. 先做图片清点，生成 manifest。
3. 再做质量筛选，排除风格极端、不可复用或不适合通用迁移的图片。
4. 对剩余图片做风格聚类。
5. 把聚类定稿为 style pack。

## 阶段 3：人物风格谱系蒸馏

1. 读取当前人物已有生成图。
2. 为每张图记录风格定位、视觉关键词、穿搭关键词、构图关键词、排版关键词。
3. 提炼人物适合的主线、补充线和惊喜线。
4. 后续任务队列必须同时参考外部 style pack 和人物风格谱系。

## 阶段 4：提示词队列生成

1. Claude Code 通过 CC Switch 选择 Doubao-Seed-2.0-Pro。
2. Doubao 读取人物参考图、风格参考图和人物谱系。
3. 生成结构化任务队列，任务至少包含：
   - `task_id`
   - `character`
   - `style_pack_id`
   - `reference_character_image`
   - `reference_style_images`
   - `core_identity_constraints`
   - `final_prompt_zh`
   - `negative_prompt_zh`
   - `output_filename`
   - `status`
   - `priority`
4. Codex 审核任务队列，只修正明显规则问题，不随意扩张任务数量。

## 阶段 5：生图前确认

生图前必须向用户列出：

- 本轮任务数量。
- 每个任务 ID 和人物。
- 每张图输出路径。
- 是否覆盖旧文件。
- 使用 GPT Image、ChatGPT Plus 浏览器，还是其他执行方式。

用户确认后才允许执行。

## 阶段 6：GPT Image 执行

1. 优先使用 GPT Image / ChatGPT Plus。
2. 每次只执行用户确认的数量。
3. 如果文字漂移但画面很好，优先在同一页面做定向编辑，不立刻重跑。
4. 保存图片到 `assets/characters/<name>/generated/` 或人物目录指定位置。
5. 验证文件存在、大小正常、图片可打开。

## 阶段 7：记录回写

1. 更新人物 Markdown。
2. 更新任务队列 JSON 和 Markdown。
3. 写入 `output-records/` 运行记录。
4. 记录用户锐评。
5. 把稳定规则写回 `docs/PROMPT_RULES.md`。

## 阶段 8：下一轮

下一轮不应盲目扩图。先判断：

- 哪些风格成功。
- 哪些风格只适合作为备选。
- 哪些问题来自提示词，哪些问题来自模型文字控制。
- 是否真的需要继续生成。

只有当规则被吸收后，才进入下一轮任务队列。
