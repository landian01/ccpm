---
allowed-tools: Read, Write, LS
---

# 史诗编辑

在创建后编辑史诗详情。

## 用法
```
/pm:epic-edit <epic_name>
```

## 指令

### 1. 读取当前史诗

读取 `.claude/epics/$ARGUMENTS/epic.md`：
- 解析前置元数据
- 读取内容部分

### 2. 交互式编辑

询问用户要编辑什么：
- 名称/标题
- 描述/概述
- 架构决策
- 技术方法
- 依赖项
- 成功标准

### 3. Update Epic File

Get current datetime: `date -u +"%Y-%m-%dT%H:%M:%SZ"`

Update epic.md:
- Preserve all frontmatter except `updated`
- Apply user's edits to content
- Update `updated` field with current datetime

### 4. Option to Update GitHub

If epic has GitHub URL in frontmatter:
Ask: "Update GitHub issue? (yes/no)"

If yes:
```bash
gh issue edit {issue_number} --body-file .claude/epics/$ARGUMENTS/epic.md
```

### 5. Output

```
✅ Updated epic: $ARGUMENTS
  Changes made to: {sections_edited}
  
{If GitHub updated}: GitHub issue updated ✅

View epic: /pm:epic-show $ARGUMENTS
```

## Important Notes

Preserve frontmatter history (created, github URL, etc.).
Don't change task files when editing epic.
Follow `/rules/frontmatter-operations.md`.