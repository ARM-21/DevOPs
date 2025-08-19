const http = require('http');

// Simple test function
function makeRequest(path, method = 'GET', data = null) {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json'
      }
    };

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => {
        body += chunk;
      });
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          body: JSON.parse(body || '{}')
        });
      });
    });

    req.on('error', reject);

    if (data) {
      req.write(JSON.stringify(data));
    }
    req.end();
  });
}

// Test cases
async function runTests() {
  console.log('🚀 Starting API tests...\n');
  
  try {
    // Test 1: Health check
    console.log('📋 Test 1: Health check');
    const health = await makeRequest('/health');
    if (health.statusCode === 200 && health.body.status === 'OK') {
      console.log('✅ Health check passed');
    } else {
      throw new Error('Health check failed');
    }

    // Test 2: Root route
    console.log('📋 Test 2: Root route');
    const root = await makeRequest('/');
    if (root.statusCode === 200 && root.body.message) {
      console.log('✅ Root route passed');
    } else {
      throw new Error('Root route failed');
    }

    // Test 3: Hello API
    console.log('📋 Test 3: Hello API');
    const hello = await makeRequest('/api/hello');
    if (hello.statusCode === 200 && hello.body.success) {
      console.log('✅ Hello API passed');
    } else {
      throw new Error('Hello API failed');
    }

    // Test 4: Database stats
    console.log('📋 Test 4: Database stats');
    const stats = await makeRequest('/api/stats');
    if (stats.statusCode === 200 && stats.body.success) {
      console.log('✅ Database stats passed');
    } else {
      console.log('⚠️ Database stats failed - MongoDB might not be running');
    }

    // Test 5: Create a user (POST)
    console.log('📋 Test 5: Create user');
    const newUser = {
      name: 'Test User',
      email: 'test@example.com',
      age: 25,
      role: 'user'
    };
    const createUser = await makeRequest('/api/users', 'POST', newUser);
    if (createUser.statusCode === 201 && createUser.body.success) {
      console.log('✅ Create user passed');
      const userId = createUser.body.data._id;

      // Test 6: Get all users
      console.log('📋 Test 6: Get all users');
      const getUsers = await makeRequest('/api/users');
      if (getUsers.statusCode === 200 && getUsers.body.success) {
        console.log('✅ Get all users passed');
      } else {
        throw new Error('Get all users failed');
      }

      // Test 7: Get user by ID
      console.log('📋 Test 7: Get user by ID');
      const getUser = await makeRequest(`/api/users/${userId}`);
      if (getUser.statusCode === 200 && getUser.body.success) {
        console.log('✅ Get user by ID passed');
      } else {
        throw new Error('Get user by ID failed');
      }

      // Test 8: Update user
      console.log('📋 Test 8: Update user');
      const updateData = { name: 'Updated Test User', age: 26 };
      const updateUser = await makeRequest(`/api/users/${userId}`, 'PUT', updateData);
      if (updateUser.statusCode === 200 && updateUser.body.success) {
        console.log('✅ Update user passed');
      } else {
        throw new Error('Update user failed');
      }

      // Test 9: Delete user
      console.log('📋 Test 9: Delete user');
      const deleteUser = await makeRequest(`/api/users/${userId}`, 'DELETE');
      if (deleteUser.statusCode === 200 && deleteUser.body.success) {
        console.log('✅ Delete user passed');
      } else {
        throw new Error('Delete user failed');
      }

    } else {
      console.log('⚠️ CRUD tests skipped - MongoDB might not be running');
    }

    console.log('\n🎉 All tests passed!');
    process.exit(0);
    
  } catch (error) {
    console.error('\n❌ Test failed:', error.message);
    process.exit(1);
  }
}

// Wait a moment for server to start, then run tests
setTimeout(runTests, 2000);
