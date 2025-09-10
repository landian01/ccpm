# Agent 协调规则

在同一个史诗工作树中并行工作的多个代理的规则。

## 并行执行原则

1. **文件级并行** - 在不同文件上工作的代理永远不会冲突
2. **明确协调** - 当需要相同文件时，明确协调
3. **快速失败** - 立即暴露冲突，不要试图耍小聪明
4. **人工解决** - 冲突由人类解决，而不是代理

## 工作流分配

每个代理从问题分析中分配一个工作流：
```yaml
# From {issue}-analysis.md
Stream A: Database Layer
  Files: src/db/*, migrations/*
  Agent: backend-specialist

Stream B: API Layer
  Files: src/api/*
  Agent: api-specialist
```

代理应该只修改其分配模式中的文件。

## 文件访问协调

### 修改前检查
修改共享文件之前：
```bash
# Check if file is being modified
git status {file}

# 如果被另一个代理修改，等待
if [[ $(git status --porcelain {file}) ]]; then
  echo "等待 {file} 可用..."
  sleep 30
  # 重试
fi
```

### 原子提交
使提交原子化和专注：
```bash
# 好 - 单一目的提交
git add src/api/users.ts src/api/users.test.ts
git commit -m "Issue #1234: 添加用户 CRUD 端点"

# 坏 - 混合关注点
git add src/api/* src/db/* src/ui/*
git commit -m "Issue #1234: 多个更改"
```

## 代理间通信

### 通过提交
代理通过提交看到彼此的工作：
```bash
# 代理检查其他人做了什么
git log --oneline -10

# 代理拉取最新更改
git pull origin epic/{name}
```

### 通过进度文件
每个流维护进度：
```markdown
# .claude/epics/{epic}/updates/{issue}/stream-A.md
---
stream: 数据库层
agent: 后端专家
started: {datetime}
status: in_progress
---

## 已完成
- 创建用户表模式
- 添加迁移文件

## 正在进行
- 添加索引

## 被阻塞
- 无
```

### 通过分析文件
分析文件是契约：
```yaml
# 代理读取这个以了解边界
Stream A:
  Files: src/db/*  # 只有代理 A 触摸这些
Stream B:
  Files: src/api/* # 只有代理 B 触摸这些
```

## 处理冲突

### 冲突检测
```bash
# 如果提交因冲突失败
git commit -m "Issue #1234: 更新"
# 错误：存在冲突

# 代理应该报告并等待
echo "❌ 在 {files} 中检测到冲突"
echo "需要人工干预"
```

### 冲突解决
始终听从人类：
1. 代理检测冲突
2. 代理报告问题
3. 代理暂停工作
4. 人类解决
5. 代理继续

永远不要尝试自动合并解决。

## 同步点

### 自然同步点
- 每次提交后
- 开始新文件前
- 切换工作流时
- 每工作30分钟

### 明确同步
```bash
# 拉取最新更改
git pull --rebase origin epic/{name}

# 如果有冲突，停止并报告
if [[ $? -ne 0 ]]; then
  echo "❌ 同步失败 - 需要人工帮助"
  exit 1
fi
```

## 代理通信协议

### 状态更新
代理应该定期更新其状态：
```bash
# 每个重要步骤更新进度文件
echo "✅ 已完成：数据库模式" >> stream-A.md
git add stream-A.md
git commit -m "进度：流 A - 模式完成"
```

### 协调请求
当代理需要协调时：
```markdown
# 在 stream-A.md 中
## 需要协调
- 需要更新 src/types/index.ts
- 将在流 B 提交后修改
- 预计时间：10分钟
```

## 并行提交策略

### 无冲突可能
在完全不同的文件上工作时：
```bash
# 这些可以同时发生
代理-A: git commit -m "Issue #1234: 更新数据库"
代理-B: git commit -m "Issue #1235: 更新 UI"
代理-C: git commit -m "Issue #1236: 添加测试"
```

### 需要时顺序执行
当触及共享资源时：
```bash
# 代理 A 先提交
git add src/types/index.ts
git commit -m "Issue #1234: 更新类型定义"

# 代理 B 等待，然后继续
# (在 A 提交后)
git pull
git add src/api/users.ts
git commit -m "Issue #1235: 使用新类型"
```

## 最佳实践

1. **早提交，常提交** - 更小的提交 = 更少的冲突
2. **待在自己的车道** - 只修改分配的文件
3. **沟通更改** - 更新进度文件
4. **频繁拉取** - 与其他代理保持同步
5. **大声失败** - 立即报告问题
6. **永远不要强制** - 绝不使用 `--force` 标志

## 常见模式

### 开始工作
```bash
1. cd ../epic-{name}
2. git pull
3. 检查 {issue}-analysis.md 获取分配
4. 更新 stream-{X}.md 为 "started"
5. 开始在分配的文件上工作
```

### 工作期间
```bash
1. 对分配的文件进行更改
2. 用清晰的消息提交
3. 更新进度文件
4. 检查来自他人的新提交
5. 根据需要继续或协调
```

### 完成工作
```bash
1. 流的最终提交
2. 更新 stream-{X}.md 为 "completed"
3. 检查其他流是否需要帮助
4. 报告完成
```
