# TOOLS.md - 产品经理 Agent 工具配置

## 工具说明

产品经理 Agent 主要使用以下工具进行工作。

## 主要工具

### multi-search-engine（仅用于简单查询）

**用途**：快速信息查询，支持 17 个搜索引擎

**使用场景**（简单查询）：
- 确认具体术语的定义
- 验证简单的事实或数字
- 快速查找单一信息

**不用于**：
- 深度竞品分析（应通过 researcher 执行）
- 系统性市场研究（应通过 researcher 执行）
- 技术选型调研（应通过 researcher 执行）

**语法参考**：参见 `~/.openclaw/workspace/skills/multi-search-engine/SKILL.md`

## 文件操作工具

### write
- 写入 PRD 文件（`prds/[feature-name]/PRD.md`）
- 写入产品分析（`research/[topic]/ANALYSIS.md`）
- 写入每日日志（`memory/YYYY-MM-DD.md`）

### read
- 读取 researcher 的调研报告
- 查阅已有 PRD 或产品规格
- 获取历史决策记录

## 不使用的工具

| 工具 | 原因 |
|------|------|
| exec | 不执行代码，不运行命令 |
| message | 不直接与其他 Agent 通信，通过 Nova 协调 |
| sessions_spawn | 不创建子 Agent（调研工作由 researcher 负责） |
| browser | 不进行 UI 截图或自动化测试 |

## 工具配置

### 调研工作流程

当需要调研时，通过以下流程：

1. **PM 定义调研需求**：明确主题、核心问题、交付期望
2. **通过 Nova 协调**：向 Nova 提交调研请求
3. **接收报告**：Nova 转达 researcher 的调研报告
4. **输出产品分析**：基于 researcher 的报告进行产品角度分析

### 信息评估框架

| 类型 | 可信度 | 说明 |
|------|--------|------|
| researcher 调研报告 | 高 | 经过系统性研究 |
| 官方文档 | 高 | 官方发布的一手资料 |
| 权威媒体报道 | 高 | 可验证的新闻媒体 |
| 开源代码 | 中高 | 可审查的实际实现 |
| 论坛/社交媒体 | 低 | 仅作为信号，不作为证据 |

---

*产品经理 Agent | 隶属于 Nova 协调者*