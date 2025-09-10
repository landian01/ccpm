---
allowed-tools: Read, Write, LS
---

# 史诗刷新

基于任务状态更新史诗进度。

## 用法
```
/pm:epic-refresh <epic_name>
```

## 指令

### 1. 统计任务状态

扫描 `.claude/epics/$ARGUMENTS/` 中的所有任务文件：
- 计算总任务数
- 计算 `status: closed` 的任务数
- 计算 `status: open` 的任务数
- 计算进行中任务的数量

### 2. 计算进度

```
progress = (closed_tasks / total_tasks) * 100
```

四舍五入到最接近的整数。

### 3. 更新 GitHub 任务列表

如果史诗有 GitHub issue，同步任务复选框：

```bash
# 从 epic.md frontmatter 中获取史诗问题编号
epic_issue={extract_from_github_field}

if [ ! -z "$epic_issue" ]; then
  # 获取当前史诗正文
  gh issue view $epic_issue --json body -q .body > /tmp/epic-body.md

  # 对于每个任务，检查其状态并更新复选框
  for task_file in .claude/epics/$ARGUMENTS/[0-9]*.md; do
    task_issue=$(grep 'github:' $task_file | grep -oE '[0-9]+$')
    task_status=$(grep 'status:' $task_file | cut -d: -f2 | tr -d ' ')

    if [ "$task_status" = "closed" ]; then
      # 标记为已选中
      sed -i "s/- \[ \] #$task_issue/- [x] #$task_issue/" /tmp/epic-body.md
    else
      # 确保未选中（以防手动选中）
      sed -i "s/- \[x\] #$task_issue/- [ ] #$task_issue/" /tmp/epic-body.md
    fi
  done

  # 更新史诗问题
  gh issue edit $epic_issue --body-file /tmp/epic-body.md
fi
```

### 4. 确定史诗状态

- 如果进度 = 0% 且没有工作开始：`backlog`
- 如果进度 > 0% 且 < 100%：`in-progress`
- 如果进度 = 100%：`completed`

### 5. 更新史诗

获取当前日期时间：`date -u +"%Y-%m-%dT%H:%M:%SZ"`

更新 epic.md frontmatter：
```yaml
status: {calculated_status}
progress: {calculated_progress}%
updated: {current_datetime}
```

### 6. 输出

```
🔄 史诗已刷新: $ARGUMENTS

任务:
  已关闭: {closed_count}
  打开: {open_count}
  总计: {total_count}

进度: {old_progress}% → {new_progress}%
状态: {old_status} → {new_status}
GitHub: 任务列表已更新 ✓

{如果完成}: 运行 /pm:epic-close $ARGUMENTS 来关闭史诗
{如果进行中}: 运行 /pm:next 查看优先级任务
```

## 重要说明

这在手动任务编辑或 GitHub 同步后很有用。
不要修改任务文件，只修改史诗状态。
保留所有其他 frontmatter 字段。