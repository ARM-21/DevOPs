#!/bin/bash

echo "🚀 DevOps API with MongoDB Setup"
echo "================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if containers are already running
echo "🔍 Checking for existing containers..."
if docker ps -q --filter "name=devops_mongodb" | grep -q .; then
    echo "📦 MongoDB container already running, stopping it..."
    docker stop devops_mongodb
    docker rm devops_mongodb
fi

if docker ps -q --filter "name=devops-api" | grep -q .; then
    echo "🚀 API container already running, stopping it..."
    docker stop devops-api
    docker rm devops-api
fi

# Check if port 27017 is in use
if lsof -Pi :27017 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️  Port 27017 is in use. Checking for MongoDB processes..."
    docker ps --filter "publish=27017"
    echo "Stopping any containers using port 27017..."
    docker stop $(docker ps -q --filter "publish=27017") 2>/dev/null || true
fi

# Use Docker Compose for better container management
echo "🐳 Starting services with Docker Compose..."
if [ -f "docker-compose.yml" ]; then
    docker compose down 2>/dev/null || true
    docker compose up -d
    
    echo "⏳ Waiting for services to be ready..."
    sleep 15
    
    echo "✅ Services started successfully!"
    echo "🔗 API will be available at: http://localhost:3000"
    echo "🔗 Health check: http://localhost:3000/health"
    echo "🔗 Database stats: http://localhost:3000/api/stats"
    echo ""
    echo "📚 Check api-test-examples.md for CRUD operation examples"
    echo ""
    echo "🧪 Run './test-api.sh' to test the API"
else
    echo "❌ docker-compose.yml not found. Creating one..."
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  mongodb:
    image: mongo:latest
    container_name: devops_mongodb
    restart: unless-stopped
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin
      MONGO_INITDB_DATABASE: devops_db
    volumes:
      - mongodb_data:/data/db
    networks:
      - devops_network

  api:
    image: main-app:1.0
    container_name: devops-api
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - MONGODB_URI=mongodb://admin:admin@mongodb:27017/devops_db?authSource=admin
    depends_on:
      - mongodb
    networks:
      - devops_network

volumes:
  mongodb_data:

networks:
  devops_network:
    driver: bridge
EOF
    
    echo "✅ docker-compose.yml created. Starting services..."
    docker compose up -d
    
    echo "⏳ Waiting for services to be ready..."
    sleep 15
    
    echo "✅ Services started successfully!"
    echo "🔗 API will be available at: http://localhost:3000"
    echo "🔗 Health check: http://localhost:3000/health"
    echo "🔗 Database stats: http://localhost:3000/api/stats"
    echo ""
    echo "📚 Check api-test-examples.md for CRUD operation examples"
    echo ""
    echo "🧪 Run './test-api.sh' to test the API"
fi