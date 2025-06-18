# Horizon SnApp Installation for MacOS
using containers for an ARM platform

This project sets up a complete development environment for the Horizon SnApp application with CI/CD automation. It uses Docker to run:

- **MS SQL Server 2022** (port 1433)
- **Apache Tomcat 9** with Java 8 (port 8080)
- Jenkins CI/CD (port 8081) for the local setup.

## Project Overview

This repository contains the necessary configurations to run the SnApp application in different environments:
1.  **Local Docker Environment:** A quick setup for development and testing on a local machine (macOS focused, but adaptable). This includes MS SQL Server, Tomcat, and Jenkins.
2.  **Linode Server Deployment:** Instructions and tools for deploying SnApp to a Linode VPS using Docker, suitable for staging or production-like environments.

---

## Deployment Environments

### 1. Local Docker Environment (MacOS Focus)

This section details setting up SnApp locally using Docker Compose.

#### Prerequisites (Local)

- Docker and Docker Compose installed on your system
- Git (for source code management)
- Access to the SnApp GitHub repository: https://github.com/accesso-Horizon/SnApp
- Access to the automation testing repository: https://github.com/accesso/horizon-automation

## Project Structure

- `docker-compose.yml`: Orchestrates all containers
- `SNP-WIP.xml`: Tomcat application configuration
- `SNP-WIP.war`: Pre-built application (for local deployment)
- `Jenkinsfile`: Example Jenkinsfile (may not be the primary CI/CD mechanism for the local setup described here; Jenkins jobs are managed by JCasC and Job DSL scripts in the `jenkins/` directory)
- `jenkins/`: Jenkins configuration and setup files, including Job DSL scripts for pipeline creation.

#### Quick Start (Local)

##### 1. Start All Services (Local)
```bash
# From the project root directory
docker-compose up -d
```

This will start:
- **SQL Server** at `localhost:1433` (SA password: `P@ssw0rd`)
- **Tomcat** at `localhost:8080`
- **Jenkins** at `localhost:8081` (admin/admin123)

##### 2. Access Jenkins and Run Pipeline (Local)
1. Open Jenkins at: http://localhost:8081
2. Login with: `admin` / `admin123`
3. You'll see the **SnApp-Local-Pipeline** job automatically created. This job is defined in `jenkins/jobs/snapp-pipeline.groovy` and loaded by Jenkins Configuration as Code (JCasC).
   *(Note: The mention of "SnApp-GitHub-Pipeline" might be from a previous setup or an example `Jenkinsfile`. The primary focus of the automated setup described is the `SnApp-Local-Pipeline` created via JCasC and Job DSL.)*

##### 3. Deploy SnApp (Local)
**Deploy Local WAR (Primary method for this local setup):**
1. Ensure `SNP-WIP.war` is in the project root directory.
2. In Jenkins, click "SnApp-Local-Pipeline".
3. Click "Build Now".

**Option B - Build from GitHub (If a `Jenkinsfile` and corresponding Jenkins job are configured for it):**
If you have a `Jenkinsfile` in your SnApp source code repository and a Jenkins pipeline job configured to use it (e.g., a Multibranch Pipeline or a Pipeline job pointing to SCM):
1. Ensure that job is configured in Jenkins.
2. Trigger that job to: checkout → build → test → deploy.
*(This setup guide primarily focuses on the JCasC-created `SnApp-Local-Pipeline` for deploying a local WAR.)*

##### 4. Configure GitHub SSH Access (First-Time Setup for Local Jenkins with Git)

**⚠️ Required for Automated Testing Pipeline**

The Jenkins pipeline includes automated testing that requires access to the private `horizon-automation` repository. This is a **one-time setup per machine/environment**.

