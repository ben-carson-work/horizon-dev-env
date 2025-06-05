# Jenkins Dockerfile
FROM jenkins/jenkins:lts

# Switch to root user to install additional packages
USER root

# Install Docker CLI (for Docker-in-Docker scenarios)
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Install Maven (for Java builds)
RUN apt-get install -y maven

# Switch back to jenkins user
USER jenkins

# Copy plugins list and install them
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Copy initial configuration
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

# Copy Job DSL scripts to accessible location (NOT init.groovy.d)
COPY --chown=jenkins:jenkins jobs/ /usr/share/jenkins/ref/jobs-dsl/

# Set Jenkins Configuration as Code plugin location
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/jenkins.yaml

# Set Java options
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dhudson.model.DirectoryBrowserSupport.CSP= -Dpermissive-script-security.enabled=true -Djob-dsl.noSecurity=true"
