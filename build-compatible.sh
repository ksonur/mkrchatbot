#!/bin/bash

# Build Mikrogrup ITBOT with older Node.js compatibility
# Uses webpack instead of Vite for older Node.js support

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Building Mikrogrup ITBOT (Compatible Mode)${NC}"
echo "=============================================="

# Check Node.js version
NODE_VERSION=$(node --version | sed 's/v//')
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1)

echo "Current Node.js version: v$NODE_VERSION"

if [ "$NODE_MAJOR" -lt 14 ]; then
    echo -e "${RED}❌ Node.js version is too old (< 14)${NC}"
    echo "Please update Node.js:"
    echo "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    exit 1
fi

# Create a simple build setup that works with older Node.js
echo -e "${YELLOW}Step 1: Creating compatible build configuration...${NC}"

# Create a simple webpack config for older Node.js
cat > webpack.simple.js << 'EOF'
const path = require('path');

module.exports = {
  mode: 'production',
  entry: './src/main.tsx',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    clean: true
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.js', '.jsx']
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        use: 'ts-loader',
        exclude: /node_modules/
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader', 'postcss-loader']
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg)$/,
        type: 'asset/resource'
      }
    ]
  }
};
EOF

# Create simple HTML template
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Mikrogrup ITBOT - TeamSystem Destekli AI Asistan</title>
  </head>
  <body>
    <div id="root"></div>
    <script src="bundle.js"></script>
  </body>
</html>
EOF

echo -e "${YELLOW}Step 2: Installing compatible dependencies...${NC}"

# Install webpack and loaders for older Node.js
npm install --save-dev webpack webpack-cli ts-loader style-loader css-loader postcss-loader html-webpack-plugin

echo -e "${YELLOW}Step 3: Building application...${NC}"

# Build with webpack
npx webpack --config webpack.simple.js

# Copy HTML template
cp public/index.html dist/

echo -e "${YELLOW}Step 4: Deploying to nginx...${NC}"

# Install nginx if not present
if ! command -v nginx &> /dev/null; then
    sudo apt update
    sudo apt install -y nginx
fi

# Backup existing content
sudo mkdir -p /var/backups/nginx
sudo cp -r /var/www/html/* /var/backups/nginx/ 2>/dev/null || true

# Deploy
sudo rm -rf /var/www/html/*
sudo cp -r dist/* /var/www/html/

# Configure nginx for port 8080
sudo tee /etc/nginx/sites-available/mikrogrup-itbot > /dev/null <<EOF
server {
    listen 8080;
    server_name localhost;
    
    root /var/www/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable site
sudo ln -sf /etc/nginx/sites-available/mikrogrup-itbot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

echo -e "${GREEN}✅ Mikrogrup ITBOT deployed successfully!${NC}"
echo -e "${GREEN}🌐 Access your app at: http://localhost:8080${NC}" 