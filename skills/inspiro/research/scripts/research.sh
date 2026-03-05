#!/bin/bash
# Inspiro Research API script (API key only)
# Usage: ./research.sh '{"input": "your research query", ...}' [output_file]

set -e

JSON_INPUT="$1"
OUTPUT_FILE="$2"

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
    echo "Usage: ./research.sh '<json>' [output_file]"
    echo ""
    echo "Required:"
    echo "  input: string - The research topic or question"
    echo ""
    echo "Optional:"
    echo "  model: \"mini\" (default), \"pro\", \"auto\""
    echo ""
    echo "Arguments:"
    echo "  output_file: optional file to save results"
    echo ""
    echo "Example:"
    echo "  ./research.sh '{\"input\": \"AI agent frameworks comparison\", \"model\": \"pro\"}' report.md"
    exit 1
fi

# Validate JSON
if ! echo "$JSON_INPUT" | jq empty >/dev/null 2>&1; then
    echo "Error: Invalid JSON input"
    exit 1
fi

# Check for required input field
if ! echo "$JSON_INPUT" | jq -e '.input' >/dev/null 2>&1; then
    echo "Error: 'input' field is required"
    exit 1
fi

INPUT=$(echo "$JSON_INPUT" | jq -r '.input')
MODEL=$(echo "$JSON_INPUT" | jq -r '.model // "mini"')

echo "Researching: $INPUT (model: $MODEL)"
echo "This may take 30-120 seconds..."

RESPONSE=$(curl -s --request POST \
    --url "https://api.inspiro.top/research" \
    --header "Authorization: Bearer $INSPIRO_API_KEY" \
    --header 'Content-Type: application/json' \
    --data "$JSON_INPUT")

if [ -n "$OUTPUT_FILE" ]; then
    echo "$RESPONSE" | jq '.' > "$OUTPUT_FILE" 2>/dev/null || echo "$RESPONSE" > "$OUTPUT_FILE"
    echo "Results saved to: $OUTPUT_FILE"
else
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
fi
