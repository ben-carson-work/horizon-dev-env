# Jenkins CI/CD for SnApp Project

This directory contains the Jenkins configuration for automated building and deployment of the SnApp Java application from GitHub to your local Tomcat container.

## 🚀 Quick Start

### 1. Start the Complete Stack
```bash
# From the project root directory
docker-compose up -d
```

### 2. Access Jenkins
- **URL**: http://localhost:8081
- **Credentials**: `admin` / `admin123`
- **Blue Ocean**: http://localhost:8081/blue (modern UI)

### 3. Available Pipeline Jobs

Two pipeline jobs are automatically created:

#### **SnApp-GitHub-Pipeline** (Recommended)
- **Purpose**: Complete CI/CD from GitHub source
- **Process**: Checkout → Build → Test → Deploy
- **Trigger**: Manual, GitHub webhooks, or polling
- **Source**: https://github.com/accesso-Horizon/SnApp

#### **SnApp-Local-Pipeline** (Legacy Support)
- **Purpose**: Deploy pre-built WAR file
- **Process**: Validate → Deploy → Test
- **Source**: Local `SNP-WIP.war` file in workspace

## 🔄 Pipeline Workflow

### GitHub Pipeline Process
1. **Checkout**: Clone source from GitHub main branch
2. **Build**: Auto-detect Maven/Gradle and compile
3. **Test**: Run unit tests (configurable)
4. **Package**: Create WAR file
5. **Deploy**: Deploy to Tomcat container
6. **Verify**: Health checks and smoke tests
7. **Notify**: Success/failure notifications

### Local Pipeline Process
1. **Prepare**: Locate and validate local WAR file
2. **Deploy**: Copy to Tomcat webapps directory
3. **Verify**: Ensure successful deployment
4. **Test**: Basic smoke test

## 🛠️ Configuration Details

### Build Tools
- **Maven 3.9**: Auto-installed via Jenkins tools
- **OpenJDK 8**: Auto-installed for Java compilation
- **Docker CLI**: For container operations

### GitHub Integration
- **Repository**: https://github.com/accesso-Horizon/SnApp
- **Branch**: main (configurable)
- **Polling**: Every 5 minutes as backup
- **Webhooks**: Supported for instant builds

### Container Integration
- **Target**: `snapp-tomcat` container
- **Path**: `/usr/local/tomcat/webapps/`
- **Context**: `/SNP-WIP`
- **Network**: `vgsdemonet`

## 📁 File Structure

```
jenkins/
├── Dockerfile                 # Custom Jenkins image with tools
├── jenkins.yaml              # Configuration as Code (CasC)
├── plugins.txt               # Required Jenkins plugins
├── README.md                 # This file
├── jobs/
│   ├── init-jobs.groovy      # Job initialization script
│   └── snapp-pipeline.groovy # Job DSL definition
└── [legacy files removed]
```

## 🔧 Configuration Files

### `Dockerfile`
- **Base**: jenkins/jenkins:lts
- **Tools**: Docker CLI, Maven, Git
- **User**: Root (for Docker socket access)
- **Plugins**: Auto-installed from plugins.txt

### `jenkins.yaml` (Configuration as Code)
- **Auth**: Local users with admin account
- **Tools**: Maven 3.9, OpenJDK 8, Git
- **Security**: Basic authentication
- **Location**: http://localhost:8081

### `plugins.txt`
Essential plugins for CI/CD:
- Pipeline and workflow plugins
- GitHub integration
- Job DSL for job creation
- Blue Ocean for modern UI
- Docker workflow support

### `jobs/snapp-pipeline.groovy` (Job DSL)
Defines both pipeline jobs:
- GitHub-based CI/CD pipeline
- Local WAR deployment pipeline
- Build triggers and parameters

## 🔄 Maintenance

### Updating Jenkins
```bash
# Rebuild Jenkins container with latest image
docker-compose build jenkins
docker-compose up -d jenkins
```

### Adding Plugins
1. Edit `jenkins/plugins.txt`
2. Rebuild Jenkins container
3. New plugins will be auto-installed

### Modifying Jobs
1. Edit `jenkins/jobs/snapp-pipeline.groovy`
2. Rebuild Jenkins container
3. Jobs will be recreated with new configuration

### Backup & Restore
```bash
# Backup Jenkins data
docker cp snapp-jenkins:/var/jenkins_home ./jenkins-backup

# Restore Jenkins data
docker cp ./jenkins-backup snapp-jenkins:/var/jenkins_home
```

## 🐛 Troubleshooting

### Job Creation Issues
```bash
# Check Job DSL logs
docker exec snapp-jenkins cat /var/jenkins_home/logs/tasks/job-dsl-seed.log

# Verify Job DSL syntax
docker exec snapp-jenkins java -jar /usr/share/jenkins/jenkins.war -s http://localhost:8080 groovy /usr/share/jenkins/ref/jobs/snapp-pipeline.groovy
```

### Docker Permission Issues
```bash
# Verify Docker socket access
docker exec snapp-jenkins docker ps

# Fix permissions (if needed)
docker exec snapp-jenkins chmod 666 /var/run/docker.sock
```

### GitHub Connectivity
```bash
# Test GitHub access from Jenkins
docker exec snapp-jenkins git ls-remote https://github.com/accesso-Horizon/SnApp.git

# Check network connectivity
docker exec snapp-jenkins ping github.com
```

## 🔐 Security Notes

⚠️ **Production Considerations**:
- Change default admin password
- Configure proper user management
- Enable HTTPS
- Review plugin security settings
- Restrict Docker socket access
- Use Jenkins secrets for credentials

## 📚 Additional Resources

- **Jenkins Documentation**: https://jenkins.io/doc/
- **Pipeline Syntax**: https://jenkins.io/doc/book/pipeline/
- **Job DSL Reference**: https://jenkinsci.github.io/job-dsl-plugin/
- **Blue Ocean Guide**: https://jenkins.io/doc/book/blueocean/
