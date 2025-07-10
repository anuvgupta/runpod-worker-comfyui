#!/bin/bash

# build.sh - Script to build Docker image with git commit hash invalidation

set -e

echo "Fetching latest dependency commit hashes..."

# Get latest commit hash for ComfyUI
COMFYUI_COMMIT=$(git ls-remote https://github.com/comfyanonymous/ComfyUI.git HEAD | cut -f1)
echo "ComfyUI latest commit: $COMFYUI_COMMIT"

# Get latest commit hash for Inspire Pack
INSPIRE_PACK_COMMIT=$(git ls-remote https://github.com/ltdrdata/ComfyUI-Inspire-Pack.git HEAD | cut -f1)
echo "Inspire Pack latest commit: $INSPIRE_PACK_COMMIT"

# Build the Docker image with commit hashes as build arguments
echo "Building Docker image..."
docker build \
  --build-arg COMFYUI_COMMIT_HASH="$COMFYUI_COMMIT" \
  --build-arg INSPIRE_PACK_COMMIT_HASH="$INSPIRE_PACK_COMMIT" \
  -t comfyui:latest \
  .

echo "Build completed!"
echo "ComfyUI commit: $COMFYUI_COMMIT"
echo "Inspire Pack commit: $INSPIRE_PACK_COMMIT"