# Claude Code PM

[![Claude Code](https://img.shields.io/badge/+-Claude%20Code-d97757)](https://github.com/landian01/ccpm/blob/main/README.md)
[![GitHub Issues](https://img.shields.io/badge/+-GitHub%20Issues-1f2328)](https://github.com/landian01/ccpm)
&nbsp;
[![MIT License](https://img.shields.io/badge/License-MIT-28a745)](https://github.com/landian01/ccpm/blob/main/LICENSE)
&nbsp;
[![Star this repo](https://img.shields.io/badge/★-Star%20this%20repo-e7b10b)](https://github.com/landian01/ccpm)

### Claude Code 工作流，使用规范驱动开发、GitHub Issues、Git 工作树和多个并行运行的 AI 代理来交付 ~~更快~~ _更好_ 的软件。

停止丢失上下文。停止任务阻塞。停止发布有缺陷的软件。这个经过实战检验的系统将 PRD 转换为史诗任务，史诗任务转换为 GitHub Issues，Issues 转换为生产代码——每一步都有完整的可追溯性。

![Claude Code PM](screenshot.webp)

## 目录

- [背景](#背景)
- [工作流程](#工作流程)
- [有何不同](#有何不同)
- [为什么选择 GitHub Issues](#为什么选择-github-issues)
- [核心原则：禁止凭感觉编码](#核心原则禁止凭感觉编码)
- [系统架构](#系统架构)
- [工作流程阶段](#工作流程阶段)
- [命令参考](#命令参考)
- [并行执行系统](#并行执行系统)
- [主要功能和优势](#主要功能和优势)
- [验证结果](#验证结果)
- [示例流程](#示例流程)
- [立即开始](#立即开始)
- [本地与远程](#本地与远程)
- [技术说明](#技术说明)
- [支持此项目](#支持此项目)

## 背景

每个团队都在挣扎于同样的问题：
- **上下文消失** 在会话之间，迫使我们不断重新发现
- **并行工作产生冲突** 当多个开发者接触相同代码时
- **需求漂移** 当口头决策覆盖书面规范时
- **进度变得不可见** 直到最后时刻

这个系统解决了所有这些问题。

## 工作流程

```mermaid
graph LR
    A[PRD 创建] --> B[史诗规划]
    B --> C[任务分解]
    C --> D[GitHub 同步]
    D --> E[并行执行]
```

### 亲眼见证 (60 秒)

```bash
# 通过引导式头脑风暴创建全面的 PRD
/pm:prd-new memory-system

# 将 PRD 转换为包含任务分解的技术史诗
/pm:prd-parse memory-system

# 推送到 GitHub 并开始并行执行
/pm:epic-oneshot memory-system
/pm:issue-start 1235
```

## 有何不同？

| 传统开发 | Claude Code PM 系统 |
|------------------------|----------------------|
| 会话间上下文丢失 | **持久化上下文** 贯穿所有工作 |
| 串行任务执行 | **并行代理** 处理独立任务 |
| 凭记忆"凭感觉编码" | **规范驱动** 具有完整可追溯性 |
| 进度隐藏在分支中 | **透明审计跟踪** 在 GitHub 中 |
| 手动任务协调 | **智能优先级排序** 使用 `/pm:next` |

## 为什么选择 GitHub Issues？

大多数 Claude Code 工作流程在隔离中运行——单个开发者在本地环境中与 AI 一起工作。这产生了一个根本性问题：**AI 辅助开发变成了一个孤岛**。

通过使用 GitHub Issues 作为我们的数据库，我们解锁了强大的功能：

### 🤝 **真正的团队协作**
- 多个 Claude 实例可以同时在同一项目上工作
- 人类开发者通过 issue 评论实时看到 AI 进度
- 团队成员可以在任何地方加入——上下文始终可见
- 管理者获得透明度而不会中断工作流

### 🔄 **无缝的人机交接**
- AI 可以开始任务，人类可以完成（反之亦然）
- 进度更新对所有人可见，不会被困在聊天日志中
- 代码审查通过 PR 评论自然发生
- 没有"AI 做了什么？"的会议

### 📈 **超越单人工作的可扩展性**
- 添加团队成员而无需入职摩擦
- 多个 AI 代理在不同问题上并行工作
- 分布式团队自动保持同步
- 与现有的 GitHub 工作流程和工具配合使用

### 🎯 **单一真实来源**
- 没有单独的数据库或项目管理工具
- Issue 状态就是项目状态
- 评论就是审计跟踪
- 标签提供组织结构

这不仅仅是一个项目管理系统——它是一个**协作协议**，让人类和 AI 代理可以大规模协作，使用您的团队已经信任的基础设施。

## 核心原则：禁止凭感觉编码

> **每行代码都必须追溯到规范。**

我们遵循严格的 5 阶段纪律：

1. **🧠 头脑风暴** - 思考得比舒适区更深
2. **📝 文档** - 编写不留解释空间的规范
3. **📐 计划** - 制定明确技术决策的架构
4. **⚡ 执行** - 精确构建指定的内容
5. **📊 跟踪** - 在每一步保持透明的进度

没有捷径。没有假设。没有遗憾。

## 系统架构

```
.claude/
├── CLAUDE.md          # 始终在线的指令（将内容复制到项目的 CLAUDE.md 文件）
├── agents/            # 面向任务的代理（用于上下文保存）
├── commands/          # 命令定义
│   ├── context/       # 创建、更新和加载上下文
│   ├── pm/            # ← 项目管理命令（此系统）
│   └── testing/       # 加载和执行测试（编辑此）
├── context/           # 项目范围的上下文文件
├── epics/             # ← PM 的本地工作区（放在 .gitignore 中）
│   └── [epic-name]/   # 史诗和相关任务
│       ├── epic.md    # 实施计划
│       ├── [#].md     # 单个任务文件
│       └── updates/   # 进行中的更新
├── prds/              # ← PM 的 PRD 文件
├── rules/             # 在此放置您想要引用的任何规则文件
└── scripts/           # 在此放置您想要使用的任何脚本文件
```

## 工作流程阶段

### 1. 产品规划阶段

```bash
/pm:prd-new feature-name
```
启动全面的头脑风暴来创建产品需求文档，捕捉愿景、用户故事、成功标准和约束条件。

**输出：** `.claude/prds/feature-name.md`

### 2. 实施规划阶段

```bash
/pm:prd-parse feature-name
```
将 PRD 转换为技术实施计划，包含架构决策、技术方法和依赖关系映射。

**输出：** `.claude/epics/feature-name/epic.md`

### 3. 任务分解阶段

```bash
/pm:epic-decompose feature-name
```
将史诗分解为具体的、可操作的任务，包含验收标准、工作量估计和并行化标志。

**输出：** `.claude/epics/feature-name/[task].md`

### 4. GitHub 同步

```bash
/pm:epic-sync feature-name
# 或者对于自信的工作流程：
/pm:epic-oneshot feature-name
```
将史诗和任务作为具有适当标签和关系的 issues 推送到 GitHub。

### 5. 执行阶段

```bash
/pm:issue-start 1234  # 启动专业化代理
/pm:issue-sync 1234   # 推送进度更新
/pm:next             # 获取下一个优先级任务
```
专业化代理实施任务，同时维护进度更新和审计跟踪。

## 命令参考

> [!TIP]
> 输入 `/pm:help` 获取简洁的命令摘要

### 初始设置
- `/pm:init` - 安装依赖项并配置 GitHub

### PRD 命令
- `/pm:prd-new` - 为新产品需求启动头脑风暴
- `/pm:prd-parse` - 将 PRD 转换为实施史诗
- `/pm:prd-list` - 列出所有 PRD
- `/pm:prd-edit` - 编辑现有 PRD
- `/pm:prd-status` - 显示 PRD 实施状态

### 史诗命令
- `/pm:epic-decompose` - 将史诗分解为任务文件
- `/pm:epic-sync` - 将史诗和任务推送到 GitHub
- `/pm:epic-oneshot` - 在一个命令中分解和同步
- `/pm:epic-list` - 列出所有史诗
- `/pm:epic-show` - 显示史诗及其任务
- `/pm:epic-close` - 将史诗标记为完成
- `/pm:epic-edit` - 编辑史诗详情
- `/pm:epic-refresh` - 从任务更新史诗进度

### Issue 命令
- `/pm:issue-show` - 显示 issue 和子 issue
- `/pm:issue-status` - 检查 issue 状态
- `/pm:issue-start` - 使用专业化代理开始工作
- `/pm:issue-sync` - 将更新推送到 GitHub
- `/pm:issue-close` - 将 issue 标记为完成
- `/pm:issue-reopen` - 重新打开已关闭的 issue
- `/pm:issue-edit` - 编辑 issue 详情

### 工作流程命令
- `/pm:next` - 显示具有史诗上下文的下一个优先级 issue
- `/pm:status` - 整体项目仪表板
- `/pm:standup` - 每日站会报告
- `/pm:blocked` - 显示被阻止的任务
- `/pm:in-progress` - 列出进行中的工作

### 同步命令
- `/pm:sync` - 与 GitHub 完全双向同步
- `/pm:import` - 导入现有 GitHub issues

### 维护命令
- `/pm:validate` - 检查系统完整性
- `/pm:clean` - 归档已完成工作
- `/pm:search` - 跨所有内容搜索

## 并行执行系统

### Issues 不是原子的

传统思维：一个 issue = 一个开发者 = 一个任务

**现实：一个 issue = 多个并行工作流**

单个"实现用户认证"issue 不是一个任务。它是...

- **代理 1**：数据库表和迁移
- **代理 2**：服务层和业务逻辑
- **代理 3**：API 端点和中间件
- **代理 4**：UI 组件和表单
- **代理 5**：测试套件和文档

所有在同一个 worktree 中**同时**运行。

### 速度的数学

**传统方法：**
- 3 个问题的史诗
- 串行执行

**此系统：**
- 相同的史诗有 3 个问题
- 每个 issue 分解为 ~4 个并行流
- **12 个代理同时工作**

我们不是将代理分配给 issues。我们**利用多个代理**来更快地交付。

### 上下文优化

**传统单线程方法：**
- 主对话承载所有实施细节
- 上下文窗口充满数据库模式、API 代码、UI 组件
- 最终达到上下文限制并失去连贯性

**并行代理方法：**
- 主线程保持清洁和战略性
- 每个代理在隔离中处理自己的上下文
- 实施细节不会污染主对话
- 主线程保持监督而不会陷入代码中

您的主对话成为指挥者，而不是管弦乐队。

### GitHub 与本地：完美分离

**GitHub 看到的：**
- 清洁、简单的 issues
- 进度更新
- 完成状态

**实际本地发生的：**
- Issue #1234 爆炸成 5 个并行代理
- 代理通过 Git 提交协调
- 复杂的编排隐藏在视线之外

GitHub 不需要知道工作是如何完成的——只知道它**已完成**。

### 命令流

```bash
# 分析可以并行化的内容
/pm:issue-analyze 1234

# 启动群组
/pm:epic-start memory-system

# 观看魔法
# 12 个代理在 3 个问题上工作
# 全部在：../epic-memory-system/

# 完成时一次干净合并
/pm:epic-merge memory-system
```

## 主要功能和优势

### 🧠 **上下文保存**
永不再丢失项目状态。每个史诗维护自己的上下文，代理从 `.claude/context/` 读取，并在同步前本地更新。

### ⚡ **并行执行**
通过多个代理同时工作来更快地交付。标记为 `parallel: true` 的任务实现无冲突的并发开发。

### 🔗 **GitHub 原生**
与您的团队已经使用的工具配合使用。Issues 是真实来源，评论提供历史记录，并且不依赖 Projects API。

### 🤖 **代理专业化**
为每项工作使用合适的工具。UI、API 和数据库工作的不同代理。每个自动读取需求并发布更新。

### 📊 **完整可追溯性**
每个决策都有文档记录。PRD → 史诗 → 任务 → Issue → 代码 → 提交。从想法到生产的完整审计跟踪。

### 🚀 **开发者生产力**
专注于构建，而不是管理。智能优先级排序、自动上下文加载，以及在准备就绪时增量同步。

## 验证结果

使用此系统的团队报告：
- **89% 更少的时间** 丢失于上下文切换——您会更频繁地使用 `/compact` 和 `/clear`
- **5-8 个并行任务** vs 之前 1 个——同时编辑/测试多个文件
- **75% 的缺陷率降低**——由于将功能分解为详细任务
- **功能交付速度提升高达 3 倍**——基于功能大小和复杂性

## 示例流程

```bash
# 开始新功能
/pm:prd-new memory-system

# 审查和完善 PRD...

# 创建实施计划
/pm:prd-parse memory-system

# 审查史诗...

# 分解任务并推送到 GitHub
/pm:epic-oneshot memory-system
# 创建 issues：#1234 (史诗), #1235, #1236 (任务)

# 在任务上开始开发
/pm:issue-start 1235
# 代理开始工作，维护本地进度

# 同步进度到 GitHub
/pm:issue-sync 1235
# 更新作为 issue 评论发布

# 检查整体状态
/pm:epic-show memory-system
```

## 立即开始

### 快速设置 (2 分钟)

1. **获取项目文件**：
   ```bash
   # 克隆项目到临时目录，然后复制 .claude 目录
   git clone https://github.com/landian01/ccpm.git temp-ccpm
   cp -r temp-ccpm/.claude ./
   rm -rf temp-ccpm
   
   ```


2. **初始化 PM 系统**：
   ```bash
   /pm:init
   ```
   此命令将：
   - 安装 GitHub CLI（如果需要）
   - 使用 GitHub 进行身份验证
   - 安装 [gh-sub-issue extension](https://github.com/yahsan2/gh-sub-issue) 用于适当的父子关系
   - 创建所需目录
   - 更新 .gitignore

3. **创建 `CLAUDE.md`** 包含您的仓库信息
   ```bash
   /init include rules from .claude/CLAUDE.md
   ```
   > 如果您已经有 `CLAUDE.md` 文件，请运行：`/re-init` 以使用 `.claude/CLAUDE.md` 中的重要规则更新它。

4. **加载系统**：
   ```bash
   /context:create
   ```



5. **开始您的第一个功能**

```bash
/pm:prd-new your-feature-name
```

观看结构化规划如何转换为已交付的代码。

## 本地与远程

| 操作 | 本地 | GitHub |
|-----------|-------|--------|
| PRD 创建 | ✅ | — |
| 实施规划 | ✅ | — |
| 任务分解 | ✅ | ✅ (同步) |
| 执行 | ✅ | — |
| 状态更新 | ✅ | ✅ (同步) |
| 最终交付物 | — | ✅ |

## 技术说明

### GitHub 集成
- 使用 **gh-sub-issue extension** 进行适当的父子关系
- 如果未安装扩展，则回退到任务列表
- 史诗 issues 自动跟踪子任务完成
- 标签提供额外组织（`epic:feature`、`task:feature`）

### 文件命名约定
- 任务在分解期间以 `001.md`、`002.md` 开头
- GitHub 同步后，重命名为 `{issue-id}.md`（例如 `1234.md`）
- 便于导航：issue #1234 = 文件 `1234.md`

### 设计决策
- 故意避免 GitHub Projects API 的复杂性
- 所有命令首先在本地文件上操作以提高速度
- 与 GitHub 的同步是明确和受控的
- Worktrees 为并行工作提供干净的 git 隔离
- 可以单独添加 GitHub Projects 用于可视化

