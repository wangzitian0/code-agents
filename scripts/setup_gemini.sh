#!/usr/bin/env bash
# Setup Gemini configuration - Shell script version
# 功能等同于 ansible/setup_gemini.yml

set -euo pipefail

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_AGENTS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GEMINI_REPO_DIR="$CODE_AGENTS_DIR/interfaces/.gemini"
HOME_DIR="$HOME"
GEMINI_BACKUP_DIR="$HOME_DIR/.gemini"
GEMINI_LINK_TARGET="$HOME_DIR/.gemini"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🔧 设置 Gemini 配置..."

# 检查 ~/.gemini 是否存在
if [ -e "$GEMINI_BACKUP_DIR" ]; then
    # 检查是否是软链接
    if [ -L "$GEMINI_BACKUP_DIR" ]; then
        # 获取软链接目标
        CURRENT_LINK_TARGET=$(readlink -f "$GEMINI_BACKUP_DIR" 2>/dev/null || echo "")
        
        # 检查是否已经正确链接
        if [ "$CURRENT_LINK_TARGET" = "$GEMINI_REPO_DIR" ]; then
            echo -e "${GREEN}✓ ~/.gemini 已经正确链接到本 repo${NC}"
            echo "  - 当前链接: $GEMINI_BACKUP_DIR -> $CURRENT_LINK_TARGET"
            echo "  - 目标路径: $GEMINI_REPO_DIR"
            echo "  - 无需操作，跳过"
            exit 0
        fi
    fi
    
    # 需要设置，获取时间戳
    TIMESTAMP=$(date +%y%m%d-%H%M%S)
    
    # 如果不是软链接，备份
    if [ ! -L "$GEMINI_BACKUP_DIR" ]; then
        echo "📦 备份现有的 ~/.gemini..."
        mv "$GEMINI_BACKUP_DIR" "${GEMINI_BACKUP_DIR}-${TIMESTAMP}"
        BACKUP_PATH="${GEMINI_BACKUP_DIR}-${TIMESTAMP}"
    fi
fi

# 创建 code-agents/interfaces/.gemini 目录
echo "📁 创建配置目录..."
mkdir -p "$GEMINI_REPO_DIR"
chmod 755 "$GEMINI_REPO_DIR"

# 如果备份了，复制内容
if [ -n "${BACKUP_PATH:-}" ] && [ -d "$BACKUP_PATH" ]; then
    echo "📋 复制备份内容到新目录..."
    cp -r "$BACKUP_PATH"/* "$GEMINI_REPO_DIR/" 2>/dev/null || true
    cp -r "$BACKUP_PATH"/.[!.]* "$GEMINI_REPO_DIR/" 2>/dev/null || true
fi

# 创建软链接
echo "🔗 创建软链接..."
if [ -e "$GEMINI_LINK_TARGET" ] && [ ! -L "$GEMINI_LINK_TARGET" ]; then
    rm -rf "$GEMINI_LINK_TARGET"
fi
ln -sfn "$GEMINI_REPO_DIR" "$GEMINI_LINK_TARGET"

# 显示完成信息
echo -e "${GREEN}✓ 完成 .gemini 配置管理${NC}"
if [ -n "${BACKUP_PATH:-}" ]; then
    echo "  - 备份位置: $BACKUP_PATH"
fi
echo "  - 仓库位置: $GEMINI_REPO_DIR"
echo "  - 软链接: $GEMINI_LINK_TARGET -> $GEMINI_REPO_DIR"

