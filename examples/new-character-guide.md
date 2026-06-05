# 新人物接入示例
本文以虚拟人物"xiaoming"为例，展示完整的新人物接入流程。
## 1. 创建人物目录
运行脚本自动创建目录结构：
```powershell
cd skills/gpt-magazine-portrait/scripts
.\make_character_dirs.ps1 -CharacterName "xiaoming"
```
执行后会生成以下目录结构：
```
assets/characters/xiaoming/
├── reference/          # 存放参考图
├── generated/          # 存放生成的图片
├── tasks/              # 存放任务队列
└── xiaoming.md         # 人物资料文档
```
## 2. 准备参考图
将xiaoming的多角度参考图放入 `assets/characters/xiaoming/reference/` 目录：
```
reference/
├── 00-正脸-自然光.png
├── 01-45度侧脸.png
├── 02-正侧脸.png
└── 03-全身照.png
```
## 3. 填写人物资料
编辑 `assets/characters/xiaoming/xiaoming.md`：
```markdown
# 人物资料：xiaoming
## 基本信息
- 姓名：xiaoming
- 性别：男
- 年龄：28岁
- 身高：180cm
- 体型：匀称偏瘦
## 面部特征
- 短发，黑色，偏分
- 单眼皮，高鼻梁，薄嘴唇
- 右脸有一颗小痣
- 面部轮廓硬朗
## 气质定位
- 阳光清爽，适合休闲、商务、运动风格
- 适合场景：城市街头、咖啡馆、户外
## 不可改变项
- 必须保留右脸的痣
- 发型保持短发
```
## 4. 选择风格包
从 `assets/style-reference/` 中选择适合的风格包，例如：
- `style-pack-001：日式杂志封面风
- `style-pack-003：都市休闲风
- `style-pack-007：运动时尚风
## 5. 生成任务队列
调用 Doubao-Seed-2.0-Pro，传入：
1. 人物参考图：`assets/characters/xiaoming/reference/ 下的所有图片
2. 风格参考图：选择的风格包对应的图片
3. 人物资料：`xiaoming.md 的内容
生成的任务队列示例（保存为 `assets/characters/xiaoming/tasks/20260606-first-round.json`）：
```json
[
  {
    "task_id": "XM001",
    "character": "xiaoming",
    "style_pack_id": "style-pack-001",
    "reference_character_image": "assets/characters/xiaoming/reference/00-正脸-自然光.png",
    "reference_style_images": [
      "assets/style-reference/style-pack-001/01-封面参考图.jpg"
    ],
    "core_identity_constraints": "男性，28岁，短发偏分，单眼皮，高鼻梁，右脸有小痣，面部轮廓硬朗",
    "final_prompt_zh": "男性，28岁，短发偏分，单眼皮，高鼻梁，右脸有小痣，面部轮廓硬朗，日式男性杂志封面风格，白色背景，正面半身照，专业打光，高清8K，杂志级画质",
    "negative_prompt_zh": "卡通，动漫，插画，低分辨率，模糊，变形，扭曲，多余肢体，文字错误，水印",
    "output_filename": "assets/characters/xiaoming/generated/01-日式杂志封面.png",
    "status": "pending",
    "priority": "high"
  }
]
```
## 6. 验证任务队列
运行验证脚本检查格式：
```powershell
.\validate_queue.ps1 -QueuePath "..\..\assets\characters\xiaoming\tasks\20260606-first-round.json"
```
如果验证通过，会显示：
```
正在验证任务队列: ..\..\assets\characters\xiaoming\tasks\20260606-first-round.json
共找到 1 个任务
任务 1 (ID: XM001): 格式正确
验证完成！
所有任务格式正确 ✅
```
## 7. 生成多视图参考图（关键步骤）
在生成正式写真前，必须先生成多视图参考图保证人物一致性：
1. 复制 `templates/multiview_reference_prompt.template.md` 中的提示词
2. 打开 ChatGPT Plus，选择 GPT-4o 模型
3. 上传 `assets/characters/xiaoming/reference/` 中的3张参考图
4. 粘贴提示词并生成多视图参考图
5. 将生成的多视图参考图保存为 `assets/characters/xiaoming/reference/00-xiaoming-多视图参考图.png`

## 8. 确认与生图
### 8.1 生图前确认
Codex 会自动列出本轮任务信息供你确认：
```
📋 本轮任务确认：
- 任务数量：3个
- 任务ID：XM001、XM002、XM003
- 输出目录：assets/characters/xiaoming/generated/
- 覆盖旧文件：否
- 预计耗时：10分钟
```
确认后开始执行生图。

### 8.2 执行生图
1. 打开 ChatGPT Plus，选择 GPT-4o 模型
2. 上传多视图参考图 `00-xiaoming-多视图参考图.png` 作为人物参考
3. 按任务队列中的提示词逐一生成
4. 每生成一张，右键保存到对应的输出路径
5. 保持文件名与任务队列中的 `output_filename` 一致

## 9. 记录与迭代
生成完成后，使用 `templates/generation_result.template.md` 模板记录结果：
1. 将生成的图片保存到 `assets/characters/xiaoming/generated/` 目录
2. 填写生成结果记录，包含每个任务的状态、评价、优缺点
3. 更新 `xiaoming.md`，添加生成的图片链接和效果评价
4. 将任务队列中对应任务的 `status` 更新为 `completed` 或 `failed`
5. 记录用户反馈，提炼可复用规则沉淀到 `docs/PROMPT_RULES.md`
6. 根据反馈生成下一轮优化建议

## 示例生成结果记录
```markdown
# 生成结果记录：xiaoming - 第一轮
## 基本信息
- 人物名称：xiaoming
- 任务轮次：第一轮
- 执行日期：2026-06-06
- 任务数量：3个
- 成功数量：3个

## 任务执行详情
| 任务ID | 风格名称 | 输出文件 | 状态 | 备注 |
|--------|----------|----------|------|------|
| XM001 | 日式杂志封面风 | assets/characters/xiaoming/generated/01-日式杂志封面.png | 成功 | 人物相似度90%，风格匹配度高 |
| XM002 | 都市休闲风 | assets/characters/xiaoming/generated/02-都市休闲风.png | 成功 | 光影效果很好，气质符合 |
| XM003 | 运动时尚风 | assets/characters/xiaoming/generated/03-运动时尚风.png | 成功 | 动作自然，适合后续扩展 |

## 整体反馈
- 优点：人物一致性很好，风格都比较匹配
- 不足：日式封面的文字有点漂移，可以后续优化
- 下一轮建议：增加商务风格和复古风格的任务
```
