# 🐳 Docker Notes – From Basic to Advanced

## Table of Contents
1. [Introduction & Basics](#1-introduction--basics)
2. [Core Concepts](#2-core-concepts)
3. [Basic Commands](#3-basic-commands)
4. [Volumes & Data Management](#4-volumes--data-management)
5. [Networking](#5-networking)
6. [Dockerfile (Image Building)](#6-dockerfile-image-building)
7. [Docker Compose](#7-docker-compose)
8. [Advanced Networking](#8-advanced-networking)
9. [Security & Best Practices](#9-security--best-practices)
10. [Orchestration](#10-orchestration)
11. [Docker in Production](#11-docker-in-production)
12. [Troubleshooting & Debugging](#12-troubleshooting--debugging)

---

## 1. Introduction & Basics

### What is Docker?

Docker is a containerization platform that packages applications and their dependencies into lightweight, portable containers. It enables consistent deployment across different environments.

#### Containerization vs Virtualization

| Aspect | Virtualization | Containerization |
|--------|----------------|------------------|
| **Resource Usage** | Heavy (includes full OS) | Lightweight (shares host kernel) |
| **Startup Time** | Minutes | Seconds |
| **Isolation** | Complete isolation | Process-level isolation |
| **Size** | GBs | MBs |
| **Performance** | Higher overhead | Near-native performance |

### Docker Architecture

```
┌─────────────────┐    ┌──────────────────────────────────┐
│   Docker CLI    │────│         Docker Daemon           │
│                 │    │  ┌─────────────┐ ┌─────────────┐ │
│ docker run      │    │  │   Images    │ │ Containers  │ │
│ docker build    │    │  │             │ │             │ │
│ docker pull     │    │  └─────────────┘ └─────────────┘ │
└─────────────────┘    └──────────────────────────────────┘
                                     │
                                     ▼
                       ┌──────────────────────────────────┐
                       │        Docker Registry          │
                       │         (Docker Hub)            │
                       └──────────────────────────────────┘
```

**Components:**
- **Client**: CLI/REST API interface
- **Daemon (dockerd)**: Background service managing containers
- **Images**: Read-only templates
- **Containers**: Running instances
- **Registry**: Storage for Docker images (Docker Hub)

### Installing Docker

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (avoid sudo)
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker run hello-world
```

---

## 2. Core Concepts

### Images
- **Definition**: Read-only templates used to create containers
- **Layers**: Built using copy-on-write mechanism
- **Storage**: Stored in Docker registry (Docker Hub, private registries)
- **Immutable**: Once created, cannot be changed

### Containers
- **Definition**: Running instances of Docker images
- **Stateful**: Can be started, stopped, moved, and deleted
- **Isolated**: Have their own filesystem, network, and process space
- **Ephemeral**: Data is lost when container is removed (unless using volumes)

### Layers & UnionFS
```
┌─────────────────┐ ← Container Layer (R/W)
├─────────────────┤
│   App Layer     │ ← Your application
├─────────────────┤
│  Runtime Layer  │ ← Node.js, Python, etc.
├─────────────────┤
│   OS Layer      │ ← Ubuntu, Alpine, etc.
└─────────────────┘ ← Base Layer
```

- **Copy-on-Write**: Modified files are copied to container layer
- **Space Efficient**: Multiple containers can share same base layers
- **Fast**: Only changed layers need to be downloaded/uploaded

### Docker Hub / Registries
- **Public Registry**: Docker Hub (hub.docker.com)
- **Private Registries**: AWS ECR, Google GCR, Azure ACR
- **Image Naming**: `[registry]/[namespace]/[repository]:[tag]`

---

## 3. Basic Commands

### Container Management
```bash
# Run a container
docker run nginx                    # Run nginx
docker run -d nginx                 # Run in detached mode
docker run -p 8080:80 nginx         # Port mapping
docker run --name my-nginx nginx    # Custom name

# List containers
docker ps                           # Running containers
docker ps -a                        # All containers (including stopped)

# Stop and remove containers
docker stop <container_id>          # Stop container
docker kill <container_id>          # Force stop
docker rm <container_id>            # Remove container
docker rm -f <container_id>         # Force remove running container
```

### Image Management
```bash
# List images
docker images
docker image ls

# Pull images
docker pull ubuntu:20.04
docker pull nginx:alpine

# Remove images
docker rmi <image_id>
docker rmi nginx:alpine

# Push images (after login)
docker login
docker push username/my-app:latest
```

### Interactive Mode
```bash
# Interactive terminal
docker run -it ubuntu bash          # Ubuntu with bash
docker run -it alpine sh            # Alpine with sh
docker run -it python:3.9 python   # Python REPL

# Execute commands in running container
docker exec -it <container_id> bash
docker exec -it <container_name> sh
docker exec <container_id> ls /app  # Non-interactive
```

### Useful Flags
```bash
# Common flags
-d, --detach          # Run in background
-it                   # Interactive + TTY
-p, --publish         # Port mapping
--name                # Container name
-v, --volume          # Volume mounting
-e, --env             # Environment variables
--rm                  # Auto-remove when stopped
```

---

## 4. Volumes & Data Management

### The Problem: Ephemeral Containers
```bash
# Data is lost when container is removed
docker run --name temp-db mysql:8.0
docker rm temp-db  # All database data is lost!
```

### Types of Mounts

#### 1. Named Volumes (Recommended)
```bash
# Create named volume
docker volume create my-data

# Use named volume
docker run -v my-data:/var/lib/mysql mysql:8.0

# List volumes
docker volume ls

# Inspect volume
docker volume inspect my-data

# Remove volume
docker volume rm my-data
```

#### 2. Bind Mounts
```bash
# Mount host directory to container
docker run -v /host/path:/container/path nginx
docker run -v $(pwd)/app:/usr/share/nginx/html nginx

# Mount single file
docker run -v /host/config.conf:/etc/app/config.conf app
```

#### 3. tmpfs Mounts (In-Memory)
```bash
# Store data in RAM (lost on container stop)
docker run --tmpfs /tmp nginx
```

### Volume Commands
```bash
# Volume management
docker volume create vol-name       # Create volume
docker volume ls                    # List volumes
docker volume inspect vol-name      # Volume details
docker volume rm vol-name           # Remove volume
docker volume prune                 # Remove unused volumes
```

### Practical Examples
```bash
# Persistent MySQL database
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=secret \
  -v mysql-data:/var/lib/mysql \
  mysql:8.0

# Development with live reload
docker run -d \
  --name web-dev \
  -p 3000:3000 \
  -v $(pwd):/app \
  -w /app \
  node:16 npm start
```

---

## 5. Networking

### Default Network Types

#### 1. Bridge (Default)
```bash
# Default bridge network
docker run nginx  # Automatically uses bridge network

# Containers can communicate via IP
docker network inspect bridge
```

#### 2. Host
```bash
# Use host's network stack
docker run --network host nginx
# Container uses host's IP directly
```

#### 3. None
```bash
# No network access
docker run --network none alpine
```

### Custom Bridge Networks
```bash
# Create custom network
docker network create my-network

# Run containers on custom network
docker run -d --name app1 --network my-network nginx
docker run -d --name app2 --network my-network alpine

# Containers can communicate by name
docker exec app2 ping app1  # Works!
```

### Port Mapping
```bash
# Basic port mapping
docker run -p 8080:80 nginx          # Host:Container
docker run -p 127.0.0.1:8080:80 nginx # Bind to specific IP
docker run -P nginx                   # Auto-map exposed ports

# Multiple ports
docker run -p 8080:80 -p 8443:443 nginx

# UDP ports
docker run -p 53:53/udp bind9
```

### Network Commands
```bash
# Network management
docker network ls                     # List networks
docker network create net-name       # Create network
docker network inspect net-name      # Network details
docker network rm net-name           # Remove network

# Connect/disconnect containers
docker network connect net-name container-name
docker network disconnect net-name container-name
```

### Docker & NAT Explained
```
Host Machine (192.168.1.100)
├── Docker Bridge (172.17.0.1)
│   ├── Container 1 (172.17.0.2:80)
│   └── Container 2 (172.17.0.3:3000)
│
└── Port Mapping via iptables
    ├── 192.168.1.100:8080 → 172.17.0.2:80
    └── 192.168.1.100:3000 → 172.17.0.3:3000
```

---

## 6. Dockerfile (Image Building)

### Basic Dockerfile Structure
```dockerfile
# Use official base image
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Set default command
CMD ["npm", "start"]
```

### Dockerfile Instructions

#### FROM
```dockerfile
FROM ubuntu:20.04              # Specific version
FROM node:16-alpine           # Lightweight Alpine Linux
FROM scratch                  # Empty base image
```

#### RUN
```dockerfile
# Single command
RUN apt-get update

# Multiple commands (reduces layers)
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

#### COPY vs ADD
```dockerfile
# COPY (preferred for simple file copying)
COPY src/ /app/src/
COPY package.json /app/

# ADD (has extra features)
ADD https://example.com/file.tar.gz /app/  # Download from URL
ADD archive.tar.gz /app/                   # Auto-extract
```

#### WORKDIR
```dockerfile
WORKDIR /app              # Set working directory
WORKDIR /app/src          # Relative to previous WORKDIR
```

#### ENV
```dockerfile
ENV NODE_ENV=production
ENV PORT=3000
ENV API_URL=https://api.example.com
```

#### ARG
```dockerfile
ARG NODE_VERSION=16
FROM node:${NODE_VERSION}-alpine

ARG BUILD_DATE
LABEL build-date=${BUILD_DATE}
```

#### EXPOSE
```dockerfile
EXPOSE 3000               # Document which port the app uses
EXPOSE 80 443             # Multiple ports
EXPOSE 8080/tcp 9090/udp  # Specify protocol
```

#### CMD vs ENTRYPOINT
```dockerfile
# CMD - can be overridden
CMD ["npm", "start"]
CMD npm start             # Shell form

# ENTRYPOINT - always executed
ENTRYPOINT ["docker-entrypoint.sh"]
ENTRYPOINT docker-entrypoint.sh

# Combined usage
ENTRYPOINT ["npm"]
CMD ["start"]             # Default argument
# docker run image test   → npm test
```

### Multi-Stage Builds
```dockerfile
# Build stage
FROM node:16-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine AS production
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Best Practices

#### 1. Use Small Base Images
```dockerfile
# Bad (large)
FROM ubuntu:20.04

# Good (smaller)
FROM node:16-alpine

# Better (minimal)
FROM node:16-alpine AS build
# ... build steps ...
FROM alpine:3.15
COPY --from=build /app/dist /app
```

#### 2. Leverage Build Cache
```dockerfile
# Copy dependencies first (changes less frequently)
COPY package*.json ./
RUN npm ci

# Copy source code last (changes frequently)
COPY . .
```

#### 3. Minimize Layers
```dockerfile
# Bad (multiple layers)
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get clean

# Good (single layer)
RUN apt-get update && \
    apt-get install -y curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

#### 4. Use .dockerignore
```bash
# .dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
coverage
.nyc_output
```

### Building Images
```bash
# Basic build
docker build -t my-app .

# Build with tag
docker build -t my-app:v1.0 .

# Build with build args
docker build --build-arg NODE_VERSION=14 -t my-app .

# Build specific stage
docker build --target production -t my-app:prod .

# Build with different Dockerfile
docker build -f Dockerfile.dev -t my-app:dev .
```

---

## 7. Docker Compose

### Why Docker Compose?
- **Multi-container applications**: Define and run multiple services
- **Simplified networking**: Services can communicate by name
- **Environment management**: Different configs for dev/prod
- **One-command deployment**: `docker-compose up`

### Basic docker-compose.yml Structure
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    volumes:
      - .:/app
      - /app/node_modules
    depends_on:
      - db
      - redis

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:

networks:
  default:
    driver: bridge
```

### Complete Example: Node.js + MongoDB Stack
```yaml
version: '3.8'

services:
  # Frontend React App
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:5000
    volumes:
      - ./frontend:/app
      - /app/node_modules
    depends_on:
      - backend

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=development
      - MONGO_URI=mongodb://mongo:27017/myapp
      - JWT_SECRET=mysecret
    volumes:
      - ./backend:/app
      - /app/node_modules
    depends_on:
      - mongo
      - redis

  # MongoDB Database
  mongo:
    image: mongo:5.0
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
      - MONGO_INITDB_DATABASE=myapp
    volumes:
      - mongo_data:/data/db
      - ./mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js

  # Redis Cache
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - backend

volumes:
  mongo_data:
  redis_data:

networks:
  default:
    driver: bridge
```

### Docker Compose Commands
```bash
# Start all services
docker-compose up                    # Foreground
docker-compose up -d                 # Background (detached)

# Build and start
docker-compose up --build

# Start specific services
docker-compose up web db

# Stop services
docker-compose down                  # Stop and remove containers
docker-compose down -v               # Also remove volumes
docker-compose stop                  # Just stop (don't remove)

# View running services
docker-compose ps

# View logs
docker-compose logs                  # All services
docker-compose logs web              # Specific service
docker-compose logs -f web           # Follow logs

# Execute commands
docker-compose exec web bash         # Interactive shell
docker-compose exec db psql -U user  # Run command

# Scale services
docker-compose up --scale web=3      # Run 3 instances of web

# Build services
docker-compose build                 # Build all
docker-compose build web             # Build specific service
```

### Environment Files
```bash
# .env file
NODE_ENV=development
DATABASE_URL=postgres://user:pass@db:5432/myapp
API_KEY=secret123
```

```yaml
# docker-compose.yml
services:
  web:
    env_file:
      - .env
    environment:
      - DEBUG=true  # Override or add variables
```

### Override Files
```yaml
# docker-compose.override.yml (automatically loaded)
version: '3.8'
services:
  web:
    volumes:
      - .:/app  # Development volume mount
    environment:
      - DEBUG=true

# docker-compose.prod.yml
version: '3.8'
services:
  web:
    environment:
      - NODE_ENV=production
    restart: unless-stopped
```

```bash
# Use specific override file
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

---

## 8. Advanced Networking

### Overlay Networks (Docker Swarm)
```bash
# Create overlay network
docker network create --driver overlay my-overlay

# Services can communicate across multiple hosts
docker service create --network my-overlay --name web nginx
docker service create --network my-overlay --name api node:16
```

### Service Discovery
```yaml
# docker-compose.yml
services:
  web:
    image: nginx
    depends_on:
      - api
      
  api:
    image: node:16
    # Web can reach API at: http://api:3000
```

```bash
# Inside web container
curl http://api:3000/users  # Resolves to API container IP
ping api                    # DNS resolution works
```

### Custom Network Configuration
```yaml
version: '3.8'

services:
  web:
    image: nginx
    networks:
      frontend:
        ipv4_address: 172.20.0.5
      
  db:
    image: postgres
    networks:
      backend:
        ipv4_address: 172.21.0.5

  api:
    image: node:16
    networks:
      - frontend  # Can talk to web
      - backend   # Can talk to db

networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
          
  backend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/16
```

### Load Balancing Inside Docker
```bash
# Docker Swarm automatically load balances
docker service create --replicas 3 --name web nginx

# Requests to 'web' are distributed across 3 containers
# Built-in VIP (Virtual IP) load balancer
```

---

## 9. Security & Best Practices

### Run as Non-Root User
```dockerfile
# Create user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Change ownership
COPY --chown=nextjs:nodejs . .

# Switch to user
USER nextjs

# Or use numeric ID
USER 1001:1001
```

### Use Minimal Base Images
```dockerfile
# Good
FROM alpine:3.15

# Better
FROM scratch

# For Node.js
FROM node:16-alpine  # Instead of node:16 (Ubuntu-based)

# For Python
FROM python:3.9-slim  # Instead of python:3.9
```

### Multi-stage Builds for Security
```dockerfile
# Build stage (includes dev tools)
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage (minimal)
FROM node:16-alpine AS production
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001
WORKDIR /app
COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nextjs:nodejs /app/package*.json ./
RUN npm ci --only=production && npm cache clean --force
USER nextjs
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Limit Container Resources
```bash
# Memory limits
docker run --memory="512m" nginx
docker run --memory="1g" --memory-swap="2g" nginx

# CPU limits
docker run --cpus="1.5" nginx
docker run --cpu-shares=512 nginx

# In docker-compose.yml
services:
  web:
    image: nginx
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

### Scan Images for Vulnerabilities
```bash
# Docker scan (requires Docker Desktop)
docker scan nginx:latest

# Trivy (open source)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image nginx:latest

# Anchore
anchore-cli image add nginx:latest
anchore-cli image vuln nginx:latest all
```

### Security Scanning in CI/CD
```yaml
# GitHub Actions example
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'my-app:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'
```

### Secrets Management
```bash
# Docker secrets (Swarm mode)
echo "mysecretpassword" | docker secret create db_password -

# Use in service
docker service create \
  --secret db_password \
  --env POSTGRES_PASSWORD_FILE=/run/secrets/db_password \
  postgres
```

```yaml
# docker-compose.yml with secrets
version: '3.8'
services:
  db:
    image: postgres
    secrets:
      - db_password
    environment:
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./db_password.txt  # Not recommended for production
```

### Additional Security Measures
```bash
# Read-only containers
docker run --read-only nginx

# No new privileges
docker run --security-opt=no-new-privileges nginx

# Custom seccomp profile
docker run --security-opt seccomp=custom-profile.json nginx

# AppArmor profile
docker run --security-opt apparmor=docker-nginx nginx

# Drop capabilities
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
```

---

## 10. Orchestration

### Why Orchestration?
- **Scalability**: Automatically scale services based on demand
- **High Availability**: Restart failed containers, distribute across nodes
- **Service Discovery**: Containers find each other automatically
- **Load Balancing**: Distribute traffic across container instances
- **Rolling Updates**: Update services without downtime

### Docker Swarm Basics

#### Initialize Swarm
```bash
# Initialize swarm on manager node
docker swarm init --advertise-addr <manager-ip>

# Join worker nodes
docker swarm join --token <worker-token> <manager-ip>:2377

# View nodes
docker node ls
```

#### Services
```bash
# Create service
docker service create --name web --replicas 3 --publish 80:80 nginx

# Scale service
docker service scale web=5

# Update service
docker service update --image nginx:alpine web

# List services
docker service ls

# Inspect service
docker service inspect web

# View service logs
docker service logs web
```

#### Service Discovery & Load Balancing
```bash
# Services automatically load balance
docker service create --name api --replicas 3 node:16

# Requests to 'api' are distributed across all replicas
# Built-in DNS resolution and VIP load balancing
```

#### Overlay Networks
```bash
# Create overlay network
docker network create --driver overlay my-network

# Deploy services on overlay network
docker service create --network my-network --name web nginx
docker service create --network my-network --name api node:16

# Services can communicate across different nodes
```

### Kubernetes (Industry Standard)

#### Why Kubernetes over Docker Swarm?
- **Ecosystem**: Larger community, more tools
- **Features**: Advanced scheduling, storage, networking
- **Cloud Support**: Native support in all major clouds
- **Extensibility**: Custom resources, operators

#### Basic Kubernetes Concepts
```yaml
# Pod (basic unit)
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80

---
# Deployment (manages replicas)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

---
# Service (load balancer)
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

#### Kubernetes vs Docker Compose
| Feature | Docker Compose | Kubernetes |
|---------|----------------|------------|
| **Scope** | Single host | Multi-host cluster |
| **Scaling** | Manual | Automatic (HPA) |
| **Self-healing** | Limited | Advanced |
| **Rolling updates** | Basic | Advanced strategies |
| **Storage** | Volumes | Persistent Volumes, Storage Classes |
| **Networking** | Basic | Advanced (CNI plugins) |
| **Learning curve** | Easy | Steep |

---

## 11. Docker in Production

### Logging & Monitoring

#### Centralized Logging
```bash
# Configure logging driver
docker run --log-driver=syslog nginx

# JSON file logging (default)
docker run --log-driver=json-file --log-opt max-size=10m nginx

# Forward to external system
docker run --log-driver=fluentd --log-opt fluentd-address=localhost:24224 nginx
```

#### ELK Stack Example
```yaml
version: '3.8'

services:
  app:
    image: my-app
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  elasticsearch:
    image: elasticsearch:7.14.0
    environment:
      - discovery.type=single-node
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data

  logstash:
    image: logstash:7.14.0
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf

  kibana:
    image: kibana:7.14.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200

volumes:
  elasticsearch_data:
```

### Monitoring with Prometheus & Grafana
```yaml
version: '3.8'

services:
  app:
    image: my-app
    ports:
      - "3000:3000"

  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana

  node-exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"

volumes:
  grafana_data:
```

### Private Registries

#### Docker Registry
```bash
# Run private registry
docker run -d -p 5000:5000 --name registry registry:2

# Tag and push
docker tag my-app localhost:5000/my-app
docker push localhost:5000/my-app

# Pull from private registry
docker pull localhost:5000/my-app
```

#### Secure Registry with TLS
```yaml
version: '3.8'

services:
  registry:
    image: registry:2
    ports:
      - "5000:5000"
    environment:
      REGISTRY_HTTP_TLS_CERTIFICATE: /certs/domain.crt
      REGISTRY_HTTP_TLS_KEY: /certs/domain.key
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/htpasswd
      REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
    volumes:
      - ./certs:/certs
      - ./auth:/auth
      - registry_data:/var/lib/registry

volumes:
  registry_data:
```

### CI/CD with Docker

#### GitHub Actions Example
```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Build Docker image
      run: docker build -t my-app:${{ github.sha }} .
    
    - name: Login to registry
      run: echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
    
    - name: Push image
      run: |
        docker tag my-app:${{ github.sha }} my-registry/my-app:${{ github.sha }}
        docker tag my-app:${{ github.sha }} my-registry/my-app:latest
        docker push my-registry/my-app:${{ github.sha }}
        docker push my-registry/my-app:latest
    
    - name: Deploy to production
      run: |
        ssh ${{ secrets.DEPLOY_HOST }} "
          docker pull my-registry/my-app:latest &&
          docker stop my-app || true &&
          docker rm my-app || true &&
          docker run -d --name my-app -p 80:3000 my-registry/my-app:latest
        "
```

### Image Optimization

#### Multi-stage Build Optimization
```dockerfile
# Development stage
FROM node:16 AS development
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# Build stage
FROM node:16-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Production stage
FROM node:16-alpine AS production
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
WORKDIR /app
COPY --from=build --chown=nextjs:nodejs /app/dist ./
COPY --from=build --chown=nextjs:nodejs /app/package*.json ./
RUN npm ci --only=production && npm cache clean --force
USER nextjs
EXPOSE 3000
CMD ["node", "index.js"]
```

#### Build Cache Optimization
```dockerfile
# Order layers by change frequency
FROM node:16-alpine

# Dependencies (change less frequently)
COPY package*.json ./
RUN npm ci --only=production

# Source code (change more frequently)
COPY . .

# Build step last
RUN npm run build
```

### Health Checks
```dockerfile
# In Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

```yaml
# In docker-compose.yml
services:
  app:
    image: my-app
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

---

## 12. Troubleshooting & Debugging

### Container Inspection
```bash
# Detailed container information
docker inspect <container_id>

# Specific information
docker inspect --format='{{.State.Status}}' <container_id>
docker inspect --format='{{.NetworkSettings.IPAddress}}' <container_id>
docker inspect --format='{{range .Mounts}}{{.Source}}:{{.Destination}}{{end}}' <container_id>
```

### Logs Analysis
```bash
# View logs
docker logs <container_id>
docker logs -f <container_id>           # Follow logs
docker logs --tail 50 <container_id>    # Last 50 lines
docker logs --since="2h" <container_id> # Last 2 hours
docker logs -t <container_id>           # Timestamps

# Service logs (in Swarm)
docker service logs <service_name>
```

### Resource Monitoring
```bash
# Real-time stats
docker stats                            # All containers
docker stats <container_id>             # Specific container

# System-wide info
docker system df                        # Disk usage
docker system events                    # Real-time events
docker system info                      # System information
```

### Performance Debugging
```bash
# Top processes in container
docker exec <container_id> top

# Memory usage
docker exec <container_id> free -h

# Disk usage
docker exec <container_id> df -h

# Network connections
docker exec <container_id> netstat -tulpn
```

### Network Debugging
```bash
# Network information
docker network inspect bridge
docker network inspect <network_name>

# Test connectivity
docker exec <container_id> ping <target>
docker exec <container_id> nslookup <hostname>
docker exec <container_id> curl -v <url>

# Check ports
docker exec <container_id> netstat -tulpn
docker port <container_id>
```

### Storage Debugging
```bash
# Volume information
docker volume inspect <volume_name>

# Check mount points
docker exec <container_id> mount | grep <path>

# File permissions
docker exec <container_id> ls -la <path>
```

### Common Issues & Solutions

#### 1. Container Exits Immediately
```bash
# Check exit code and logs
docker ps -a
docker logs <container_id>

# Common causes:
# - Wrong CMD/ENTRYPOINT
# - Application crashes
# - Missing dependencies
```

#### 2. Port Already in Use
```bash
# Find process using port
sudo netstat -tulpn | grep :8080
sudo lsof -i :8080

# Kill process
sudo kill -9 <pid>

# Use different port
docker run -p 8081:80 nginx
```

#### 3. Permission Denied
```bash
# Check file ownership
docker exec <container_id> ls -la /app

# Fix ownership
docker exec <container_id> chown -R app:app /app

# Run as root temporarily
docker exec -u root <container_id> chown -R app:app /app
```

#### 4. Cannot Connect to Container
```bash
# Check if container is running
docker ps

# Check port mapping
docker port <container_id>

# Test from host
curl localhost:8080

# Test from inside container
docker exec <container_id> curl localhost:80
```

#### 5. Out of Disk Space
```bash
# Clean up unused resources
docker system prune                     # Remove unused data
docker system prune -a                  # Remove all unused images
docker system prune --volumes           # Include volumes

# Remove specific items
docker container prune                  # Remove stopped containers
docker image prune                      # Remove unused images
docker volume prune                     # Remove unused volumes
docker network prune                    # Remove unused networks
```

### Advanced Debugging

#### Debug Container with Different Entrypoint
```bash
# Override entrypoint to investigate
docker run -it --entrypoint /bin/sh nginx:alpine

# Debug existing container
docker exec -it <container_id> /bin/sh
```

#### Copy Files for Analysis
```bash
# Copy from container to host
docker cp <container_id>:/app/logs/error.log ./error.log

# Copy from host to container
docker cp ./config.json <container_id>:/app/config.json
```

#### Network Troubleshooting Tools
```bash
# Install tools in running container
docker exec <container_id> apt-get update && apt-get install -y curl dnsutils

# Create debug container with tools
docker run -it --rm --network container:<container_id> nicolaka/netshoot

# Test network connectivity
docker run --rm --network <network_name> busybox ping <service_name>
```

### Useful Debug Commands Cheat Sheet
```bash
# Quick container info
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# Find containers by image
docker ps --filter ancestor=nginx

# Find containers by status
docker ps -a --filter status=exited

# Remove all stopped containers
docker container prune

# Show only container IDs
docker ps -q

# Execute multiple commands
docker exec <container_id> sh -c "ps aux && netstat -tulpn"

# Follow logs from multiple containers
docker-compose logs -f web api db

# Check compose service health
docker-compose ps
```

---

## Quick Reference Commands

### Docker CLI Essentials
```bash
# Images
docker pull <image>                     # Download image
docker build -t <name> .                # Build image
docker images                           # List images
docker rmi <image>                      # Remove image

# Containers
docker run <image>                      # Create and start
docker ps                               # List running
docker ps -a                            # List all
docker stop <container>                 # Stop container
docker rm <container>                   # Remove container

# Debugging
docker logs <container>                 # View logs
docker exec -it <container> bash        # Interactive shell
docker inspect <container>              # Detailed info
docker stats                            # Resource usage

# Cleanup
docker system prune                     # Clean unused
docker system prune -a                  # Clean all unused
```

### Docker Compose Essentials
```bash
docker-compose up -d                    # Start in background
docker-compose down                     # Stop and remove
docker-compose logs -f                  # Follow logs
docker-compose ps                       # List services
docker-compose exec <service> bash      # Execute command
docker-compose build                    # Build services
docker-compose pull                     # Pull images
```

---

🎯 **Pro Tips:**
- Always use specific image tags in production (avoid `latest`)
- Implement health checks for all services
- Use multi-stage builds to reduce image size
- Set up proper logging and monitoring from day one
- Practice the principle of least privilege
- Regularly scan images for vulnerabilities
- Use `.dockerignore` to exclude unnecessary files
- Leverage layer caching for faster builds