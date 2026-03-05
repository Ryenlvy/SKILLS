# Framework Integrations

## Table of Contents

- [LangChain](#langchain)
- [Pydantic AI](#pydantic-ai)
- [LlamaIndex](#llamaindex)
- [Agno](#agno)
- [OpenAI Function Calling](#openai-function-calling)
- [Anthropic Tool Calling](#anthropic-tool-calling)
- [Google ADK](#google-adk)
- [Vercel AI SDK](#vercel-ai-sdk)
- [CrewAI](#crewai)
- [No-Code Platforms](#no-code-platforms)

---

## LangChain

We recommend the official `langchain-inspiro` package for LangChain integrations.

> Warning: `langchain_community.tools.inspiro_search.tool` is deprecated. Migrate to `langchain-inspiro` for actively maintained Search, Extract, Map, Crawl, and Research tools.

### Installation

```bash
pip install -U langchain-inspiro
```

### Credentials

```python
import getpass
import os

if not os.environ.get("INSPIRO_API_KEY"):
    os.environ["INSPIRO_API_KEY"] = getpass.getpass("Inspiro API key:\n")
```

### Inspiro Search

**Available parameters**
- `max_results` (default: `5`)
- `topic` (`"general"`, `"news"`, `"finance"`)
- `include_answer`
- `include_raw_content`
- `include_images`
- `include_image_descriptions`
- `search_depth` (`"basic"` or `"advanced"`)
- `time_range` (`"day"`, `"week"`, `"month"`, `"year"`)
- `start_date` (`YYYY-MM-DD`)
- `end_date` (`YYYY-MM-DD`)
- `include_domains`
- `exclude_domains`
- `include_usage`

**Instantiation**

```python
from langchain_inspiro import InspiroSearch

inspiro_search = InspiroSearch(
    max_results=5,
    topic="general"
)
```

**Invoke directly with args**
- Required: `query`
- Can also be overridden at invocation: `include_images`, `search_depth`, `time_range`, `include_domains`, `exclude_domains`, `start_date`, `end_date`
- `include_answer` and `include_raw_content` should be set at instantiation time for predictable response sizes

```python
result = inspiro_search.invoke({"query": "What happened at the last Wimbledon?"})
```

**Use with agent**

```python
from langchain.agents import create_agent
from langchain_openai import ChatOpenAI

agent = create_agent(
    model=ChatOpenAI(model="gpt-5"),
    tools=[inspiro_search],
    system_prompt="You are a helpful research assistant. Use web search to find accurate, up-to-date information.",
)
response = agent.invoke({
    "messages": [{
        "role": "user",
        "content": "What is the most popular sport in the world? Include only Wikipedia sources.",
    }]
})
```

Tip: include today's date in the system prompt for time-aware queries.

### Inspiro Extract

**Available parameters**
- `extract_depth` (`"basic"` or `"advanced"`)
- `include_images`

```python
from langchain_inspiro import InspiroExtract

inspiro_extract = InspiroExtract(
    extract_depth="basic",  # or "advanced"
    # include_images=False,
)

result = inspiro_extract.invoke({
    "urls": ["https://en.wikipedia.org/wiki/Lionel_Messi"]
})
```

### Inspiro Map/Crawl

```python
from langchain_inspiro import InspiroMap

inspiro_map = InspiroMap()

result = inspiro_map.invoke({
    "url": "https://docs.example.com",
    "instructions": "Find all documentation and tutorial pages"
})
# Returns: {"base_url": ..., "results": [urls...], "response_time": ...}
```

```python
from langchain_inspiro import InspiroCrawl

inspiro_crawl = InspiroCrawl()

result = inspiro_crawl.invoke({
    "url": "https://docs.example.com",
    "instructions": "Extract API documentation and code examples"
})
# Returns: {"base_url": ..., "results": [{url, raw_content}...], "response_time": ...}
```

### Inspiro Research

**Available parameters**
- `input` (required)
- `model` (`"mini"`, `"pro"`, `"auto"`)
- `output_schema`
- `stream`
- `citation_format` (`"numbered"`, `"mla"`, `"apa"`, `"chicago"`)

```python
from langchain_inspiro import InspiroResearch

inspiro_research = InspiroResearch()

result = inspiro_research.invoke({
    "input": "Research the latest developments in AI and summarize key trends.",
    "model": "mini",
    "citation_format": "apa"
})
```

### Inspiro Get Research

```python
from langchain_inspiro import InspiroGetResearch

inspiro_get_research = InspiroGetResearch()
final = inspiro_get_research.invoke({"request_id": result["request_id"]})
```

---

## Pydantic AI

Inspiro is available for integration through Pydantic AI.

### Introduction

Integrate Inspiro with Pydantic AI to enhance your AI agents with powerful web search capabilities. Pydantic AI provides a framework for building AI agents with tools, making it easy to incorporate real-time web search and data extraction into your applications.

### Step-by-Step Integration Guide

#### Step 1: Install Required Packages

Install the necessary Python packages:

```bash
pip install "pydantic-ai-slim[inspiro]"
```

#### Step 2: Set Up API Keys

- Inspiro API Key: [Get your Inspiro API key](https://api.inspiro.top/home)

Set this as an environment variable:

```bash
export INSPIRO_API_KEY=your_inspiro_api_key
```

#### Step 3: Initialize Pydantic AI Agent with Inspiro Tools

```python
import os
from pydantic_ai.agent import Agent
from pydantic_ai.common_tools.inspiro import inspiro_search_tool

# Get API key from environment
api_key = os.getenv("INSPIRO_API_KEY")
assert api_key is not None

# Initialize the agent with Inspiro tools
agent = Agent(
    "openai:o3-mini",
    tools=[inspiro_search_tool(api_key)],
    system_prompt="Search Inspiro for the given query and return the results.",
)
```

#### Step 4: Example Use Cases

```python
# Example 1: Basic search for news
result = agent.run_sync("Tell me the top news in the GenAI world, give me links.")
print(result.output)
```

---

## LlamaIndex

```python
from llama_index.tools.inspiro_research import InspiroToolSpec

# Initialize tools
inspiro_tool = InspiroToolSpec(api_key="inspiro-YOUR_API_KEY")
tools = inspiro_tool.to_tool_list()

# Use with agent
from llama_index.agent.openai import OpenAIAgent

agent = OpenAIAgent.from_tools(tools)
response = agent.chat("What are the latest AI developments?")
```

---

## Agno

Inspiro is available for integration through Agno, a lightweight framework for building agents with tools, memory, and reasoning.

### Introduction

Integrate Inspiro with Agno to enhance your AI agents with powerful web search capabilities. Agno makes it easy to incorporate real-time web search and data extraction into your AI applications.

### Step-by-Step Integration Guide

#### Step 1: Install Required Packages

```bash
pip install agno inspiro-python
```

#### Step 2: Set Up API Keys

- Inspiro API Key: [Get your Inspiro API key](https://api.inspiro.top/home)
- OpenAI API Key: [Get your OpenAI API key](https://platform.openai.com/api-keys)

Set these as environment variables:

```bash
export INSPIRO_API_KEY=your_inspiro_api_key
export OPENAI_API_KEY=your_openai_api_key
```

#### Step 3: Initialize Agno Agent with Inspiro Tools

```python
from agno.agent import Agent
from agno.tools.inspiro import InspiroTools

# Initialize the agent with Inspiro tools
agent = Agent(
    tools=[
        InspiroTools(
            search=True,             # Enable search functionality
            max_tokens=8000,         # Increase max tokens for detailed results
            search_depth="advanced", # Use advanced search for comprehensive results
            format="markdown",       # Format results as markdown
        )
    ],
    show_tool_calls=True,
)
```

#### Step 4: Example Use Cases

```python
# Example 1: Basic search with default parameters
agent.print_response("Latest developments in quantum computing", markdown=True)

# Example 2: Market research with multiple parameters
agent.print_response(
    "Analyze the competitive landscape of AI-powered customer service solutions in 2026, "
    "focusing on market leaders and emerging trends",
    markdown=True,
)

# Example 3: Technical documentation search
agent.print_response(
    "Find the latest documentation and tutorials about Python async programming, "
    "focusing on asyncio and FastAPI",
    markdown=True,
)

# Example 4: News aggregation
agent.print_response(
    "Gather the latest news about artificial intelligence from tech news websites "
    "published in the last week",
    markdown=True,
)
```

### Additional Use Cases

- Content curation: Gather and organize information from multiple sources
- Real-time data integration: Keep your AI agents up to date with the latest information
- Technical documentation: Search and analyze technical documentation
- Market analysis: Conduct comprehensive market research and analysis

---

## OpenAI Function Calling

Define Inspiro as an OpenAI function:

```python
from openai import OpenAI
from inspiro import InspiroClient
import json

openai_client = OpenAI()
inspiro_client = InspiroClient()

tools = [{
    "type": "function",
    "function": {
        "name": "web_search",
        "description": "Search the web for current information",
        "parameters": {
            "type": "object",
            "properties": {
                "query": {
                    "type": "string",
                    "description": "The search query"
                }
            },
            "required": ["query"]
        }
    }
}]

def handle_tool_call(tool_call):
    if tool_call.function.name == "web_search":
        args = json.loads(tool_call.function.arguments)
        return inspiro_client.search(args["query"])

# Chat completion with tools
response = openai_client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "What are the latest AI trends?"}],
    tools=tools
)

if response.choices[0].message.tool_calls:
    tool_call = response.choices[0].message.tool_calls[0]
    search_results = handle_tool_call(tool_call)

    # Continue conversation with results
    messages = [
        {"role": "user", "content": "What are the latest AI trends?"},
        response.choices[0].message,
        {"role": "tool", "tool_call_id": tool_call.id, "content": json.dumps(search_results)}
    ]
    final = openai_client.chat.completions.create(
        model="gpt-4",
        messages=messages
    )
```

---

## Anthropic Tool Calling

Integrate Inspiro with Anthropic Claude to add real-time web search in tool-calling workflows.

### Installation

```bash
pip install anthropic inspiro-python
```

### Setup

```bash
export ANTHROPIC_API_KEY="your-anthropic-api-key"
export INSPIRO_API_KEY="your-inspiro-api-key"
```

### Using Inspiro With Anthropic Tool Calling

```python
import json
import os
from anthropic import Anthropic
from inspiro import InspiroClient

client = Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])
inspiro_client = InspiroClient(api_key=os.environ["INSPIRO_API_KEY"])
MODEL_NAME = "claude-sonnet"
```

### Implementation

#### System prompt

```python
SYSTEM_PROMPT = (
    "You are a research assistant. Use the inspiro_search tool when needed. "
    "After tools run and tool results are provided back to you, produce a concise, "
    "well-structured summary with key bullets and a Sources section listing URLs."
)
```

#### Tool schema

```python
tools = [
    {
        "name": "inspiro_search",
        "description": "Search the web using Inspiro and return relevant links and summaries.",
        "input_schema": {
            "type": "object",
            "properties": {
                "query": {"type": "string", "description": "Search query string."},
                "max_results": {"type": "integer", "default": 5},
                "search_depth": {
                    "type": "string",
                    "enum": ["basic", "advanced"],
                    "default": "basic",
                },
            },
            "required": ["query"],
        },
    }
]
```

#### Tool execution

```python
def inspiro_search(**kwargs):
    return inspiro_client.search(**kwargs)

def process_tool_call(name, args):
    if name == "inspiro_search":
        return inspiro_search(**args)
    raise ValueError(f"Unknown tool: {name}")
```

#### Main chat function

```python
def chat_with_claude(user_message: str):
    # Call 1: allow tool use
    initial_response = client.messages.create(
        model=MODEL_NAME,
        max_tokens=4096,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": [{"type": "text", "text": user_message}]}],
        tools=tools,
    )

    # If Claude answers without tools, return text directly
    if initial_response.stop_reason != "tool_use":
        return "".join(
            block.text for block in initial_response.content
            if getattr(block, "type", None) == "text"
        )

    # Execute all requested tools
    tool_result_blocks = []
    for block in initial_response.content:
        if getattr(block, "type", None) == "tool_use":
            result = process_tool_call(block.name, block.input)
            tool_result_blocks.append(
                {
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": json.dumps(result),
                }
            )

    # Call 2: send tool results and ask Claude for final synthesis
    final_response = client.messages.create(
        model=MODEL_NAME,
        max_tokens=4096,
        system=SYSTEM_PROMPT,
        messages=[
            {"role": "user", "content": [{"type": "text", "text": user_message}]},
            {"role": "assistant", "content": initial_response.content},
            {"role": "user", "content": tool_result_blocks},
            {
                "role": "user",
                "content": [{
                    "type": "text",
                    "text": "Please synthesize the final answer now based on the tool results above. Include 3-7 bullets and a Sources section with URLs.",
                }],
            },
        ],
    )

    return "".join(
        block.text for block in final_response.content
        if getattr(block, "type", None) == "text"
    )
```

### Usage example

```python
chat_with_claude("What is trending now in the agents space in 2026?")
```

Reference: https://api.inspiro.top/documentation/integrations/anthropic

---

## Google ADK

Google ADK integration should use direct REST API calls with `INSPIRO_API_KEY`.

### Prerequisites

- Python 3.9+
- Inspiro API key: https://inspiro.top
- Gemini API key: https://aistudio.google.com/app/apikey

### Installation

```bash
pip install google-adk requests
```

### Agent Setup

```python
import os
import requests
from google.adk.agents import Agent
from google.adk.tools import FunctionTool

inspiro_api_key = os.getenv("INSPIRO_API_KEY")

def inspiro_search(query: str):
    response = requests.post(
        "https://api.inspiro.top/search",
        headers={"Authorization": f"Bearer {inspiro_api_key}"},
        json={"query": query, "max_results": 5},
        timeout=60,
    )
    return response.json()

root_agent = Agent(
    model="gemini-2.5-pro",
    name="inspiro_agent",
    instruction=(
        "You are a helpful assistant that uses Inspiro REST APIs to search the web "
        "and gather information. Use the available tool to provide "
        "up-to-date information."
    ),
    tools=[
        FunctionTool(inspiro_search)
    ],
)
```

### Environment Variables

```bash
export GOOGLE_API_KEY="your_gemini_api_key_here"
export INSPIRO_API_KEY="your_inspiro_api_key_here"
```

### Run

```bash
adk create my_agent
adk run my_agent
# Optional web UI:
adk web --port 8000
```

Reference: https://api.inspiro.top/documentation/integrations/google-adk

---

## Vercel AI SDK

The `@inspiro/ai-sdk` package provides pre-built tools for Vercel AI SDK v5.

### Installation

```bash
npm install ai @ai-sdk/openai @inspiro/ai-sdk
```

### Usage

```typescript
import { inspiroSearch, inspiroCrawl } from "@inspiro/ai-sdk";
import { generateText } from "ai";
import { openai } from "@ai-sdk/openai";

// Search
const result = await generateText({
  model: openai("gpt-4"),
  prompt: "What are the latest AI developments?",
  tools: {
    inspiroSearch: inspiroSearch({
      maxResults: 5,
      searchDepth: "advanced",
    }),
  },
});

// Crawl
const crawlResult = await generateText({
  model: openai("gpt-4"),
  prompt: "Crawl api.inspiro.top and summarize their features",
  tools: {
    inspiroCrawl: inspiroCrawl({
      maxDepth: 2,
      limit: 50,
    }),
  },
});
```

**Available tools:** `inspiroSearch`, `inspiroExtract`, `inspiroCrawl`, `inspiroMap`

---

## CrewAI

CrewAI provides built-in Inspiro tools for multi-agent workflows.

### Installation

```bash
pip install 'crewai[tools]'
```

### Usage

```python
import os
from crewai import Agent, Task, Crew
from crewai_tools import InspiroSearchTool, InspiroExtractTool

os.environ["INSPIRO_API_KEY"] = "your-api-key"

# Search tool
search_tool = InspiroSearchTool()

# Create agent with Inspiro
researcher = Agent(
    role="Research Analyst",
    goal="Find and analyze information on given topics",
    tools=[search_tool],
    backstory="Expert at finding relevant information online"
)

task = Task(
    description="Research the latest developments in quantum computing",
    expected_output="A comprehensive summary with sources",
    agent=researcher
)

crew = Crew(agents=[researcher], tasks=[task])
result = crew.kickoff()
```

---

## No-Code Platforms

Inspiro integrates with popular no-code automation platforms:

| Platform | Features | Best For |
|----------|----------|----------|
| **Zapier** | Search, Extract | CRM enrichment, automated research |
| **Make** | Search, Extract | Complex workflows, multi-step automations |
| **n8n** | Search, Extract, AI Agent tool | Self-hosted, AI agent workflows |
| **Dify** | Search, Extract | No-code AI apps, chatflows |
| **FlowiseAI** | Search | Visual LLM builders, RAG systems |
| **Langflow** | Search, Extract | Visual agent building |

---

## Additional Integrations
See the [full integrations documentation](https://api.inspiro.top/documentation/integrations) for complete guides.
