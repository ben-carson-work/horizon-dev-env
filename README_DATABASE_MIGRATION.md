# MS SQL Server Database Migration to Linode using Docker

This guide provides instructions on how to set up an MS SQL Server instance using Docker on your Linode and restore your database from a `.bak` backup file.

## Prerequisites

1.  **Linode Instance Prepared:** Ensure your Linode instance is provisioned and configured as per the `linode_setup_manual_steps.md` guide, including Docker and Docker Compose installation.
2.  **Docker Compose File:** You should have the `docker-compose.mssql.yml` file in your current directory on the Linode instance.
3.  **Database Backup File:**
    *   Upload your MS SQL Server database backup file (e.g., `B2B-baseline.bak`) to a directory named `mssql-backup` in the same location where you have `docker-compose.mssql.yml`.
    *   If the `mssql-backup` directory does not exist, create it: `mkdir mssql-backup`.
    *   The `docker-compose.mssql.yml` file is configured to map this `./mssql-backup` directory on your Linode host to `/var/opt/mssql/backup` inside the Docker container.

## Steps to Start MS SQL Server

1.  **Navigate to the Directory:** Open a terminal on your Linode instance and navigate to the directory where you have `docker-compose.mssql.yml` and the `mssql-backup` directory.
2.  **Set a Strong SA Password:**
    *   **CRITICAL:** Open the `docker-compose.mssql.yml` file and change the placeholder `SA_PASSWORD` (e.g., `YourStrongPassword123!`) to a strong, unique password.
    *   Example using `nano`: `nano docker-compose.mssql.yml`. Save the changes.
3.  **Start the MS SQL Server Container:**
    ```bash
    docker compose -f docker-compose.mssql.yml up -d
    ```
    This command will download the MS SQL Server image (if not already present) and start the container in detached mode (`-d`).
4.  **Verify the Container is Running:**
    ```bash
    docker ps
    ```
    You should see `mssql-server-linode` or the name you specified in the list of running containers.
5.  **Check Logs (Optional):**
    If you encounter issues, you can check the logs of the container:
    ```bash
    docker logs mssql-server-linode
    ```
    Wait for a message like "SQL Server is now ready for client connections." before proceeding to restore. This might take a few minutes the first time.

## Database Restoration Steps

You can restore your database using `sqlcmd` within the Docker container or by connecting with a graphical tool like Azure Data Studio or DBeaver.

**Assumed database name:** The following commands assume your application expects the database to be named `SNP_WIP`. If your `.bak` file contains a database with a different name but you want to restore it as `SNP_WIP`, these commands are appropriate. If the `.bak` file already contains `SNP_WIP` and the file paths within the backup match the target paths, the `MOVE` clauses might be optional but are good practice for clarity.

### Option 1: Using `sqlcmd` inside the Docker container

1.  **Access `sqlcmd` in the container:**
    ```bash
    docker exec -it mssql-server-linode /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'YourStrongPassword123!'
    # Replace 'YourStrongPassword123!' with the SA_PASSWORD you set in docker-compose.mssql.yml
    ```
2.  **Run the RESTORE command:**
    At the `1>` prompt, type the following T-SQL command. **Ensure the `.bak` filename matches the one you uploaded.**
    ```sql
    RESTORE DATABASE SNP_WIP
    FROM DISK = '/var/opt/mssql/backup/B2B-baseline.bak'
    WITH MOVE 'SNP_WIP_Data' TO '/var/opt/mssql/data/SNP_WIP.mdf',
    MOVE 'SNP_WIP_Log' TO '/var/opt/mssql/data/SNP_WIP_log.ldf',
    REPLACE;
    GO
    ```
    *   **Explanation:**
        *   `RESTORE DATABASE SNP_WIP`: Specifies the target database name on the new server.
        *   `FROM DISK = '/var/opt/mssql/backup/B2B-baseline.bak'`: Points to the backup file *inside the container*.
        *   `WITH MOVE 'SNP_WIP_Data' TO '/var/opt/mssql/data/SNP_WIP.mdf'`: Specifies the new path for the data file. Replace `SNP_WIP_Data` with the logical name of the data file in your backup if it's different. You can find this using `RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/B2B-baseline.bak';` first.
        *   `MOVE 'SNP_WIP_Log' TO '/var/opt/mssql/data/SNP_WIP_log.ldf'`: Specifies the new path for the log file. Replace `SNP_WIP_Log` with the logical name of the log file if different.
        *   `REPLACE`: Overwrites any existing database with the same name. Use with caution.
3.  **Exit `sqlcmd`:**
    Type `QUIT` and press Enter.

### Option 2: Using a GUI Tool (Azure Data Studio, DBeaver, SSMS)

1.  **Connection Details:**
    *   **Server/Hostname:** Your Linode's public IP address.
    *   **Port:** 1433 (or as mapped in `docker-compose.mssql.yml`).
    *   **Authentication:** SQL Server Authentication.
    *   **Username:** `SA`
    *   **Password:** The strong password you set in `docker-compose.mssql.yml`.
2.  **Connect to the Server:** Use your preferred GUI tool to connect to the MS SQL Server instance.
3.  **Open a New Query Window:**
4.  **Execute the RESTORE command:**
    Paste and execute the same T-SQL `RESTORE` command as shown in Option 1:
    ```sql
    RESTORE DATABASE SNP_WIP
    FROM DISK = '/var/opt/mssql/backup/B2B-baseline.bak'
    WITH MOVE 'SNP_WIP_Data' TO '/var/opt/mssql/data/SNP_WIP.mdf',
    MOVE 'SNP_WIP_Log' TO '/var/opt/mssql/data/SNP_WIP_log.ldf',
    REPLACE;
    ```
    Ensure the backup filename and logical file names are correct for your `.bak` file.

## Important Notes

*   **SA_PASSWORD:** The `SA_PASSWORD` environment variable in `docker-compose.mssql.yml` sets the password for the System Administrator (`SA`) user. **It is critical to change this from the placeholder to a very strong password.**
*   **Database Name:** The application is expected to use a database named `SNP_WIP`. The restore commands above assume this. If your backup is for a database with a different name, or if your application expects a different name, adjust the `RESTORE DATABASE [YourDBName]` command and application configuration accordingly.
*   **Data Persistence:** The `mssql-data` volume mapping (`./mssql-data:/var/opt/mssql`) ensures that your database data persists even if the container is stopped or removed. Do not delete the `./mssql-data` directory on your Linode host unless you intend to lose all database data.
*   **Backup Volume:** The `mssql-backup` volume (`./mssql-backup:/var/opt/mssql/backup`) is used to make the `.bak` file accessible to the SQL Server instance running inside Docker.
*   **Troubleshooting:**
    *   Check Docker container logs: `docker logs mssql-server-linode`
    *   Ensure the Linode firewall (`ufw`) is configured to allow port 1433 (or the port you've mapped).
    *   Verify the `.bak` file was correctly uploaded to the `mssql-backup` directory and that the filename in the `RESTORE` command is exact.
    *   If `RESTORE` fails with errors about file paths or logical names, use `RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/YourBackupFile.bak';` (via `sqlcmd` or GUI tool) to inspect the logical file names and paths stored within your backup file and adjust the `MOVE` clauses accordingly.

After successful restoration, your MS SQL Server database should be running on Linode and accessible to your application.
