# Agent Skills

## 安装

```bash
npx skills add https://github.com/Ryenlvy/SKILLS
```

## 认证

仅支持 API Key 导入。

请先在 [https://inspiro.top](https://inspiro.top) 注册并获取你自己的 API Key，然后写入 `~/.claude/settings.json`：
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
