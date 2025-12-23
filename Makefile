# Code Agents - Development Environment Setup
# 使用 Makefile 管理开发环境和任务（配合 asdf）

.PHONY: help setup check install-tools setup-gemini install-mcp-servers start-bun start-uv start stop-services status logs clean gemini ready

# 默认任务：显示帮助
help:
	@echo "Code Agents - 开发环境管理"
	@echo ""
	@echo "常用命令："
	@echo "  make ready          - 完整设置（安装工具 + 检查设置 + 启动服务）"
	@echo "  make gemini         - 启动 Gemini（后台服务 + 前台 Gemini）"
	@echo "  make start          - 检查设置并启动服务"
	@echo "  make status         - 查看服务状态"
	@echo "  make logs           - 查看日志"
	@echo "  make stop-services  - 停止服务"
	@echo "  make clean          - 清理临时文件"
	@echo ""
	@echo "工具管理："
	@echo "  make install-tools  - 安装所有工具（使用 asdf）"
	@echo "  make check          - 检查工具版本"

# 确保使用 asdf 管理的工具
ASDF_SH := $(shell brew --prefix asdf 2>/dev/null)/libexec/asdf.sh
ifeq ($(wildcard $(ASDF_SH)),)
	ASDF_SH := $(HOME)/.asdf/asdf.sh
endif

# 激活 asdf 环境
activate-asdf:
	@if [ -f "$(ASDF_SH)" ]; then \
		. $(ASDF_SH); \
	fi

# 安装所有工具
install-tools: activate-asdf
	@echo "📦 安装所有工具（使用 asdf）..."
	@. $(ASDF_SH) && \
	echo "📦 安装 asdf 插件..." && \
	bash .asdf-setup.sh && \
	echo "" && \
	echo "📦 安装工具版本（从 .tool-versions）..." && \
	echo "💡 Python 会自动使用预编译版本（如果可用），通常很快（1-2分钟）" && \
	asdf install && \
	echo "✅ 工具安装完成"

# 检查工具版本
check: activate-asdf
	@echo "🔍 检查工具版本..."
	@. $(ASDF_SH) && asdf current

# 设置 Gemini 配置
setup-gemini:
	@echo "🔧 设置 Gemini 配置..."
	@bash scripts/setup_gemini.sh

# 安装 MCP 服务器
install-mcp-servers: activate-asdf
	@echo "📦 安装 MCP 服务器..."
	@. $(ASDF_SH) && \
	echo "安装 basic-memory (使用 asdf 管理的 Python)..." && \
	if command -v python > /dev/null 2>&1; then \
		echo "✅ 使用 Python: $$(python --version) ($$(which python))"; \
	fi && \
	uv tool install basic-memory || echo "⚠️  basic-memory 安装失败，可能需要手动安装: uv tool install basic-memory" && \
	if uv tool run basic-memory --help > /dev/null 2>&1; then \
		echo "✅ basic-memory 已安装并可用"; \
	else \
		echo "⚠️  basic-memory 可能未正确安装，请检查"; \
	fi
	@if [ -f "package.json" ]; then \
		if [ -f "$(HOME)/.bun/bin/bun" ]; then \
			echo "安装 JS MCP 服务器（使用系统 bun）..."; \
			$(HOME)/.bun/bin/bun install; \
		elif command -v bun > /dev/null 2>&1; then \
			echo "安装 JS MCP 服务器..."; \
			bun install; \
		else \
			echo "⚠️  bun 未找到，跳过 JS MCP 服务器安装"; \
			echo "💡 安装 bun: curl -fsSL https://bun.sh/install | bash"; \
		fi; \
	fi
	@echo "✅ MCP 服务器安装完成"
	@echo "💡 MCP 配置位于: interfaces/.gemini/antigravity/mcp_config.json"

