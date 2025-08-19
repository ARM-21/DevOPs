pipeline {
    agent any
    
    environment {
        // Define environment variables
        DOCKER_IMAGE = "devops-app"
        COMPOSE_PROJECT_NAME = "devops"
        API_URL = "http://localhost:3000"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Checking out source code...'
                checkout scm
            }
        }
        
        stage('Environment Setup') {
            steps {
                echo '🛠️ Setting up environment...'
                script {
                    // Make shell scripts executable
                    sh 'chmod +x run.sh'
                    sh 'chmod +x test-api.sh'
                    sh 'chmod +x setup-and-run.sh'
                    
                    // Create environment file for Jenkins if not exists
                    sh '''
                        if [ ! -f .env ]; then
                            echo "Creating environment file for Jenkins build..."
                            cp .env.example .env
                        fi
                    '''
                    
                    // Install jq if not present (for API testing)
                    sh '''
                        if ! command -v jq &> /dev/null; then
                            echo "Installing jq for JSON processing..."
                            apt-get update && apt-get install -y jq
                        fi
                    '''
                }
            }
        }
        
        stage('Dependency Check') {
            steps {
                echo '📦 Checking dependencies...'
                sh 'node --version'
                sh 'npm --version'
                sh 'docker --version'
                sh 'docker-compose --version'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo '📥 Installing Node.js dependencies...'
                sh 'npm install'
            }
        }
        
        stage('Lint & Code Quality') {
            steps {
                echo '🔍 Running code quality checks...'
                script {
                    // Run any linting if configured
                    sh 'npm run build || echo "No build script found"'
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                echo '🧪 Running unit tests...'
                sh 'npm test'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                echo '🐳 Building Docker images...'
                script {
                    // Build the application image
                    sh 'docker-compose build'
                }
            }
        }
        
        stage('Start Services') {
            steps {
                echo '🚀 Starting services with Docker Compose...'
                script {
                    // Stop any existing containers and start fresh
                    sh 'docker-compose down || true'
                    sh 'docker-compose up -d'
                    
                    // Wait for services to be ready
                    sleep(time: 30, unit: 'SECONDS')
                    
                    // Check if services are running
                    sh 'docker-compose ps'
                }
            }
        }
        
        stage('Health Check') {
            steps {
                echo '🏥 Performing health checks...'
                script {
                    // Wait for API to be ready and perform health check
                    timeout(time: 2, unit: 'MINUTES') {
                        waitUntil {
                            script {
                                def result = sh(
                                    script: 'curl -s http://localhost:3000/health',
                                    returnStatus: true
                                )
                                return result == 0
                            }
                        }
                    }
                    echo '✅ Health check passed!'
                }
            }
        }
        
        stage('Integration Tests') {
            steps {
                echo '🔬 Running integration tests...'
                script {
                    // Run API tests
                    sh './test-api.sh'
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                echo '🛡️ Running security scans...'
                script {
                    // Run security scans on Docker images
                    sh '''
                        echo "Checking for vulnerabilities..."
                        # You can add tools like Trivy, Snyk, or other security scanners here
                        # docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image devops_app || true
                    '''
                }
            }
        }
        
        stage('Performance Tests') {
            steps {
                echo '⚡ Running performance tests...'
                script {
                    // Basic performance test using curl
                    sh '''
                        echo "Running basic performance test..."
                        for i in {1..10}; do
                            curl -s -w "Response time: %{time_total}s\\n" http://localhost:3000/health > /dev/null
                        done
                    '''
                }
            }
        }
        
        stage('Collect Logs') {
            steps {
                echo '📋 Collecting application logs...'
                script {
                    sh 'docker-compose logs app > app-logs.txt || true'
                    sh 'docker-compose logs mongodb > mongodb-logs.txt || true'
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                echo '🚢 Deploying to staging environment...'
                script {
                    // Add staging deployment logic here
                    echo 'Staging deployment would happen here'
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo '🚀 Deploying to production environment...'
                script {
                    // Add production deployment logic here
                    echo 'Production deployment would happen here'
                    // You might want to tag the Docker image and push to registry
                    // sh 'docker tag devops_app:latest your-registry/devops_app:${BUILD_NUMBER}'
                    // sh 'docker push your-registry/devops_app:${BUILD_NUMBER}'
                }
            }
        }
    }
    
    post {
        always {
            echo '🧹 Cleaning up...'
            script {
                // Clean up containers and networks
                sh 'docker-compose down || true'
                sh 'docker system prune -f || true'
                
                // Archive logs
                archiveArtifacts artifacts: '*.txt', allowEmptyArchive: true
                
                // Clean workspace
                cleanWs()
            }
        }
        
        success {
            echo '✅ Pipeline completed successfully!'
            script {
                // Send success notifications
                // You can add Slack, email, or other notifications here
                echo 'Success notifications would go here'
            }
        }
        
        failure {
            echo '❌ Pipeline failed!'
            script {
                // Collect failure logs
                sh 'docker-compose logs || true'
                
                // Send failure notifications
                // You can add Slack, email, or other notifications here
                echo 'Failure notifications would go here'
            }
        }
        
        unstable {
            echo '⚠️ Pipeline completed with warnings!'
        }
    }
}
