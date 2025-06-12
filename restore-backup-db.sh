#!/bin/bash

# Database Backup Restoration Script
# Usage: ./restore-backup-db.sh <backup-file> [container-name] [sa-password]
# Example: ./restore-backup-db.sh deploy-artifacts/B2B-baseline.bak snapp-mssql P@ssw0rd

set -e  # Exit on any error

# Parameters
BACKUP_FILE="${1:-deploy-artifacts/B2B-baseline.bak}"
CONTAINER_NAME="${2:-snapp-mssql}"
SA_PASSWORD="${3:-P@ssw0rd}"
BACKUP_DIR="/var/opt/mssql/backup"

# Validation
if [ -z "$1" ]; then
    echo "Usage: $0 <backup-file> [container-name] [sa-password]"
    echo "Example: $0 deploy-artifacts/B2B-baseline.bak snapp-mssql P@ssw0rd"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' not found!"
    exit 1
fi

echo "=== Database Backup Restoration ==="
echo "Backup file: $BACKUP_FILE"
echo "Container: $CONTAINER_NAME"
echo "Backup directory: $BACKUP_DIR"

# Check if container is running
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo "Error: Container '$CONTAINER_NAME' is not running!"
    echo "Available containers:"
    docker ps
    exit 1
fi

# Check if backup directory exists, create if it doesn't
echo "Checking backup directory..."
if docker exec -i "$CONTAINER_NAME" test -d "$BACKUP_DIR"; then
    echo "✓ Backup directory already exists"
else
    echo "Creating backup directory..."
    docker exec -i "$CONTAINER_NAME" mkdir -p "$BACKUP_DIR"
    echo "✓ Backup directory created"
fi

# Copy backup file to container
echo "Copying backup file to container..."
docker cp "$BACKUP_FILE" "$CONTAINER_NAME:$BACKUP_DIR/"
BACKUP_FILENAME=$(basename "$BACKUP_FILE")
echo "✓ Backup file copied: $BACKUP_DIR/$BACKUP_FILENAME"

# Get file list from backup to understand the structure
echo "Analyzing backup file structure..."
docker exec -i "$CONTAINER_NAME" /opt/mssql-tools18/bin/sqlcmd -S localhost \
   -U sa -P "$SA_PASSWORD" \
   -C \
   -Q "RESTORE FILELISTONLY FROM DISK = '$BACKUP_DIR/$BACKUP_FILENAME'" \
   -h -1 -s "|" | tr -s ' ' | cut -d '|' -f 1-2

# Extract database name from backup (first logical name typically indicates DB name)
DB_LOGICAL_NAMES=$(docker exec -i "$CONTAINER_NAME" /opt/mssql-tools18/bin/sqlcmd -S localhost \
   -U sa -P "$SA_PASSWORD" \
   -C \
   -Q "RESTORE FILELISTONLY FROM DISK = '$BACKUP_DIR/$BACKUP_FILENAME'" \
   -h -1 -s "|" | cut -d '|' -f 1 | grep -v "^$" | head -4)

echo "Logical file names found:"
echo "$DB_LOGICAL_NAMES"

# For WideWorldImporters backup, use the known structure
# For other backups, this might need to be adjusted
if [[ "$BACKUP_FILENAME" == *"wwi"* ]] || [[ "$BACKUP_FILENAME" == *"WideWorldImporters"* ]]; then
    DB_NAME="WideWorldImporters"
    RESTORE_QUERY="RESTORE DATABASE $DB_NAME FROM DISK = '$BACKUP_DIR/$BACKUP_FILENAME' WITH REPLACE,
    MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImporters.mdf',
    MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImporters_userdata.ndf',
    MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImporters.ldf',
    MOVE 'WWI_InMemory_Data_1' TO '/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1'"
else
    # Generic restore - use SNP-WIP as the target database name
    DB_NAME="SNP-WIP"
    echo "Restoring backup as database '$DB_NAME'"
    
    # Extract logical file names from the backup
    LOGICAL_FILES=($(echo "$DB_LOGICAL_NAMES" | tr '\n' ' '))
    DATA_FILE="${LOGICAL_FILES[0]}"
    LOG_FILE="${LOGICAL_FILES[1]}"
    
    echo "Moving logical files: $DATA_FILE -> $DB_NAME.mdf, $LOG_FILE -> ${DB_NAME}_log.ldf"
    
    # Use proper Linux paths for the container and move logical files dynamically
    RESTORE_QUERY="RESTORE DATABASE [$DB_NAME] FROM DISK = '$BACKUP_DIR/$BACKUP_FILENAME' WITH REPLACE,
    MOVE '$DATA_FILE' TO '/var/opt/mssql/data/$DB_NAME.mdf',
    MOVE '$LOG_FILE' TO '/var/opt/mssql/data/$DB_NAME_log.ldf'"
fi

# Restore the database
echo "Restoring database '$DB_NAME'..."
docker exec -i "$CONTAINER_NAME" /opt/mssql-tools18/bin/sqlcmd \
   -S localhost -U sa -P "$SA_PASSWORD" \
   -C \
   -Q "$RESTORE_QUERY"

if [ $? -eq 0 ]; then
    echo "✓ Database restoration completed successfully"
else
    echo "❌ Database restoration failed"
    exit 1
fi

# Verify restoration by listing databases
echo "Verifying restoration - listing all databases..."
docker exec -i "$CONTAINER_NAME" /opt/mssql-tools18/bin/sqlcmd \
   -S localhost -U sa -P "$SA_PASSWORD" \
   -C \
   -Q "SELECT name FROM sys.databases" \
   -h -1

echo "=== Database Restoration Complete ==="