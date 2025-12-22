# Gemini 配置目录

这个目录包含 Gemini 的个性化配置，通过软链接从 `~/.gemini` 指向这里，实现配置的版本管理。

## 文件说明

### ✅ 明确允许入库的文件（白名单 - 影响体验的核心配置）

采用**反向操作**策略：默认忽略所有文件，只明确允许以下**影响体验**的配置文件：

**根目录配置：**
- **settings.json** - UI 和功能配置（主题、MCP 服务器配置等）
- **GEMINI.md** - 文档说明
- **README.md** - 本说明文档
- **.gitignore** - Git 忽略规则

**Antigravity 功能配置：**
- **antigravity/mcp_config.json** - MCP 服务器配置（影响功能）
- **antigravity/browserAllowlist.txt** - 浏览器允许列表（影响功能）

### ❌ 默认忽略（黑名单策略）

所有其他文件默认被忽略，包括但不限于：

以下文件包含敏感信息，**不应**提交到 git：

1. **oauth_creds.json** ⚠️ **高度敏感**
   - 包含 OAuth access_token、refresh_token、id_token
   - 这些 token 可以访问你的 Google 账户

2. **google_accounts.json** ⚠️ **敏感**
   - 包含你的 Google 账户邮箱地址

3. **installation_id** ⚠️ **敏感**
   - 安装唯一标识符

4. **antigravity/** ⚠️ **高度敏感**
   - 包含对话历史（conversations/）
   - 浏览器录制（browser_recordings/）
   - 代码跟踪数据（code_tracker/）
   - 用户设置和状态

5. **antigravity-browser-profile/** ⚠️ **高度敏感**
   - 完整的浏览器配置文件
   - 包含 cookies、缓存、扩展数据等

6. **tmp/** - 临时文件

## 安全建议

1. **定期检查**：运行 `git status` 确保敏感文件没有被意外添加
2. **如果已提交**：如果敏感文件已经被提交，需要：
   ```bash
   git rm --cached interfaces/.gemini/oauth_creds.json
   git rm --cached interfaces/.gemini/google_accounts.json
   # ... 其他敏感文件
   git commit -m "Remove sensitive files from git"
   ```
3. **使用 git-secrets**：考虑安装 git-secrets 来防止提交敏感信息

## 配置迁移

使用 Ansible playbook 来管理配置迁移：

```bash
cd ~/zitian/code-agents
ansible-playbook ansible/setup_gemini.yml
```

