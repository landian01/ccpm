---
allowed-tools: Bash, Read, Write, LS
---

# 问题关闭

标记问题为完成并在 GitHub 上关闭它。

## 用法
```
/pm:issue-close <issue_number> [completion_notes]
```

## 指令

### 1. 查找本地任务文件

首先检查 `.claude/epics/*/$ARGUMENTS.md` 是否存在（新命名）。
如果未找到，在前置元数据中搜索包含 `github:.*issues/$ARGUMENTS` 的任务文件（旧命名）。
如果未找到："❌ 问题 #$ARGUMENTS 没有本地任务"

### 2. 更新本地状态

获取当前日期时间：`date -u +"%Y-%m-%dT%H:%M:%SZ"`

更新任务文件前置元数据：
```yaml
status: closed
updated: {current_datetime}
```

### 3. 更新进度文件

如果进度文件存在于 `.claude/epics/{epic}/updates/$ARGUMENTS/progress.md`：
- 设置完成度：100%
- 添加带有时间戳的完成说明
- 使用当前日期时间更新 last_sync

### 4. 在 GitHub 上关闭

添加完成评论并关闭：
```bash
# 添加最终评论
echo "✅ 任务已完成

$ARGUMENTS

---
关闭时间：{timestamp}" | gh issue comment $ARGUMENTS --body-file -

# 关闭问题
gh issue close $ARGUMENTS
```

### 5. 更新 GitHub 上的史诗任务列表

在史诗问题中勾选任务复选框：

```bash
# 从本地任务文件路径获取史诗名称
epic_name={extract_from_path}

# 从 epic.md 获取史诗问题编号
epic_issue=$(grep 'github:' .claude/epics/$epic_name/epic.md | grep -oE '[0-9]+$')

if [ ! -z "$epic_issue" ]; then
  # 获取当前史诗主体
  gh issue view $epic_issue --json body -q .body > /tmp/epic-body.md

  # 勾选此任务
  sed -i "s/- \[ \] #$ARGUMENTS/- [x] #$ARGUMENTS/" /tmp/epic-body.md

  # 更新史诗问题
  gh issue edit $epic_issue --body-file /tmp/epic-body.md

  echo "✓ 已更新 GitHub 上的史诗进度"
fi
```

### 6. 更新史诗进度

- 计算史诗中的总任务数
- 计算已关闭的任务数
- 计算新的进度百分比
- 更新 epic.md 前置元数据的进度字段

### 7. 输出

```
✅ 已关闭问题 #$ARGUMENTS
  本地：任务标记为完成
  GitHub：问题已关闭 & 史诗已更新
  史诗进度：{new_progress}% ({closed}/{total} 任务完成)

下一步：运行 /pm:next 获取下一个优先级任务
```

## 重要说明

更新时遵循 `/rules/frontmatter-operations.md`。
GitHub 命令遵循 `/rules/github-operations.md`。
始终在 GitHub 之前同步本地状态。