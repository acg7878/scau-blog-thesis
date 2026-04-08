#!/bin/bash

# LaTeX 一键编译脚本
# 用于编译 SCAU 论文模板

echo "================================"
echo "  SCAU 论文编译脚本"
echo "================================"

# 设置主文件名(不含扩展名)
MAIN_FILE="main"

# 确保 pdf 目录存在
mkdir -p pdf

echo ""
echo "[1/4] 第一次 XeLaTeX 编译..."
xelatex -interaction=nonstopmode ${MAIN_FILE}.tex

# 第一次编译检查 PDF 是否生成（辅助文件缺失时 XeLaTeX 仍会成功）
if [ ! -f "${MAIN_FILE}.pdf" ]; then
    echo "❌ 第一次编译失败!"
    exit 1
fi

echo ""
echo "[2/4] 处理参考文献 (BibTeX)..."
bibtex ${MAIN_FILE}

echo ""
echo "[3/4] 第二次 XeLaTeX 编译..."
xelatex -interaction=nonstopmode ${MAIN_FILE}.tex

echo ""
echo "[4/4] 第三次 XeLaTeX 编译(完善交叉引用)..."
xelatex -interaction=nonstopmode ${MAIN_FILE}.tex

# XeLaTeX可能因警告返回非零退出码，只要PDF生成成功即可
if [ ! -f "${MAIN_FILE}.pdf" ]; then
    echo "❌ 最终编译失败!"
    exit 1
fi

# 跳过中间文件清理（用户禁止 rm）
# rm -f *.aux *.log *.out *.toc *.bbl *.blg *.synctex.gz *.fdb_latexmk *.fls *.xdv

echo ""
echo "📦 移动 PDF 到 pdf 文件夹..."
mv -f ${MAIN_FILE}.pdf pdf/

if [ -f "pdf/${MAIN_FILE}.pdf" ]; then
    PDF_SIZE=$(du -h "pdf/${MAIN_FILE}.pdf" | cut -f1)
    echo ""
    echo "================================"
    echo "✅ 编译成功!"
    echo "📄 文件位置: pdf/${MAIN_FILE}.pdf"
    echo "📊 文件大小: ${PDF_SIZE}"
    echo "================================"
else
    echo ""
    echo "❌ PDF 文件未找到,编译可能失败"
    exit 1
fi
