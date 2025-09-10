---
allowed-tools: Bash, Read, LS
---

# 问题状态

检查问题状态（打开/关闭）和当前状态。

## 用法
```
/pm:issue-status <issue_number>
```

## 指令

您正在检查 GitHub 问题的当前状态并为以下问题提供快速状态报告：**问题 #$ARGUMENTS**

### 1. 获取问题状态
使用 GitHub CLI 获取当前状态：
```bash
gh issue view #$ARGUMENTS --json state,title,labels,assignees,updatedAt
```

### 2. 状态显示
显示简洁的状态信息：
```
🎫 问题 #$ARGUMENTS: {Title}

📊 状态: {OPEN/CLOSED}
   最后更新: {timestamp}
   分配给: {assignee or "未分配"}

🏷️ 标签: {label1}, {label2}, {label3}
```

### 3. 史诗上下文
如果问题是史诗的一部分：
```
📚 史诗上下文:
   史诗: {epic_name}
   史诗进度: {completed_tasks}/{total_tasks} 任务完成
   此任务: {task_position}/{total_tasks}
```

### 4. 本地同步状态
检查本地文件是否同步：
```
💾 本地同步:
   本地文件: {exists/missing}
   最后本地更新: {timestamp}
   同步状态: {in_sync/needs_sync/local_ahead/remote_ahead}
```

### 5. 快速状态指示器
使用清晰的视觉指示器：
- 🟢 打开且准备就绪
- 🟡 打开但有阻塞
- 🔴 打开且已过期
- ✅ 已关闭且完成
- ❌ 已关闭但未完成

### 6. 可操作的下一步
基于状态，建议行动：
```
🚀 建议行动:
   - 开始工作: /pm:issue-start $ARGUMENTS
   - 同步更新: /pm:issue-sync $ARGUMENTS
   - 关闭问题: gh issue close #$ARGUMENTS
   - 重新打开问题: gh issue reopen #$ARGUMENTS
```

### 7. 批量状态
如果检查多个问题，支持逗号分隔的列表：
```
/pm:issue-status 123,124,125
```

保持输出简洁但信息丰富，完美适用于问题 #$ARGUMENTS 开发过程中的快速状态检查。
