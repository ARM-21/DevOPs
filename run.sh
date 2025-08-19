 Start services
docker compose up -d

# Stop services  
docker compose down

# View logs
docker compose logs app
docker compose logs mongodb

# Test API
./test-api.sh