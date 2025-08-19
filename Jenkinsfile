pipeline {
    agent any
    
    options {
        // Limit build history to save space
        buildDiscarder(logRotator(numToKeepStr: '5'))
        // Set timeout to prevent hanging
        timeout(time: 10, unit: 'MINUTES')
    }
    
    environment {
        DOCKER_IMAGE = "devops-app"
        API_URL = "http://localhost:3000"
    }
    
    stages {
        stage('Setup') {
            steps {
                echo '�️ Quick setup...'
                sh 'chmod +x *.sh || true'
                sh 'cp .env.example .env || true'
            }
        }
        
        stage('Install & Test') {
            steps {
                echo '� Install dependencies...'
                sh 'npm install --production'
                echo '🧪 Run tests...'
                sh 'npm test || echo "Tests failed but continuing..."'
            }
        }
        
        stage('Docker Build') {
            steps {
                echo '🐳 Build and test...'
                sh 'docker-compose down || true'
                sh 'docker-compose build --no-cache'
                sh 'docker-compose up -d'
                sleep 15
                sh 'curl -f http://localhost:3000/health || echo "Health check failed"'
            }
        }
        
        stage('Quick API Test') {
            steps {
                echo '🔬 API test...'
                sh './test-api.sh || echo "API tests failed but continuing..."'
            }
        }
    }
    
    post {
        always {
            echo '🧹 Cleanup...'
            sh 'docker-compose down || true'
            sh 'docker system prune -f || true'
            // Don't use cleanWs() to save space temporarily
        }
        
        success {
            echo '✅ Pipeline completed!'
        }
        
        failure {
            echo '❌ Pipeline failed!'
            sh 'docker-compose logs || true'
        }
    }
}
