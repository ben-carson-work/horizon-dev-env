# Horizon SnApp Installation for MacOS
using containers for an ARM platform

This project sets up a complete development environment for the Horizon SnApp application with CI/CD automation. It uses Docker to run:

- **MS SQL Server 2022** (port 1433)
- **Apache Tomcat 9** with Java 8 (port 8080)
- **Jenkins CI/CD** (port 8081)

## Prerequisites

- Docker and Docker Compose installed on your system
- Git (for source code management)
- Access to the SnApp GitHub repository: https://github.com/accesso-Horizon/SnApp

## Project Structure

- `docker-compose.yml`: Orchestrates all containers
- `SNP-WIP.xml`: Tomcat application configuration
- `SNP-WIP.war`: Pre-built application (for local deployment)
- `Jenkinsfile`: CI/CD pipeline definition
- `jenkins/`: Jenkins configuration and setup files

## Quick Start

### 1. Start All Services
```bash
# From the project root directory
docker-compose up -d
```

This will start:
- **SQL Server** at `localhost:1433` (SA password: `P@ssw0rd`)
- **Tomcat** at `localhost:8080`
- **Jenkins** at `localhost:8081` (admin/admin123)

### 2. Access Jenkins and Run Pipeline
1. Open Jenkins at: http://localhost:8081
2. Login with: `admin` / `admin123`
3. You'll see two pipeline jobs automatically created:
   - **SnApp-GitHub-Pipeline**: Builds from GitHub source
   - **SnApp-Local-Pipeline**: Deploys local WAR file

### 3. Deploy SnApp
**Option A - Build from GitHub (Recommended):**
1. Click "SnApp-GitHub-Pipeline"
2. Click "Build Now"
3. Pipeline will: checkout → build → test → deploy

**Option B - Deploy Local WAR:**
1. Ensure `SNP-WIP.war` is in the project root
2. Click "SnApp-Local-Pipeline"
3. Click "Build Now"

### 4. Access the Application
After successful deployment: http://localhost:8080/SNP-WIP

## CI/CD Pipeline Features

### GitHub Integration
- **Automatic builds** from the main branch
- **Webhook support** for instant builds on code changes
- **Polling backup** every 5 minutes
- **Source code checkout** and compilation

### Build Process
- **Auto-detects** Maven or Gradle projects
- **Compiles** Java source code
- **Runs unit tests** (optional)
- **Packages** WAR file for deployment

### Deployment
- **Automated deployment** to local Tomcat
- **Health checks** and verification
- **Smoke testing** after deployment
- **Rollback support** (removes old versions)

## Container Details

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
- **Features**: Docker-in-Docker, Maven, Job DSL
- **Volume**: Persistent storage for jobs and configs

## Stopping the Containers

To stop the containers:

```bash
docker-compose down
```

## Accessing the Application

- The application will be available at: [http://localhost:8080/SNP-WIP/admin](http://localhost:8080/SNP-WIP/admin)
- The database can be accessed at `localhost:1433` using the following credentials:
  - **Username:** `sa`
  - **Password:** `P@ssw0rd`

## monitoring tomcat container logs
### For real-time application-specific logs
`docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/localhost.2025-05-15.log`
### For last 50 lines of log
`docker exec snapp-tomcat tail -n 50 /usr/local/tomcat/logs/localhost.2025-05-15.log`

### For access logs
`docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/localhost_access_log.2025-05-15.txt`

### For Tomcat main logs
`docker exec snapp-tomcat tail -f /usr/local/tomcat/logs/catalina.2025-05-15.log`

## Notes

- The `SNP-WIP.xml` file is automatically mounted into the Tomcat container at `/usr/local/tomcat/conf/Catalina/localhost/SNP-WIP.xml`.
- The database name is set to `SNP_WIP`.

## Advanced Features

### GitHub Webhooks
To enable automatic builds on code changes:
1. In GitHub repository settings, go to Webhooks
2. Add webhook URL: `http://your-server:8081/github-webhook/`
3. Select "Push events" and "Pull request events"

### Blue Ocean Interface
Access the modern Jenkins UI at: http://localhost:8081/blue

### Pipeline Monitoring
- **Build History**: View all builds in Jenkins dashboard
- **Console Output**: Click on build numbers for detailed logs
- **Pipeline Visualization**: Use Blue Ocean for visual pipeline status

## Troubleshooting

### Common Issues

**Jenkins Pipeline Fails:**
```bash
# Check Jenkins logs
docker logs snapp-jenkins

# Verify Docker access from Jenkins
docker exec snapp-jenkins docker ps

# Check workspace permissions
docker exec snapp-jenkins ls -la /workspace
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
docker exec snapp-mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "P@ssw0rd" -Q "SELECT @@VERSION"

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
