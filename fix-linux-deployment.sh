#!/bin/bash

# Fix Linux Deployment Issues - Comprehensive Solution
# Resolves NS_ERROR_NET_PARTIAL_TRANSFER and blank page issues

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Fixing Linux Deployment Issues${NC}"
echo "=================================="

# Step 1: Stop any running containers
echo -e "${YELLOW}Step 1: Stopping existing containers...${NC}"
docker compose down 2>/dev/null || true
docker stop $(docker ps -q) 2>/dev/null || true

# Step 2: Check .env.local file
echo -e "${YELLOW}Step 2: Checking environment configuration...${NC}"
if [ ! -f .env.local ]; then
    echo -e "${RED}ERROR: .env.local file not found!${NC}"
    echo "Creating a template .env.local file..."
    
    # Get server IP for redirect URI
    SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")
    
    cat > .env.local << EOF
# Azure AD Configuration
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=http://$SERVER_IP:8080

# OpenAI Configuration
VITE_OPENAI_API_KEY=your_openai_api_key_here
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1
EOF
    
    echo -e "${GREEN}✅ Created .env.local template${NC}"
    echo -e "${RED}⚠️  IMPORTANT: Edit .env.local with your actual API keys!${NC}"
    echo ""
    read -p "Press Enter after editing .env.local, or Ctrl+C to exit..."
fi

# Step 3: Source environment variables
echo -e "${YELLOW}Step 3: Loading environment variables...${NC}"
if [ -f .env.local ]; then
    export $(grep -v '^#' .env.local | xargs) 2>/dev/null || true
    echo "✅ Environment variables loaded"
else
    echo -e "${RED}ERROR: .env.local not found after creation${NC}"
    exit 1
fi

# Step 4: Validate required environment variables
echo -e "${YELLOW}Step 4: Validating environment variables...${NC}"
MISSING_VARS=""

if [ -z "$VITE_AZURE_CLIENT_ID" ]; then
    MISSING_VARS="$MISSING_VARS VITE_AZURE_CLIENT_ID"
fi
if [ -z "$VITE_AZURE_TENANT_ID" ]; then
    MISSING_VARS="$MISSING_VARS VITE_AZURE_TENANT_ID"
fi
if [ -z "$VITE_AZURE_REDIRECT_URI" ]; then
    MISSING_VARS="$MISSING_VARS VITE_AZURE_REDIRECT_URI"
fi

if [ ! -z "$MISSING_VARS" ]; then
    echo -e "${RED}ERROR: Missing required environment variables:$MISSING_VARS${NC}"
    echo "Please check your .env.local file"
    exit 1
fi

echo "✅ Required environment variables are set"

# Step 5: Clean Docker environment
echo -e "${YELLOW}Step 5: Cleaning Docker environment...${NC}"
docker system prune -f
docker volume prune -f

# Step 6: Build with proper environment variables
echo -e "${YELLOW}Step 6: Building Docker image with environment variables...${NC}"
echo "Building production image with the following variables:"
echo "  VITE_AZURE_CLIENT_ID: $VITE_AZURE_CLIENT_ID"
echo "  VITE_AZURE_TENANT_ID: $VITE_AZURE_TENANT_ID"
echo "  VITE_AZURE_REDIRECT_URI: $VITE_AZURE_REDIRECT_URI"
echo "  VITE_OPENAI_MODEL: $VITE_OPENAI_MODEL"

# Build with environment variables as build arguments
docker build \
    --no-cache \
    --build-arg VITE_OPENAI_API_KEY="$VITE_OPENAI_API_KEY" \
    --build-arg VITE_OPENAI_MODEL="$VITE_OPENAI_MODEL" \
    --build-arg VITE_AZURE_CLIENT_ID="$VITE_AZURE_CLIENT_ID" \
    --build-arg VITE_AZURE_TENANT_ID="$VITE_AZURE_TENANT_ID" \
    --build-arg VITE_AZURE_REDIRECT_URI="$VITE_AZURE_REDIRECT_URI" \
    -t mikrogrup-itbot:fixed \
    .

echo -e "${GREEN}✅ Build completed successfully${NC}"

# Step 7: Start the container
echo -e "${YELLOW}Step 7: Starting the container...${NC}"

# Stop and remove any existing container
docker stop mikrogrup-itbot-fixed 2>/dev/null || true
docker rm mikrogrup-itbot-fixed 2>/dev/null || true

# Start the new container
docker run -d \
    --name mikrogrup-itbot-fixed \
    -p 8080:80 \
    --restart unless-stopped \
    mikrogrup-itbot:fixed

# Step 8: Wait and test
echo -e "${YELLOW}Step 8: Testing deployment...${NC}"
sleep 5

# Check if container is running
if docker ps | grep -q mikrogrup-itbot-fixed; then
    echo -e "${GREEN}✅ Container is running${NC}"
    
    # Test HTTP response
    if curl -f -s http://localhost:8080 > /dev/null; then
        echo -e "${GREEN}✅ HTTP response OK${NC}"
    else
        echo -e "${RED}❌ HTTP response failed${NC}"
        echo "Container logs:"
        docker logs mikrogrup-itbot-fixed --tail 20
    fi
else
    echo -e "${RED}❌ Container failed to start${NC}"
    echo "Container logs:"
    docker logs mikrogrup-itbot-fixed --tail 20
    exit 1
fi

# Step 9: Show final status
echo ""
echo -e "${GREEN}🎉 Deployment Fix Complete!${NC}"
echo "================================"
echo -e "${BLUE}Container Status:${NC}"
docker ps | grep mikrogrup-itbot-fixed

echo ""
echo -e "${BLUE}Application URL:${NC}"
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")
echo "  Local: http://localhost:8080"
echo "  Network: http://$SERVER_IP:8080"

echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Test the application in your browser"
echo "2. Check browser console for any remaining errors"
echo "3. Verify Azure AD login works correctly"
echo "4. Add http://$SERVER_IP:8080 to Azure App Registration redirect URIs"

echo ""
echo -e "${BLUE}Useful Commands:${NC}"
echo "  View logs: docker logs mikrogrup-itbot-fixed -f"
echo "  Stop container: docker stop mikrogrup-itbot-fixed"
echo "  Access shell: docker exec -it mikrogrup-itbot-fixed sh"

echo ""
echo -e "${YELLOW}If you still see issues:${NC}"
echo "1. Check browser console for specific JavaScript errors"
echo "2. Verify all environment variables are correct in .env.local"
echo "3. Make sure Azure redirect URI is properly configured"
echo "4. Run: docker logs mikrogrup-itbot-fixed to see container logs"