#!/bin/bash

# Mikrogrup ITBOT Docker Management Script - Linux Optimized
# Compatible with Ubuntu, CentOS, Debian, etc.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo -e "${BLUE}Mikrogrup ITBOT Docker Management (Linux)${NC}"
    echo ""
    echo "Usage: ./docker-start-linux.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  dev         Start development server with hot reload"
    echo "  prod        Start production server"
    echo "  build       Build production Docker image"
    echo "  stop        Stop all containers"
    echo "  clean       Remove containers and images"
    echo "  logs        Show container logs"
    echo "  shell       Access container shell"
    echo "  status      Show container status and resource usage"
    echo "  install     Install Docker (Ubuntu/Debian only)"
    echo "  fix-perms   Fix Docker permissions for current user"
    echo ""
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed!${NC}"
        echo "Run: ./docker-start-linux.sh install"
        exit 1
    fi
    
    # Check if Docker daemon is running
    if ! sudo systemctl is-active --quiet docker; then
        echo -e "${RED}Docker daemon is not running!${NC}"
        echo "Run: sudo systemctl start docker"
        exit 1
    fi
    
    # Check if user can access Docker without sudo
    if ! docker info &> /dev/null; then
        echo -e "${YELLOW}Note: Docker requires sudo access for user $USER${NC}"
        echo -e "${YELLOW}Using sudo for Docker commands...${NC}"
        USE_SUDO="sudo"
    else
        USE_SUDO=""
    fi
}

fix_permissions() {
    echo -e "${BLUE}Fixing Docker permissions for user $USER...${NC}"
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✅ User added to docker group${NC}"
    echo -e "${YELLOW}Please logout and login again, or run: newgrp docker${NC}"
    echo "Then try running the script again."
}

check_env() {
    if [ ! -f ".env.local" ]; then
        echo -e "${YELLOW}Warning: .env.local not found${NC}"
        echo "Creating .env.local from template..."
        cp .env.docker .env.local
        echo -e "${RED}Please edit .env.local with your actual API keys before starting!${NC}"
        exit 1
    fi
}

install_docker() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            echo -e "${BLUE}Installing Docker on Debian/Ubuntu...${NC}"
            sudo apt update
            sudo apt install -y docker.io docker-compose
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            echo -e "${GREEN}✅ Docker installed! Please logout and login again.${NC}"
        elif [ -f /etc/redhat-release ]; then
            echo -e "${BLUE}Installing Docker on CentOS/RHEL...${NC}"
            sudo yum install -y docker docker-compose
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            echo -e "${GREEN}✅ Docker installed! Please logout and login again.${NC}"
        else
            echo -e "${RED}Unsupported Linux distribution. Please install Docker manually.${NC}"
        fi
    else
        echo -e "${RED}This install command only works on Linux!${NC}"
    fi
}

case "$1" in
    "dev")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in development mode...${NC}"
        check_docker
        check_env
        ${USE_SUDO} docker-compose --profile dev up --build
        ;;
    "prod")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in production mode...${NC}"
        check_docker
        check_env
        
        # Source environment variables for build
        if [ -f .env.local ]; then
            export $(grep -v '^#' .env.local | xargs) 2>/dev/null || true
        fi
        
        ${USE_SUDO} docker-compose up mikrogrup-itbot --build -d
        echo -e "${GREEN}✅ Mikrogrup ITBOT is running at http://localhost:8080${NC}"
        ;;
    "build")
        echo -e "${BLUE}Building production Docker image...${NC}"
        check_docker
        ${USE_SUDO} docker build -t mikrogrup-itbot:latest .
        echo -e "${GREEN}✅ Build complete!${NC}"
        ;;
    "stop")
        echo -e "${YELLOW}Stopping all containers...${NC}"
        check_docker
        ${USE_SUDO} docker-compose down
        ;;
    "clean")
        echo -e "${RED}Cleaning up containers and images...${NC}"
        check_docker
        ${USE_SUDO} docker-compose down --rmi all --volumes
        ${USE_SUDO} docker system prune -f
        ;;
    "logs")
        check_docker
        ${USE_SUDO} docker-compose logs -f
        ;;
    "shell")
        check_docker
        ${USE_SUDO} docker-compose exec mikrogrup-itbot sh
        ;;
    "status")
        echo -e "${BLUE}Container Status:${NC}"
        check_docker
        ${USE_SUDO} docker ps
        echo -e "${BLUE}Resource Usage:${NC}"
        ${USE_SUDO} docker stats --no-stream
        ;;
    "fix-perms")
        fix_permissions
        ;;
    "install")
        install_docker
        ;;
    *)
        print_usage
        ;;
esac 