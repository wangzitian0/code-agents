#!/usr/bin/env bash
# 一键安装脚本 - 自动设置 asdf 和开发环境
# 运行: bash install.sh

set -e

echo "🚀 Code Agents - 一键环境设置"
echo ""

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. 检查并安装 asdf
echo "📦 检查 asdf..."
if ! command -v asdf &> /dev/null; then
    echo "安装 asdf..."
    if command -v brew &> /dev/null; then
        brew install asdf
    else
        echo -e "${RED}❌ Homebrew 未安装，请先安装 Homebrew${NC}"
        echo "💡 安装: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
else
    echo -e "${GREEN}✅ asdf 已安装${NC}"
fi

# 2. 配置 shell
echo ""
echo "🔧 配置 shell..."
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bash_profile"
    [ -f "$HOME/.bashrc" ] && SHELL_RC="$HOME/.bashrc"
fi

if [ -z "$SHELL_RC" ]; then
    echo -e "${YELLOW}⚠️  无法检测 shell 类型，请手动添加 asdf 配置${NC}"
else
    ASDF_LINE=". \$(brew --prefix asdf)/libexec/asdf.sh"
    if ! grep -q "asdf.sh" "$SHELL_RC" 2>/dev/null; then
        echo "$ASDF_LINE" >> "$SHELL_RC"
        echo -e "${GREEN}✅ 已添加到 $SHELL_RC${NC}"
    else
        echo -e "${GREEN}✅ $SHELL_RC 已包含 asdf 配置${NC}"
    fi
    
    # 尝试加载 asdf（如果 brew 可用）
    if command -v brew &> /dev/null; then
        . $(brew --prefix asdf)/libexec/asdf.sh 2>/dev/null || true
    fi
fi

# 3. 安装 asdf 插件
echo ""
echo "📦 安装 asdf 插件..."
if ! asdf plugin list | grep -q "^uv$"; then
    echo "安装 uv 插件..."
    asdf plugin add uv || echo -e "${YELLOW}⚠️  uv 插件可能已存在或安装失败${NC}"
else
    echo -e "${GREEN}✅ uv 插件已安装${NC}"
fi

if ! asdf plugin list | grep -q "^python$"; then
    echo "安装 python 插件..."
    asdf plugin add python || echo -e "${YELLOW}⚠️  python 插件可能已存在或安装失败${NC}"
else
    echo -e "${GREEN}✅ python 插件已安装${NC}"
fi

# 4. 安装工具版本
echo ""
echo "📦 安装工具版本（从 .tool-versions）..."
if [ -f ".tool-versions" ]; then
    asdf install
    echo -e "${GREEN}✅ 工具安装完成${NC}"
else
    echo -e "${YELLOW}⚠️  未找到 .tool-versions 文件${NC}"
fi

# 5. 检查 bun（使用系统版本）
echo ""
echo "🔍 检查 bun..."
if [ -f "$HOME/.bun/bin/bun" ]; then
    echo -e "${GREEN}✅ bun 已安装（系统版本）${NC}"
elif command -v bun &> /dev/null; then
    echo -e "${GREEN}✅ bun 已安装${NC}"
else
    echo -e "${YELLOW}⚠️  bun 未安装${NC}"
    echo "💡 安装: curl -fsSL https://bun.sh/install | bash"
fi

# 完成
echo ""
echo -e "${GREEN}🎉 环境设置完成！${NC}"
echo ""
echo "💡 下一步："
echo "  - 重新加载 shell: source $SHELL_RC"
echo "  - 或打开新终端窗口"
echo "  - 然后运行: make ready"
echo "  - 或直接: make gemini"

