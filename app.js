const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware for parsing JSON
app.use(express.json());

// Health check route - essential for CI/CD
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    message: 'Service is healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Root route
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to DevOps Learning API',
    version: '1.0.0',
    endpoints: [
      'GET /',
      'GET /health',
      'GET /api/hello'
    ]
  });
});

// Simple hello route for testing
app.get('/api/hello', (req, res) => {
  res.json({
    message: 'Hello, DevOps World!',
    timestamp: new Date().toISOString(),
    success: true
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Something went wrong!',
    error: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Start server
const server = app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Health check available at: http://localhost:${PORT}/health`);
});

// Export for testing
module.exports = app;