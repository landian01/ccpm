---
allowed-tools: Bash, Read, LS
---

# 问题显示

显示问题和子问题以及详细信息。

## 用法
```
/pm:issue-show <issue_number>
```

## 指令

您正在显示关于 GitHub 问题和相关子问题的综合信息：**问题 #$ARGUMENTS**

### 1. 获取问题数据
- 使用 `gh issue view #$ARGUMENTS` 获取 GitHub 问题详情
- 查找本地任务文件：首先检查 `.claude/epics/*/$ARGUMENTS.md`（新命名）
- 如果未找到，在 frontmatter 中搜索包含 `github:.*issues/$ARGUMENTS` 的文件（旧命名）
- 检查相关问题和子任务

### 2. 问题概述
显示问题标题：
```
🎫 问题 #$ARGUMENTS: {Issue Title}
   状态: {open/closed}
   标签: {labels}
   分配给: {assignee}
   Created: {creation_date}
   Updated: {last_update}
   
📝 Description:
{issue_description}
```

### 3. Local File Mapping
If local task file exists:
```
📁 Local Files:
   Task file: .claude/epics/{epic_name}/{task_file}
   Updates: .claude/epics/{epic_name}/updates/$ARGUMENTS/
   Last local update: {timestamp}
```

### 4. Sub-Issues and Dependencies
Show related issues:
```
🔗 Related Issues:
   Parent Epic: #{epic_issue_number}
   Dependencies: #{dep1}, #{dep2}
   Blocking: #{blocked1}, #{blocked2}
   Sub-tasks: #{sub1}, #{sub2}
```

### 5. Recent Activity
Display recent comments and updates:
```
💬 Recent Activity:
   {timestamp} - {author}: {comment_preview}
   {timestamp} - {author}: {comment_preview}
   
   View full thread: gh issue view #$ARGUMENTS --comments
```

### 6. Progress Tracking
If task file exists, show progress:
```
✅ Acceptance Criteria:
   ✅ Criterion 1 (completed)
   🔄 Criterion 2 (in progress)
   ⏸️ Criterion 3 (blocked)
   □ Criterion 4 (not started)
```

### 7. Quick Actions
```
🚀 Quick Actions:
   Start work: /pm:issue-start $ARGUMENTS
   Sync updates: /pm:issue-sync $ARGUMENTS
   Add comment: gh issue comment #$ARGUMENTS --body "your comment"
   View in browser: gh issue view #$ARGUMENTS --web
```

### 8. Error Handling
- Handle invalid issue numbers gracefully
- Check for network/authentication issues
- Provide helpful error messages and alternatives

Provide comprehensive issue information to help developers understand context and current status for Issue #$ARGUMENTS.
