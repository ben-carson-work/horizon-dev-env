#!/bin/bash

# Docker Complete Reset Script
# This script completely resets Docker to a clean state by removing all containers, images, volumes, networks, and build cache
# WARNING: This will permanently delete ALL Docker data including persistent volumes and configurations

set -e  # Exit on any error

echo "🐳 Docker Complete Reset Script"
echo "================================="
echo ""
echo "⚠️  WARNING: This will permanently delete ALL Docker data including:"
echo "   - All containers (running and stopped)"
echo "   - All images"
echo "   - All volumes (including persistent data)"
echo "   - All custom networks"
echo "   - All build cache"
echo ""

# Ask for confirmation unless --force flag is used
if [[ "$1" != "--force" ]]; then
    read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Reset cancelled."
        exit 1
    fi
fi

echo ""
echo "🚀 Starting Docker reset process..."
echo ""

# Step 1: Stop all running containers
echo "📦 Step 1: Stopping all running containers..."
if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -aq)
    echo "✅ All containers stopped"
else
    echo "ℹ️  No running containers found"
fi
echo ""

# Step 2: Remove all containers
echo "🗑️  Step 2: Removing all containers..."
if [ "$(docker ps -aq)" ]; then
    docker rm $(docker ps -aq)
    echo "✅ All containers removed"
else
    echo "ℹ️  No containers found"
fi
echo ""

# Step 3: Remove all images
echo "🖼️  Step 3: Removing all images..."
if [ "$(docker images -aq)" ]; then
    docker rmi $(docker images -aq) --force
    echo "✅ All images removed"
else
    echo "ℹ️  No images found"
fi
echo ""

# Step 4: Remove all volumes
echo "💾 Step 4: Removing all volumes..."
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q)
    echo "✅ All volumes removed"
else
    echo "ℹ️  No volumes found"
fi
echo ""

# Step 5: Remove all custom networks
echo "🌐 Step 5: Removing all custom networks..."
CUSTOM_NETWORKS=$(docker network ls -q --filter type=custom)
if [ -n "$CUSTOM_NETWORKS" ]; then
    docker network rm $CUSTOM_NETWORKS
    echo "✅ All custom networks removed"
else
    echo "ℹ️  No custom networks found"
fi
echo ""

# Step 6: Remove all build cache
echo "🧹 Step 6: Removing all build cache..."
docker builder prune -af
echo "✅ All build cache removed"
echo ""

# Step 7: Final cleanup
echo "🔄 Step 7: Final system cleanup..."
docker system prune -af --volumes
echo "✅ Final cleanup completed"
echo ""

# Step 8: Verify clean state
echo "📊 Step 8: Verifying clean state..."
echo ""
docker system df
echo ""

echo "🎉 Docker reset completed successfully!"
echo ""
echo "📈 Summary:"
echo "   - Containers: $(docker ps -aq | wc -l | tr -d ' ') remaining"
echo "   - Images: $(docker images -aq | wc -l | tr -d ' ') remaining"
echo "   - Volumes: $(docker volume ls -q | wc -l | tr -d ' ') remaining"
echo "   - Custom Networks: $(docker network ls -q --filter type=custom | wc -l | tr -d ' ') remaining"
echo ""
echo "✨ Docker is now in a completely clean state!"