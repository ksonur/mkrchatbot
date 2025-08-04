#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

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
    echo ""
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed!${NC}"
        echo "Run: ./docker-start-linux.sh install"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker daemon is not running!${NC}"
        echo "Run: sudo systemctl start docker"
        exit 1
    fi
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
        docker-compose --profile dev up --build
        ;;
    "prod")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in production mode...${NC}"
        check_docker
        docker-compose up mikrogrup-itbot --build -d
        echo -e "${GREEN}✅ Mikrogrup ITBOT is running at http://localhost:8080${NC}"
        ;;
    "build")
        echo -e "${BLUE}Building production Docker image...${NC}"
        check_docker
        docker build -t mikrogrup-itbot:latest .
        echo -e "${GREEN}✅ Build complete!${NC}"
        ;;
    "stop")
        echo -e "${YELLOW}Stopping all containers...${NC}"
        docker-compose down
        ;;
    "clean")
        echo -e "${RED}Cleaning up containers and images...${NC}"
        docker-compose down --rmi all --volumes
        docker system prune -f
        ;;
    "logs")
        docker-compose logs -f
        ;;
    "shell")
        docker-compose exec mikrogrup-itbot sh
        ;;
    "status")
        echo -e "${BLUE}Container Status:${NC}"
        docker ps
        echo -e "${BLUE}Resource Usage:${NC}"
        docker stats --no-stream
        ;;
    "install")
        install_docker
        ;;
    *)
        print_usage
        ;;
esac 