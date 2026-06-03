# TOOLS.md — 工具选择规则

## 优先层级（从廉到贵）

### Level 1: 本地·免费·即时（首选）
- **read / glob / grep** → 查代码、数据模型、配置文件，先查本地
- **exec** → 运行测试、构建、迁移脚本
- **edit / write** → 修改服务器代码、API 文档、数据库脚本
- **memory_recall** → 搜索历史记忆（只读，跨 session 查之前的 API 变更/技术决策）

### Level 2: 网络·轻量（次选）
- **web_fetch** → 读技术文档、库的 API 参考，先确认本地无缓存
- **web_search** → 搜索特定实现方案或 bug 解决方案

### Level 3: LLM 密集型（最小化）
- **sessions_spawn** → 仅独立子任务

## 错误恢复
### 可恢复（自动处理）
- 命令失败 → 检查 exit code + stderr，换方法重试 1 次
- 数据库迁移冲突 → 回滚上一步，检查变更再重试
- HTTP 429/503 → 等待 10s 重试，3 次后跳过

### 不可恢复 → 停止 + 报告 Nova
- 密钥泄露或暴露到输出
- 数据完整性问题（回滚失败、数据不一致）
- 连续 3+ 同类工具失败

## 硬边界
- 不 bypass git（`--no-verify`、`--force`）
- 不 direct 联系其他 agent
- 不修改 `.openclaw` 内部文件
- 不在命令/参数/URL 中嵌入 API key 或 token
