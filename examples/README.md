# Examples

## 新人物接入

推荐先读 [new-character-guide.md](new-character-guide.md)。

MVP 顺序：

1. 在仓库根目录运行 `make_character_dirs.ps1` 创建人物目录。
2. 将人物多角度照片放入 `assets/characters/<name>/reference/`。
3. 使用 `templates/multiview_reference_prompt.template.md` 让 Codex 生成多视图参考图，并保存到 `reference/`。
4. 填写人物资料 Markdown。
5. 使用 Doubao-Seed-2.0-Pro 生成任务队列，保存到 `tasks/`。
6. 运行 `validate_queue.ps1` 校验队列。
7. 用户确认后，由 Codex 生图并保存到 `generated/`。
8. 更新人物 Markdown、任务状态和必要运行记录。

## 无生图测试

见 [../docs/QUICKSTART_TEST.md](../docs/QUICKSTART_TEST.md)。
