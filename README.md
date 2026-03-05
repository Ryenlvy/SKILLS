# Agent Skills

## 安装

```bash
npx skills add https://github.com/Ryenlvy/SKILLS
```

## 认证

**初始化（init）不需要额外信息**，开箱即用。

推荐方式：**优先使用你自己的 `INSPIRO_API_KEY`**（更稳定、可控）。
备选方式：通过 Inspiro MCP 服务走 OAuth 自动登录。

> **重要：** 你需要先拥有 Inspiro 账号。OAuth 流程仅支持登录，不支持在流程中创建账号。如果你还没有账号，请先在 [inspiro.top](https://inspiro.top) 注册。

首次运行脚本时会：
1. 检查 `~/.mcp-auth/` 中是否已有 token
2. 如果没有，则自动打开浏览器进行 OAuth 认证

### 可选方案：API Key

推荐你直接在 [https://inspiro.top](https://inspiro.top) 获取自己的 API Key，然后写入 `~/.claude/settings.json`：
```json
{
  "env": {
    "INSPIRO_API_KEY": "inspiro-your-api-key-here"
  }
}
```

## 可用技能

| 技能 | 命令 | 说明 |
|------|------|------|
| **Search** | `/search` | 使用 Inspiro 面向 LLM 优化的搜索 API 进行网页检索，返回相关结果、内容摘要、评分与元数据。 |
| **Research** | `/research` | 对任意主题进行带引用的研究，支持结构化 JSON 输出，便于接入自动化流程。 |
| **Extract** | `/extract` | 从指定 URL 提取干净内容，返回网页的 markdown/text 结果。 |
| **Crawl** | `/crawl` | 爬取网站内容，并可将文档、知识库或网页内容保存为本地 markdown 文件。 |
| **Inspiro Best Practices** | `/inspiro-best-practices` | 面向生产环境的 Inspiro 集成参考文档，适用于 agent 工作流、RAG 系统与自治代理。 |
