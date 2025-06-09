#!/bin/bash

echo "=== Testing SQL Server Database Creation ==="

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
sleep 5

# Test database creation
echo "Testing database creation..."
docker exec snapp-mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "P@ssw0rd" -C -Q "SELECT name FROM sys.databases WHERE name = 'SNP_WIP'"

if [ $? -eq 0 ]; then
    echo "✅ Database connection test successful!"
    
    # List all databases
    echo "All databases:"
    docker exec snapp-mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "P@ssw0rd" -C -Q "SELECT name FROM sys.databases"
else
    echo "❌ Database connection test failed!"
    echo "Checking SQL Server logs:"
    docker logs snapp-mssql --tail 20
fi