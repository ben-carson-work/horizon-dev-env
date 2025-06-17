# Docker Complete Reset Script Guide

## Overview

The [`reset-environment.sh`](reset-environment.sh) script provides a comprehensive solution for completely resetting Docker to a clean state, equivalent to a fresh Docker installation. This script systematically removes all Docker artifacts including containers, images, volumes, networks, and build cache.

## ⚠️ Critical Warning

**This script permanently deletes ALL Docker data including:**
- All containers (running and stopped)
- All Docker images
- All volumes (including persistent application data)
- All custom networks
- All build cache and temporary files

**Data loss is irreversible. Ensure you have backups of any important data before running this script.**

## Usage

### Interactive Mode (Recommended)
```bash
./reset-environment.sh
```
- Prompts for confirmation before executing
- Safe for manual use
- Displays warnings and requires user acknowledgment

### Force Mode (Automated)
```bash
./reset-environment.sh --force
```
- Skips confirmation prompts
- Suitable for CI/CD pipelines or automated scripts
- **Use with extreme caution**

## Script Operation Flow

### Step 1: Container Management
```bash
docker stop $(docker ps -aq)    # Stop all running containers
docker rm $(docker ps -aq)      # Remove all containers
```

### Step 2: Image Cleanup
```bash
docker rmi $(docker images -aq) --force    # Remove all images (forced)
```

### Step 3: Volume Removal
```bash
docker volume rm $(docker volume ls -q)    # Remove all volumes
```

### Step 4: Network Cleanup
```bash
docker network rm $(docker network ls -q --filter type=custom)    # Remove custom networks
```

### Step 5: Build Cache Cleanup
```bash
docker builder prune -af    # Remove all build cache
```

### Step 6: Final System Cleanup
```bash
docker system prune -af --volumes    # Final comprehensive cleanup
```

### Step 7: Verification
```bash
docker system df    # Display current Docker disk usage (should show zeros)
```

## Expected Results

After successful execution, Docker will be in a completely clean state:

```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          0         0         0B        0B
Containers      0         0         0B        0B
Local Volumes   0         0         0B        0B
Build Cache     0         0         0B        0B
```

Only default Docker networks will remain:
- `bridge` (default bridge network)
- `host` (host networking)
- `none` (null driver)

## Safety Features

### Error Handling
- Uses `set -e` to exit immediately on any command failure
- Checks for existence of Docker objects before attempting removal
- Provides informative messages for empty states

### User Protection
- Interactive confirmation with clear warnings
- Detailed step-by-step progress reporting
- Summary statistics showing final clean state

### Smart Detection
- Detects if containers/images/volumes exist before removal attempts
- Handles edge cases where Docker objects may not be present
- Graceful handling of already-clean Docker installations

## Common Use Cases

### Development Environment Reset
```bash
# When switching between projects or cleaning up after experimentation
./reset-environment.sh
```

### CI/CD Pipeline Cleanup
```bash
# Automated cleanup in build pipelines
./reset-environment.sh --force
```

### Troubleshooting Docker Issues
```bash
# When Docker daemon issues require complete reset
./reset-environment.sh
```

### Disk Space Recovery
```bash
# When Docker has accumulated significant disk usage
./reset-environment.sh
```

## Performance Impact

### Typical Space Recovery
- **Images**: 5-10GB+ (depends on accumulated images)
- **Volumes**: 1-5GB+ (depends on persistent data)
- **Build Cache**: 500MB-2GB+ (depends on build history)
- **Total**: Often 10GB+ recovered

### Execution Time
- **Small environments**: 30-60 seconds
- **Large environments**: 2-5 minutes
- **Time varies with**: Number of images, volume sizes, network complexity

## Prerequisites

### System Requirements
- Docker installed and running
- Bash shell (macOS/Linux)
- Execute permissions on script file

### Permissions
```bash
chmod +x reset-environment.sh    # Make script executable
```

## Troubleshooting

### Script Won't Execute
```bash
# Ensure execute permissions
chmod +x reset-environment.sh

# Check if Docker is running
docker info
```

### Partial Cleanup Issues
```bash
# Manual verification of remaining objects
docker system df
docker ps -a
docker images
docker volume ls
docker network ls
```

### Permission Errors
```bash
# On some systems, may need sudo
sudo ./reset-environment.sh --force
```

## Integration with Other Tools

### Git Integration
Add to `.gitignore` if desired:
```gitignore
# Optionally ignore the reset script in version control
reset-environment.sh
```

### Makefile Integration
```makefile
docker-reset:
	./reset-environment.sh --force

docker-reset-interactive:
	./reset-environment.sh
```

### Package.json Scripts
```json
{
  "scripts": {
    "docker:reset": "./reset-environment.sh --force",
    "docker:reset:interactive": "./reset-environment.sh"
  }
}
```

## Security Considerations

### Data Protection
- **Never run in production environments**
- **Always backup critical data first**
- **Verify environment before execution**

### Access Control
- Keep script in project directories only
- Don't add to system PATH unless intentional
- Consider file permissions for shared systems

## AI Assistant Usage Notes

### For AI Assistants
This script serves as a standardized tool for Docker environment resets. When users request Docker cleanup:

1. **Assessment**: First analyze current Docker state with `docker system df`
2. **Recommendation**: Suggest this script for complete resets
3. **Guidance**: Explain the permanent nature of data loss
4. **Execution**: Guide through appropriate usage mode (interactive vs force)

### Common AI Workflows
```bash
# 1. Assess current state
docker system df

# 2. Recommend reset script
./reset-environment.sh

# 3. Verify clean state
docker system df
```

## Maintenance

### Script Updates
- Update Docker commands as Docker evolves
- Test with new Docker versions
- Enhance error handling based on user feedback

### Version History
- **v1.0**: Initial comprehensive reset functionality
- **Future**: Enhanced error handling, logging options

---

**Remember**: This script is a powerful tool that permanently removes all Docker data. Use responsibly and always ensure you have backups of any important data before execution.