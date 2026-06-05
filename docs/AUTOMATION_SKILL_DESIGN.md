# Automation Skill Design

## 结论

这个项目最终应该是“资产仓库 + Codex skill”的组合。

- 仓库负责保存资产、样张、风格库、模板、规范和历史运行记录。
- Skill 负责让 Codex 知道如何拿到一个新人物的多角度照片后，按固定步骤执行整套流程。

单独做 skill 不够，因为 skill 不适合塞大量图片资产。单独做仓库也不够，因为仓库只能放文件，不能让 Codex 自动知道下一步怎么跑。

## Skill 应该做什么

当用户把一个人的多角度图片交给 Codex，并说“按这个项目跑一轮人物写真工作流”时，skill 应该指导 Codex：

1. 在仓库中为新人物创建目录。
2. 保存人物参考图。
3. 生成或整理人物核心设定。
4. 调用现有风格参考库和 style pack。
5. 把人物设定、风格包、用户需求交给 Claude Code / Doubao-Seed-2.0-Pro 生成提示词队列。
6. 读取并审核提示词队列。
7. 列出本轮生图任务、数量、输出路径和是否覆盖旧图。
8. 等用户确认。
9. 使用 GPT Image / ChatGPT Plus 批量生图。
10. 保存图片。
11. 更新人物 Markdown、任务队列、运行记录。
12. 等用户锐评。
13. 把用户反馈写回提示词规则。

## Skill 不应该做什么

- 不内置大量图片资产。
- 不绕开用户确认直接生图。
- 不默认使用 DeepSeek V4 Pro 看图，因为它不能看图。
- 不承诺其他生图模型能达到 GPT Image 的效果。
- 不在额度紧张时做测试图。

## 推荐 skill 名称

```text
gpt-magazine-portrait
```

## 推荐触发语

- “按 gpt-magazine-portrait 工作流给这个人生成杂志写真”
- “我上传了多角度人物图，跑一轮人物写真”
- “用这个仓库的风格资产给新人物生成提示词队列”
- “审核这一轮人物写真任务队列并准备生图”

## Skill 资源结构

Skill 本体可以很小：

```text
gpt-magazine-portrait/
  SKILL.md
  references/
    workflow.md
    prompt-rules.md
    task-schema.md
  scripts/
    validate_queue.ps1
    make_character_dirs.ps1
```

图片资产仍然放在本仓库：

```text
ai-magazine-portrait-workflow/
  assets/
  docs/
  templates/
  workflow-runs/
```

## MVP 自动化边界

第一版 skill 不需要全自动控制所有软件。它只要把流程固定下来：

- 能接新人物图片。
- 能创建人物目录。
- 能准备 Claude Code / Doubao 任务包。
- 能审核返回的任务队列。
- 能让 Codex 执行 GPT Image 生图并落盘。

后续再考虑完全自动化控制 Claude Code、浏览器或 ChatGPT 桌面端。

## 当前优先级

1. 先把仓库推到 GitHub。
2. 让 Claude Code 接手继续完善 README、模板和 skill 设计。
3. 再创建真正的 Codex skill。
4. 最后用一个新人物跑一次端到端验证。
