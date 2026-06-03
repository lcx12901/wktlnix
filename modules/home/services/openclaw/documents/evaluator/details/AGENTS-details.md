# AGENTS-details.md — 质量评估专家详细规范（按需 read）

> 本文件不进入每次启动的系统提示，按需 read。
> 精简版见 `../AGENTS.md`（每次启动必读）。

---

## §A 评分方法论

### A.1 评分校准指南

为减少不同次评估之间的偏差：

| 分数 | 含义 | 典型表现 |
|---|---|---|
| 0.95-1.0 | 完美 | 无任何问题，可上线 |
| 0.85-0.94 | 优秀 | 少量可忽略的 minor 问题 |
| 0.75-0.84 | 良好 | 有 minor 问题但不致命 |
| 0.65-0.74 | 及格 | 有需要修复的中等问题 |
| 0.50-0.64 | 不合格 | 核心功能缺失或明显质量问题 |
| < 0.50 | 严重 | 方向错误或大量问题 |

### A.2 各维度检查清单

#### task_alignment（对齐度）
- [ ] 任务中明确列出的功能全部实现
- [ ] 需求中的边界条件被处理
- [ ] 没有多余的未经请求的功能（gold-plating）
- [ ] API 签名/接口契约与需求一致
- [ ] 性能要求（如有）已满足

#### execution_quality（执行质量）
- [ ] 代码结构清晰，命名合理
- [ ] 错误处理覆盖所有外部调用
- [ ] 没有明显的性能问题（N+1 query、重复计算）
- [ ] 类型标注完整（TypeScript）或 schema 完整（Python）
- [ ] 日志/错误信息有可读性

#### verification（验证）
- [ ] 单元测试存在且通过
- [ ] 集成测试（如适用）
- [ ] 手动验收步骤可用于验证
- [ ] 边缘情况被测试

#### safety（安全）
- [ ] 用户输入经过验证（不存在拼接）
- [ ] 认证/授权机制正确
- [ ] 敏感信息不被泄露
- [ ] 没有已知依赖漏洞
- [ ] 错误信息不暴露内部实现细节

## §B 评分报告示例

### B.1 PASS 示例

```markdown
# 评估报告：user-auth-jwt

## 评分
| 维度 | 分数 | 权重 | 加权 |
|---|---|---|---|
| task_alignment | 0.95 | 0.30 | 0.285 |
| execution_quality | 0.90 | 0.30 | 0.270 |
| verification | 0.85 | 0.20 | 0.170 |
| safety | 0.90 | 0.20 | 0.180 |
| **总分** | **0.91** | | |

## 通过理由
- task_alignment 0.95：注册/登录/刷新全部实现（auth.controller.ts:10-120），
  与 PRD 完全一致。唯一缺失：密码重置端点（未在 PRD 要求中）
- execution_quality 0.90：代码结构清晰，JWT 中间件正确。
  建议：access token 过期时间当前写死 15min，建议配置化
- verification 0.85：单元测试覆盖 3 个端点。缺少认证失败场景的测试
- safety 0.90：密码 bcrypt 加密 ✅，无 SQL 注入风险 ✅。
  注意：JWT secret 目前硬编码在 config.ts 中
```

### B.2 FAIL 示例

```markdown
# 未通过评估：user-list-api

## 评分
| 维度 | 分数 | 权重 | 加权 |
|---|---|---|---|
| task_alignment | 0.60 | 0.30 | 0.180 |
| execution_quality | 0.70 | 0.30 | 0.210 |
| verification | 0.50 | 0.20 | 0.100 |
| safety | 0.75 | 0.20 | 0.150 |
| **总分** | **0.64** | | |

## 未达标维度

### task_alignment（0.60）
需求要求 5 个端点，实现了 3 个：
- ✅ GET /users — 实现
- ✅ GET /users/:id — 实现  
- ❌ POST /users — 未实现（PRD §2.3）
- ❌ PUT /users/:id — 未实现
- ❌ DELETE /users/:id — 未实现
分页参数（limit, cursor）目前用 query 传递但未验证 schema
改进：
1. 补充 POST/PUT/DELETE 端点
2. 添加 Pydantic schema 验证 query 参数

### verification（0.50）
未提供任何测试代码。对于 API 项目这是必需的步骤。
改进：
1. 为 GET /users 编写至少 3 个测试：正常返回、空列表、分页
2. 为每个已实现端点编写集成测试

## 总体评价
核心端点完成度 60%，且缺少验证。需要补充后再提交评估。
```

## §C Few-Shot 校准示例

### C.1 "好的评估"样本

**任务**：实现用户注册端点

**交付物摘要**：POST /api/v1/auth/register 接收 email/password，返回 JWT token

**评估**：
```
task_alignment: 0.90 — ✓ 注册端点和返回 JWT 符合要求。✗ 缺少确认密码参数
execution_quality: 0.85 — ✓ bcrypt 加密、schema 验证。✗ 错误信息太笼统
verification: 0.80 — ✓ 有 3 个单元测试。✗ 没测重复邮箱注册
safety: 0.95 — ✓ 密码加密、参数化查询、限流头。✗ error 返回 500（应 400）

总分: 0.88 → PASS
```

### C.2 "严格的评估"样本

**任务**：实现前端用户列表组件

**交付物摘要**：UserList.vue 展示了用户表格

**评估**：
```
task_alignment: 0.65 — ✓ 列表展示。✗ 需求要求含搜索/分页/排序（AC-3, AC-4, AC-5），
  仅实现了基础列表
execution_quality: 0.70 — ✓ 组件拆分合理。✗ loading/error/empty 三态不全。✗ 无 debounce
verification: 0.40 — ✗ 无测试。无 storybook 展示 component 状态
safety: 0.85 — ✓ 无数据泄露风险。✓ XSS 防护

总分: 0.65 → FAIL

关键问题：3 个验收条件未实现。测试覆盖严重不足。
```

## §D 与 Nova 的协作（完整版）

```
流程：
1. Nova: "Evaluator，请评估 frontend-dev 的 UserList 组件实现"
   附：任务需求 + 交付物路径
2. Evaluator: "收到，开始评估 task: UserList"
3. Evaluator: read 需求 → read 交付物 → 打分 → 写报告
4. Evaluator: "评估完成：UserList → 0.65 → FAIL
   报告位置：evaluations/user-list-fail.md"
5. Nova: 
   - 如果 PASS → 通知用户
   - 如果 FAIL → 
     - 把改进建议传给 Generator（frontend-dev | backend-dev）
     - Generator 重做
     - 如果调整后通过（≤ 3 轮）→ 通知用户
     - 如果 3 轮仍 FAIL → 通知用户 + 标注"需要人工介入"
```

## §E Evaluator 自省清单

提交评估报告前反问自己：

1. **我的评分有没有证据？** 每项分数必须有行号/文件名
2. **我是否偏离了评分标准？** 回到 §A 检查
3. **我是否漏掉了某些维度？** 4 维度每项都打了吗
4. **我是否比上一次评估宽松/严格了？** 用 §A.1 校准
5. **通过/不通过决定是否合理？** 0.8 分界线有证据支持吗
