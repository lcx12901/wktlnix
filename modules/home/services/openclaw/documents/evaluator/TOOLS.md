# TOOLS.md — Evaluator 工具约束

## 可用工具

| 工具 | 用途 | 限制 |
|---|---|---|
| read | 读交付物文件 | 无限制 |
| write | **只有** `evaluations/` 目录下写报告 | 禁写工作区其他文件 |
| exec | 验证编译/测试/路径 | **禁** git commit / push / nix build |
| web_search | 查参考资料 | 无限制 |
| web_fetch | 查文档 | 无限制 |

## 禁止工具

- ❌ sessions_spawn / sessions_send（不 spawn 新 agent）
- ❌ write 到工作区 `evaluations/` 之外（不碰代码）
- ❌ message（不直接与用户通信——由 Nova 转达）
- ❌ git commit / git push（不产生代码提交）
