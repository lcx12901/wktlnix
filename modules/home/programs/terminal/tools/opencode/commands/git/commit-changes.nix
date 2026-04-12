let
  commandName = "commit-changes";
  description = "按照代码仓库规范，系统地分析、分组和提交更改";
  allowedTools = "Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git reset:*), Read, Grep";
  argumentHint = "[--all] [--amend] [--dry-run] [--interactive]";
  prompt = ''
    创建**最小、原子性的提交**，每个提交代表一次独立的逻辑变更。目标是让 git 日志清晰讲述：代码库是如何通过一系列离散、易理解的改进逐步演化的。

    ## **核心理念**

    **关键原则：每次提交只进行最小的完整逻辑更改**

    - 每次提交都必须是**可构建、可运行的状态**
    - 历史记录中不能有构建失败的情况。
    - 每个提交应当是一个可以独立存在的逻辑增强
    - 如果一个“功能”跨越多个文件，并且包含不同的逻辑组件，则该功能可能需要提交多次
    - 绝不要因为改在同一个文件或目录里，就把互不相关的改动捆绑在一个提交里
    - git 日志应该像一份由离散改进组成的变更日志（changelog）
    - 看 `git log --oneline` 的人应该能理解**改了什么（WHAT）以及为什么改（WHY）**

    **可构建性规则（THE BUILDABILITY RULE）：**
    - 每个提交都**必须**可以成功编译/构建
    - 每个提交都**必须**通过基础校验（例如 `nix flake check`）
    - 如果变更 A 依赖于变更 B，它们要么在**同一个提交**里，要么 B 必须**先提交**
    - 绝不要提交对一个“尚不存在的东西”的引用
    - 时刻思考：“别人切到**这一条**提交时，系统是否依然可用？”

    **为什么这很重要：**
    - `git bisect` 依赖于“每个提交都可测试”
    - 任意一个提交都应该可以被 cherry-pick
    - 回滚任意一个提交后，系统仍应保持可工作状态
    - 对任意单个提交，都应该可以独立进行代码评审

    **需要避免的反模式（ANTI-PATTERNS TO AVOID）：**
    - 先提交函数调用，再提交函数定义
    - 先提交 import，再提交被导入的模块
    - 先提交某个选项的使用，再提交该选项的定义
    - 用一句“Add module X”包含一个模块 X 下 5 个互不相关的子组件
    - 在只需要当前改动的一部分时，把整个文件的所有改动都暂存起来
    - 按目录结构而不是按“逻辑功能”给提交分组
    - 把格式化修复和功能性改动混在一个提交里
    - 把多个 bug 修复打包在一个提交中

    ## **工作流总览（WORKFLOW OVERVIEW）**
    1. **分析（Analysis）** —— 在“补丁块（hunk）”级别审视变更，而不是文件级别
    2. **拆分（Decomposition）** —— 将变更拆分为尽可能小的逻辑单元
    3. **选择性暂存（Selective Staging）** —— 使用 `git add -p` 暂存独立的行/补丁块
    4. **原子提交（Atomic Commits）** —— 每个提交只包含一个逻辑变更

    ## **阶段 1：细粒度变更分析（PHASE 1: GRANULAR CHANGE ANALYSIS）**

    ### **步骤 1.1：按补丁块（Hunk）检查**

    ```bash
    # 查看所有更改及其上下文
    git diff

    # 对于每个文件，检查各个代码块
    git diff -U5<file> # 更多上下文信息，以便理解

    # 识别每个文件内的逻辑边界
    ```

    **针对每个补丁块，问自己：**
    - 这段补丁块“单独完成了一件什么事情”？
    - 这个补丁块是否独立于同一文件中的其他补丁块？
    - 这个补丁块能否单独提交且保持代码库可工作？
    - 这个补丁块是否应当与其他文件中的补丁块归到同一个逻辑变更里？

    ### **步骤 1.2：变更拆解（Change Decomposition）**

    ```
    对于每个修改过的文件：
        对于文件中的每个补丁块：
            明确这个具体变更的“目的”：
                - 是修 bug 吗？
                - 是新功能的某个组成部分吗？
                - 是重构吗？
                - 是文档变更吗？
                - 是格式/风格调整吗？
    ```

    ### **步骤 1.3：跨文件分组（Cross-File Grouping）**

    - 将不同文件中**相关的补丁块**分到同一组
    - 确保每一组都代表一个逻辑变更
    - 识别组与组之间的依赖关系

    ## **阶段 2：暂存策略（PHASE 2: STAGING STRATEGY）**

    ### **步骤 2.1：制定暂存计划（Create Staging Plan）**

    - 列出每一个逻辑变更组
    - 按依赖顺序对变更组排序（如果存在依赖）
    - 规划暂存顺序

    ### **步骤 2.2：选择性暂存（Selective Staging）**

    ```bash
    # 暂存特定补丁块
    git add -p

    # 暂存特定文件
    git add path/to/file

    # 暂存特定行（高级用法）
    git add -e
    ```

    ### **步骤 2.3：校验暂存内容（Verify Staging）**

    - 在每次暂存一个变更组后查看 `git status`
    - 用 `git diff --cached` 检查已暂存的 diff
    - 确认没有无关改动被一并暂存

    ## **阶段 3：创建提交（PHASE 3: COMMIT CREATION）**

    ### **步骤 3.1：提交信息（Commit Message）**

    - 遵循约定式（conventional commits）提交信息格式
    - 说明为什么需要这个变更
    - 保持标题行（subject line）在 72 字符以内
    - 备注行（body）可以详细描述变更的背景、实现细节和任何相关信息

    ### 步骤 3.2：验证提交（Validate Commit）

    - 确保此次提交能构建/测试通过
    - 确认提交中只包含你打算提交的改动

    ## **输出格式（Output Format）：**

    ```markdown
    ## Commit Plan
    - **Commit 1:** [Description]
    - **Commit 2:** [Description]

    ## Staging Commands
    ```bash
    git add <files>
    ```

    ## Commit Messages
    - `feat: add ...`
    - `fix: correct ...`

    ## Notes
    - [任何警告或注意事项]
    ```

    提供清晰、简洁的提交计划，并在提交前请求确认。
  '';
in
{
  ${commandName} = {
    inherit
      commandName
      description
      allowedTools
      argumentHint
      prompt
      ;
  };
}
