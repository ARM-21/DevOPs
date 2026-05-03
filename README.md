# DevOps API with MongoDB CRUD Operations

A comprehensive DevOps learning project demonstrating continuous integration, continuous deployment, and containerization practices. This project features a production-ready Express.js API with MongoDB integration, complete with Docker containerization, Jenkins CI/CD pipeline, automated testing, and pre-commit hooks.

---

## 📋 Project Overview

This DevOps project serves as a practical learning resource for implementing modern DevOps practices including continuous integration, continuous deployment, containerization, and infrastructure automation. The project includes a fully functional Express.js API with MongoDB CRUD operations, complete Docker setup with Docker Compose, Jenkins pipeline configuration for automated builds and deployments, comprehensive testing suites, and pre-commit hooks for code quality assurance.

The project demonstrates enterprise-level DevOps practices suitable for production environments, including automated testing, containerization, CI/CD pipeline configuration, database management, and deployment automation. It provides hands-on experience with industry-standard tools and practices used in modern software development.

---

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| **Backend Framework** | Express.js (Node.js) |
| **Database** | MongoDB |
| **Containerization** | Docker & Docker Compose |
| **CI/CD Pipeline** | Jenkins |
| **Testing Framework** | Jest / Mocha |
| **Version Control** | Git |
| **Pre-commit Hooks** | Husky |
| **Code Quality** | ESLint, Prettier |
| **Scripting** | Bash Shell Scripts |
| **License** | MIT |

---

## ✨ Core Features

### Express.js API with CRUD Operations

The application provides a comprehensive RESTful API built with Express.js featuring complete CRUD (Create, Read, Update, Delete) operations for user management. The API includes well-defined endpoints for retrieving all users, creating new users, fetching individual users by ID, updating user information, and deleting users. Each endpoint implements proper error handling, validation, and response formatting. The API follows REST conventions with appropriate HTTP methods and status codes.

### MongoDB Integration

The project demonstrates professional MongoDB integration with connection pooling, error handling, and data persistence. The database schema includes user models with fields for name, email, age, and role with appropriate validation and constraints. The project includes database connection management with automatic reconnection logic and connection status monitoring. Database operations are optimized with proper indexing on frequently queried fields.

### Docker Containerization

The project includes complete Docker setup with a Dockerfile for containerizing the Node.js application and docker-compose.yml for orchestrating multi-container environments. The Docker configuration includes MongoDB service setup with persistent volumes, environment variable configuration, port mapping, and network isolation. The containerized setup enables consistent development, testing, and production environments.

### Jenkins CI/CD Pipeline

A comprehensive Jenkinsfile defines the complete CI/CD pipeline with multiple stages including source code checkout, dependency installation, code quality analysis, automated testing, Docker image building, and deployment automation. The pipeline implements security scanning, artifact management, and deployment verification. The Jenkins configuration demonstrates best practices for automated build and deployment workflows.

### Automated Testing

The project includes comprehensive test suites using Jest or Mocha testing frameworks. Tests cover API endpoint functionality, database operations, error handling, and edge cases. The testing suite includes unit tests for individual functions, integration tests for API endpoints, and end-to-end tests for complete workflows. Automated tests run as part of the CI/CD pipeline ensuring code quality.

### Pre-commit Hooks

Husky pre-commit hooks enforce code quality standards before commits. The hooks run linting checks with ESLint, code formatting with Prettier, and automated tests. Pre-commit hooks prevent commits with code quality issues, maintaining repository standards and reducing CI/CD failures.

### Health Checks and Monitoring

The API includes health check endpoints for monitoring application status and database connectivity. The `/health` endpoint provides quick status verification for load balancers and monitoring systems. Database statistics endpoints provide insights into connection status and operation metrics.

### API Documentation

Comprehensive API documentation includes endpoint specifications, request/response formats, example curl commands, and testing procedures. The documentation covers all available endpoints, required parameters, response schemas, and error handling.

---

## 📁 Project Structure

