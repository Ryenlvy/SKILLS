#!/bin/bash
# Inspiro Search API script (API key only)
# Usage: ./search.sh '{"query": "your search query", ...}'

set -e

JSON_INPUT="$1"

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required. Please install jq first."
    exit 1
fi

if [ -z "$INSPIRO_API_KEY" ]; then
    echo "Error: INSPIRO_API_KEY is required."
    echo "Set INSPIRO_API_KEY in your environment or ~/.claude/settings.json before running this script."
    exit 1
fi

if [ -z "$JSON_INPUT" ]; then
    echo "Usage: ./search.sh '<json>'"
    echo ""
    echo "Required:"
    echo "  query: string - Search query (keep under 400 chars)"
    echo ""
    echo "Optional:"
    echo "  search_depth: \"ultra-fast\", \"fast\", \"basic\" (default), \"advanced\""
    echo "  topic: \"general\" (default)"
    echo "  max_results: 1-20 (default: 10)"
    echo "  time_range: \"day\", \"week\", \"month\", \"year\""
    echo "  start_date: \"YYYY-MM-DD\""
    echo "  end_date: \"YYYY-MM-DD\""
    echo "  include_domains: [\"domain1.com\", \"domain2.com\"]"
    echo "  exclude_domains: [\"domain1.com\", \"domain2.com\"]"
    echo "  country: country name (general topic only)"
    echo "  include_raw_content: true/false"
    echo "  include_images: true/false"
    echo "  include_image_descriptions: true/false"
    echo "  include_favicon: true/false"
    echo ""
    echo "Example:"
    echo "  ./search.sh '{\"query\": \"latest AI trends\", \"time_range\": \"week\"}'"
    exit 1
fi

# Validate JSON
if ! echo "$JSON_INPUT" | jq empty >/dev/null 2>&1; then
    echo "Error: Invalid JSON input"
    exit 1
fi

# Check for required query field
if ! echo "$JSON_INPUT" | jq -e '.query' >/dev/null 2>&1; then
    echo "Error: 'query' field is required"
    exit 1
fi

RESPONSE=$(curl -s --request POST \
    --url "https://api.inspiro.top/search" \
    --header "Authorization: Bearer $INSPIRO_API_KEY" \
    --header 'Content-Type: application/json' \
    --data "$JSON_INPUT")

echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
