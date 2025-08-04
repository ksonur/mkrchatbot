#!/bin/bash

# Docker Installation Fix Script for Linux
# Resolves dependency conflicts and installs Docker properly

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐳 Docker Installation Fix Script${NC}"
echo "=================================="

# Step 1: Check system
echo -e "${YELLOW}Step 1: Checking system...${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "OS: $NAME $VERSION"
else
    echo "Cannot determine OS version"
fi

# Step 2: Remove conflicting packages
echo -e "${YELLOW}Step 2: Removing conflicting Docker packages...${NC}"
sudo apt remove --purge -y docker docker-engine docker.io containerd runc containerd.io docker-ce docker-ce-cli 2>/dev/null || echo "Some packages not found (this is OK)"

# Clean up
sudo apt autoremove -y
sudo apt autoclean

# Step 3: Install prerequisites
echo -e "${YELLOW}Step 3: Installing prerequisites...${NC}"
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Step 4: Install Docker (simple method)
echo -e "${YELLOW}Step 4: Installing Docker (simple method)...${NC}"
sudo apt update
sudo apt install -y docker.io

# Step 5: Install docker-compose
echo -e "${YELLOW}Step 5: Installing docker-compose...${NC}"
# Try package manager first
if sudo apt install -y docker-compose; then
    echo "docker-compose installed via apt"
else
    echo "Installing docker-compose via pip..."
    sudo apt install -y python3-pip
    sudo pip3 install docker-compose
fi

# Step 6: Setup Docker service
echo -e "${YELLOW}Step 6: Setting up Docker service...${NC}"
sudo systemctl start docker
sudo systemctl enable docker

# Step 7: Add user to docker group
echo -e "${YELLOW}Step 7: Adding user to docker group...${NC}"
sudo usermod -aG docker $USER

# Step 8: Test installation
echo -e "${YELLOW}Step 8: Testing Docker installation...${NC}"
sudo docker --version
sudo docker-compose --version

# Test Docker with hello-world
if sudo docker run hello-world; then
    echo -e "${GREEN}✅ Docker installation successful!${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Logout and login again (or restart) to use docker without sudo"
    echo "2. Go to your project directory: cd ~/mkrchatbot"
    echo "3. Run your app: ./docker-start.sh prod"
else
    echo -e "${RED}❌ Docker test failed${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}" 