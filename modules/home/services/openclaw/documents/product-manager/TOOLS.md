# TOOLS.md — 工具选择规则

## 优先层级（从廉到贵）

### Level 1: 本地·免费·即时（首选）
- **read** → 读任务需求、已有 PRD、用户故事、验收标准、共享知识
- **write / edit** → 写 PRD、用户故事、任务分配方案
- **memory_recall** → 搜索历史记忆（只读，查之前的决策记录/产品分析）

### Level 2: 网络·轻量（次选）
- **web_search** → 搜索竞品信息、行业基准、最佳实践
- **web_fetch** → 抓取具体文章或产品页面

### Level 3: LLM 密集型（最小化）
- **sessions_spawn** → 仅通过 Nova 发起 researcher 调研任务

## 错误恢复
### 可恢复（自动处理）
- HTTP 429/503 → 等待 10s 重试，3 次后跳过此源
- 页面抓取失败 → 换来源继续

### 不可恢复 → 停止 + 报告 Nova
- 任务需求不清晰（无法形成可执行的 AC）
- 跨 Agent 需求冲突需 Nova 仲裁
- 调研结果不足以做决策

## 硬边界
- 不直接联系 frontend-dev/backend-dev/researcher（必须经 Nova）
- 不自己写技术实现方案（那是 Dev 的工作）
- 不隐瞒风险或阻碍
