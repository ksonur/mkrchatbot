#!/bin/bash
# Create .env.local file for Azure AD configuration

echo "🔧 Setting up environment variables..."

# Check if .env.local already exists
if [ -f .env.local ]; then
    echo "⚠️ .env.local already exists. Backing up to .env.local.backup"
    cp .env.local .env.local.backup
fi

# Get current environment
if [ "$1" = "docker" ]; then
    # Docker/Production setup
    SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "your-server-ip")
    REDIRECT_URI="http://$SERVER_IP:8080"
    echo "🐳 Setting up for Docker deployment..."
elif [ "$1" = "local" ]; then
    # Local development setup
    REDIRECT_URI="https://asistan.mikrogrup.net"
    echo "💻 Setting up for local development..."
else
    # Interactive setup
    echo "Choose your setup:"
    echo "1) Local development (localhost:3000)"
    echo "2) Docker/Production"
    read -p "Enter choice (1 or 2): " choice
    
    if [ "$choice" = "1" ]; then
        REDIRECT_URI="http://localhost:3000"
        echo "💻 Setting up for local development..."
    else
        SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "your-server-ip")
        REDIRECT_URI="http://$SERVER_IP:8080"
        echo "🐳 Setting up for Docker deployment..."
    fi
fi

# Create .env.local file
cat > .env.local << EOF
# Azure AD Configuration
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=$REDIRECT_URI

# OpenAI Configuration
VITE_OPENAI_API_KEY=your_openai_api_key_here
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1
EOF

echo "✅ Created .env.local with:"
echo "   📍 Redirect URI: $REDIRECT_URI"
echo ""
echo "📋 Next steps:"
echo "   1. Add your OpenAI API key to .env.local"
echo "   2. Add this redirect URI to Azure Portal:"
echo "      $REDIRECT_URI"
echo "   3. Go to: Azure Portal → App Registrations → Authentication → Single-page application"
echo ""
echo "📄 View created file: cat .env.local" 