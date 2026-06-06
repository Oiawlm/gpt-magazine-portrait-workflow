# Examples

## 新人物接入

推荐先读 [new-character-guide.md](new-character-guide.md)。

MVP 顺序：

1. 用户把人物多角度照片拖给 Codex 并触发工作流。
2. Codex 调用 `start_character_run.ps1` 创建默认目录并保存原图。
3. 使用 `templates/multiview_reference_prompt.template.md` 让 Codex 生成多视图参考图，并保存到 `reference/multiview/`。
4. Codex 自动草拟人物资料 Markdown。
5. 使用 Doubao-Seed-2.0-Pro 生成第一轮默认 4 个任务，保存到 `tasks/`。
6. 运行 `validate_queue.ps1` 校验队列。
7. 若不会覆盖旧图且前置条件完整，由 Codex 自动生图并保存到 `generated/`。
8. 更新人物 Markdown、任务状态和必要运行记录。

## 无生图测试

见 [../docs/QUICKSTART_TEST.md](../docs/QUICKSTART_TEST.md)。
