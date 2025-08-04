#!/bin/bash

# Mikrogrup ITBOT Docker Management - Simple Images (TLS Fix)
# Uses Ubuntu base images instead of Alpine to avoid TLS issues

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_usage() {
    echo -e "${BLUE}Mikrogrup ITBOT Docker Management (Simple)${NC}"
    echo ""
    echo "Usage: ./docker-start-simple.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  dev         Start development server"
    echo "  prod        Start production server"
    echo "  build       Build production Docker image"
    echo "  stop        Stop all containers"
    echo "  logs        Show container logs"
    echo "  status      Show container status"
    echo ""
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed!${NC}"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        USE_SUDO="sudo"
        echo -e "${YELLOW}Using sudo for Docker commands...${NC}"
    else
        USE_SUDO=""
    fi
}

check_env() {
    if [ ! -f ".env.local" ]; then
        echo -e "${YELLOW}Warning: .env.local not found${NC}"
        echo "Creating .env.local from template..."
        cat > .env.local << EOF
# OpenAI Configuration
VITE_OPENAI_API_KEY=your-openai-api-key
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1

# Azure AD Configuration
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=http://localhost:8080
EOF
        echo -e "${RED}Please edit .env.local with your actual API keys before starting!${NC}"
        exit 1
    fi
}

case "$1" in
    "dev")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in development mode (Simple)...${NC}"
        check_docker
        check_env
        
        # Stop existing container if running
        ${USE_SUDO} docker stop mikrogrup-itbot-dev-simple 2>/dev/null || true
        ${USE_SUDO} docker rm mikrogrup-itbot-dev-simple 2>/dev/null || true
        
        # Build development image with simple Dockerfile
        echo "Building development image..."
        ${USE_SUDO} docker build -f Dockerfile.dev.simple -t mikrogrup-itbot:dev-simple .
        
        # Run development container
        ${USE_SUDO} docker run -d \
            --name mikrogrup-itbot-dev-simple \
            -p 5173:5173 \
            -v $(pwd):/app \
            -v /app/node_modules \
            --env-file .env.local \
            mikrogrup-itbot:dev-simple
            
        echo -e "${GREEN}✅ Development server running at http://localhost:5173${NC}"
        ;;
        
    "prod")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in production mode (Simple)...${NC}"
        check_docker
        
        # Stop existing container if running
        ${USE_SUDO} docker stop mikrogrup-itbot-prod-simple 2>/dev/null || true
        ${USE_SUDO} docker rm mikrogrup-itbot-prod-simple 2>/dev/null || true
        
        # Build production image with simple Dockerfile
        echo "Building production image..."
        ${USE_SUDO} docker build -f Dockerfile.simple -t mikrogrup-itbot:prod-simple .
        
        # Run production container
        ${USE_SUDO} docker run -d \
            --name mikrogrup-itbot-prod-simple \
            -p 8080:80 \
            --env-file .env.local \
            --restart unless-stopped \
            mikrogrup-itbot:prod-simple
            
        echo -e "${GREEN}✅ Production server running at http://localhost:8080${NC}"
        ;;
        
    "build")
        echo -e "${BLUE}Building production Docker image (Simple)...${NC}"
        check_docker
        ${USE_SUDO} docker build -f Dockerfile.simple -t mikrogrup-itbot:prod-simple .
        echo -e "${GREEN}✅ Build complete!${NC}"
        ;;
        
    "stop")
        echo -e "${YELLOW}Stopping Mikrogrup ITBOT containers...${NC}"
        check_docker
        ${USE_SUDO} docker stop mikrogrup-itbot-prod-simple mikrogrup-itbot-dev-simple 2>/dev/null || true
        ${USE_SUDO} docker rm mikrogrup-itbot-prod-simple mikrogrup-itbot-dev-simple 2>/dev/null || true
        echo -e "${GREEN}✅ Containers stopped${NC}"
        ;;
        
    "logs")
        echo -e "${BLUE}Container logs:${NC}"
        check_docker
        echo "Production logs:"
        ${USE_SUDO} docker logs mikrogrup-itbot-prod-simple 2>/dev/null || echo "Production container not running"
        echo "Development logs:"
        ${USE_SUDO} docker logs mikrogrup-itbot-dev-simple 2>/dev/null || echo "Development container not running"
        ;;
        
    "status")
        echo -e "${BLUE}Container Status:${NC}"
        check_docker
        ${USE_SUDO} docker ps | grep mikrogrup-itbot || echo "No mikrogrup-itbot containers running"
        ;;
        
    *)
        print_usage
        ;;
esac 