#### When SSH Setup is Required:
- ✅ **First-time setup** (new installation)
- ✅ **New machine/environment** (different developer's machine)
- ✅ **Fresh Docker volumes** (if `jenkins_home` volume is deleted)
- ❌ **NOT required for every build** (SSH keys persist in Jenkins volume)

#### Setup Steps:
```bash
# 1. Generate SSH keys for Jenkins
./setup-github-ssh.sh

# 2. Copy the displayed public key to your clipboard

# 3. Add to GitHub:
#    • Go to GitHub → Settings → SSH and GPG keys
#    • Click "New SSH key"
#    • Paste the public key
#    • Title: "Jenkins SnApp Local"

# 4. Rebuild Jenkins to include SSH keys
docker-compose down
docker-compose build jenkins
docker-compose up -d

# 5. Test SSH connection (optional)
docker exec -it snapp-jenkins ssh -T git@github.com
```

###### Skip SSH Setup (Alternative for Local Jenkins):
If you want to skip automated testing temporarily (which requires GitHub access), you can comment out the "Smoke Test" stage in `jenkins/jobs/snapp-pipeline.groovy`.

**✨ Note (Local Jenkins):** SSH keys are automatically mounted to the correct location within the `snapp-jenkins` container - no manual configuration needed beyond the setup script!

##### 5. Access the Application (Local)
After successful deployment via Jenkins: http://localhost:8080/SNP-WIP

#### CI/CD Pipeline Features (for `SnApp-Local-Pipeline` in Local Environment)

##### Local Deployment Focus
- **Automated Job Creation**: `SnApp-Local-Pipeline` is created automatically on Jenkins startup via JCasC and Job DSL.
- **Manual Trigger**: Designed for manual triggering to deploy the `SNP-WIP.war` from the local workspace.
- **Deployment Process**: Copies the local WAR to the Tomcat container.

*(Features like GitHub integration, automatic builds from main branch, webhook support, etc., would typically be part of a separate pipeline job configured to use SCM, like a `Jenkinsfile` in the SnApp repository, which is distinct from the `SnApp-Local-Pipeline` described here.)*

#### Build Process (as performed by `SnApp-Local-Pipeline` in Local Environment)
- **Pre-built WAR**: Assumes `SNP-WIP.war` is already built and present in the root directory for local deployment.
- **No Compilation**: This specific pipeline (`SnApp-Local-Pipeline`) does not compile Java source code; it deploys an existing artifact.

#### Deployment (by `SnApp-Local-Pipeline` in Local Environment)
- **Automated deployment** of the local `SNP-WIP.war` to the `snapp-tomcat` container.
- **Health checks** and verification (as defined in the pipeline script if configured).

#### Container Details (Local Environment)

### SQL Server (`snapp-mssql`)
- **Image**: mcr.microsoft.com/mssql/server:2022-latest
- **Port**: 1433
- **Database**: SNP_WIP
- **SA Password**: P@ssw0rd

### Tomcat (`snapp-tomcat`)
- **Image**: tomcat:9.0-jdk8-temurin
- **Port**: 8080
- **Memory**: 4GB-6GB allocated
- **App Context**: /SNP-WIP

### Jenkins (`snapp-jenkins`)
- **Image**: Custom (based on jenkins/jenkins:lts)
- **Port**: 8081
- **Features**: Docker-in-Docker, Maven, Job DSL, Configuration as Code (JCasC)
- **Job Automation**: `SnApp-Local-Pipeline` is auto-created via JCasC processing `jenkins/jobs/snapp-pipeline.groovy`.
- **Volume**: Persistent storage for jobs and configs

#### Stopping the Containers (Local Environment)

To stop the local Docker Compose services:

```bash
docker-compose down
```

#### Accessing the Application (Local Environment)

- The application will be available at: [http://localhost:8080/SNP-WIP/admin](http://localhost:8080/SNP-WIP/admin) (or `/SNP-WIP` depending on your entry point).
- The local database can be accessed at `localhost:1433` using the following credentials:
  - **Username:** `sa`
  - **Password:** `P@ssw0rd`

#### Monitoring Tomcat Container Logs (Local Environment)
To monitor logs from the `snapp-tomcat` container:
*   For real-time application-specific logs (replace date with current date):
    `docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/localhost.YYYY-MM-DD.log`
*   For the last 50 lines of that log:
    `docker exec snapp-tomcat tail -n 50 /usr/local/tomcat/logs/localhost.YYYY-MM-DD.log`
*   For access logs (replace date):
    `docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/localhost_access_log.YYYY-MM-DD.txt`
*   For Tomcat's main `catalina.out` logs (replace date):
    `docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/catalina.YYYY-MM-DD.log`
    (Alternatively, `docker logs snapp-tomcat` will show `catalina.out` streams)

#### Notes (Local Environment)

- The `SNP-WIP.xml` file is copied to the Tomcat container during Jenkins deployment at `/usr/local/tomcat/conf/Catalina/localhost/SNP-WIP.xml`.
- The database name is set to `SNP_WIP` and is **automatically created** when the SQL Server container starts.
- Database initialization is handled by custom scripts in the `sql-scripts/` directory.

#### Database Initialization (Local Environment)

The SQL Server container for the local environment (`snapp-mssql`) includes automatic database creation functionality:

### Files Created
- `sql-scripts/init-database.sql`: SQL script that creates the SNP_WIP database
- `sql-scripts/entrypoint.sh`: Custom entrypoint script that initializes the database on container startup
- `test-database.sh`: Test script to verify database creation

### How It Works
1. When the SQL Server container starts, it uses the custom entrypoint script
2. The script waits for SQL Server to be ready
3. It then executes the initialization SQL script to create the SNP_WIP database
4. The database is ready for the application to connect

### Testing Database Creation
To verify the database was created successfully:
```bash
./test-database.sh
```

This will check if the SNP_WIP database exists and list all available databases.

#### Advanced Features (Local Jenkins)

##### GitHub Webhooks
To enable automatic builds on code changes (if you have a Jenkins job configured for SCM polling or webhooks):
1. In your SnApp GitHub repository settings, go to Webhooks.
2. Add webhook URL: `http://<your_ngrok_or_public_ip>:8081/github-webhook/` (Jenkins needs to be accessible from GitHub).
3. Select "Push events" and "Pull request events".

##### Blue Ocean Interface
Access the modern Jenkins UI at: http://localhost:8081/blue

##### Pipeline Monitoring
- **Build History**: View all builds in the Jenkins dashboard.
- **Console Output**: Click on build numbers for detailed logs.
- **Pipeline Visualization**: Use Blue Ocean for a visual representation of pipeline status.

#### Troubleshooting (Local Environment)

##### Common Issues

**Jenkins Pipeline Fails:**
```bash
# Check Jenkins logs
docker logs snapp-jenkins

# Verify Docker access from Jenkins
docker exec snapp-jenkins docker ps

# Check workspace permissions
docker exec snapp-jenkins ls -la /workspace
```

**SSH/GitHub Access Issues:**
```bash
# Test SSH connection to GitHub
docker exec -it snapp-jenkins ssh -T git@github.com

# Check if SSH keys exist in container
docker exec snapp-jenkins ls -la /root/.ssh/

# Verify SSH key permissions
docker exec snapp-jenkins ls -la /root/.ssh/id_rsa

# Test Git clone manually
docker exec -it snapp-jenkins git clone git@github.com:accesso/horizon-automation.git /tmp/test-clone

# Check SSH configuration
docker exec snapp-jenkins cat /root/.ssh/config
```

**Smoke Test Stage Failures:**
```bash
# Regenerate SSH keys if needed
./setup-github-ssh.sh
docker-compose build jenkins && docker-compose up -d jenkins

# Or skip automation tests temporarily (comment out Smoke Test stage)
# Edit jenkins/jobs/snapp-pipeline.groovy and comment out lines 139-195
```

**Build Failures:**
```bash
# Check if GitHub repository is accessible
git clone https://github.com/accesso-Horizon/SnApp.git

# Verify Maven/Java tools in Jenkins
docker exec snapp-jenkins mvn --version
docker exec snapp-jenkins java -version
```

**Tomcat Deployment Issues:**
```bash
# Check Tomcat logs
docker logs snapp-tomcat
docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/catalina.out

# Verify WAR deployment
docker exec snapp-tomcat ls -la /usr/local/tomcat/webapps/
```

**SQL Server Connection Issues:**
```bash
# Test SQL Server connectivity
docker exec snapp-mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "P@ssw0rd" -C -Q "SELECT @@VERSION"

# Check SQL Server logs
docker logs snapp-mssql
```

### Container Management
```bash
# Restart specific service
docker-compose restart jenkins
docker-compose restart tomcat

# Rebuild Jenkins with new configuration
docker-compose build jenkins
docker-compose up -d jenkins

# View all container status
docker-compose ps
```

---

### 2. Linode Server Deployment

This section describes deploying the SnApp application to a Linode Virtual Private Server (VPS) using Docker. This is suitable for creating a staging, UAT, or production-like environment.

#### Overview of the Linode Deployment Process

1.  **Provision and Configure Linode Instance:** Manually set up the Linode server, install Docker, and perform initial security configurations.
2.  **Migrate the Database:** Set up MS SQL Server in Docker on Linode and restore your database from a backup.
3.  **Deploy the Application:** Configure and deploy the SnApp application (WAR file) to Tomcat running in Docker on Linode.
4.  **Automated Deployment Script:** Use a shell script to manage and streamline the deployment process on Linode.
5.  **Testing and Verification:** Perform thorough testing to ensure the application is working correctly.

#### Detailed Steps for Linode Deployment

##### 1. Provision Linode & Initial Setup
*   **Action:** Create a Linode account, provision a Linode instance (e.g., Ubuntu 22.04 LTS), perform initial security hardening (create user, configure SSH, firewall), and install Docker and Docker Compose.
*   **Guide:** For detailed step-by-step instructions, refer to:
    *   [`linode_setup_manual_steps.md`](./linode_setup_manual_steps.md)

##### 2. Database Setup on Linode
*   **Goal:** Run an MS SQL Server instance in a Docker container on your Linode and restore your application's database.
*   **Configuration:** Uses `docker-compose.mssql.yml` to define the MS SQL Server service.
*   **Process:**
    1.  Upload your database backup (`.bak` file, e.g., `B2B-baseline.bak`) to the `mssql-backup` directory on your Linode (e.g., `./mssql-backup/B2B-baseline.bak`).
    2.  **Crucially, set a strong SA_PASSWORD** in `docker-compose.mssql.yml` before starting the service.
    3.  Start the MS SQL Server container and then restore the database from the backup file.
*   **Guide:** For detailed instructions, refer to:
    *   [`README_DATABASE_MIGRATION.md`](./README_DATABASE_MIGRATION.md)

##### 3. Application Deployment on Linode
*   **Goal:** Run the SnApp application (`SNP-WIP.war`) in a Tomcat Docker container on your Linode.
*   **Configuration:** Uses `docker-compose.app.yml` to define the Tomcat service. This is configured to network with the MS SQL Server container.
*   **Process:**
    1.  Obtain your `SNP-WIP.war` application file.
    2.  **Crucially, create a copy of your `SNP-WIP.xml` (Tomcat context file) and modify it for the Linode environment.** The `VGS-DB_url` parameter must be updated to point to the Dockerized MS SQL Server (e.g., `jdbc:sqlserver://mssql-server;DatabaseName=SNP_WIP;...`) and `VGS-DB_password` must be set to the strong SA password you configured for the MS SQL Server on Linode.
    3.  Place the `SNP-WIP.war` and the **modified** `SNP-WIP.xml` into the `./app-deploy` directory on your Linode.
*   **Guide:** For detailed instructions on configuration and deployment, refer to:
    *   [`README_APPLICATION_DEPLOYMENT.md`](./README_APPLICATION_DEPLOYMENT.md)

##### 4. Running the Application on Linode (Deployment Script)
*   **Tool:** The `deploy_on_linode.sh` script is provided to automate the process of starting, stopping, and updating the application and database services on Linode.
*   **Usage:** After placing the Docker Compose files and application artifacts (`.war`, `.xml`) in their respective locations, run this script to manage the services.
*   **Guide:** For details on using the script, its prerequisites, customization, and general CI/CD considerations for Linode, refer to:
    *   [`README_CICD_LINODE.md`](./README_CICD_LINODE.md)

##### 5. Testing and Verification on Linode
*   **Goal:** Ensure the migrated application is functioning correctly, data is intact, and services are stable.
*   **Process:** Follow a structured testing plan covering basic connectivity, application features, database interaction, and deployment script verification.
*   **Guide:** For a comprehensive checklist and testing procedures, refer to:
    *   [`TESTING_VERIFICATION_GUIDE.md`](./TESTING_VERIFICATION_GUIDE.md)

#### Key Artifacts for Linode Deployment

The following files have been created to support the Linode deployment process:

*   `linode_setup_manual_steps.md`: Manual guide for initial Linode instance provisioning and setup.
*   `docker-compose.mssql.yml`: Docker Compose file for running MS SQL Server on Linode.
*   `docker-compose.app.yml`: Docker Compose file for running the Tomcat application (SnApp) on Linode.
*   `README_DATABASE_MIGRATION.md`: Instructions for setting up and migrating the database to MS SQL Server on Linode.
*   `README_APPLICATION_DEPLOYMENT.md`: Instructions for configuring and deploying the SnApp application to Tomcat on Linode.
*   `deploy_on_linode.sh`: A shell script to automate deployment tasks on the Linode server.
*   `README_CICD_LINODE.md`: Discusses CI/CD options for Linode and explains the usage of the deployment script.
*   `TESTING_VERIFICATION_GUIDE.md`: A comprehensive guide for testing the migrated application on Linode.

#### Important Considerations for Linode

*   **Security:**
    *   Always use strong, unique passwords, especially for the `SA` account of MS SQL Server.
    *   Keep your Linode system and packages updated (`apt update && apt upgrade`).
    *   Ensure your firewall (`ufw`) is configured correctly, only allowing necessary ports (e.g., 22 for SSH, 8080 for Tomcat, or 80/443 if using a reverse proxy).
    *   Utilize SSH key-based authentication for accessing your Linode.
*   **Backups:**
    *   Configure Linode's backup service for your entire instance for disaster recovery.
    *   Implement a strategy for regular database backups from within the MS SQL Server container (e.g., scheduled SQL agent jobs writing backups to the mapped backup volume, which then gets included in Linode's instance backup).
*   **Domain Name and SSL/TLS:**
    *   For any environment beyond basic testing, you should:
        *   Point a domain name (e.g., `snapp.yourcompany.com`) to your Linode's IP address.
        *   Implement SSL/TLS certificates (e.g., using Let's Encrypt) to secure traffic with HTTPS.
        *   This typically involves setting up a reverse proxy like Nginx or Traefik in front of the Tomcat container to handle SSL termination and request routing. These tools can also run in Docker on the same Linode.

---
