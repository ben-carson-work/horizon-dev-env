# Testing and Verification Guide for SnApp on Linode

This guide outlines the steps and checks to perform to test and verify that the SnApp application has been successfully migrated and is functioning correctly on your Linode instance.

## 1. Prerequisites for Testing

Before you begin testing, please ensure the following conditions are met:

*   **Linode Instance Ready:** Your Linode virtual server is provisioned, secured (as per `linode_setup_manual_steps.md`), and you have SSH access.
*   **Docker Installed:** Docker and Docker Compose are installed and operational on the Linode instance.
*   **Database Running:** MS SQL Server is running as a Docker container (e.g., `mssql-server-linode`) on Linode, and your database (e.g., `SNP_WIP`) has been successfully restored from your `.bak` file (as per `README_DATABASE_MIGRATION.md`).
*   **Application Running:** The SnApp application (Tomcat) is running as a Docker container (e.g., `tomcat-app-linode`) on Linode. This requires the `SNP-WIP.war` to be deployed and the `SNP-WIP.xml` context file to be correctly modified with Linode-specific database connection details (as per `README_APPLICATION_DEPLOYMENT.md`).
*   **Deployment Complete:** You have successfully run the `deploy_on_linode.sh` script, or manually started the services using `docker compose -f <file_name> up -d` for both the database and application.
*   **Firewall Configured:** The firewall on your Linode instance (e.g., `ufw`) is configured to allow incoming traffic on the necessary ports (typically port `8080` for Tomcat, unless you have a reverse proxy configured for ports `80/443`).

## 2. Basic Connectivity and Service Checks

Perform these initial checks to ensure the core components are operational:

*   **Check Docker Containers:**
    *   **Command:** Open a terminal on your Linode and run:
        ```bash
        docker ps
        ```
    *   **Expected:** You should see both the MS SQL Server container (e.g., `mssql-server-linode`) and the Tomcat application container (e.g., `tomcat-app-linode`) in the list. Note their `STATUS` (should be "Up"), `PORTS`, and `NAMES`.