```
DevOPs/
├── .github/
│   └── workflows/              # GitHub Actions workflows (optional)
├── app.js                      # Main Express.js application
├── test.js                     # Test suite (Jest/Mocha)
├── package.json                # Node.js dependencies and scripts
├── package-lock.json           # Dependency lock file
├── dockerfile                  # Docker image configuration
├── docker-compose.yml          # Multi-container Docker setup
├── Jenkinsfile                 # Jenkins CI/CD pipeline configuration
├── .dockerignore                # Docker build exclusions
├── .gitignore                  # Git exclusions
├── run.sh                      # Application startup script
├── setup-and-run.sh            # Automated setup and run script
├── test-api.sh                 # API testing script
├── Continous-Integration.md    # CI/CD documentation
├── docker_Notes.md             # Docker setup and usage notes
├── pre-commit-hook.md          # Pre-commit hook configuration
├── api-test-examples.md        # Comprehensive API testing examples
└── README.md                   # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

Before setting up the project, ensure you have the following installed:

- **Node.js** (version 14.0 or higher) - Download from [nodejs.org](https://nodejs.org/)
- **npm** (comes with Node.js)
- **Docker** (version 20.0 or higher) - Download from [docker.com](https://www.docker.com/products/docker-desktop)
- **Docker Compose** (version 1.29 or higher)
- **Git** (for version control)
- **MongoDB** (optional, if running without Docker)

### Installation Steps

**Step 1: Clone the Repository**

```bash
git clone https://github.com/ARM-21/DevOPs.git
cd DevOPs
```

**Step 2: Automated Setup (Recommended)**

The easiest way to get started is using the automated setup script:

```bash
chmod +x setup-and-run.sh
./setup-and-run.sh
```

This script will:
- Start MongoDB with Docker
- Install Node.js dependencies
- Start the Express.js API
- Run the test suite

**Step 3: Manual Setup**

If you prefer manual setup, follow these steps:

**Start MongoDB with Docker:**

```bash
docker run -d \
  --name devops_mongodb \
  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=admin \
  -e MONGO_INITDB_DATABASE=devops_db \
  mongo:latest
```

**Install Dependencies:**

```bash
npm install
```

**Start the API:**

```bash
npm start
```

The API will be available at `http://localhost:3000`

**Step 4: Using Docker Compose**

For a complete containerized setup:

```bash
docker-compose up -d
```

This will start both MongoDB and the Express.js API in containers.

**Step 5: Verify Installation**

Test the API health check:

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "success": true,
  "message": "API is running",
  "timestamp": "2026-01-15T10:30:00Z"
}
```

---

## 📋 API Endpoints

### General Endpoints

| Method | Endpoint | Description | Response |
|--------|----------|-------------|----------|
| GET | `/` | API information and available endpoints | API metadata |
| GET | `/health` | Health check for monitoring and CI/CD | Status and timestamp |
| GET | `/api/stats` | Database connection statistics | Connection info |

### User Management Endpoints

| Method | Endpoint | Description | Request Body |
|--------|----------|-------------|--------------|
| GET | `/api/users` | Retrieve all users | N/A |
| POST | `/api/users` | Create a new user | `{name, email, age, role}` |
| GET | `/api/users/:id` | Retrieve user by ID | N/A |
| PUT | `/api/users/:id` | Update user by ID | `{name, email, age, role}` |
| DELETE | `/api/users/:id` | Delete user by ID | N/A |

---

## 🧪 Testing

### Automated Testing

Run the complete test suite:

```bash
npm test
```

This will execute all unit tests, integration tests, and generate a coverage report.

### Manual API Testing

**Create a User:**

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

**Get All Users:**

```bash
curl http://localhost:3000/api/users
```

**Get User by ID:**

```bash
curl http://localhost:3000/api/users/USER_ID
```

**Update User:**

```bash
curl -X PUT http://localhost:3000/api/users/USER_ID \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Smith",
    "age": 31
  }'
```

**Delete User:**

```bash
curl -X DELETE http://localhost:3000/api/users/USER_ID
```

### Automated Testing Script

Run the provided testing script:

```bash
chmod +x test-api.sh
./test-api.sh
```

---

## 📊 Data Schema

### User Model

```javascript
{
  _id: ObjectId,                    // MongoDB ObjectId
  name: String (required),          // User's full name
  email: String (required, unique), // User's email address
  age: Number,                      // User's age
  role: String (enum: ['user', 'admin', 'moderator']), // User role
  createdAt: Date,                  // Creation timestamp
  updatedAt: Date                   // Last update timestamp
}
```

### Response Format

All API responses follow a consistent format:

```json
{
  "success": true,
  "message": "Operation description",
  "data": {
    // Response data (for successful operations)
  },
  "error": "Error message" // Only present on errors
}
```

---

## 🐳 Docker Setup

### Docker Compose

The docker-compose.yml file orchestrates both MongoDB and the Express.js API:

```bash
docker-compose up -d
```

Services included:
- **MongoDB**: Database service with persistent volume
- **API**: Express.js application

### Building Docker Image

Build a custom Docker image:

```bash
docker build -t devops-api:latest .
```

Run the image:

```bash
docker run -d \
  -p 3000:3000 \
  -e MONGO_URI=mongodb://admin:admin@mongo:27017/devops_db \
  --name devops-api \
  devops-api:latest
```

### Docker Configuration

**MongoDB Connection:**
- URI: `mongodb://admin:admin@localhost:27017/devops_db?authSource=admin`
- Username: `admin`
- Password: `admin`
- Database: `devops_db`
- Port: `27017`

**API Configuration:**
- Port: `3000` (configurable via PORT environment variable)
- Host: `0.0.0.0` (accessible from all interfaces)

---

## 🔄 CI/CD Pipeline with Jenkins

### Jenkinsfile Stages

The Jenkins pipeline includes the following stages:

