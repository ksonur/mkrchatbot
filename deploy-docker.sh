#!/bin/bash
# Deploy Mikrogrup ITBOT with Docker and Azure AD integration

echo "🔄 Deploying Mikrogrup ITBOT with Docker..."

# Get server IP for redirect URI
SERVER_IP=$(hostname -I | awk '{print $1}')

# Stop existing containers
echo "⏹️ Stopping existing containers..."
docker compose down

# Get latest code
echo "📥 Getting latest code..."
git pull origin main

# Check if .env.local exists
if [ ! -f .env.local ]; then
    echo "⚠️ Creating .env.local file..."
    cat > .env.local << EOF
# Azure AD Configuration
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=http://$SERVER_IP:8080

# OpenAI Configuration
VITE_OPENAI_API_KEY=your_openai_api_key_here
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1
EOF
    echo "📝 Created .env.local with server IP: $SERVER_IP"
    echo "⚠️ Don't forget to add your OpenAI API key to .env.local"
else
    echo "✅ .env.local already exists"
fi

# Rebuild with no cache to include latest changes
echo "🔨 Building Docker image with latest code..."
docker compose build --no-cache

# Start on port 8080
echo "🚀 Starting container on port 8080..."
PORT=8080 docker compose up -d mikrogrup-itbot

# Wait a moment for container to start
sleep 3

# Show status
echo "📊 Container status:"
docker compose ps

echo ""
echo "✅ Deployment complete!"
echo "🌐 Access your app at: http://$SERVER_IP:8080"
echo "📄 View logs with: docker compose logs -f mikrogrup-itbot"
echo ""
echo "🔧 Azure Portal Requirements:"
echo "   Add this redirect URI: http://$SERVER_IP:8080"
echo "   Go to: Azure Portal → App Registrations → Authentication → Single-page application"
echo ""
echo "⚙️ Next steps:"
echo "   1. Add your OpenAI API key to .env.local"
echo "   2. Add redirect URI to Azure Portal"
echo "   3. Test Azure AD login at http://$SERVER_IP:8080" 