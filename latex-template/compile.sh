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

if [ $? -ne 0 ]; then
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

if [ $? -ne 0 ]; then
    echo "❌ 最终编译失败!"
    exit 1
fi

echo ""
echo "🧹 清理中间文件..."
# 删除编译产生的中间文件
rm -f *.aux *.log *.out *.toc *.bbl *.blg *.synctex.gz *.fdb_latexmk *.fls *.xdv

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
