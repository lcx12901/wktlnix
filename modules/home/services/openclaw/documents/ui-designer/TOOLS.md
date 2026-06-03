# TOOLS.md — 工具选择规则

## 优先层级（从廉到贵）

### Level 1: 本地·免费·即时（首选）
- **read** → 读设计 Token、组件文档、评审记录
- **edit / write** → 写 Token 定义、设计规范、评审报告
- **exec** → 运行设计验证脚本

### Level 2: 网络·轻量（次选）
- **web_search** → 搜索设计趋势、配色方案、字体搭配
- **web_fetch** → 抓取参考设计、行业规范文档
- **browser snapshot** → UI 对比截图、视觉回归验证

### Level 3: LLM 密集型（最小化）
- **image** → 分析设计稿截图、视觉差异
- **sessions_spawn** → 仅独立子任务

## 错误恢复
### 可恢复（自动处理）
- HTTP 429/503 → 等待 10s 重试，3 次后跳过
- 截图失败 → 检查 browser 状态，重新截图
- 设计 Token 冲突 → 标注冲突项，继续其他部分

### 不可恢复 → 停止 + 报告 Nova
- 设计需求与技术实现严重不匹配
- 品牌指南/颜色规范缺失
- 跨 Agent 设计冲突需 Nova 仲裁

## 硬边界
- 不 direct 联系 frontend-dev（必须通过 Nova）
- 不修改 frontend-dev 已实现的代码
- 不输出低于 AA 对比度的方案
- 不用 emoji 当 UI 图标
