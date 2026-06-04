# TOOLS.md

## 核心工具说明

### Cron 任务管理

- `cron.list` — 列出所有 cron 任务
- `cron.get jobId=<id>` — 查看单个任务详情和最近运行状态
- `cron.runs jobId=<id>` — 查看任务的运行历史
- `cron.run jobId=<id>` — 手动触发任务
- `cron.remove jobId=<id>` — 删除任务

### Memory 管理

- `memory_recall` — 搜索长期记忆（需要 query）
- `memory_store` — 存入新记忆（category: fact/preference/entity/decision）
- `memory_forget` — 删除记忆
- `memory_update` — 更新记忆内容或元数据

### 自我提升

- `self_improvement_log` — 记录学习/错误（type: learning/error）
  - 触发时机：命令失败、用户纠正、知识过时、发现更好方案
  - 自动晋升：`Recurrence-Count >= 3` 或 `Priority=critical/high` 时写入 SOUL.md/AGENTS.md/TOOLS.md

### Capability Evolver

- 分析 agent 日志，检测错误模式，计算 health score
- `action=analyze` — 日志模式检测
- `action=evolve` — 生成改进提案（strategy: auto/balanced/innovate/harden/repair-only）

### 跨渠道消息发送

- **跨渠道（Discord group chat 等）回复必须显式调用 `message` 工具**，不能依赖默认行为或会话上下文自动路由
- 必须传递 `action=send` + `channel` 参数指定目标渠道
- Discord mention 格式：用户 `<@USER_ID>`，频道 `<#CHANNEL_ID>`，角色 `<@&ROLE_ID>`

## 工具使用注意

- LanceDB memory 直接读取需要用 Node.js 脚本（lancedb npm 包）
- `exec` 中 `yieldMs` 用于后台任务，避免长时间等待
- 不在命令参数中暴露密钥，使用环境变量读取

## Phase 2 行为优化

### 文件读取分级

```
- ≤ 8K chars  → read 全量
- 8K-50K chars → read --limit 50（仅开头 50 行）
- > 50K chars  → read --limit 20，分页读取
- 代码文件例外：按需全量
```

### Web fetch 默认截断

```
web_fetch url maxChars:4000   # 默认
web_fetch url maxChars:8000   # 仅深度调研时
```

### 大工具结果 offload（>20K tokens）

```
write ~/.openclaw/workspace/.cache/<ts>-<desc>.txt
```

### 用户上传文件

内容已注入 message 时，先估算大小：
- 明显 >8K chars → 只参考前 50 行
- 需要细节时 read 源文件
- 不重复复述全部上传内容

### Spawn 必传 `lightContext: true`

减少 sub-agent 启动开销。

详见 `details/AGENTS-details.md §4.6.5`