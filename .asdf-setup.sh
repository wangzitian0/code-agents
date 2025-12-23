#!/usr/bin/env bash
# Asdf 插件安装脚本
# 运行: bash .asdf-setup.sh

set -e

echo "🔧 设置 asdf 插件..."

# 检查 asdf 是否安装
if ! command -v asdf &> /dev/null; then
    echo "❌ asdf 未安装"
    echo "💡 安装: brew install asdf"
    echo "💡 然后添加到 ~/.zshrc: echo '. \$(brew --prefix asdf)/libexec/asdf.sh' >> ~/.zshrc"
    exit 1
fi

# 加载 asdf
. $(brew --prefix asdf)/libexec/asdf.sh

# 安装 uv 插件
if ! asdf plugin list | grep -q "^uv$"; then
    echo "📦 安装 uv 插件..."
    asdf plugin add uv
else
    echo "✅ uv 插件已安装"
fi

# 安装 python 插件
if ! asdf plugin list | grep -q "^python$"; then
    echo "📦 安装 python 插件..."
    asdf plugin add python
else
    echo "✅ python 插件已安装"
fi

# 安装工具版本
echo "📦 安装工具版本（从 .tool-versions）..."
if [ -f ".tool-versions" ]; then
    # Python 在 macOS 上默认会尝试使用预编译二进制，无需编译
    # 只有在没有预编译版本时才会从源码编译
    echo "💡 Python 安装说明："
    echo "   - macOS ARM64 通常有预编译版本，安装很快（1-2分钟）"
    echo "   - 如果没有预编译版本，会从源码编译（5-15分钟）"
    echo ""
    asdf install
    echo ""
    echo "✅ asdf 设置完成！"
    echo "💡 查看已安装版本: asdf current"
else
    echo "⚠️  未找到 .tool-versions 文件"
    exit 1
fi

