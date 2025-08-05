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

    console.log('\n🎉 All tests passed!');
    process.exit(0);
    
  } catch (error) {
    console.error('\n❌ Test failed:', error.message);
    process.exit(1);
  }
}

// Wait a moment for server to start, then run tests
setTimeout(runTests, 2000);
