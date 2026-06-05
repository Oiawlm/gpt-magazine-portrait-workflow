# Handoff To Claude Code

## 当前状态

Codex 已经创建并初始化开源仓库：

```text
D:\Download\agent_vault\ai-magazine-portrait-workflow
```

GitHub 远程目标：

```text
https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git
```

本仓库目标不是通用 AI 生图工具，而是用户自己的资产化 GPT Image 人物杂志写真工作流。仓库内已经包含风格参考、良子/嘎子人物资料、生成样张、历史任务队列、运行记录和规范文档。

## 用户最新意图

用户认为这个项目最终可能需要一个 Codex skill，但不是只有 skill。

更准确的产品形态：

- GitHub 仓库：保存资产、文档、模板、风格参考、样张和运行记录。
- Codex skill：让 Codex 在用户上传一个新人物多角度照片后，知道如何调用这套资产和流程，把整个生成流程跑起来。

用户希望别人拿到仓库后，不需要重新收集风格图，只要上传一个人的多角度照片，就可以按这套效果路线生成高质量杂志写真。

## 已完成文件

关键入口：

- `README.md`
- `PROJECT_GUIDE.md`
- `docs/WORKFLOW.md`
- `docs/STANDARD.md`
- `docs/AGENT_ROLES.md`
- `docs/GPT_IMAGE_GUIDE.md`
- `docs/PROMPT_RULES.md`
- `docs/RELEASE_PLAN.md`
- `docs/AUTOMATION_SKILL_DESIGN.md`
- `assets/ASSET_MANIFEST.md`
- `templates/character_profile.template.md`
- `templates/generation_task.template.json`
- `templates/style_pack.template.json`

资产：

- `assets/style-reference/`
- `assets/characters/良子/`
- `assets/characters/嘎子/`
- `assets/source-notes/`
- `assets/source-images/`
- `workflow-runs/`
- `output-records/`

## 已取消事项

不要继续做谢孟伟/XIEMENGWEI 红绳镜面版。

`T013` 已在以下两个队列中标为 `cancelled`：

- `D:\Download\agent_vault\ai-portrait-workflow\runs\2026-06-05-style-pack-v1\second_round_prompt_queue.json`
- `D:\Download\agent_vault\ai-magazine-portrait-workflow\workflow-runs\2026-06-05-style-pack-v1\second_round_prompt_queue.json`

原因：用户明确取消，当前优先搭建开源工作流，节省 GPT Image 额度。

## 用户偏好

- 不要写素材声明类文档。
- 不要继续争版权/授权问题。
- 不要消耗 GPT Image 额度做测试。
- DeepSeek V4 Pro 是纯文本模型，不能读图。
- 最终生图效果以 GPT Image / ChatGPT Plus 为准。
- Claude Code 可通过 CC Switch 使用 Doubao-Seed-2.0-Pro 做图片理解和提示词生成。

## 下一步建议

1. 检查 README 是否足够面向 GitHub 用户。
2. 根据 `docs/AUTOMATION_SKILL_DESIGN.md` 起草真正的 Codex skill：
   - skill 名称建议：`gpt-magazine-portrait`
   - skill 不内置大量图片，只引用仓库资产路径。
3. 补一个更明确的新人物接入示例。
4. 可选：写两个脚本：
   - 创建新人物目录。
   - 校验任务队列 JSON。
5. 等用户确认后，再用一个新人物做端到端验证。

## 推送命令

如果 Codex 尚未推送，可执行：

```powershell
cd D:\Download\agent_vault\ai-magazine-portrait-workflow
git remote add origin https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git
git branch -M main
git push -u origin main
```
