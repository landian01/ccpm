---
allowed-tools: Bash, Read, Write, LS
---

# 问题同步

将本地更新作为 GitHub 问题评论推送，实现透明的审计跟踪。

## 用法
```
/pm:issue-sync <issue_number>
```

## 必需规则

**重要**：执行此命令前，请阅读并遵循：
- `.claude/rules/datetime.md` - 获取真实的当前日期/时间

## 飞行前检查清单

在继续之前，完成这些验证步骤。
不要用飞行前检查进度打扰用户（"我不会去..."）。直接执行并继续。

0. **仓库保护检查：**
   遵循 `/rules/github-operations.md` - 检查远程源：
   ```bash
   remote_url=$(git remote get-url origin 2>/dev/null || echo "")
   if [[ "$remote_url" == *"automazeio/ccpm"* ]]; then
     echo "❌ 错误：无法同步到 CCPM 模板仓库！"
     echo "更新您的远程：git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
     exit 1
   fi
   ```

1. **GitHub 认证：**
   - 运行：`gh auth status`
   - 如果未认证，告诉用户："❌ GitHub CLI 未认证。运行：gh auth login"

2. **问题验证：**
   - 运行：`gh issue view $ARGUMENTS --json state`
   - 如果问题不存在，告诉用户："❌ 问题 #$ARGUMENTS 未找到"
   - 如果问题已关闭但完成度 < 100%，警告："⚠️ 问题已关闭但工作未完成"

3. **本地更新检查：**
   - 检查 `.claude/epics/*/updates/$ARGUMENTS/` 目录是否存在
   - 如果未找到，告诉用户："❌ 问题 #$ARGUMENTS 没有本地更新。运行：/pm:issue-start $ARGUMENTS"
   - 检查 progress.md 是否存在
   - 如果不存在，告诉用户："❌ 未找到进度跟踪。使用初始化：/pm:issue-start $ARGUMENTS"

4. **检查上次同步：**
   - 从 progress.md 前置元数据读取 `last_sync`
   - 如果最近同步过（< 5 分钟），询问："⚠️ 最近已同步。仍要强制同步吗？（yes/no）"
   - 计算自上次同步以来的新内容

5. **验证更改：**
   - 检查是否有实际更新要同步
   - 如果没有更改，告诉用户："ℹ️ 自 {last_sync} 以来没有新更新要同步"
   - 如果没有内容要同步则优雅退出

## 指令

您正在将本地开发进度同步到 GitHub 作为问题评论：**问题 #$ARGUMENTS**

### 1. 收集本地更新
收集问题的所有本地更新：
- 从 `.claude/epics/{epic_name}/updates/$ARGUMENTS/` 读取
- 检查以下文件中的新内容：
  - `progress.md` - 开发进度
  - `notes.md` - 技术说明和决策
  - `commits.md` - 最近的提交和更改
  - 任何其他更新文件

### 2. Update Progress Tracking Frontmatter
Get current datetime: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

Update the progress.md file frontmatter:
```yaml
---
issue: $ARGUMENTS
started: [preserve existing date]
last_sync: [Use REAL datetime from command above]
completion: [calculated percentage 0-100%]
---
```

### 3. Determine What's New
Compare against previous sync to identify new content:
- Look for sync timestamp markers
- Identify new sections or updates
- Gather only incremental changes since last sync

### 4. Format Update Comment
Create comprehensive update comment:

```markdown
## 🔄 Progress Update - {current_date}

### ✅ Completed Work
{list_completed_items}

### 🔄 In Progress
{current_work_items}

### 📝 Technical Notes
{key_technical_decisions}

### 📊 Acceptance Criteria Status
- ✅ {completed_criterion}
- 🔄 {in_progress_criterion}
- ⏸️ {blocked_criterion}
- □ {pending_criterion}

### 🚀 Next Steps
{planned_next_actions}

### ⚠️ Blockers
{any_current_blockers}

### 💻 Recent Commits
{commit_summaries}

---
*Progress: {completion}% | Synced from local updates at {timestamp}*
```

### 5. Post to GitHub
Use GitHub CLI to add comment:
```bash
gh issue comment #$ARGUMENTS --body-file {temp_comment_file}
```

### 6. Update Local Task File
Get current datetime: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

