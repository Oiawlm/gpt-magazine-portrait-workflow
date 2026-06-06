# Handoff To Claude Code

## 当前状态

Codex 已经创建并初始化开源仓库。请在仓库根目录执行后续操作：

```text
gpt-magazine-portrait-workflow/
```

GitHub 远程目标：

```text
https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git
```

本仓库目标不是通用 AI 生图工具，而是用户自己的资产化人物杂志写真工作流。仓库内已经包含风格参考、良子/嘎子人物资料、生成样张、历史任务队列、运行记录和规范文档。

## 用户最新意图

用户认为这个项目最终可能需要一个 Codex skill，但不是只有 skill。

更准确的产品形态：

- GitHub 仓库：保存资产、文档、模板、风格参考、样张和运行记录。
- Codex skill：让 Codex 在用户上传一个新人物多角度照片后，知道如何调用这套资产和流程，把整个生成流程跑起来，并由 Codex 生图能力完成最终出图。

用户希望别人拿到仓库后，不需要重新收集风格图，只要上传一个人的多角度照片，就可以按这套效果路线生成高质量杂志写真。

最新执行口径：普通用户只需要把人物多角度照片拖给 Codex 并触发工作流。仓库和 skill 应使用默认目录、默认命名和第一轮默认 4 张的 MVP 策略；不要要求用户手动输入人物名、路径、张数或“是否开始”。触发语和照片本身视为执行授权，只有覆盖旧文件、缺前置能力、路径不存在或队列无法修复时才暂停。

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

`T013` 已在当前仓库的以下队列中标为 `cancelled`：

- `workflow-runs/2026-06-05-style-pack-v1/second_round_prompt_queue.json`

原因：用户明确取消，当前优先搭建开源工作流，节省 GPT Image 额度。

## 用户偏好

- 不要写素材声明类文档。
- 不要继续争版权/授权问题。
- 不要消耗 GPT Image 额度做测试。
- 不要把“等待用户确认”作为新人物 MVP 的必经步骤。
- 当前工作流不使用 DeepSeek V4 Pro；不要把它写入任务队列、文本整理、fallback 或可选步骤。
- 最终出图由 Codex 生图能力执行，视觉效果以 GPT Image 经验为基准。
- Claude Code 必须通过 CC Switch 或等价方式使用 Doubao-Seed-2.0-Pro 做图片理解和提示词队列生成。
- 不要把控制浏览器、ChatGPT 网页版或 GPT 桌面端作为工作流、fallback 或未来路线。

## 下一步建议

1. 检查 README 是否足够面向 GitHub 用户。
2. 根据 `docs/AUTOMATION_SKILL_DESIGN.md` 起草真正的 Codex skill：
   - skill 名称建议：`gpt-magazine-portrait`
   - skill 不内置大量图片，只引用仓库资产路径。
3. 补一个更明确的新人物接入示例。
4. 维护三个关键脚本：
   - `check_workflow_prereqs.ps1`：检查仓库前置条件。
   - `start_character_run.ps1`：按默认路径启动新人物运行。
   - `validate_queue.ps1`：校验任务队列 JSON。
5. 后续用一个新人物做端到端验证，但不要为验证消耗不必要生图额度。

## 推送命令

如果 Codex 尚未推送，可执行：

```powershell
git remote add origin https://github.com/Oiawlm/gpt-magazine-portrait-workflow.git
git branch -M main
git push -u origin main
```
