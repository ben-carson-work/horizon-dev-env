# Docker Complete Reset Script - PowerShell Version
# This script completely resets Docker to a clean state by removing all containers, images, volumes, networks, and build cache
# WARNING: This will permanently delete ALL Docker data including persistent volumes and configurations

param(
    [switch]$Force
)

# Set error handling
$ErrorActionPreference = "Stop"

Write-Host "🐳 Docker Complete Reset Script" -ForegroundColor Blue
Write-Host "=================================" -ForegroundColor Blue
Write-Host ""
Write-Host "⚠️  WARNING: This will permanently delete ALL Docker data including:" -ForegroundColor Yellow
Write-Host "   - All containers (running and stopped)" -ForegroundColor White
Write-Host "   - All images" -ForegroundColor White
Write-Host "   - All volumes (including persistent data)" -ForegroundColor White
Write-Host "   - All custom networks" -ForegroundColor White
Write-Host "   - All build cache" -ForegroundColor White
Write-Host ""

# Ask for confirmation unless --force flag is used
if (-not $Force) {
    $response = Read-Host "Are you sure you want to proceed? (y/N)"
    if ($response -notmatch '^[Yy]$') {
        Write-Host "❌ Reset cancelled." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "🚀 Starting Docker reset process..." -ForegroundColor Green
Write-Host ""

# Step 1: Stop all running containers
Write-Host "📦 Step 1: Stopping all running containers..." -ForegroundColor Yellow
try {
    $runningContainers = docker ps -q 2>$null
    if ($runningContainers) {
        docker stop $($runningContainers -split "`n" | Where-Object { $_ -ne "" }) 2>$null
        Write-Host "✅ All containers stopped" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No running containers found" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Error stopping containers: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 2: Remove all containers
Write-Host "🗑️  Step 2: Removing all containers..." -ForegroundColor Yellow
try {
    $allContainers = docker ps -aq 2>$null
    if ($allContainers) {
        docker rm $($allContainers -split "`n" | Where-Object { $_ -ne "" }) 2>$null
        Write-Host "✅ All containers removed" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No containers found" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Error removing containers: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 3: Remove all images
Write-Host "🖼️  Step 3: Removing all images..." -ForegroundColor Yellow
try {
    $allImages = docker images -aq 2>$null
    if ($allImages) {
        docker rmi $($allImages -split "`n" | Where-Object { $_ -ne "" }) --force 2>$null
        Write-Host "✅ All images removed" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No images found" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Error removing images: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 4: Remove all volumes
Write-Host "💾 Step 4: Removing all volumes..." -ForegroundColor Yellow
try {
    $allVolumes = docker volume ls -q 2>$null
    if ($allVolumes) {
        docker volume rm $($allVolumes -split "`n" | Where-Object { $_ -ne "" }) 2>$null
        Write-Host "✅ All volumes removed" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No volumes found" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Error removing volumes: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 5: Remove all custom networks
Write-Host "🌐 Step 5: Removing all custom networks..." -ForegroundColor Yellow
try {
    $customNetworks = docker network ls -q --filter type=custom 2>$null
    if ($customNetworks) {
        docker network rm $($customNetworks -split "`n" | Where-Object { $_ -ne "" }) 2>$null
        Write-Host "✅ All custom networks removed" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  No custom networks found" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️  Error removing networks: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 6: Remove all build cache
Write-Host "🧹 Step 6: Removing all build cache..." -ForegroundColor Yellow
try {
    docker builder prune -af 2>$null
    Write-Host "✅ All build cache removed" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Error removing build cache: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 7: Final cleanup
Write-Host "🔄 Step 7: Final system cleanup..." -ForegroundColor Yellow
try {
    docker system prune -af --volumes 2>$null
    Write-Host "✅ Final cleanup completed" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Error during final cleanup: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# Step 8: Verify clean state
Write-Host "📊 Step 8: Verifying clean state..." -ForegroundColor Yellow
Write-Host ""
try {
    docker system df
} catch {
    Write-Host "⚠️  Error getting system info: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

Write-Host "🎉 Docker reset completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📈 Summary:" -ForegroundColor Blue

try {
    $containerCount = (docker ps -aq 2>$null | Measure-Object).Count
    $imageCount = (docker images -aq 2>$null | Measure-Object).Count
    $volumeCount = (docker volume ls -q 2>$null | Measure-Object).Count
    $networkCount = (docker network ls -q --filter type=custom 2>$null | Measure-Object).Count
    
    Write-Host "   - Containers: $containerCount remaining" -ForegroundColor White
    Write-Host "   - Images: $imageCount remaining" -ForegroundColor White
    Write-Host "   - Volumes: $volumeCount remaining" -ForegroundColor White
    Write-Host "   - Custom Networks: $networkCount remaining" -ForegroundColor White
} catch {
    Write-Host "   - Could not retrieve final counts" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✨ Docker is now in a completely clean state!" -ForegroundColor Green