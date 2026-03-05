---
name: inspiro-best-practices
description: "Bash-first best practices for production Inspiro usage with zero SDK dependency. Use when you need stable, scriptable API workflows for search, extract, crawl, and research using curl and INSPIRO_API_KEY."
---

# Inspiro Best Practices (Bash Only)

This skill is **Bash-first** and requires **no Python/JavaScript SDK**.

## Authentication

Only API key authentication is supported.

```bash
export INSPIRO_API_KEY="your_inspiro_api_key"
```

## Recommended Execution Pattern

Use the provided Bash scripts from this repository:

- `skills/inspiro/search/scripts/search.sh`
- `skills/inspiro/extract/scripts/extract.sh`
- `skills/inspiro/crawl/scripts/crawl.sh`
- `skills/inspiro/research/scripts/research.sh`

These scripts validate inputs and call Inspiro REST endpoints directly.

## Direct API Calls (curl)

### Search

```bash
curl --request POST \
  --url https://api.inspiro.top/search \
  --header "Authorization: Bearer $INSPIRO_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"query":"latest ai trends","max_results":5}'
```

### Extract

```bash
curl --request POST \
  --url https://api.inspiro.top/extract \
  --header "Authorization: Bearer $INSPIRO_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"urls":["https://example.com"]}'
```

### Crawl

```bash
curl --request POST \
  --url https://api.inspiro.top/crawl \
  --header "Authorization: Bearer $INSPIRO_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"url":"https://docs.example.com","max_depth":1,"limit":20}'
```

### Research

```bash
curl --request POST \
  --url https://api.inspiro.top/research \
  --header "Authorization: Bearer $INSPIRO_API_KEY" \
  --header 'Content-Type: application/json' \
  --data '{"input":"AI agent framework comparison","model":"mini"}'
```

## Operational Tips

- Keep `INSPIRO_API_KEY` in environment or `~/.claude/settings.json`; never hardcode in scripts.
- Use small `max_results`/`limit` first, then scale up.
- Always validate JSON request bodies before batch execution.
- For reproducible automation, prefer repository scripts over ad-hoc one-liners.