# 后台启动 Bun
start-bun: activate-asdf
	@if [ -f "package.json" ]; then \
		if [ -f "$(HOME)/.bun/bin/bun" ]; then \
			echo "🚀 启动 Bun 服务（使用系统 bun）..."; \
			nohup $(HOME)/.bun/bin/bun run dev > .bun.log 2>&1 & \
			echo $$! > .bun.pid; \
			echo "✅ Bun 已启动 (PID: $$(cat .bun.pid), 日志: .bun.log)"; \
		elif command -v bun > /dev/null 2>&1; then \
			echo "🚀 启动 Bun 服务..."; \
			nohup bun run dev > .bun.log 2>&1 & \
			echo $$! > .bun.pid; \
			echo "✅ Bun 已启动 (PID: $$(cat .bun.pid), 日志: .bun.log)"; \
		else \
			echo "⚠️  bun 未找到，跳过 Bun 启动"; \
			echo "💡 安装 bun: curl -fsSL https://bun.sh/install | bash"; \
		fi; \
	else \
		echo "⚠️  未找到 package.json，跳过 Bun 启动"; \
	fi

# 后台启动 uv
start-uv: activate-asdf
	@if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then \
		echo "✅ uv 环境已准备（如需启动服务，请修改此任务）"; \
	else \
		echo "⚠️  未找到 Python 项目文件，跳过 uv 启动"; \
	fi

# 停止服务
stop-services:
	@echo "🛑 停止后台服务..."
	@if [ -f ".bun.pid" ]; then \
		pid=$$(cat .bun.pid); \
		if kill -0 $$pid 2>/dev/null; then \
			kill $$pid; \
			echo "✅ Bun 已停止 (PID: $$pid)"; \
		fi; \
		rm -f .bun.pid; \
	fi
	@if [ -f ".uv.pid" ]; then \
		pid=$$(cat .uv.pid); \
		if kill -0 $$pid 2>/dev/null; then \
			kill $$pid; \
			echo "✅ uv 服务已停止 (PID: $$pid)"; \
		fi; \
		rm -f .uv.pid; \
	fi
	@echo "✅ 所有服务已停止"

# 查看服务状态
status:
	@echo "📊 服务状态："
	@echo ""
	@if [ -f ".bun.pid" ]; then \
		pid=$$(cat .bun.pid); \
		if kill -0 $$pid 2>/dev/null; then \
			echo "✅ Bun: 运行中 (PID: $$pid)"; \
		else \
			echo "❌ Bun: 未运行"; \
		fi; \
	else \
		echo "❌ Bun: 未启动"; \
	fi
	@if [ -f ".uv.pid" ]; then \
		pid=$$(cat .uv.pid); \
		if kill -0 $$pid 2>/dev/null; then \
			echo "✅ uv: 运行中 (PID: $$pid)"; \
		else \
			echo "❌ uv: 未运行"; \
		fi; \
	else \
		echo "ℹ️  uv: 未配置服务"; \
	fi

# 查看日志
logs:
	@if [ -f ".bun.log" ]; then \
		echo "📄 Bun 日志："; \
		tail -f .bun.log; \
	else \
		echo "⚠️  未找到日志文件"; \
	fi

# 清理
clean: stop-services
	@echo "🧹 清理临时文件..."
	@rm -f .bun.log .bun.pid .uv.log .uv.pid
	@echo "✅ 清理完成"

# 启动所有服务
start: setup-gemini install-mcp-servers start-bun start-uv
	@echo ""
	@echo "✅ 所有服务已启动"
	@echo "查看日志: tail -f .bun.log"

# 启动 Gemini
gemini: setup-gemini install-mcp-servers start-bun start-uv
	@sleep 2
	@echo ""
	@echo "🚀 启动 Gemini..."
	@echo "💡 服务已在后台运行，查看状态: make status"
	@echo "💡 查看日志: make logs"
	@echo ""
	@exec gemini -y -s

# 完整设置（自动检查并安装 asdf）
ready:
	@if ! command -v asdf &> /dev/null; then \
		echo "⚠️  asdf 未安装，运行一键安装脚本..."; \
		bash install.sh; \
		echo ""; \
		echo -e "\033[1;33m💡 请重新加载 shell 或打开新终端，然后运行: make ready\033[0m"; \
		exit 0; \
	fi
	@$(MAKE) install-tools
	@$(MAKE) start
	@echo ""
	@echo "🎉 环境就绪！"
	@echo "💡 启动 Gemini: make gemini"

