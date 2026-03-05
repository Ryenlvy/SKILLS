#!/bin/bash
# Inspiro Crawl API script (API key only)
# Usage: ./crawl.sh '{"url": "https://example.com", ...}' [output_dir]

set -e

JSON_INPUT="$1"
OUTPUT_DIR="$2"

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
    echo "Usage: ./crawl.sh '<json>' [output_dir]"
    echo ""
    echo "Required:"
    echo "  url: string - Root URL to begin crawling"
    echo ""
    echo "Optional:"
    echo "  max_depth: 1-5 (default: 1) - Levels deep to crawl"
    echo "  max_breadth: integer (default: 20) - Links per page"
    echo "  limit: integer (default: 50) - Total pages cap"
    echo "  instructions: string - Natural language guidance for semantic focus"
    echo "  extract_depth: \"basic\" (default), \"advanced\""
    echo "  format: \"markdown\" (default), \"text\""
    echo "  select_paths: [\"regex1\", \"regex2\"] - Paths to include"
    echo "  select_domains: [\"regex1\"] - Domains to include"
    echo "  allow_external: true/false (default: true)"
    echo "  include_favicon: true/false"
    echo ""
    echo "Arguments:"
    echo "  output_dir: optional directory to save markdown files"
    echo ""
    echo "Example:"
    echo "  ./crawl.sh '{\"url\": \"https://docs.example.com\", \"max_depth\": 2, \"select_paths\": [\"/api/.*\"]}' ./output"
    exit 1
fi

# Validate JSON
if ! echo "$JSON_INPUT" | jq empty >/dev/null 2>&1; then
    echo "Error: Invalid JSON input"
    exit 1
fi

# Check for required url field
if ! echo "$JSON_INPUT" | jq -e '.url' >/dev/null 2>&1; then
    echo "Error: 'url' field is required"
    exit 1
fi

# Ensure format is markdown when saving files
if [ -n "$OUTPUT_DIR" ]; then
    JSON_INPUT=$(echo "$JSON_INPUT" | jq '. + {format: "markdown"}')
fi

URL=$(echo "$JSON_INPUT" | jq -r '.url')
echo "Crawling: $URL"

RESPONSE=$(curl -s --request POST \
    --url "https://api.inspiro.top/crawl" \
    --header "Authorization: Bearer $INSPIRO_API_KEY" \
    --header 'Content-Type: application/json' \
    --data "$JSON_INPUT")

if [ -n "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"

    if ! echo "$RESPONSE" | jq -e '.results' >/dev/null 2>&1; then
        echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
        exit 1
    fi

    echo "$RESPONSE" | jq -r '.results[] | @base64' | while read -r item; do
        _jq() {
            echo "$item" | base64 --decode | jq -r "$1"
        }

        PAGE_URL=$(_jq '.url')
        CONTENT=$(_jq '.raw_content // .content // ""')

        FILENAME=$(echo "$PAGE_URL" | sed 's|https\?://||' | sed 's|[/:?&=]|_|g' | cut -c1-100)
        FILEPATH="$OUTPUT_DIR/${FILENAME}.md"

        echo "# $PAGE_URL" > "$FILEPATH"
        echo "" >> "$FILEPATH"
        echo "$CONTENT" >> "$FILEPATH"

        echo "Saved: $FILEPATH"
    done

    echo "Crawl complete. Files saved to: $OUTPUT_DIR"
else
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
fi
