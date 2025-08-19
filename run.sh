#!/bin/bash

# DevOps Project Runner Script
echo "🚀 DevOps Project Management Script"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from template..."
    cp .env.example .env
    echo "📝 Please update .env with your secure credentials before running!"
    exit 1
fi

# Start services
echo "🐳 Starting services with Docker Compose..."
docker compose down 2>/dev/null || true
docker compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if services are running
echo "📊 Checking service status..."
docker compose ps

echo ""
echo "🎉 Services are running!"
echo ""
echo "📋 Available commands:"
echo "  - Stop services: docker compose down"
echo "  - View app logs: docker compose logs app"
echo "  - View DB logs: docker compose logs mongodb"
echo "  - Run tests: ./test-api.sh"
echo "  - API URL: http://localhost:3000"