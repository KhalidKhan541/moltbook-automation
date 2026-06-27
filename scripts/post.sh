#!/bin/bash

# Manual post script for Moltbook
# Usage: ./scripts/post.sh "title" "body" "submolt"

set -e

API_BASE="https://www.moltbook.com/api/v1"

if [ -z "$MOLTBOOK_API_KEY" ]; then
    echo "Error: MOLTBOOK_API_KEY environment variable is not set"
    echo "Usage: export MOLTBOOK_API_KEY=your_api_key_here"
    exit 1
fi

if [ $# -lt 3 ]; then
    echo "Usage: $0 \"title\" \"body\" \"submolt\""
    echo "Example: $0 \"My Post\" \"Post body text\" \"m/general\""
    exit 1
fi

TITLE="$1"
BODY="$2"
SUBMOLT="$3"

echo "Posting to Moltbook..."
echo "Title: $TITLE"
echo "Submolt: $SUBMOLT"
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X POST "$API_BASE/posts" \
    -H "Authorization: Bearer $MOLTBOOK_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg title "$TITLE" --arg body "$BODY" --arg submolt "$SUBMOLT" \
        '{title: $title, body: $body, submolt: $submolt}')")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "Post created successfully!"
    echo "$BODY" | jq .
else
    echo "Error (HTTP $HTTP_CODE):"
    echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
    exit 1
fi
