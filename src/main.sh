#!/usr/bin/env bash

# Main script for Runpod worker
set -e

# Check if .env file exists
if [ -f .env ]; then
  # Load environment variables
  export $(cat .env | xargs)
fi

# Validate required environment variables
ENVIRONMENT="${ENVIRONMENT:-PRODUCTION}"
DEBUG="${DEBUG:-FALSE}"

# Start Runpod handler
if [ "$ENVIRONMENT" = "PRODUCTION" ]; then
    if [ "$DEBUG" = "FALSE" ]; then
        echo "Worker Initiated for Production"
        echo "Starting Runpod Serverless Handler"
        python -u "/app/handler.py"
    else
        echo "Worker Initiated for Debug"
        echo "Starting Runpod Serverless Test Server"
        python -u "/app/handler.py" --rp_serve_api --rp_api_host="0.0.0.0"
    fi
else
    echo "Worker Initiated for Local Test"
    echo "Starting Runpod Serverless Test Server"
    python -u "src/handler.py" --rp_serve_api --rp_api_host="0.0.0.0"
fi