*   **Check Application URL:**
    *   **Action:** Open a web browser and navigate to your application's URL. This is typically:
        `http://<your_linode_public_ip>:8080/SNP-WIP`
        (Replace `<your_linode_public_ip>` with your Linode's actual public IP address. Adjust the port and path if your setup differs, e.g., if using a domain name and reverse proxy).
    *   **Expected:** The main page or login page of the SnApp application should load without browser errors (e.g., "This site can’t be reached", 404 Not Found, 500 Internal Server Error).

*   **Check Tomcat Application Logs:**
    *   **Command:** Find your Tomcat container name using `docker ps` (e.g., `tomcat-app-linode`). Then run:
        ```bash
        docker logs tomcat-app-linode
        ```
        (Replace `tomcat-app-linode` if your container has a different name).
    *   **Expected:** Scan the logs for:
        *   Successful deployment messages (e.g., "Deployment of web application archive [/usr/local/tomcat/webapps/SNP-WIP.war] has finished").
        *   Absence of critical startup errors, especially database connection errors (e.g., "Cannot create JDBC driver of class '' for connect URL 'null'"), or Java stack traces indicating failures.
        *   Confirmation that the application context (`/SNP-WIP`) has started successfully.

*   **Check MS SQL Server Logs:**
    *   **Command:** Find your MS SQL Server container name using `docker ps` (e.g., `mssql-server-linode`). Then run:
        ```bash
        docker logs mssql-server-linode
        ```
        (Replace `mssql-server-linode` if your container has a different name).
    *   **Expected:** Look for messages indicating that SQL Server is ready for client connections. Check for any error messages related to database recovery or listener ports.

## 3. Application Functionality Testing

Thoroughly test the features and functionalities of your SnApp application.

*   **Core Features:**
    *   Attempt to log in with valid test user credentials.
    *   If there are different user roles, test with each role.
    *   Execute the primary functions of SnApp:
        *   Test creating new records/data.
        *   Test viewing/reading existing data. Ensure data migrated from the `.bak` file is present and correctly displayed.
        *   Test updating existing records/data.
        *   Test deleting records/data (if applicable).
    *   Test any data submission forms (e.g., contact forms, settings changes).
    *   Test data retrieval features, including search, sorting, and filtering if available.

*   **User Interface (UI) Checks:**
    *   Navigate through various pages of the application.
    *   Verify that all pages load correctly without visual glitches.
    *   Check for any broken links (404 errors) or missing images/CSS.
    *   If the application is designed to be responsive, test it on different screen sizes (or use browser developer tools to simulate).

*   **Specific Test Cases:**
    *   Execute any pre-defined test cases you have for the SnApp application.
    *   Focus on critical paths and business-critical functionalities.
    *   If this is the first time testing after migration, it's wise to be more comprehensive.

## 4. Database Integrity and Connectivity

Ensure the application is interacting correctly with the database.

*   **Verify Data Manipulation:**
    *   Perform actions within the application that are known to write data to the database (e.g., creating a new user, submitting a form).
    *   Verify that this newly written data can be retrieved and is displayed correctly within the application.
    *   Update some data and verify the changes are reflected.
*   **Direct Database Check (Optional but Recommended):**
    *   Connect to the MS SQL Server instance running in Docker on your Linode. You can do this using:
        *   **GUI Tools:** Azure Data Studio or DBeaver from your local machine (connect to `<your_linode_ip>:1433` with SA user and password).
        *   **`sqlcmd` via `docker exec`:**
            ```bash
            docker exec -it mssql-server-linode /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'YourStrongSAPassword'
            # At the 1> prompt, use SQL commands like:
            # USE SNP_WIP;
            # GO
            # SELECT TOP 10 * FROM YourTable ORDER BY LastModifiedDate DESC;
            # GO
            # QUIT
            ```
    *   Run SQL queries to:
        *   Confirm that data written through the application is correctly stored in the tables.
        *   Check data types and constraints if you suspect issues.
        *   Verify that existing data from the migration is intact.
*   **Connection Stability:**
    *   Use the application for an extended session. Navigate through various parts, perform operations, and leave it idle for some time to ensure the database connection remains stable and doesn't drop unexpectedly.

## 5. Deployment Script Verification (`deploy_on_linode.sh`)

Test the provided deployment script to ensure it works for application updates.

*   **Test Application Update/Redeployment:**
    1.  **Prepare a "new" version:** If you have a newer `SNP-WIP.war`, use that. Otherwise, you can simulate an update:
        *   Make a backup of your current `./app-deploy/SNP-WIP.war`.
        *   If you can, make a very minor, visible change to the application (e.g., modify a static text string in a JSP if you can rebuild the WAR quickly). If not, just re-copying the same WAR will at least test the script's mechanics.
    2.  Place the (new or re-copied) `SNP-WIP.war` into the `./app-deploy/` directory on your Linode.
    3.  Run the deployment script:
        ```bash
        ./deploy_on_linode.sh
        ```
        (Ensure `RESTART_DATABASE` is `false` or not set, which is the default, so it only redeploys the app).
    4.  **Expected:**
        *   The script should stop and restart the `tomcat-app` container.
        *   The MS SQL Server container should remain running.
        *   After a brief period, the application should be accessible again.
        *   If you deployed a visibly different version, verify the changes are live.

*   **Test Database Restart Flag (Optional):**
    *   If you need to test the database restart functionality:
        ```bash
        RESTART_DATABASE=true ./deploy_on_linode.sh
        ```
    *   **Expected:** Both `mssql-server` and `tomcat-app` containers should be stopped and then restarted. This will take longer. Verify both services come back up correctly.

## 6. Performance (Basic Check)

This is not a formal performance test but a subjective observation.

*   While using the application, note its general responsiveness.
*   Do pages load reasonably quickly?
*   Are database queries returning results in an acceptable timeframe?
*   If you have experience with the application on its previous platform, compare if the performance feels significantly different (better, worse, or the same). Significant degradation might warrant further investigation into Linode plan resources or application/database tuning.

## 7. Troubleshooting Tips

If you encounter issues during testing:

*   **Check Container Logs:** This is often the first place to look for errors.
    *   `docker logs tomcat-app-linode`
    *   `docker logs mssql-server-linode`
*   **Verify `SNP-WIP.xml` Configuration:**
    *   Ensure the `VGS-DB_url` parameter correctly points to `jdbc:sqlserver://mssql-server;DatabaseName=SNP_WIP;...` (assuming `mssql-server` is the service name on the Docker network).
    *   Double-check that `VGS-DB_password` matches the SA password you set for MS SQL Server.
    *   Confirm the `DatabaseName` parameter is correct.
*   **Check Linode Firewall:**
    *   Ensure your firewall rules allow traffic on the necessary ports (e.g., 8080 for Tomcat).
    *   Command: `sudo ufw status verbose`
*   **Docker Networking:**
    *   Ensure both containers are on the `snapp-network` (or your chosen network name) if you're relying on service name resolution.
    *   Command: `docker network inspect snapp-network` (look under the "Containers" section).
*   **Application-Specific Debugging:** Enable any debugging or verbose logging features within the SnApp application itself, if available.

By systematically going through these testing and verification steps, you can gain confidence that your SnApp application has been successfully migrated to the Linode platform. Remember to adapt application-specific tests to the actual functionality of SnApp.
