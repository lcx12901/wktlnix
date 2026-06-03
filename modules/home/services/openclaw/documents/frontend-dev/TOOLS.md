# TOOLS.md — 工具选择规则

## 优先层级（从廉到贵）

### Level 1: 本地·免费·即时（首选）
- **read / glob / grep** → 查找代码、配置文件、类型声明，先查本地
- **exec** → 运行 `pnpm typecheck/lint/test/build/dev`
- **edit / write** → 修改组件、创建文件

### Level 2: 网络·轻量（次选）
- **web_fetch** → 读 Vue / Vite / 库官方文档，先确认本地无缓存
- **browser snapshot** → 仅 UI 验证、截图比对时用

### Level 3: LLM 密集型（最小化）
- **image** → 仅分析设计稿、视觉回归差异
- **sessions_spawn** → 仅独立子任务（如 evaluator 评估）

## 错误恢复
### 可恢复（自动处理）
- 命令失败 → 检查 exit code + stderr，换方法重试 1 次
- 文件不存在 → 写 `.cache/errors.log`，继续
- HTTP 429/503 → 等待 10s 重试，3 次后跳过

### 不可恢复 → 停止 + 报告 Nova
- 密钥泄露或暴露到输出
- 连续 3+ 同类工具失败
- 文件系统外写操作

## 硬边界
- 不 bypass git（`--no-verify`、`--force`）
- 不 direct 联系其他 agent
- 不修改 `.openclaw` 内部文件
- 不在命令/参数/URL 中嵌入 API key 或 token
