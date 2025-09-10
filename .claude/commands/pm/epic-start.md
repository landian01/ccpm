---
allowed-tools: Bash, Read, Write, LS, Task
---

# 史诗开始

在共享分支中启动并行代理处理史诗任务。

## 用法
```
/pm:epic-start <epic_name>
```

## 快速检查

1. **验证史诗是否存在：**
   ```bash
   test -f .claude/epics/$ARGUMENTS/epic.md || echo "❌ 未找到史诗。先运行：/pm:prd-parse $ARGUMENTS"
   ```

2. **检查 GitHub 同步：**
   在史诗前置元数据中查找 `github:` 字段。
   如果缺失："❌ 史诗未同步。先运行：/pm:epic-sync $ARGUMENTS"

3. **检查分支：**
   ```bash
   git branch -a | grep "epic/$ARGUMENTS"
   ```

4. **检查未提交的更改：**
   ```bash
   git status --porcelain
   ```
   如果输出不为空："❌ 您有未提交的更改。请在开始史诗前提交或暂存它们"

## 指令

### 1. 创建或进入分支

遵循 `/rules/branch-operations.md`：

```bash
# 检查未提交的更改
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ 您有未提交的更改。请在开始史诗前提交或暂存它们。"
  exit 1
fi

# 如果分支不存在，创建它
if ! git branch -a | grep -q "epic/$ARGUMENTS"; then
  git checkout main
  git pull origin main
  git checkout -b epic/$ARGUMENTS
  git push -u origin epic/$ARGUMENTS
  echo "✅ 已创建分支：epic/$ARGUMENTS"
else
  git checkout epic/$ARGUMENTS
  git pull origin epic/$ARGUMENTS
  echo "✅ 使用现有分支：epic/$ARGUMENTS"
fi
```

### 2. 识别就绪的问题

读取 `.claude/epics/$ARGUMENTS/` 中的所有任务文件：
- 解析前置元数据中的 `status`、`depends_on`、`parallel` 字段
- 如果需要检查 GitHub 问题状态
- 构建依赖关系图

对问题进行分类：
- **就绪**：没有未满足的依赖关系，未开始
- **阻塞**：有未满足的依赖关系
- **进行中**：已经在处理中
- **完成**：已完成

### 3. 分析就绪的问题

对于每个没有分析的就绪问题：
```bash
# 检查分析
if ! test -f .claude/epics/$ARGUMENTS/{issue}-analysis.md; then
  echo "正在分析问题 #{issue}..."
  # 运行分析（内联或通过 Task 工具）
fi
```

### 4. 启动并行代理

对于每个有分析的就绪问题：

```markdown
## 开始问题 #{issue}：{title}

正在读取分析...
发现 {count} 个并行流：
  - 流 A：{description} (Agent-{id})
  - 流 B：{description} (Agent-{id})

在分支中启动代理：epic/$ARGUMENTS
```

使用 Task 工具启动每个流：
```yaml
Task:
  description: "Issue #{issue} Stream {X}"
  subagent_type: "{agent_type}"
  prompt: |
    工作分支：epic/$ARGUMENTS
    问题：#{issue} - {title}
    流：{stream_name}

    您的范围：
    - 文件：{file_patterns}
    - 工作：{stream_description}

    从以下位置读取完整要求：
    - .claude/epics/$ARGUMENTS/{task_file}
    - .claude/epics/$ARGUMENTS/{issue}-analysis.md

    遵循 /rules/agent-coordination.md 中的协调规则

    频繁提交，使用消息格式：
    "Issue #{issue}: {specific change}"

    在以下位置更新进度：
    .claude/epics/$ARGUMENTS/updates/{issue}/stream-{X}.md
```

### 5. 跟踪活跃代理

创建/更新 `.claude/epics/$ARGUMENTS/execution-status.md`：

```markdown
---
started: {datetime}
branch: epic/$ARGUMENTS
---

# 执行状态

## 活跃代理
- Agent-1: Issue #1234 Stream A (Database) - Started {time}
- Agent-2: Issue #1234 Stream B (API) - Started {time}
- Agent-3: Issue #1235 Stream A (UI) - Started {time}

## 排队问题
- Issue #1236 - 等待 #1234
- Issue #1237 - 等待 #1235

## 已完成
- {None yet}
```

### 6. 监控和协调

设置监控：
```bash
echo "
代理启动成功！

监控进度：
  /pm:epic-status $ARGUMENTS

查看分支更改：
  git status

停止所有代理：
  /pm:epic-stop $ARGUMENTS

完成后合并：
  /pm:epic-merge $ARGUMENTS
"
```

### 7. 处理依赖关系

当代理完成流时：
- 检查是否有阻塞的问题现在就绪
- 为新就绪的工作启动新的代理
- 更新 execution-status.md

## 输出格式

```
🚀 史诗执行已开始：$ARGUMENTS

分支：epic/$ARGUMENTS

在 {issue_count} 个问题中启动 {total} 个代理：

Issue #1234: Database Schema
  ├─ Stream A: Schema creation (Agent-1) ✓ Started
  └─ Stream B: Migrations (Agent-2) ✓ Started

Issue #1235: API Endpoints
  ├─ Stream A: User endpoints (Agent-3) ✓ Started
  ├─ Stream B: Post endpoints (Agent-4) ✓ Started
  └─ Stream C: Tests (Agent-5) ⏸ Waiting for A & B

阻塞问题 (2):
  - #1236: UI Components (depends on #1234)
  - #1237: Integration (depends on #1235, #1236)

使用以下命令监控：/pm:epic-status $ARGUMENTS
```

## 错误处理

如果代理启动失败：
```
❌ 启动代理失败 Agent-{id}
  问题：#{issue}
  流：{stream}
  错误：{reason}

继续其他代理？（yes/no）
```

如果发现未提交的更改：
```
❌ 您有未提交的更改。请在开始史诗前提交或暂存它们。

要提交更改：
  git add .
  git commit -m "您的提交消息"

要暂存更改：
  git stash push -m "进行中的工作"
  # (稍后恢复：git stash pop)
```

如果分支创建失败：
```
❌ 无法创建分支
  {git 错误消息}

尝试：git branch -d epic/$ARGUMENTS
或者：使用 git branch -a 检查现有分支
```

## 重要说明

- 遵循 `/rules/branch-operations.md` 进行 git 操作
- 遵循 `/rules/agent-coordination.md` 进行并行工作
- 代理在同一分支中工作（不是单独分支）
- 最大并行代理数量应合理（例如，5-10）
- 如果启动多个代理，请监控系统资源
