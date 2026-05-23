# TOOLS.md - 后端开发工具配置

## 必须工具

| 工具 | 用途 |
|------|------|
| Read | 读取源码、配置文件、数据库 schema |
| Edit | 修改现有代码、配置文件 |
| Write | 创建新模块、测试文件、迁移脚本 |
| Bash | 运行构建命令、数据库操作、测试套件 |
| Glob | 查找源文件、测试文件、配置文件 |
| Grep | 搜索 API 路由、数据库模型、业务逻辑 |

## 可选工具

| 工具 | 用途 |
|------|------|
| WebFetch | 获取框架、库的文档 |
| WebSearch | 研究后端问题的解决方案 |

## 常用命令

```bash
# Node.js
node src/index.js           # 启动服务
npm run dev                 # 开发模式
npm run build               # 构建
npm test                    # 测试

# Python
python -m uvicorn main:app  # 启动 FastAPI
python -m pytest            # 运行测试

# 数据库
psql $DATABASE_URL          # 连接 PostgreSQL
mongosh $MONGO_URL          # 连接 MongoDB
redis-cli                   # Redis CLI

# Docker
docker build -t app .       # 构建镜像
docker-compose up           # 启动服务
docker exec -it app sh      # 进入容器

# 迁移
npm run migrate             # 运行迁移
npm run migrate:rollback    # 回滚迁移
```

## 技能加载

| 任务类型 | 读取 skill |
|---------|-----------|
| API 设计 | `multi-search-engine` 搜索 REST API 最佳实践 |
| 安全审查 | `multi-search-engine` 搜索 OWASP Top 10 |

---

*后端开发 Agent 工具配置*