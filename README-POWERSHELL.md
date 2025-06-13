# Docker Reset Script - PowerShell Version

Simple PowerShell version of the bash [`reset-environment.sh`](reset-environment.sh) script for Windows 11.

## Usage

### Interactive Mode (Recommended)
```powershell
.\Reset-DockerEnvironment-Simple.ps1
```
- Shows warnings and asks for confirmation
- Safe for manual use

### Force Mode (Automated) 
```powershell
.\Reset-DockerEnvironment-Simple.ps1 -Force
```
- Skips confirmation prompts
- Good for automation/scripts

## What It Does

This script performs the exact same operations as the bash version:

1. **Stop all running containers** - `docker stop`
2. **Remove all containers** - `docker rm` 
3. **Remove all images** - `docker rmi --force`
4. **Remove all volumes** - `docker volume rm`
5. **Remove all custom networks** - `docker network rm`
6. **Remove build cache** - `docker builder prune -af`
7. **Final system cleanup** - `docker system prune -af --volumes`
8. **Verify clean state** - `docker system df`

## Requirements

- Windows 11 (or Windows 10)
- Docker Desktop installed and running
- PowerShell 5.1+ (comes with Windows)

## ⚠️ Warning

**This permanently deletes ALL Docker data including:**
- All containers and images
- All volumes (persistent data)
- All custom networks  
- All build cache

Make sure you have backups of any important data!

## Execution Policy

If you get an execution policy error, run this first:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Differences from Bash Version

- Uses PowerShell syntax instead of bash
- Same visual output with emojis and colors
- Same confirmation and safety features
- Works on Windows with Docker Desktop