Update the task file frontmatter with sync information:
```yaml
---
name: [Task Title]
status: open
created: [preserve existing date]
updated: [Use REAL datetime from command above]
github: https://github.com/{org}/{repo}/issues/$ARGUMENTS
---
```

### 7. Handle Completion
If task is complete, update all relevant frontmatter:

**Task file frontmatter**:
```yaml
---
name: [Task Title]
status: closed
created: [existing date]
updated: [current date/time]
github: https://github.com/{org}/{repo}/issues/$ARGUMENTS
---
```

**Progress file frontmatter**:
```yaml
---
issue: $ARGUMENTS
started: [existing date]
last_sync: [current date/time]
completion: 100%
---
```

**Epic progress update**: Recalculate epic progress based on completed tasks and update epic frontmatter:
```yaml
---
name: [Epic Name]
status: in-progress
created: [existing date]
progress: [calculated percentage based on completed tasks]%
prd: [existing path]
github: [existing URL]
---
```

### 8. Completion Comment
If task is complete:
```markdown
## ✅ Task Completed - {current_date}

### 🎯 All Acceptance Criteria Met
- ✅ {criterion_1}
- ✅ {criterion_2}
- ✅ {criterion_3}

### 📦 Deliverables
- {deliverable_1}
- {deliverable_2}

### 🧪 Testing
- Unit tests: ✅ Passing
- Integration tests: ✅ Passing
- Manual testing: ✅ Complete

### 📚 Documentation
- Code documentation: ✅ Updated
- README updates: ✅ Complete

This task is ready for review and can be closed.

---
*Task completed: 100% | Synced at {timestamp}*
```

### 9. Output Summary
```
☁️ Synced updates to GitHub Issue #$ARGUMENTS

📝 Update summary:
   Progress items: {progress_count}
   Technical notes: {notes_count}
   Commits referenced: {commit_count}

📊 Current status:
   Task completion: {task_completion}%
   Epic progress: {epic_progress}%
   Completed criteria: {completed}/{total}

🔗 View update: gh issue view #$ARGUMENTS --comments
```

### 10. Frontmatter Maintenance
- Always update task file frontmatter with current timestamp
- Track completion percentages in progress files
- Update epic progress when tasks complete
- Maintain sync timestamps for audit trail

### 11. Incremental Sync Detection

**Prevent Duplicate Comments:**
1. Add sync markers to local files after each sync:
   ```markdown
   <!-- SYNCED: 2024-01-15T10:30:00Z -->
   ```
2. Only sync content added after the last marker
3. If no new content, skip sync with message: "No updates since last sync"

### 12. Comment Size Management

**Handle GitHub's Comment Limits:**
- Max comment size: 65,536 characters
- If update exceeds limit:
  1. Split into multiple comments
  2. Or summarize with link to full details
  3. Warn user: "⚠️ Update truncated due to size. Full details in local files."

### 13. Error Handling

**Common Issues and Recovery:**

1. **Network Error:**
   - Message: "❌ Failed to post comment: network error"
   - Solution: "Check internet connection and retry"
   - Keep local updates intact for retry

2. **Rate Limit:**
   - Message: "❌ GitHub rate limit exceeded"
   - Solution: "Wait {minutes} minutes or use different token"
   - Save comment locally for later sync

3. **Permission Denied:**
   - Message: "❌ Cannot comment on issue (permission denied)"
   - Solution: "Check repository access permissions"

4. **Issue Locked:**
   - Message: "⚠️ Issue is locked for comments"
   - Solution: "Contact repository admin to unlock"

### 14. Epic Progress Calculation

When updating epic progress:
1. Count total tasks in epic directory
2. Count tasks with `status: closed` in frontmatter
3. Calculate: `progress = (closed_tasks / total_tasks) * 100`
4. Round to nearest integer
5. Update epic frontmatter only if percentage changed

### 15. Post-Sync Validation

After successful sync:
- [ ] Verify comment posted on GitHub
- [ ] Confirm frontmatter updated with sync timestamp
- [ ] Check epic progress updated if task completed
- [ ] Validate no data corruption in local files

This creates a transparent audit trail of development progress that stakeholders can follow in real-time for Issue #$ARGUMENTS, while maintaining accurate frontmatter across all project files.
