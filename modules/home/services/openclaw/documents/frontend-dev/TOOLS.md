# TOOLS.md - 前端开发工具配置

## 必须工具

| 工具  | 用途                               |
| ----- | ---------------------------------- |
| Read  | 读取源文件、设计稿、配置文件       |
| Edit  | 修改现有组件、样式、配置文件       |
| Write | 创建新组件、测试文件、文档         |
| Bash  | 运行构建命令、开发服务器、测试套件 |
| Glob  | 查找 .vue, .ts, .spec.ts 文件      |
| Grep  | 搜索组件使用、类型引用、样式引用   |

## 可选工具

| 工具      | 用途                       |
| --------- | -------------------------- |
| WebFetch  | 获取框架、库的文档         |
| WebSearch | 研究特定前端问题的解决方案 |

## 常用命令

```bash
# 开发
pnpm dev          # 启动 Vite 开发服务器
pnpm dev --host   # 允许外部访问

# 构建
pnpm build        # 生产构建
pnpm preview      # 预览生产构建

# 检查
pnpm typecheck    # vue-tsc 类型检查
pnpm lint         # ESLint 检查
pnpm lint:fix     # 自动修复 lint 问题

# 测试
pnpm test         # 运行 Vitest
pnpm test:watch   # 监听模式
pnpm test:coverage # 覆盖率报告

# 其他
pnpm storybook    # 启动 Storybook（如配置）
pnpm analyse      # bundle 分析
```

## 技能加载

遇到以下任务类型时，优先读取对应 skill：

| 任务类型       | 读取 skill                                               |
| -------------- | -------------------------------------------------------- |
| Vue 组件开发   | `~/.openclaw/skills/vue/SKILL.md`                        |
| Vite 配置      | `~/.openclaw/skills/vite/SKILL.md`                       |
| 单元测试       | `~/.openclaw/skills/vitest/SKILL.md`                     |
| Pinia 状态管理 | `~/.openclaw/skills/pinia/SKILL.md`                      |
| Vue 最佳实践   | `~/.openclaw/skills/vue-best-practices/SKILL.md`         |
| 测试策略       | `~/.openclaw/skills/vue-testing-best-practices/SKILL.md` |

---

_前端开发 Agent 工具配置_

