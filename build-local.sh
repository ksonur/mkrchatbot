#!/bin/bash

# Build Mikrogrup ITBOT locally without Docker
# This bypasses all Docker Hub TLS issues

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Building Mikrogrup ITBOT Locally${NC}"
echo "===================================="

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js is not installed!${NC}"
    echo "Install with: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    exit 1
fi

# Check if nginx is installed
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}Installing nginx...${NC}"
    sudo apt update
    sudo apt install -y nginx
fi

# Build the application
echo -e "${YELLOW}Step 1: Installing dependencies...${NC}"
npm install

echo -e "${YELLOW}Step 2: Building production app...${NC}"
npm run build

echo -e "${YELLOW}Step 3: Deploying to nginx...${NC}"
# Backup existing nginx content
sudo mkdir -p /var/backups/nginx
sudo cp -r /var/www/html/* /var/backups/nginx/ 2>/dev/null || true

# Deploy our app
sudo rm -rf /var/www/html/*
sudo cp -r dist/* /var/www/html/

# Configure nginx
sudo tee /etc/nginx/sites-available/mikrogrup-itbot > /dev/null <<EOF
server {
    listen 8080;
    server_name localhost;
    
    root /var/www/html;
    index index.html;
    
    # Handle client-side routing
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/mikrogrup-itbot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

echo -e "${GREEN}✅ Mikrogrup ITBOT deployed successfully!${NC}"
echo -e "${GREEN}🌐 Access your app at: http://localhost:8080${NC}"
echo ""
echo -e "${BLUE}Management commands:${NC}"
echo "sudo systemctl stop nginx    # Stop the server"
echo "sudo systemctl start nginx   # Start the server"
echo "sudo systemctl reload nginx  # Reload configuration" 