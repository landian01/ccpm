---
allowed-tools: Bash, Read, LS
---

# 加载上下文

此命令通过读取项目上下文文档并理解代码库结构，为新代理会话加载必要的上下文。

## 预检查清单

在继续之前，完成这些验证步骤。
不要用预检查进度打扰用户（"我不会去..."）。直接执行并继续。

### 1. 上下文可用性检查
- 运行：`ls -la .claude/context/ 2>/dev/null`
- 如果目录不存在或为空：
  - 告知用户："❌ 未找到上下文。请先运行 /context:create 建立项目上下文。"
  - 优雅退出
- 计算可用上下文文件：`ls -1 .claude/context/*.md 2>/dev/null | wc -l`
- 报告："📁 找到 {count} 个上下文文件要加载"

### 2. 文件完整性检查
- 对于找到的每个上下文文件：
  - 验证文件可读：`test -r ".claude/context/{file}" && echo "readable"`
  - 检查文件有内容：`test -s ".claude/context/{file}" && echo "has content"`
  - 检查有效的 frontmatter（应以 `---` 开头）
- 报告任何问题：
  - 空文件："⚠️ {filename} 为空（跳过）"
  - 不可读文件："⚠️ 无法读取 {filename}（权限问题）"
  - 缺失 frontmatter："⚠️ {filename} 缺失 frontmatter（可能已损坏）"

### 3. 项目状态检查
- 运行：`git status --short 2>/dev/null` 查看当前状态
- 运行：`git branch --show-current 2>/dev/null` 获取当前分支
- 注意如果不是 git 仓库（上下文可能不完整）

## 指令

### 1. 上下文加载顺序

按优先级顺序加载上下文文件以获得最佳理解：

**优先级 1 - 必要上下文（首先加载）：**
1. `project-overview.md` - 项目的高级理解
2. `project-brief.md` - 核心目的和目标
3. `tech-context.md` - 技术栈和依赖项

**优先级 2 - 当前状态（其次加载）：**
4. `progress.md` - 当前状态和最近工作
5. `project-structure.md` - 目录和文件组织

**优先级 3 - 深度上下文（最后加载）：**
6. `system-patterns.md` - 架构和设计模式
7. `product-context.md` - 用户需求和需求
8. `project-style-guide.md` - 编码约定
9. `project-vision.md` - 长期方向

### 2. 加载期间验证

对于每个加载的文件：
- 检查 frontmatter 存在并解析：
  - `created` 日期应该有效
  - `last_updated` 应该 ≥ created 日期
  - `version` 应该存在
- 如果 frontmatter 无效，记录但继续加载内容
- 跟踪哪些文件成功加载与失败

### 3. 补充信息

加载上下文文件后：
- 运行：`git ls-files --others --exclude-standard | head -20` 查看未跟踪文件
- 如果存在则读取 `README.md` 获取额外项目信息
- 检查 `.env.example` 或类似文件了解环境设置需求

### 4. 错误恢复

**如果关键文件缺失：**
- `project-overview.md` 缺失：尝试从 README.md 理解
- `tech-context.md` 缺失：直接分析 package.json/requirements.txt
- `progress.md` 缺失：检查最近的 git 提交了解状态

**如果上下文不完整：**
- 告知用户哪些文件缺失
- 建议运行 `/context:update` 刷新上下文
- 使用部分上下文继续但注意限制

### 5. 加载摘要

加载完成后提供综合摘要：

```
🧠 上下文加载成功

📖 已加载上下文文件：
  ✅ 必要：{count}/3 个文件
  ✅ 当前状态：{count}/2 个文件
  ✅ 深度上下文：{count}/4 个文件

🔍 项目理解：
  - 名称：{project_name}
  - 类型：{project_type}
  - 语言：{primary_language}
  - 状态：{progress.md 中的当前状态}
  - 分支：{git_branch}

📊 关键指标：
  - 最后更新：{most_recent_update}
  - 上下文版本：{version}
  - 已加载文件：{success_count}/{total_count}

⚠️ 警告：
  {列出任何缺失文件或问题}

🎯 就绪状态：
  ✅ 项目上下文已加载
  ✅ 当前状态已理解
  ✅ 准备开发工作

💡 项目摘要：
  {2-3 句关于项目是什么和当前状态的摘要}
```

### 6. 部分上下文处理

如果某些文件加载失败：
- 使用可用上下文继续
- 明确说明缺失的内容
- 建议修复措施：
  - "缺失技术上下文 - 运行 /context:create 重建"
  - "进度文件损坏 - 运行 /context:update 刷新"

### 7. 性能优化

对于大型上下文：
- 尽可能并行加载文件
- 显示进度指示器："正在加载上下文文件... {current}/{total}"
- 跳过极大文件（>10000 行）并警告
- 缓存解析的 frontmatter 以加快后续加载

## 重要说明

- **始终验证**文件后再尝试读取
- **按优先级顺序加载**以首先获得必要上下文
- **优雅处理缺失文件** - 不要完全失败
- **提供清晰摘要**说明加载的内容和项目状态
- **注意任何可能**影响开发工作的问题
