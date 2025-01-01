#!/usr/bin/env bash

# Check if .env file exists
if [ -f .env ]; then
  # Load environment variables
  export $(cat .env | xargs)
fi

# Validate required environment variables
ENVIRONMENT="${ENVIRONMENT:-PRODUCTION}"

# Start Runpod handler
if [ "$ENVIRONMENT" = "PRODUCTION" ]; then
    echo "Worker Initiated"
    echo "Starting Runpod Handler"
    python -u "/app/handler.py"
else
    echo "Local Test Worker Initiated"
    echo "Starting Test Runpod Handler"
    python -u "src/handler.py" --rp_serve_api --rp_api_host="0.0.0.0"
fi
