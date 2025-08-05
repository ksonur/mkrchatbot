#!/bin/bash
# Force rebuild Docker containers with new code changes

echo "🔄 Stopping existing containers..."
docker compose down

echo "🧹 Removing old images..."
docker compose build --no-cache

echo "🚀 Starting with fresh build..."
docker compose up -d

echo "✅ Docker containers rebuilt and started!"
echo "📋 Check status with: docker compose ps"
echo "📄 Check logs with: docker compose logs -f"
