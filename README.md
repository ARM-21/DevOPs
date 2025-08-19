# DevOps API with MongoDB CRUD Operations

A simple Express.js API with MongoDB integration featuring full CRUD operations for user management.

## 🚀 Quick Start

### Option 1: Automated Setup
```bash
./setup-and-run.sh
```

### Option 2: Manual Setup

1. **Start MongoDB with Docker:**
```bash
docker run -d \
  --name devops_mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=admin \
  -e MONGO_INITDB_DATABASE=devops_db \
  mongo:latest
```

2. **Install dependencies:**
```bash
npm install
```

3. **Start the API:**
```bash
npm start
```

## 📋 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information and available endpoints |
| GET | `/health` | Health check for CI/CD |
| GET | `/api/hello` | Simple hello endpoint |
| GET | `/api/stats` | Database connection stats |
| GET | `/api/users` | Get all users |
| POST | `/api/users` | Create a new user |
| GET | `/api/users/:id` | Get user by ID |
| PUT | `/api/users/:id` | Update user by ID |
| DELETE | `/api/users/:id` | Delete user by ID |

## 🧪 Testing

### Run Automated Tests
```bash
npm test
```

### Manual Testing with curl

**Create a user:**
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "age": 30,
    "role": "user"
  }'
```

**Get all users:**
```bash
curl http://localhost:3000/api/users
```

**Update a user:**
```bash
curl -X PUT http://localhost:3000/api/users/USER_ID \
  -H "Content-Type: application/json" \
  -d '{"name": "John Smith", "age": 31}'
```

**Delete a user:**
```bash
curl -X DELETE http://localhost:3000/api/users/USER_ID
```

## 📊 User Schema

```javascript
{
  name: String (required),
  email: String (required, unique),
  age: Number,
  role: String (enum: ['user', 'admin', 'moderator']),
  createdAt: Date,
  updatedAt: Date
}
```

## 🐳 Docker Support

### Using Docker Compose
```bash
docker-compose up -d
```

### Building the Docker Image
```bash
docker build -t devops-api .
```

## 🔧 Configuration

- **MongoDB URI:** `mongodb://admin:admin@localhost:27017/devops_db?authSource=admin`
- **Port:** 3000 (configurable via PORT environment variable)
- **Database:** devops_db
- **Credentials:** admin:admin

## 📁 Project Structure

```
├── app.js                 # Main application file
├── test.js               # Test suite
├── package.json          # Dependencies and scripts
├── dockerfile            # Docker configuration
├── docker-compose.yml    # Docker Compose setup
├── setup-and-run.sh      # Automated setup script
├── api-test-examples.md  # API testing examples
└── README.md            # This file
```

## 🛠️ Development

1. Make sure MongoDB is running
2. Start the application: `npm start`
3. The API will be available at `http://localhost:3000`
4. Health check: `http://localhost:3000/health`
5. Database stats: `http://localhost:3000/api/stats`

## 📝 Response Format

All API responses follow this format:
```json
{
  "success": true/false,
  "message": "Description of the operation",
  "data": {}, // Response data (for successful operations)
  "error": "Error message" // Only present on errors
}
```

## 🚨 Troubleshooting

- **MongoDB Connection Error:** Make sure MongoDB is running with the correct credentials
- **Port Already in Use:** Change the PORT environment variable or stop other services using port 3000
- **Docker Issues:** Ensure Docker is running and you have sufficient permissions

## 📚 Additional Resources

- Check `api-test-examples.md` for comprehensive testing examples
- Use the automated test suite with `npm test`
- Monitor database status with `/api/stats` endpoint
