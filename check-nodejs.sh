#!/bin/bash

# Check Node.js Installation and Requirements
echo "🔍 Checking Node.js Installation..."
echo "=================================="

# Check if Node.js is installed
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js is installed: $NODE_VERSION"
    
    # Check version compatibility
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_MAJOR" -ge 16 ]; then
        echo "✅ Node.js version is compatible (>= 16)"
    else
        echo "⚠️  Node.js version is too old. Please upgrade to v16 or higher"
        echo "   Run: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    fi
else
    echo "❌ Node.js is not installed"
    echo ""
    echo "📋 Installation options:"
    echo "1. curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs"
    echo "2. sudo apt install -y nodejs npm"
    echo "3. sudo snap install node --classic"
    exit 1
fi

# Check if npm is installed
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ npm is installed: v$NPM_VERSION"
else
    echo "❌ npm is not installed"
    echo "   Run: sudo apt install -y npm"
    exit 1
fi

# Check available disk space
DISK_SPACE=$(df -h . | awk 'NR==2 {print $4}')
echo "💾 Available disk space: $DISK_SPACE"

# Check if git is available (for cloning)
if command -v git &> /dev/null; then
    echo "✅ Git is available"
else
    echo "⚠️  Git not found. Install with: sudo apt install -y git"
fi

echo ""
echo "🚀 System is ready for Mikrogrup ITBOT deployment!"
echo "   Next steps:"
echo "   1. cd ~/mkrchatbot"
echo "   2. ./build-local.sh" 