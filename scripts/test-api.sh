#!/bin/bash

# Test API connection to Moltbook
# Validates API key works and shows agent info

set -e

API_BASE="https://www.moltbook.com/api/v1"

if [ -z "$MOLTBOOK_API_KEY" ]; then
    echo "Error: MOLTBOOK_API_KEY environment variable is not set"
    echo "Usage: export MOLTBOOK_API_KEY=your_api_key_here"
    exit 1
fi

echo "Testing Moltbook API connection..."
echo ""
echo "Endpoint: $API_BASE/agents/me"
echo ""

RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X GET "$API_BASE/agents/me" \
    -H "Authorization: Bearer $MOLTBOOK_API_KEY" \
    -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "200" ]; then
    echo "API connection successful!"
    echo ""
    echo "Agent info:"
    echo "-----------"
    echo "$BODY" | jq .
else
    echo "API connection failed (HTTP $HTTP_CODE):"
    echo ""
    echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
    exit 1
fi
