#!/usr/bin/env bash
# Build Docker image for Chat Simulator

set -e

echo "🐳 Building Docker image for Chat Simulator..."

# Build the image
docker build -t chat-simulator:latest .

echo ""
echo "✅ Docker image built successfully!"
echo ""
echo "To run the container:"
echo "  docker-compose up"
echo ""
echo "Or manually:"
echo "  docker run -it --rm chat-simulator:latest"
