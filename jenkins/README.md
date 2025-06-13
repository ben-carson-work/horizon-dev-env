<!-- AI Metadata: This file documents the Jenkins configuration, usage, and integration for the SnApp project.
- Purpose: Provides setup, usage, and troubleshooting instructions for Jenkins in this environment.
- Dependencies: Relies on files in jenkins/jobs/, jenkins/ssh/, and project root scripts.
- Integration: Used by developers and CI/CD agents to configure and operate Jenkins pipelines and jobs.
- Maintainers: DevOps team, see AI_GUIDELINES.md for update instructions. -->

# Jenkins CI/CD for SnApp Project

This directory contains the Jenkins configuration for automated deployment of the SnApp Java application to your local Tomcat container.

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

> **Before running the pipeline jobs:**
> - Ensure you have a `B2B-baseline.bak` (or other `.bak` database backup file) in the `deploy-artifacts/` folder.
> - Ensure you have a `SNP-WIP.war` file in the `deploy-artifacts/` folder.

### 3. Pipeline Jobs Setup

The `SnApp-Local-Pipeline` job is automatically created when Jenkins starts. This is achieved through Jenkins Configuration as Code (JCasC) and Job DSL.

- **JCasC Configuration (`jenkins.yaml`)**: Instructs Jenkins to load Job DSL scripts.
- **Job DSL Script (`jobs/snapp-pipeline.groovy`)**: Defines the `SnApp-Local-Pipeline`.

No manual seed job creation is required for this pipeline. Jenkins processes the DSL script directly on startup.

#### **SnApp-Local-Pipeline**
- **Purpose**: Deploy pre-built WAR file
- **Process**: Validate → Deploy → Test
- **Source**: Local `SNP-WIP.war` file in workspace
- **Trigger**: Manual execution

## 🔄 Pipeline Workflow

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

### Container Integration
- **Target**: `snapp-tomcat` container
- **Path**: `/usr/local/tomcat/webapps/`
- **Context**: `/SNP-WIP`
- **Network**: `vgsdemonet`

## 📁 File Structure

```
jenkins/
├── Dockerfile                 # Custom Jenkins image with tools
├── jenkins.yaml              # Configuration as Code (JCasC)
├── plugins.txt               # Required Jenkins plugins
├── README.md                 # This file
└── jobs/
    ├── snapp-pipeline.groovy # Job DSL definition for SnApp-Local-Pipeline
    ├── job-dsl-seed.groovy   # Legacy/Alternative: Defines a seed job (if used)
    └── SnApp-Local-Pipeline/ # Pipeline job workspace (auto-created by Jenkins)
```
*Note: `job-dsl-seed.groovy` is present but the primary `SnApp-Local-Pipeline` is created directly by JCasC processing `snapp-pipeline.groovy`.*

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
- Job DSL for job creation
- Blue Ocean for modern UI
- Docker workflow support

### `jobs/snapp-pipeline.groovy` (Job DSL)
Defines the local WAR deployment pipeline:
- `SnApp-Local-Pipeline` for local WAR deployment
- Build triggers and parameters (as defined within the script)

## Job DSL and Jenkins Configuration as Code (JCasC)
### What is Job DSL?

**Job DSL** is a Jenkins plugin that lets you define jobs using Groovy code. The `snapp-pipeline.groovy` script uses this plugin's syntax (e.g., `pipelineJob{...}`) to define the pipeline.

### How JCasC Automates Job Creation

Instead of manually creating a "seed job" to process DSL scripts, this project uses **Jenkins Configuration as Code (JCasC)**.
The `jenkins.yaml` file contains a `jobs` section:
```yaml
jobs:
  - file: /usr/share/jenkins/ref/jobs-dsl/snapp-pipeline.groovy
```
This configuration tells Jenkins to:
1. Automatically find the `snapp-pipeline.groovy` script at the specified path within the container.
2. Process this script using the Job DSL plugin.
3. Create or update the jobs defined in the script (i.e., `SnApp-Local-Pipeline`) when Jenkins starts.

This direct JCasC approach streamlines job setup, removing the need for an intermediary seed job for `SnApp-Local-Pipeline`.

The `Dockerfile` ensures that JCasC is active and knows where to find `jenkins.yaml`:
````dockerfile
# ... (other Dockerfile instructions) ...

# Copy initial configuration
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

# Copy Job DSL scripts
COPY --chown=jenkins:jenkins jobs/ /usr/share/jenkins/ref/jobs-dsl/

# Set Jenkins Configuration as Code plugin location
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/jenkins.yaml

# ... (other Dockerfile instructions) ...
````

This way:
1. **JCasC directly processes** `snapp-pipeline.groovy` when Jenkins starts.
2. **Job DSL plugin creates** your pipeline job(s) as defined in the script.

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
1. Edit `jenkins/jobs/snapp-pipeline.groovy` (or other relevant DSL scripts).
2. Rebuild and restart the `snapp-jenkins` container:
   ```bash
   docker-compose build snapp-jenkins
   docker-compose up -d --force-recreate snapp-jenkins
   ```
3. Jobs will be updated by JCasC on startup based on the modified DSL.

### Backup & Restore
```bash
# Backup Jenkins data
docker cp snapp-jenkins:/var/jenkins_home ./jenkins-backup

# Restore Jenkins data
docker cp ./jenkins-backup snapp-jenkins:/var/jenkins_home
```

## 🐛 Troubleshooting

### Job Creation Issues
- **Check Jenkins Startup Logs**: These logs show JCasC processing and Job DSL execution.
  ```bash
  docker logs snapp-jenkins
  ```
- **Verify `jenkins.yaml`**: Ensure the `jobs:` section correctly paths to your `.groovy` files.
- **Validate Job DSL Syntax**: If a job isn't created or updated as expected, there might be a syntax issue in the `.groovy` script. You can use the Jenkins Script Console for testing snippets, or refer to Job DSL plugin documentation.
  A general (but not always perfect) local check for Groovy syntax (not full Job DSL methods):
  ```bash
  # Inside the jenkins container or where groovy is available
  # groovy /usr/share/jenkins/ref/jobs-dsl/snapp-pipeline.groovy
  ```
  For Job DSL specific validation, it's often best to rely on Jenkins processing it.

### Docker Permission Issues
```bash
# Verify Docker socket access
docker exec snapp-jenkins docker ps

# Fix permissions (if needed)
docker exec snapp-jenkins chmod 666 /var/run/docker.sock
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