1. **Checkout**: Clone the repository
2. **Install Dependencies**: Run `npm install`
3. **Lint**: Code quality analysis with ESLint
4. **Test**: Run automated test suite
5. **Build**: Create Docker image
6. **Push**: Push image to registry
7. **Deploy**: Deploy to target environment
8. **Verify**: Run smoke tests

### Running Jenkins Pipeline

1. Create a new Jenkins job
2. Configure Git repository URL
3. Set pipeline script from repository (Jenkinsfile)
4. Configure webhook for automatic triggering
5. Run the pipeline

---

## 🔐 Security Features

The project implements several security best practices:

- **Environment Variables**: Sensitive credentials stored in environment variables
- **Input Validation**: Request validation and sanitization
- **Error Handling**: Comprehensive error handling without exposing sensitive information
- **Database Security**: MongoDB authentication with username and password
- **Docker Security**: Non-root user execution in containers
- **Pre-commit Hooks**: Code quality enforcement before commits
- **Health Checks**: Monitoring and alerting capabilities

---

## 📝 Configuration

### Environment Variables

```bash
# MongoDB Configuration
MONGO_URI=mongodb://admin:admin@localhost:27017/devops_db?authSource=admin
MONGO_USERNAME=admin
MONGO_PASSWORD=admin
MONGO_DATABASE=devops_db

# API Configuration
PORT=3000
NODE_ENV=development

# Docker Configuration
COMPOSE_PROJECT_NAME=devops
```

---

## 🤝 Contributing

We welcome contributions from the community. To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeatureName`)
3. Commit your changes (`git commit -m 'Add YourFeatureName'`)
4. Push to the branch (`git push origin feature/YourFeatureName`)
5. Open a Pull Request with a clear description of your changes

---

## 🚨 Troubleshooting

### MongoDB Connection Error

**Problem**: Cannot connect to MongoDB
**Solution**: 
- Ensure MongoDB is running: `docker ps | grep mongo`
- Check credentials in connection string
- Verify port 27017 is accessible

### Port Already in Use

**Problem**: Port 3000 is already in use
**Solution**: 
```bash
# Change port via environment variable
PORT=3001 npm start

# Or kill the process using port 3000
lsof -ti:3000 | xargs kill -9
```

### Docker Issues

**Problem**: Docker daemon not running
**Solution**: 
- Start Docker Desktop or Docker daemon
- Ensure you have sufficient permissions
- Check Docker installation

### Test Failures

**Problem**: Tests are failing
**Solution**:
- Ensure MongoDB is running
- Check database credentials
- Run `npm install` to update dependencies
- Check logs: `npm test -- --verbose`

---

## 📚 Additional Resources

### Documentation Files
- [Continuous Integration Guide](Continous-Integration.md) - CI/CD setup and configuration
- [Docker Notes](docker_Notes.md) - Docker setup and troubleshooting
- [Pre-commit Hooks Guide](pre-commit-hook.md) - Git hooks configuration
- [API Testing Examples](api-test-examples.md) - Comprehensive API testing guide

### External Resources
- [Express.js Documentation](https://expressjs.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Node.js Best Practices](https://nodejs.org/en/docs/guides/)

---

## 👨‍💻 Developer

**Manoj Neupane** - Project Lead & DevOps Implementation

---

## 📄 License

This project is licensed under the **MIT License**. You are free to use, modify, and distribute this software for personal and commercial purposes. See the LICENSE file for complete license terms.

**Copyright © 2026** Manoj Neupane

---

## 📞 Support & Contact

For questions, bug reports, or feature requests:

1. Open an issue on the GitHub repository
2. Contact the project maintainer directly
3. Check the documentation files for common questions

---

## 🎯 Learning Outcomes

By working with this project, you will learn:

- **Docker**: Containerization and container orchestration
- **Docker Compose**: Multi-container application setup
- **Jenkins**: CI/CD pipeline configuration and automation
- **MongoDB**: NoSQL database design and operations
- **Express.js**: RESTful API development
- **Testing**: Automated testing frameworks and practices
- **Git Hooks**: Pre-commit hooks for code quality
- **Bash Scripting**: Automation script development
- **DevOps Practices**: Industry-standard DevOps workflows
- **Infrastructure as Code**: Configuration management

---

## 🎯 Future Enhancements

Planned features and improvements:

- Kubernetes deployment configuration
- Prometheus monitoring and metrics
- ELK Stack integration for logging
- Advanced authentication (JWT, OAuth)
- API rate limiting and throttling
- Database backup and recovery procedures
- Multi-environment configuration
- Terraform infrastructure setup
- Ansible playbooks for deployment
- GitLab CI/CD pipeline configuration

---

**Last Updated**: January 2026  
**Version**: 1.0.0  
**Status**: Active Development  
**Repository**: [GitHub - ARM-21/DevOPs](https://github.com/ARM-21/DevOPs)
