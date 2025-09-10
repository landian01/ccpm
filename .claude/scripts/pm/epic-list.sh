#!/bin/bash
echo "正在获取史诗..."
echo ""
echo ""

[ ! -d ".claude/epics" ] && echo "📁 未找到史诗目录。请使用以下命令创建第一个史诗：/pm:prd-parse <feature-name>" && exit 0
[ -z "$(ls -d .claude/epics/*/ 2>/dev/null)" ] && echo "📁 未找到史诗。请使用以下命令创建第一个史诗：/pm:prd-parse <feature-name>" && exit 0

echo "📚 项目史诗"
echo "================"
echo ""

# 初始化数组以按状态存储史诗
planning_epics=""
in_progress_epics=""
completed_epics=""

# 处理所有史诗
for dir in .claude/epics/*/; do
  [ -d "$dir" ] || continue
  [ -f "$dir/epic.md" ] || continue

  # 提取元数据
  n=$(grep "^name:" "$dir/epic.md" | head -1 | sed 's/^name: *//')
  s=$(grep "^status:" "$dir/epic.md" | head -1 | sed 's/^status: *//' | tr '[:upper:]' '[:lower:]')
  p=$(grep "^progress:" "$dir/epic.md" | head -1 | sed 's/^progress: *//')
  g=$(grep "^github:" "$dir/epic.md" | head -1 | sed 's/^github: *//')

  # 默认值
  [ -z "$n" ] && n=$(basename "$dir")
  [ -z "$p" ] && p="0%"

  # 统计任务
  t=$(ls "$dir"[0-9]*.md 2>/dev/null | wc -l)

  # 如果可用，使用 GitHub 问题编号格式化输出
  if [ -n "$g" ]; then
    i=$(echo "$g" | grep -o '/[0-9]*$' | tr -d '/')
    entry="   📋 ${dir}epic.md (#$i) - $p 已完成 ($t 个任务)"
  else
    entry="   📋 ${dir}epic.md - $p 已完成 ($t 个任务)"
  fi

  # 按状态分类（处理各种状态值）
  case "$s" in
    planning|draft|"")
      planning_epics="${planning_epics}${entry}\n"
      ;;
    in-progress|in_progress|active|started)
      in_progress_epics="${in_progress_epics}${entry}\n"
      ;;
    completed|complete|done|closed|finished)
      completed_epics="${completed_epics}${entry}\n"
      ;;
    *)
      # Default to planning for unknown statuses
      planning_epics="${planning_epics}${entry}\n"
      ;;
  esac
done

# 显示分类的史诗
echo "📝 规划中:"
if [ -n "$planning_epics" ]; then
  echo -e "$planning_epics" | sed '/^$/d'
else
  echo "   (无)"
fi

echo ""
echo "🚀 进行中:"
if [ -n "$in_progress_epics" ]; then
  echo -e "$in_progress_epics" | sed '/^$/d'
else
  echo "   (无)"
fi

echo ""
echo "✅ 已完成:"
if [ -n "$completed_epics" ]; then
  echo -e "$completed_epics" | sed '/^$/d'
else
  echo "   (无)"
fi

# 摘要
echo ""
echo "📊 摘要"
total=$(ls -d .claude/epics/*/ 2>/dev/null | wc -l)
tasks=$(find .claude/epics -name "[0-9]*.md" 2>/dev/null | wc -l)
echo "   史诗总数: $total"
echo "   任务总数: $tasks"

exit 0
