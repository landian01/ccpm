---
allowed-tools: Bash, Read, Write, LS
---

# 清理

清理已完成的工作并归档旧的史诗。

## 用法
```
/pm:clean [--dry-run]
```

选项：
- `--dry-run` - 显示将要清理的内容而不实际执行

## 指令

### 1. 识别已完成的史诗

查找具有以下特征的史诗：
- 前置元数据中 `status: completed`
- 所有任务已关闭
- 最后更新 > 30 天前

### 2. 识别过时的作品

查找：
- 已关闭问题的进度文件
- 已完成工作的更新目录
- 孤立的任务文件（史诗已删除）
- 空目录

### 3. 显示清理计划

```
🧹 清理计划

要归档的已完成史诗：
  {epic_name} - {days} 天前完成
  {epic_name} - {days} 天前完成

要删除的过时进度：
  已关闭问题的 {count} 个进度文件

空目录：
  {empty_dirs_list}

可回收空间：~{size}KB

{如果是 --dry-run}：这是试运行。没有进行任何更改。
{否则}：继续清理？（yes/no）
```

### 4. 执行清理

如果用户确认：

**归档史诗：**
```bash
mkdir -p .claude/epics/.archived
mv .claude/epics/{completed_epic} .claude/epics/.archived/
```

**删除过时文件：**
- 删除已关闭问题 > 30 天的进度文件
- 删除空的更新目录
- 清理孤立文件

**创建归档日志：**
创建 `.claude/epics/.archived/archive-log.md`：
```markdown
# 归档日志

## {current_date}
- 已归档：{epic_name}（{date} 完成）
- 已删除：{count} 个过时进度文件
- 已清理：{count} 个空目录
```

### 5. 输出

```
✅ 清理完成

已归档：
  {count} 个已完成史诗

已删除：
  {count} 个过时文件
  {count} 个空目录

回收空间：{size}KB

系统干净且井井有条。
```

## 重要说明

始终提供 --dry-run 来预览更改。
永远不要删除 PRD 或未完成的工作。
保留归档日志作为历史记录。