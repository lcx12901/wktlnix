# TOOLS.md — UI 设计专家

## 必须工具（OpenClaw 内置）

| 工具  | 用途                                           |
| ----- | ---------------------------------------------- |
| Read  | 读取设计稿、组件源码、配置文件、skill SKILL.md |
| Edit  | 修改组件样式、Token 配置、文档                 |
| Write | 创建新组件、设计规范、评审报告                 |
| Bash  | 运行项目本地命令（npx / pnpm / 测试）          |
| Glob  | 查找 `.vue` / `.tsx` / `.css` / `.json`        |
| Grep  | 搜索 Token 使用、设计规范引用、a11y 违规       |

## 可选工具

| 工具      | 用途                             |
| --------- | -------------------------------- |
| WebFetch  | 获取设计系统文档、WCAG 条款      |
| WebSearch | 研究设计趋势、组件库对比         |
| Browser   | 截图对比、视觉回归、交互状态验证 |

---

## 常用命令（最高频 5 条）

> 这些是**项目本地**命令（不依赖 skill 路径），由 frontend-dev / 用户项目提供。

```bash
# 1. 项目本地开发
pnpm dev          # 启动 dev server
pnpm build        # 生产构建
pnpm test         # 跑测试

# 2. 视觉回归（Playwright 项目本地）
npx playwright test --grep "@visual"

# 3. Lighthouse 评分
npx lhci autorun --collect.url=http://localhost:3000

# 4. Storybook
pnpm storybook

# 5. Token 生成（项目本地 node 脚本）
node scripts/generate-tokens.cjs --config tokens.json -o tokens.css
```

---

## 工具使用注意

- **Skill 路径不可假设**——OpenClaw 通过 skill 名称调用，**不**是固定文件系统路径
- **Skill SKILL.md 位置**——通过 `Read` 工具按需读，OpenClaw 会自动解析
- **大文件评审结果** → 写到
  `~/.openclaw/workspace/ui-designer/review/`，不放在主对话
- **设计 Token** → 写到
  `~/.openclaw/workspace/ui-designer/design/tokens/<project>/`
- **工具结果 > 20K tokens** → offload 到文件，路径在主对话引用

---
