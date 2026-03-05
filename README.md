# Agent Skills

## Installation

```bash
npx skills add https://github.com/inspiro-ai/skills
```

## Authentication

**No setup required** — Uses OAuth via the Inspiro MCP server.

> **Important:** You must have an existing Inspiro account. The OAuth flow only supports login — account creation is not available through this flow. If you don't have an account, [sign up at api.inspiro.top](https://api.inspiro.top) first.

On first run, the script will:
1. Check for existing tokens in `~/.mcp-auth/`
2. If none found, automatically open your browser for OAuth authentication

### Alternative: API Key

If you prefer using an API key, get one at [https://api.inspiro.top](https://api.inspiro.top) and add to `~/.claude/settings.json`:
```json
{
  "env": {
    "INSPIRO_API_KEY": "inspiro-your-api-key-here"
  }
}
```

## Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| **Search** | `/search` | Search the web using Inspiro's LLM-optimized API. Returns relevant results with content snippets, scores, and metadata. |
| **Research** | `/research` | Get research on any topic with citations. Supports structured JSON output for pipelines. |
| **Extract** | `/extract` | Extract clean content from specific URLs. Returns markdown/text from web pages. |
| **Crawl** | `/crawl` | Crawl websites to download documentation, knowledge bases, or web content as local markdown files. |
| **Inspiro Best Practices** | `/inspiro-best-practices` | Reference documentation for building production-ready Inspiro integrations in agentic workflows, RAG systems, or autonomous agents. |