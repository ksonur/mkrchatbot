# 🐳 Running Azure AD Integration in Docker

## ✅ **What You Need To Do:**

### **1. 📋 Environment Variables on Server**

**On your Linux server, create `.env.local`:**
```bash
cd ~/mkrchatbot

# Create environment file for Docker
cat > .env.local << 'EOF'
# Azure AD Configuration
VITE_AZURE_CLIENT_ID=645a4b0e-9042-474e-beea-f7840c1a8c83
VITE_AZURE_TENANT_ID=bb364f09-07cf-4eca-9b92-1f26a92d5f3f
VITE_AZURE_REDIRECT_URI=http://your-server-ip:8080

# OpenAI Configuration
VITE_OPENAI_API_KEY=your_openai_api_key_here
VITE_OPENAI_MODEL=ft:gpt-3.5-turbo-0125:mikrogrup::Bz01EUG1
EOF

# Replace 'your-server-ip' with actual IP
sed -i 's/your-server-ip/YOUR_ACTUAL_SERVER_IP/g' .env.local
```

### **2. 🔧 Azure Portal Configuration**

**Add Docker redirect URI in Azure Portal:**

1. **Go to:** [Azure Portal](https://portal.azure.com) → App Registrations
2. **Find:** `645a4b0e-9042-474e-beea-f7840c1a8c83`
3. **Authentication** → **Single-page application**
4. **Add URI:** `http://your-server-ip:8080`

**Your redirect URIs should include:**
```
✅ http://localhost:5173      (local dev)
✅ http://localhost:5176      (local dev)
✅ http://your-server-ip:8080 (Docker production)
```

### **3. 🚀 Deploy with Docker**

**Force rebuild and deploy:**
```bash
# Stop existing containers
docker compose down

# Rebuild with latest code and environment variables
docker compose build --no-cache

# Start production container on port 8080
PORT=8080 docker compose up -d mikrogrup-itbot

# Check status
docker compose ps
docker compose logs -f mikrogrup-itbot
```

### **4. 🎯 Quick Deploy Script**

**Create deployment script:**
```bash
cat > deploy-docker.sh << 'EOF'
#!/bin/bash
echo "🔄 Deploying Mikrogrup ITBOT with Docker..."

# Stop existing containers
echo "⏹️ Stopping containers..."
docker compose down

# Get latest code
echo "📥 Getting latest code..."
git pull origin main

# Rebuild with no cache
echo "🔨 Building Docker image..."
docker compose build --no-cache

# Start on port 8080
echo "🚀 Starting container..."
PORT=8080 docker compose up -d mikrogrup-itbot

# Show status
echo "📊 Container status:"
docker compose ps

echo "✅ Deployment complete!"
echo "🌐 Access app at: http://$(hostname -I | awk '{print $1}'):8080"
echo "📄 View logs: docker compose logs -f mikrogrup-itbot"
EOF

chmod +x deploy-docker.sh
```

### **5. 🧪 Test Azure AD Login**

**After deployment:**
1. **Access:** `http://your-server-ip:8080`
2. **Click:** "Azure AD ile Giriş Yap"
3. **Check:** Browser console for errors
4. **Verify:** Name and email appear in top right

## 🔍 **Troubleshooting:**

### **Environment Variables Not Working**
```bash
# Check if .env.local exists
ls -la .env.local

# Check Docker container environment
docker compose exec mikrogrup-itbot env | grep VITE

# If variables are missing, recreate .env.local and rebuild
```

### **Azure AD Redirect Error**
```bash
# Error: redirect_uri_mismatch
# Fix: Add your Docker URL to Azure Portal
# http://your-server-ip:8080
```

### **Build Issues**
```bash
# If Docker build fails, clean everything:
docker compose down
docker system prune -f
docker compose build --no-cache
PORT=8080 docker compose up -d mikrogrup-itbot
```

## 📋 **Complete Checklist:**

- [ ] ✅ `.env.local` created on server with correct values
- [ ] ✅ Azure Portal redirect URI added for Docker URL
- [ ] ✅ Latest code pulled from Git
- [ ] ✅ Docker containers rebuilt with `--no-cache`
- [ ] ✅ Container running on port 8080
- [ ] ✅ Azure AD login tested successfully

## 🎯 **Quick Commands:**

```bash
# Complete deployment
cd ~/mkrchatbot
git pull origin main
./deploy-docker.sh

# Check logs
docker compose logs -f mikrogrup-itbot

# Access app
# http://your-server-ip:8080
```

**Your Azure AD integration should work perfectly in Docker after these steps! 🎉** 