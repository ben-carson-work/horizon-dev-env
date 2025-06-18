#!/bin/bash

# === Configuration ===
# Adjust these paths if your files are located elsewhere.
# Ensure these paths are correct on your Linode server.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" # Gets the directory where the script is located

COMPOSE_MSSQL_FILE="${SCRIPT_DIR}/docker-compose.mssql.yml"
COMPOSE_APP_FILE="${SCRIPT_DIR}/docker-compose.app.yml"
APP_DEPLOY_DIR="${SCRIPT_DIR}/app-deploy" # Directory containing SNP-WIP.war and SNP-WIP.xml

# WAR and XML file names - typically these don't change.
WAR_FILE="SNP-WIP.war"
XML_FILE="SNP-WIP.xml"

# Control whether to restart the database container.
# Set to 'true' to restart DB, 'false' to leave it running if already up.
# For initial deployment, you might want this true. For app updates, likely false.
RESTART_DATABASE=${RESTART_DATABASE:-false} # Default to false if not set externally

# === Script Start ===
echo "Starting Linode SnApp Deployment Script..."
echo "------------------------------------------"
echo "Configuration:"
echo "  MS SQL Compose File: ${COMPOSE_MSSQL_FILE}"
echo "  App Compose File:    ${COMPOSE_APP_FILE}"
echo "  App Deploy Dir:      ${APP_DEPLOY_DIR}"
echo "  Restart Database:    ${RESTART_DATABASE}"
echo "------------------------------------------"

# === Pre-flight Checks (Optional but Recommended) ===
echo "Performing pre-flight checks..."

if [ ! -f "$COMPOSE_MSSQL_FILE" ]; then
    echo "ERROR: MS SQL Docker Compose file not found at $COMPOSE_MSSQL_FILE"
    exit 1
fi

if [ ! -f "$COMPOSE_APP_FILE" ]; then
    echo "ERROR: Application Docker Compose file not found at $COMPOSE_APP_FILE"
    exit 1
fi

if [ ! -d "$APP_DEPLOY_DIR" ]; then
    echo "ERROR: Application deployment directory not found at $APP_DEPLOY_DIR"
    echo "Please create it and place $WAR_FILE and $XML_FILE inside."
    exit 1
fi

if [ ! -f "$APP_DEPLOY_DIR/$WAR_FILE" ]; then
    echo "ERROR: $WAR_FILE not found in $APP_DEPLOY_DIR"
    exit 1
fi

if [ ! -f "$APP_DEPLOY_DIR/$XML_FILE" ]; then
    echo "ERROR: $XML_FILE not found in $APP_DEPLOY_DIR"
    echo "Ensure this is the MODIFIED version for Linode."
    exit 1
fi
echo "Pre-flight checks passed."
echo "------------------------------------------"

# === Stop Existing Application Service ===
# This ensures a clean start for the application.
# We use --remove-orphans to clean up any containers not defined in the compose file.
echo "Stopping existing application service (if running)..."
docker compose -f "$COMPOSE_APP_FILE" down --remove-orphans
echo "Application service stopped."
echo "------------------------------------------"

# === Handle Database Service ===
if [ "$RESTART_DATABASE" = true ]; then
    echo "Stopping existing database service (if running)..."
    docker compose -f "$COMPOSE_MSSQL_FILE" down --remove-orphans
    echo "Database service stopped."
    echo "------------------------------------------"
    echo "Starting database service..."
    docker compose -f "$COMPOSE_MSSQL_FILE" up -d --remove-orphans
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to start MS SQL Server. Check logs with: docker logs mssql-server-linode"
        exit 1
    fi
    echo "Database service started. Waiting a few seconds for it to initialize..."
    sleep 15 # Give SQL Server some time to be ready, especially on first start
else
    echo "Ensuring database service is running (without restarting)..."
    # Check if mssql-server container is running
    if [ ! "$(docker ps -q -f name=mssql-server-linode)" ]; then
        echo "Database container (mssql-server-linode) not found running. Starting it..."
        docker compose -f "$COMPOSE_MSSQL_FILE" up -d --remove-orphans
        if [ $? -ne 0 ]; then
            echo "ERROR: Failed to start MS SQL Server. Check logs with: docker logs mssql-server-linode"
            exit 1
        fi
        echo "Database service started. Waiting a few seconds for it to initialize..."
        sleep 15
    else
        echo "Database service (mssql-server-linode) is already running."
    fi
fi
echo "Database setup complete."
echo "------------------------------------------"

# === Start Application Service ===
echo "Starting application service..."
# Using --build is generally for when you're building an image from a Dockerfile.
# Since we are deploying a pre-built WAR file placed in a mapped volume,
# simply `up -d` is usually sufficient after `down`.
# --remove-orphans is good practice.
docker compose -f "$COMPOSE_APP_FILE" up -d --remove-orphans
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to start Tomcat application. Check logs with: docker logs tomcat-app-linode"
    exit 1
fi
echo "Application service started."
echo "------------------------------------------"

# === Post-deployment Checks ===
echo "Deployment summary:"
docker ps
echo "------------------------------------------"
echo "To check application logs: docker logs tomcat-app-linode"
echo "To check database logs: docker logs mssql-server-linode"
echo ""
echo "Application should be accessible at http://<your_linode_ip>:8080/SNP-WIP (if everything is correct)."
echo "Deployment script finished."
