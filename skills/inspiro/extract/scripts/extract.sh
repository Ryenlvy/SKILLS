#!/bin/bash
# Inspiro Extract API script (API key only)
# Usage: ./extract.sh '{"urls": ["url1", "url2"], ...}'

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
    echo "Usage: ./extract.sh '<json>'"
    echo ""
    echo "Required:"
    echo "  urls: array - List of URLs to extract (max 20)"
    echo ""
    echo "Optional:"
    echo "  extract_depth: \"basic\" (default), \"advanced\" (for JS/complex pages)"
    echo "  query: string - Reranks chunks by relevance to this query"
    echo "  format: \"markdown\" (default), \"text\""
    echo "  include_images: true/false"
    echo "  include_favicon: true/false"
    echo ""
    echo "Example:"
    echo "  ./extract.sh '{\"urls\": [\"https://docs.example.com/api\"], \"query\": \"authentication\"}'"
    exit 1
fi

# Validate JSON
if ! echo "$JSON_INPUT" | jq empty >/dev/null 2>&1; then
    echo "Error: Invalid JSON input"
    exit 1
fi

# Check for required urls field
if ! echo "$JSON_INPUT" | jq -e '.urls' >/dev/null 2>&1; then
    echo "Error: 'urls' field is required"
    exit 1
fi

RESPONSE=$(curl -s --request POST \
    --url "https://api.inspiro.top/extract" \
    --header "Authorization: Bearer $INSPIRO_API_KEY" \
    --header 'Content-Type: application/json' \
    --data "$JSON_INPUT")

echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
