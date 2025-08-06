#!/bin/bash
# Update redirect URI based on current Docker port

echo "🔍 Checking current Docker setup..."

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

# Check what port Docker is using
DOCKER_PORT=$(docker compose ps | grep mikrogrup-itbot | grep -o '0.0.0.0:[0-9]*->80' | cut -d':' -f2 | cut -d'-' -f1)

if [ -z "$DOCKER_PORT" ]; then
    echo "❌ No running Docker container found."
    echo "Start with: docker compose up -d mikrogrup-itbot"
    exit 1
fi

echo "✅ Docker container running on port: $DOCKER_PORT"
echo "🌐 App URL: http://$SERVER_IP:$DOCKER_PORT"

# Current redirect URI
CURRENT_REDIRECT="http://$SERVER_IP:$DOCKER_PORT"

# Update .env.local if it exists
if [ -f .env.local ]; then
    echo "📝 Updating .env.local with correct redirect URI..."
    
    # Backup current file
    cp .env.local .env.local.backup
    
    # Update redirect URI in .env.local
    sed -i "s|VITE_AZURE_REDIRECT_URI=.*|VITE_AZURE_REDIRECT_URI=$CURRENT_REDIRECT|g" .env.local
    
    echo "✅ Updated .env.local:"
    grep "VITE_AZURE_REDIRECT_URI" .env.local
else
    echo "⚠️ .env.local not found. Creating it..."
    cat > .env.local << EOF
# Azure AD Configuration
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=$CURRENT_REDIRECT

# OpenAI Configuration
VITE_OPENAI_API_KEY=your_openai_api_key_here
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1
EOF
    echo "✅ Created .env.local"
fi

echo ""
echo "🔧 Azure Portal Configuration:"
echo "   Add this redirect URI: $CURRENT_REDIRECT"
echo "   Go to: Azure Portal → App Registrations → Authentication → Single-page application"
echo ""
echo "🎯 Steps to complete Azure AD setup:"
echo "   1. Add redirect URI to Azure Portal: $CURRENT_REDIRECT"
echo "   2. Add your OpenAI API key to .env.local"
echo "   3. Rebuild Docker: docker compose build --no-cache && docker compose up -d"
echo "   4. Test login at: http://$SERVER_IP:$DOCKER_PORT" 