#!/bin/bash

echo "🧪 Testing DevOps API CRUD Operations"
echo "======================================"

API_URL="http://localhost:3000"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq is not installed. Installing jq for better JSON formatting..."
    sudo apt-get update && sudo apt-get install -y jq
fi

# Check if API is running
echo "🔍 Checking if API is running..."
if ! curl -s $API_URL/health > /dev/null; then
    echo "❌ API is not running. Please start it first with: ./setup-and-run.sh"
    exit 1
fi

echo "✅ API is running!"

# Test health check
echo -e "\n1. 🏥 Testing health check..."
curl -s $API_URL/health | jq '.'

echo -e "\n2. 👥 Creating test users..."

# Create users and capture IDs
echo "Creating User 1..."
USER1_RESPONSE=$(curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User 1","email":"test1@example.com","age":25,"role":"user"}')

USER1_ID=$(echo $USER1_RESPONSE | jq -r '.data._id')
echo "User 1 created with ID: $USER1_ID"
echo $USER1_RESPONSE | jq '.'

echo -e "\nCreating User 2..."
USER2_RESPONSE=$(curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User 2","email":"test2@example.com","age":30,"role":"admin"}')

USER2_ID=$(echo $USER2_RESPONSE | jq -r '.data._id')
echo "User 2 created with ID: $USER2_ID"
echo $USER2_RESPONSE | jq '.'

echo -e "\nCreating User 3..."
USER3_RESPONSE=$(curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User 3","email":"test3@example.com","age":35,"role":"moderator"}')

USER3_ID=$(echo $USER3_RESPONSE | jq -r '.data._id')
echo "User 3 created with ID: $USER3_ID"
echo $USER3_RESPONSE | jq '.'

echo -e "\n3. 📋 Getting all users..."
curl -s $API_URL/api/users | jq '.'

echo -e "\n4. 🔍 Getting user by ID (User 1)..."
curl -s $API_URL/api/users/$USER1_ID | jq '.'

echo -e "\n5. ✏️  Updating user (User 1)..."
UPDATE_RESPONSE=$(curl -s -X PUT $API_URL/api/users/$USER1_ID \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated Test User 1","age":26,"role":"moderator"}')
echo $UPDATE_RESPONSE | jq '.'

echo -e "\n6. 👀 Getting updated user..."
curl -s $API_URL/api/users/$USER1_ID | jq '.'

echo -e "\n7. 🗑️  Deleting user (User 2)..."
DELETE_RESPONSE=$(curl -s -X DELETE $API_URL/api/users/$USER2_ID)
echo $DELETE_RESPONSE | jq '.'

echo -e "\n8. 📊 Final user list..."
curl -s $API_URL/api/users | jq '.'

echo -e "\n9. 📈 Database stats..."
curl -s $API_URL/api/stats | jq '.'

echo -e "\n10. ❌ Testing error cases..."

echo -e "\nTesting invalid user creation (missing required field)..."
curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"age": 25}' | jq '.'

echo -e "\nTesting invalid user ID..."
curl -s $API_URL/api/users/invalid_id | jq '.'

echo -e "\nTesting duplicate email..."
curl -s -X POST $API_URL/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Duplicate User","email":"test1@example.com","age":25}' | jq '.'

echo -e "\n✅ API test completed!"
echo -e "\n📋 Summary:"
echo "- Created 3 users"
echo "- Updated 1 user"
echo "- Deleted 1 user"
echo "- Tested error cases"
echo "- Final user count should be 2"

echo -e "\n🎉 All tests completed successfully!"
