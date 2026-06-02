# TOOLS.md — 前端开发专家

> 工具细节。命令清单 + 工具分层 + 踩坑。Skill 配置不在本文件
> （由 `default.nix` 的 `frontend-dev.skills` 字段管理）。
> 需要用 skill 时直接按名称调用，详情 `Read` 读对应 SKILL.md。

---

## 必须工具（OpenClaw 内置）

| 工具  | 用途                                       |
| ----- | ------------------------------------------ |
| Read  | 读组件源码、配置文件、skill SKILL.md       |
| Edit  | 修改组件、样式、配置文件                   |
| Write | 创建新组件、测试文件、文档                 |
| Bash  | 运行 pnpm scripts、构建命令、测试套件     |
| Glob  | 查找 `.vue` / `.ts` / `.spec.ts` / `.css`  |
| Grep  | 搜索组件使用、类型引用、样式引用           |

## 可选工具

| 工具         | 用途                          |
| ------------ | ----------------------------- |
| WebFetch     | 获取 Vue / Vite / 库官方文档  |
| WebSearch    | 研究特定前端问题的解决方案    |
| Browser      | 截图对比、视觉回归、交互验证  |
| image        | 分析设计稿截图 / 视觉回归对比 |

---

## 常用命令（最高频）

> 这些是**项目本地**命令（视具体项目 `package.json` 而定）。遇到命令不存在
> 时，**先 `Read` 读 `package.json` 的 `scripts` 字段**，不要凭印象拼。

```bash
# === 开发 ===
pnpm dev                                # Vite dev server
pnpm dev --host                         # 允许外部访问

# === 质量门控（提交前必跑）===
pnpm typecheck                          # vue-tsc 严格类型检查
pnpm lint                               # ESLint
pnpm lint:fix                           # 自动修复
pnpm test                               # Vitest 单元测试
pnpm test:watch                         # 监听模式
pnpm test:coverage                      # 覆盖率报告

# === 构建 / 分析 ===
pnpm build                              # 生产构建
pnpm preview                            # 预览生产构建
pnpm analyse                            # bundle 分析（rollup-plugin-visualizer）

# === 可选 ===
pnpm storybook                          # 启动 Storybook（如配置）
npx playwright test --grep "@visual"    # 视觉回归
npx lhci autorun                        # Lighthouse CI
```

---

## 工具分层

### 核心（必用）

- 文件三剑客：`read` / `write` / `edit`
- 搜索：`rg`（ripgrep，不用 `grep -r`）
- Shell：`exec` 同步 / `exec --yield` 后台
- 任务管理：`process --action poll`

### 项目本地（按项目）

- 所有 `pnpm <script>` 来自项目 `package.json`
- 视觉回归 / E2E 来自项目 `tests/` 目录
- 组件库 / Storybook 来自项目配置

### Skill（按名称调用，不假设路径）

> 详细 SKILL.md 通过 `Read` 按需读。OpenClaw 自动解析位置。

- **vue / vue-best-practices / vue-testing-best-practices** — Vue 3
  组件开发 / 测试
- **vite** — 构建工具配置
- **pinia** — 状态管理
- **vitest** — 单元测试
- **unocss** — 原子化 CSS
- **leaferjs** — 画布 / 图形编辑（如项目用到）
- **code-review** — 自审 / 提交前检查
- **self-improving-agent** — 任务后学习记录
- **multi-search-engine** — 多搜索引擎调研

### 不用

- 直接发邮件 / 推文等外发工具
- 越权访问其他 agent 的 workspace
- 绕开 `pnpm` 直接调底层（项目脚本是封装层）

---

## 工具使用注意

- **Skill 路径不可假设**——OpenClaw 通过 skill 名称调用，**不**是固定
  文件系统路径
- **Skill SKILL.md 位置**——通过 `Read` 工具按需读，OpenClaw 自动解析
- **大文件评审结果** → 写到
  `~/.openclaw/workspace/frontend-dev/`，不放在主对话
- **设计 Token / 评审报告** → 来自 ui-designer（通过 Nova），不要自己
  生成 Token
- **接口契约 / 类型定义** → 来自 backend-dev（通过 Nova），前端不
  擅自修改
- **工具结果 > 20K tokens** → offload 到文件，路径在主对话引用
- **凭证** → 环境变量读取，单条命令内完成（不通过中间变量中转）
- **连续 3+ 相似操作** → 聚合脚本，不要手动重复

---

## 工具踩坑速查

| 症状 | 原因 | 解决 |
| ---- | ---- | ---- |
| `pnpm: command not found` | 装 corepack / pnpm | `corepack enable && corepack prepare pnpm@latest --activate` |
| `vue-tsc` 报红但 vite dev 不报 | 类型检查是独立步骤 | 提交前 `pnpm typecheck` |
| `Vitest` 找不到组件类型 | 缺 `vue-tsc` 类型生成 | 加 `pnpm test:types` 或 `"types": ["vitest/importMeta"]` |
| UnoCSS 类不生效 | 没装 preset | 装 `@unocss/preset-uno` + 在 `uno.config.ts` 加 preset |
| Storybook 启动报 module not found | 与 vite 配置不同步 | 同步 vite-plugin-vue / tsconfig paths |
| Playwright 视觉回归基线图丢失 | 基线未 commit | `.gitignore` 不要忽略 `tests/visual/__snapshots__` |

> 完整踩坑库 → `details/AGENTS-details.md §3.7`

---

## 工作区结构

```
~/.openclaw/workspace/frontend-dev/
├── SOUL.md                # 人设（你正在读它的子集）
├── AGENTS.md              # 工作规范核心版
├── IDENTITY.md            # 元数据
├── TOOLS.md               # 本文件
├── details/               # 按需参考
│   └── AGENTS-details.md
├── decisions/             # 关键决策日志
│   └── YYYY-MM-DD.md
├── components/            # 组件沉淀
│   └── REGISTRY.md        # 项目级组件清单
├── performance/           # 性能优化记录（含 Before/After）
│   └── YYYY-MM-DD-<topic>.md
├── memory/                # 每日工作日志
│   └── YYYY-MM-DD.md
└── .learnings/            # 学习 / 错误记录
    ├── LEARNINGS.md
    └── ERRORS.md
```

---
