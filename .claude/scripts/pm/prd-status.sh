#!/bin/bash

echo "📄 PRD 状态报告"
echo "===================="
echo ""

if [ ! -d ".claude/prds" ]; then
  echo "未找到 PRD 目录。"
  exit 0
fi

total=$(ls .claude/prds/*.md 2>/dev/null | wc -l)
[ $total -eq 0 ] && echo "未找到 PRD。" && exit 0

# 按状态计数
backlog=0
in_progress=0
implemented=0

for file in .claude/prds/*.md; do
  [ -f "$file" ] || continue
  status=$(grep "^status:" "$file" | head -1 | sed 's/^status: *//')

  case "$status" in
    backlog|draft|"") ((backlog++)) ;;
    in-progress|active) ((in_progress++)) ;;
    implemented|completed|done) ((implemented++)) ;;
    *) ((backlog++)) ;;
  esac
done

echo "正在获取状态..."
echo ""
echo ""

# 显示图表
echo "📊 分布:"
echo "================"

echo ""
echo "  积压:     $(printf '%-3d' $backlog) [$(printf '%0.s█' $(seq 1 $((backlog*20/total))))]"
echo "  进行中: $(printf '%-3d' $in_progress) [$(printf '%0.s█' $(seq 1 $((in_progress*20/total))))]"
echo "  已实现: $(printf '%-3d' $implemented) [$(printf '%0.s█' $(seq 1 $((implemented*20/total))))]"
echo ""
echo "  PRD 总数: $total"

# 最近活动
echo ""
echo "📅 最近 PRD（最后 5 个修改的）:"
ls -t .claude/prds/*.md 2>/dev/null | head -5 | while read file; do
  name=$(grep "^name:" "$file" | head -1 | sed 's/^name: *//')
  [ -z "$name" ] && name=$(basename "$file" .md)
  echo "  • $name"
done

# 建议
echo ""
echo "💡 后续操作:"
[ $backlog -gt 0 ] && echo "  • 将积压 PRD 解析为史诗: /pm:prd-parse <name>"
[ $in_progress -gt 0 ] && echo "  • 检查活跃 PRD 的进度: /pm:epic-status <name>"
[ $total -eq 0 ] && echo "  • 创建你的第一个 PRD: /pm:prd-new <name>"

exit 0
