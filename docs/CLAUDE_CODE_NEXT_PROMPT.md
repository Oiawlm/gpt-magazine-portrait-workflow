# Claude Code Next Prompt

把下面这段直接复制给 Claude Code 使用。

```text
请在当前仓库根目录接手 gpt-magazine-portrait-workflow 项目。

先阅读：
1. PROJECT_GUIDE.md
2. README.md
3. docs/WORKFLOW.md
4. docs/PROMPT_RULES.md
5. docs/AGENT_ROLES.md
6. docs/GPT_IMAGE_GUIDE.md
7. skills/gpt-magazine-portrait/SKILL.md

当前目标：
继续完善“资产仓库 + Codex skill”的人物杂志写真工作流。

现在不要做：
1. 不要新增图片资源。
2. 不要生图。
3. 不要做风格迁移试跑。
4. 不要写素材声明类文档。
5. 不要继续谢孟伟/XIEMENGWEI 红绳任务，T013 已取消。
6. 不要把控制浏览器、ChatGPT 网页版或 GPT 桌面端写入工作流、计划或 fallback。
7. 不要把人物名、目录、张数、路径或“是否开始”设计成公开 MVP 的用户必填项；拖图并触发工作流即视为授权默认执行。

请先做这几件事：
1. 检查 README.md 里的教程是否足够清楚，尤其是“配置一次，之后拖图即跑”的日常使用路径。
2. 检查 skills/gpt-magazine-portrait/SKILL.md 是否能让 Codex 正确触发和执行这套流程。
3. 检查 scripts/check_workflow_prereqs.ps1、scripts/start_character_run.ps1、scripts/make_character_dirs.ps1 和 scripts/validate_queue.ps1 是否仍然可用。
4. 只做文档和脚本层面的修正，不调用 GPT Image。
5. 修改后运行项目 PROJECT_GUIDE.md 里的检查命令。
6. 输出你修改了哪些文件、跑了哪些验证、还有哪些未确认事项。

如果要验证新人物流程，只允许创建临时测试目录并在验证后删除，不要生成图片。
```
