# Tomcat Application Deployment to Linode using Docker

This guide provides instructions on how to deploy your Java web application (`SNP-WIP.war`) using Tomcat on your Linode instance with Docker. It assumes you have already set up MS SQL Server as per `README_DATABASE_MIGRATION.md`.

## Prerequisites

1.  **Linode Instance Prepared:**
    *   Your Linode instance is provisioned and configured (as per `linode_setup_manual_steps.md`).
    *   Docker and Docker Compose are installed.
2.  **MS SQL Server Deployed:**
    *   The MS SQL Server container (`mssql-server`) is running on Linode.
    *   Your database (e.g., `SNP_WIP`) has been successfully restored (as per `README_DATABASE_MIGRATION.md`).
3.  **Application Artifacts:**
    *   You have your application's WAR file: `SNP-WIP.war`.
    *   You have the Tomcat context XML file: `SNP-WIP.xml` (typically found in `deploy-artifacts/SNP-WIP.xml` in your source repository).
4.  **Docker Compose File for Application:**
    *   You should have the `docker-compose.app.yml` file in your current directory on the Linode instance.

## Configuration: `SNP-WIP.xml` (Crucial Step!)

Before deploying, you **must** modify the `SNP-WIP.xml` file to correctly connect to the MS SQL Server instance running in Docker on your Linode.

1.  **Locate and Copy:**
    *   Find your original `SNP-WIP.xml` file.
    *   Create a copy of it. This copy will be modified and used for the Linode deployment.
2.  **Modify the Database Connection URL:**
    *   Open the copied `SNP-WIP.xml` file with a text editor.
    *   Look for the `<Parameter>` element with the `name="VGS-DB_url"`.
    *   Its `value` attribute will look something like this:
        `jdbc:sqlserver://snapp-mssql;DatabaseName=SNP_WIP;encrypt=true;trustServerCertificate=true;`
    *   **Change the hostname:** Modify `snapp-mssql` (or whatever hostname was used previously) to `mssql-server`. This is the service name defined in `docker-compose.mssql.yml` and is resolvable on the shared Docker network `snapp-network`.
    *   The updated URL should look like:
        `jdbc:sqlserver://mssql-server;DatabaseName=SNP_WIP;encrypt=true;trustServerCertificate=true;`
3.  **Modify the Database Password:**
    *   Look for the `<Parameter>` element with the `name="VGS-DB_password"`.
    *   Its `value` attribute will likely be a placeholder like `P@ssw0rd`.
    *   **Change the password:** Replace this placeholder with the **actual strong `SA_PASSWORD`** you configured in `docker-compose.mssql.yml` when setting up the MS SQL Server.
4.  **Save the modified `SNP-WIP.xml` file.**

## Deployment Steps

1.  **Create Deployment Directory on Linode:**
    *   On your Linode instance, create a directory to hold your application artifacts. This guide uses `./app-deploy` relative to where `docker-compose.app.yml` is located. You can choose a different path like `/opt/snapp/app-deploy/` if you prefer, but ensure you update the volume paths in `docker-compose.app.yml` accordingly.
    *   If using the relative path, in the same directory as `docker-compose.app.yml`, run:
        ```bash
        mkdir app-deploy
        ```
2.  **Place Artifacts in `app-deploy`:**
    *   Upload your application's WAR file (`SNP-WIP.war`) into the `./app-deploy` directory on your Linode.
    *   Upload the **modified** `SNP-WIP.xml` file (with the updated database URL and password) into the `./app-deploy` directory on your Linode.
3.  **Start the Tomcat Application Container:**
    *   Navigate to the directory where `docker-compose.app.yml` is located.
    *   Run the following command:
        ```bash
        docker compose -f docker-compose.app.yml up -d
        ```
        This will download the Tomcat image (if not already present) and start the application container in detached mode (`-d`).
4.  **Verify the Container is Running:**
    ```bash
    docker ps
    ```
    You should see `tomcat-app-linode` (or the name you specified) in the list of running containers.

## Accessing the Application

*   Once Tomcat starts and deploys the `SNP-WIP.war` file (which can take a minute or two), you should be able to access your application at:
    `http://<your_linode_public_ip>:8080/SNP-WIP`
    Replace `<your_linode_public_ip>` with the actual public IP address of your Linode instance.

## Networking Configuration

*   The `docker-compose.app.yml` and `docker-compose.mssql.yml` files are configured to use a shared Docker bridge network called `snapp-network`.
*   This allows the `tomcat-app` service to resolve and connect to the `mssql-server` service using its name (`mssql-server`) directly, as configured in the modified `SNP-WIP.xml`.
*   When you run `docker compose -f docker-compose.mssql.yml up -d` and then `docker compose -f docker-compose.app.yml up -d` (or vice-versa), Docker will either create the `snapp-network` (if it's the first compose operation defining it) or attach the services to the existing `snapp-network`.

## Troubleshooting

*   **Check Tomcat Logs:** If the application doesn't deploy or you encounter errors:
    ```bash
    docker logs tomcat-app-linode
    ```
    Look for errors related to database connectivity, class loading, or context initialization.
*   **Verify `SNP-WIP.xml`:**
    *   Double-check that the `VGS-DB_url` points to `mssql-server`.
    *   Ensure the `VGS-DB_password` is correct.
    *   Confirm the modified `SNP-WIP.xml` was correctly placed in the `./app-deploy` directory (or your chosen path) and that this path matches the volume mapping in `docker-compose.app.yml`.
*   **Verify `SNP-WIP.war`:**
    *   Ensure `SNP-WIP.war` is correctly placed in the `./app-deploy` directory.
*   **Firewall:**
    *   Confirm your Linode's firewall (e.g., `ufw`) allows traffic on port 8080 (for Tomcat) and port 1433 (for MS SQL Server, if you need to connect to it directly from outside Linode for any reason). The `linode_setup_manual_steps.md` should cover this.
*   **Database Connectivity from within Tomcat container (Advanced):**
    If you suspect network issues between Tomcat and SQL Server:
    ```bash
    docker exec -it tomcat-app-linode /bin/bash
    # Once inside the container, try to ping the mssql-server
    # apt-get update && apt-get install -y iputils-ping (if ping is not available)
    ping mssql-server
    # You can also try to establish a connection using a simple tool if available/installable
    exit
    ```

By following these steps, your SnApp application should be successfully deployed on Linode and connected to your MS SQL Server database.
