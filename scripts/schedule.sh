#!/bin/bash

# Schedule preview script
# Reads promo-posts.json and shows what would post each day

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTENT_FILE="$SCRIPT_DIR/../content/promo-posts.json"

if [ ! -f "$CONTENT_FILE" ]; then
    echo "Error: promo-posts.json not found at $CONTENT_FILE"
    exit 1
fi

POST_COUNT=$(jq length "$CONTENT_FILE")
DAYS=("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun")

echo "=== Moltbook Weekly Schedule ==="
echo ""
echo "Total posts ready: $POST_COUNT"
echo ""

jq -r '.[] | "\(.submolt)|\(.title)|\(.tags)"' "$CONTENT_FILE" | \
while IFS='|' read -r submolt title tags; do
    for i in "${!DAYS[@]}"; do
        if [ $((i % POST_COUNT)) -eq 0 ] || [ $((POST_COUNT % 7)) -eq 0 ]; then
            echo "${DAYS[$((i % 7))]}:"
        fi
    done
done

echo "Daily schedule:"
echo "---------------"

INDEX=0
jq -c '.[]' "$CONTENT_FILE" | while read -r post; do
    DAY_INDEX=$((INDEX % 7))
    DAY="${DAYS[$DAY_INDEX]}"
    SUBMOLT=$(echo "$post" | jq -r '.submolt')
    TITLE=$(echo "$post" | jq -r '.title' | head -c 50)
    TAGS=$(echo "$post" | jq -r '.tags')
    
    echo "$DAY | $SUBMOLT"
    echo "    $TITLE..."
    echo "    $TAGS"
    echo ""
    
    INDEX=$((INDEX + 1))
done

echo "Note: Actual posting requires MOLTBOOK_API_KEY to be set."
echo "Run ./scripts/post.sh to post manually."
