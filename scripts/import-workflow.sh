#!/bin/bash
# import-workflow.sh
# Imports the ETL workflow into your running n8n instance

N8N_URL="http://localhost:5678"
N8N_USER="admin"
N8N_PASS="changeme123"
WORKFLOW_FILE="./workflows/csv-to-json-etl.json"

echo "🚀 Importing n8n ETL workflow..."

# Wait for n8n to be ready
echo "⏳ Waiting for n8n to start..."
until curl -s -o /dev/null -w "%{http_code}" "$N8N_URL/healthz" | grep -q "200"; do
  sleep 3
done

echo "✅ n8n is up!"

# Import workflow via API
RESPONSE=$(curl -s -X POST "$N8N_URL/api/v1/workflows" \
  -u "$N8N_USER:$N8N_PASS" \
  -H "Content-Type: application/json" \
  -d @"$WORKFLOW_FILE")

WORKFLOW_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

if [ -n "$WORKFLOW_ID" ]; then
  echo "✅ Workflow imported! ID: $WORKFLOW_ID"
  echo "🌐 Open n8n at: $N8N_URL"
  echo "👤 Login: $N8N_USER / $N8N_PASS"
else
  echo "⚠️  Import may have failed. Check n8n manually."
  echo "Response: $RESPONSE"
fi
