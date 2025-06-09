#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be ready
echo "Waiting for SQL Server to start..."
sleep 30

# Keep checking if SQL Server is ready
until /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -C -Q "SELECT 1" &> /dev/null
do
  echo "SQL Server is not ready yet. Waiting..."
  sleep 5
done

echo "SQL Server is ready. Running initialization script..."

# Run the database initialization script
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -C -d master -i /docker-entrypoint-initdb.d/init-database.sql

echo "Database initialization completed."

# Keep the container running by waiting for the SQL Server process
wait