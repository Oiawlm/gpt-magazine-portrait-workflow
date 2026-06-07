# Asset Manifest

## 风格参考

位置：`assets/style-reference/`

内容：用户收集和整理的高质量杂志、海报、肖像风格参考图，以及对应的清点、质量筛选、聚类和 style pack 文件。

关键文件：

- `IMAGE_MANIFEST.md`
- `IMAGE_QUALITY_REVIEW.md`
- `STYLE_CLUSTER_DRAFT.md`
- `STYLE_PACKS.md`
- `image_manifest.json`
- `image_quality_review.json`
- `style_cluster_draft.json`
- `style_packs.json`

## 人物资料

位置：`assets/characters/`

包含：

- `良子/`
- `嘎子/`

每个人物目录包含人物 Markdown、任务 JSON、参考图和生成样张。

效果展示索引：

- `assets/SHOWCASE.md`

## 原始对话和提示词记录

位置：`assets/source-notes/root-conversations/`

包含早期与 GPT、Doubao-Seed-2.0-Pro 讨论多视角参考图、人物风格提示词和杂志封面提示词的记录。

## 根目录散图

位置：`assets/source-images/root-loose/`

包含原工作区根目录中的补充图片素材和临时导出图。

## 默认图片入口

位置：`assets/inbox/`

当 Codex 环境不能把拖入图片暴露为本地文件路径时，把待处理人物的 3-5 张多角度照片放入此目录。`start_character_run.ps1` 在没有 `-SourceImagePath` 参数时会自动扫描该目录。

## 运行记录

位置：

- `workflow-runs/`
- `output-records/`

包含第一轮、第二轮队列，人物风格谱系，GPT fallback 试跑记录和用户反馈回写记录。
