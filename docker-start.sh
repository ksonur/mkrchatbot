#!/bin/bash

# Mikrogrup ITBOT Docker Management Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo -e "${BLUE}Mikrogrup ITBOT Docker Management${NC}"
    echo ""
    echo "Usage: ./docker-start.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  dev         Start development server with hot reload"
    echo "  prod        Start production server"
    echo "  build       Build production Docker image"
    echo "  stop        Stop all containers"
    echo "  clean       Remove containers and images"
    echo "  logs        Show container logs"
    echo "  shell       Access container shell"
    echo ""
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

case "$1" in
    "dev")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in development mode...${NC}"
        check_env
        docker-compose --profile dev up --build
        ;;
    "prod")
        echo -e "${GREEN}Starting Mikrogrup ITBOT in production mode...${NC}"
        docker-compose up mikrogrup-itbot --build -d
        echo -e "${GREEN}✅ Mikrogrup ITBOT is running at http://localhost:3000${NC}"
        ;;
    "build")
        echo -e "${BLUE}Building production Docker image...${NC}"
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
        ;;
    "logs")
        docker-compose logs -f
        ;;
    "shell")
        docker-compose exec mikrogrup-itbot sh
        ;;
    *)
        print_usage
        ;;
esac 