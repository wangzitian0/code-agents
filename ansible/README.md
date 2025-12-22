# Ansible 配置管理

使用 Ansible 管理本地个性化配置，将配置入库到代码仓库。

## 功能

### `.gemini` 配置管理

将 `~/.gemini` 配置目录迁移到代码仓库中，通过软链接管理。

**操作流程：**
1. 备份现有的 `~/.gemini` 为 `~/.gemini-yymmdd-HHMMSS`（带时间戳）
2. 在 `code-agents/interfaces/` 目录下创建 `.gemini` 目录
3. 将备份的内容复制到新目录
4. 创建软链接 `~/.gemini` -> `code-agents/interfaces/.gemini`

## 使用方法

```bash
# 在 code-agents 目录下运行
cd /Users/SP14016/zitian/code-agents
ansible-playbook ansible/setup_gemini.yml
```

## 验证

运行后可以验证：

```bash
# 检查软链接
ls -la ~/.gemini

# 应该显示类似：
# .gemini -> /Users/SP14016/zitian/code-agents/interfaces/.gemini
```

## 注意事项

- 如果 `~/.gemini` 已经是软链接，playbook 会直接更新链接目标
- 备份文件会保留在 `~/.gemini-yymmdd-HHMMSS`，可以手动删除
- 配置目录现在在代码仓库中，可以通过 git 进行版本管理

