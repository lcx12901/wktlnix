# TOOLS.md - 研究专家

## 核心调研工具

### multi-search-engine

**用途**：系统性深度搜索（8 中文 + 9 英文搜索引擎）

**调用方式**：通过 skill 名称调用，详细参数见对应 `SKILL.md`

**适用场景**：

- 文献检索 / 竞品调研
- 技术方案搜索 / 行业分析
- 多语言交叉验证

## 辅助工具

| 工具         | 用途     | 说明                  |
| ------------ | -------- | --------------------- |
| `web_search` | 快速搜索 | 简单信息查询          |
| `web_fetch`  | 内容抓取 | 提取页面主要文本      |
| `read`       | 文件读取 | 看本地文档/参考       |
| `write`      | 文件写入 | 输出报告和数据        |
| `edit`       | 文件编辑 | 精确修改文档          |
| `rg`         | 本地搜索 | ripgrep，不用 grep -r |

## 工具分层

### 核心（必用）

- `web_search`、`web_fetch`
- `read`、`write`、`edit`
- multi-search-engine skill

### 可选（按需）

- `rg` 本地代码/文档搜索
- 多次 web_search 的聚合脚本
- `process` 后台任务管理

### 不用

- 代码执行工具（不写代码）
- 数据库工具
- 消息发送工具（不直接联系其他 agent）

## 信息评估框架（摘要）

详细评估表 → `details/AGENTS-details.md §C`

| 类型          | 可信度 | 说明               |
| ------------- | ------ | ------------------ |
| 官方文档      | 高     | 官方发布的一手资料 |
| 权威媒体      | 高     | 可验证的新闻媒体   |
| 开源代码      | 中高   | 可审查的实际实现   |
| 社区讨论      | 中     | 需要交叉验证       |
| 论坛/社交媒体 | 低     | 仅作信号，不作证据 |

## 工作区结构

```
~/.openclaw/workspace/researcher/
├── SOUL.md               # 身份定义（你正在读它的子集）
├── AGENTS.md             # 工作规范（核心版）
├── IDENTITY.md           # 元数据
├── TOOLS.md              # 本文件
├── details/              # 按需参考
│   └── AGENTS-details.md
├── memory/               # 每日调研日志
│   └── YYYY-MM-DD.md
├── reports/              # 调研报告输出
│   └── [topic]/REPORT.md
└── sources/              # 参考文献和数据源
    └── [topic]/
```

---
