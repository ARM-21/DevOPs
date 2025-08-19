# MongoDB CRUD API Test Examples

## Prerequisites
Make sure MongoDB is running with admin:admin credentials:
```bash
# If using Docker:
docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=admin mongo:latest

# Or if MongoDB is installed locally, ensure it's configured with admin:admin
```

## API Endpoints

### 1. Health Check
```bash
curl http://localhost:3000/health
```

### 2. Database Stats
```bash
curl http://localhost:3000/api/stats
```

### 3. Create a User (POST)
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

### 4. Get All Users (GET)
```bash
curl http://localhost:3000/api/users
```

### 5. Get User by ID (GET)
```bash
# Replace USER_ID with actual ID from previous response
curl http://localhost:3000/api/users/USER_ID
```

### 6. Update User (PUT)
```bash
# Replace USER_ID with actual ID
curl -X PUT http://localhost:3000/api/users/USER_ID \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "age": 31,
    "role": "admin"
  }'
```

### 7. Delete User (DELETE)
```bash
# Replace USER_ID with actual ID
curl -X DELETE http://localhost:3000/api/users/USER_ID
```

## Sample Test Data
Here are some sample users you can create:

```json
{
  "name": "Alice Johnson",
  "email": "alice@example.com",
  "age": 28,
  "role": "moderator"
}
```

```json
{
  "name": "Bob Wilson",
  "email": "bob@example.com",
  "age": 35,
  "role": "user"
}
```

```json
{
  "name": "Carol Brown",
  "email": "carol@example.com",
  "age": 42,
  "role": "admin"
}
```

## Complete Test Flow Script

Create a file `test-api.sh` to test all operations:

```bash
#!/bin/bash

echo "🧪 Testing DevOps API CRUD Operations"
echo "======================================"

API_URL="http://localhost:3000"

# Test health check
echo "1. Testing health check..."
curl -s $API_URL/health | jq '.'

echo -e "\n2. Creating users..."

# Create users and capture IDs
USER1_ID=$(curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User 1","email":"test1@example.com","age":25,"role":"user"}' | jq -r '.data._id')

USER2_ID=$(curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User 2","email":"test2@example.com","age":30,"role":"admin"}' | jq -r '.data._id')

echo "Created User 1 ID: $USER1_ID"
echo "Created User 2 ID: $USER2_ID"

echo -e "\n3. Getting all users..."
curl -s $API_URL/api/users | jq '.'

echo -e "\n4. Getting user by ID..."
curl -s $API_URL/api/users/$USER1_ID | jq '.'

echo -e "\n5. Updating user..."
curl -s -X PUT $API_URL/api/users/$USER1_ID \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated Test User 1","age":26}' | jq '.'

echo -e "\n6. Getting updated user..."
curl -s $API_URL/api/users/$USER1_ID | jq '.'

echo -e "\n7. Deleting user..."
curl -s -X DELETE $API_URL/api/users/$USER2_ID | jq '.'

echo -e "\n8. Final user list..."
curl -s $API_URL/api/users | jq '.'

echo -e "\n9. Database stats..."
curl -s $API_URL/api/stats | jq '.'

echo -e "\n✅ API test completed!"
```

## Error Testing

### Test Invalid User Creation
```bash
# Missing required field
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "age": 25
  }'
```

### Test Invalid User ID
```bash
curl -X GET http://localhost:3000/api/users/invalid_id
```

### Test Duplicate Email
```bash
# Create user with duplicate email
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Duplicate User",
    "email": "john@example.com",
    "age": 25
  }'
```

## Response Format
All responses follow this format:

### Success Response
```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": { /* actual data */ },
  "count": 10  // for list operations
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "error": "Detailed error message"
}
```

## Database Schema

The User model has the following fields:

- **name**: String (required, trimmed)
- **email**: String (required, unique, lowercase, trimmed)
- **age**: Number (minimum: 0)
- **role**: String (enum: ['user', 'admin', 'moderator'], default: 'user')
- **createdAt**: Date (auto-generated)
- **updatedAt**: Date (auto-generated)

## Tips

1. **Use jq for pretty JSON output:**
   ```bash
   curl -s http://localhost:3000/api/users | jq '.'
   ```

2. **Save response to variable:**
   ```bash
   RESPONSE=$(curl -s http://localhost:3000/api/users)
   echo $RESPONSE | jq '.data[0]._id'
   ```

3. **Monitor MongoDB logs:**
   ```bash
   docker logs -f devops_mongodb
   ```
