# 工作树操作

Git 工作树通过允许同一仓库有多个工作目录来实现并行开发。

## 创建工作树

始终从干净的主分支创建工作树：
```bash
# 确保 main 是最新的
git checkout main
git pull origin main

# 为史诗创建工作树
git worktree add ../epic-{name} -b epic/{name}
```

工作树将作为同级目录创建，以保持清晰的分离。

## 在工作树中工作

### 代理提交
- 代理直接提交到工作树
- 使用小的、专注的提交
- 提交消息格式：`Issue #{number}: {description}`
- 示例：`Issue #1234: 添加用户身份验证模式`

### 文件操作
```bash
# 工作目录是工作树
cd ../epic-{name}

# 正常的 git 操作工作
git add {files}
git commit -m "Issue #{number}: {change}"

# 查看工作树状态
git status
```

## 在同一工作树中并行工作

多个代理可以在同一工作树中工作，如果它们处理不同的文件：
```bash
# 代理 A 在 API 上工作
git add src/api/*
git commit -m "Issue #1234: 添加用户端点"

# 代理 B 在 UI 上工作（没有冲突！）
git add src/ui/*
git commit -m "Issue #1235: 添加仪表板组件"
```

## 合并工作树

当史诗完成时，合并回 main：
```bash
# From main repository (not worktree)
cd {main-repo}
git checkout main
git pull origin main

# Merge epic branch
git merge epic/{name}

# If successful, clean up
git worktree remove ../epic-{name}
git branch -d epic/{name}
```

## 处理冲突

如果合并冲突发生：
```bash
# 冲突将会显示
git status

# 人工解决冲突
# 然后继续合并
git add {resolved-files}
git commit
```

## 工作树管理

### 列出活动工作树
```bash
git worktree list
```

### 移除过期工作树
```bash
# 如果工作树目录被删除
git worktree prune

# 强制移除工作树
git worktree remove --force ../epic-{name}
```

### 检查工作树状态
```bash
# 从主仓库
cd ../epic-{name} && git status && cd -
```

## 最佳实践

1. **每个史诗一个工作树** - 不是每个问题
2. **创建前清理** - 始终从更新的 main 开始
3. **频繁提交** - 小提交更容易合并
4. **合并后删除** - 不要留下过期的工作树
5. **使用描述性分支** - `epic/feature-name` 而不是 `feature`

## 常见问题

### 工作树已存在
```bash
# 先移除旧工作树
git worktree remove ../epic-{name}
# 然后创建新的
```

### 分支已存在
```bash
# 删除旧分支
git branch -D epic/{name}
# 或使用现有分支
git worktree add ../epic-{name} epic/{name}
```

### 无法移除工作树
```bash
# 强制移除
git worktree remove --force ../epic-{name}
# 清理引用
git worktree prune
```