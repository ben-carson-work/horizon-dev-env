# CI/CD and Deployment on Linode

This document discusses options for Continuous Integration/Continuous Deployment (CI/CD) for the SnApp application on a Linode server and explains the usage of the provided `deploy_on_linode.sh` script.

## CI/CD Options for Linode

When deploying to a single Linode instance, several CI/CD strategies can be adopted, ranging in complexity:

1.  **A. Adapt Existing Jenkins Setup (Complex):**
    *   **Concept:** Modify the current Jenkins pipeline (`Jenkinsfile`) to add a new stage that handles deployment to Linode.
    *   **Implementation:** This would involve Jenkins SSHing into the Linode server, transferring artifacts (like `SNP-WIP.war` and the modified `SNP-WIP.xml`), and then running deployment commands (similar to those in `deploy_on_linode.sh` or directly using `docker compose`).
    *   **Pros:** Fully automated, integrates with existing CI.
    *   **Cons:** Can be complex to set up securely (SSH keys, credentials management), requires Jenkins to have network access to Linode, and might be overkill for a single server if not already heavily invested in Jenkins for deployment.

2.  **B. Script-Based Deployment (Provided Approach - Simpler):**
    *   **Concept:** Use a shell script (`deploy_on_linode.sh`) directly on the Linode server to manage the application and database containers.
    *   **Implementation:** The script handles stopping, starting, and checking services. Artifacts (`SNP-WIP.war`, `SNP-WIP.xml`) are manually or semi-manually placed on the server before running the script.
    *   **Pros:** Simple to understand and implement, good control over the deployment steps on the server, minimal external dependencies.
    *   **Cons:** Requires manual/semi-manual steps for artifact transfer and configuration. Not fully automated "push-button" deployment from CI.

3.  **C. Git-Based Deployment (Simple Alternative):**
    *   **Concept:** Set up a bare Git repository on the Linode server. A `post-receive` Git hook script is triggered when changes are pushed to this repository. This hook script can then check out the files and run deployment commands.
    *   **Implementation:** Developers push code to a specific branch on the Linode Git remote. The hook script builds the project (if necessary, or fetches pre-built artifacts) and restarts services.
    *   **Pros:** Simple "git push to deploy" workflow.
    *   **Cons:** Requires setting up a Git server on Linode, build process might need to be handled on Linode (can be resource-intensive) or artifacts still need to be managed.

For this migration, we are providing `deploy_on_linode.sh` (Option B) as a starting point for a manageable deployment process.

## Explaining `deploy_on_linode.sh`

The `deploy_on_linode.sh` script is designed to simplify the deployment and management of the SnApp application and its MS SQL Server database on your Linode server using Docker Compose.

### Purpose

*   Automate the starting, stopping, and restarting of the Tomcat application (`tomcat-app`) and MS SQL Server (`mssql-server`) containers.
*   Provide basic pre-flight checks for necessary files and directories.
*   Offer a consistent way to bring up the application stack.

### Prerequisites

Before running this script, ensure the following are in place on your Linode server:

1.  **Linode Server Setup:** Fully provisioned with Docker and Docker Compose installed (as per `linode_setup_manual_steps.md`).
2.  **Docker Compose Files:**
    *   `docker-compose.mssql.yml` (configured for Linode, using `snapp-network`).
    *   `docker-compose.app.yml` (configured for Linode, using `snapp-network`).
    These should be in the same directory as the `deploy_on_linode.sh` script, or the paths at the top of the script must be updated.
3.  **Application Artifacts Directory (`./app-deploy/`):**
    *   Create a directory named `app-deploy` in the same location as the script (or update `APP_DEPLOY_DIR` in the script).
    *   Place your compiled Java web application archive `SNP-WIP.war` into this `app-deploy` directory.
    *   Place your **modified** Tomcat context file `SNP-WIP.xml` into this `app-deploy` directory. This file **must** be updated with the correct database connection details for the Linode environment (hostname: `mssql-server`, and the correct SA password) as detailed in `README_APPLICATION_DEPLOYMENT.md`.
4.  **Database State:**
    *   For initial deployment: The database does not need to exist; the script can start the `mssql-server` container. You will still need to perform the database restoration process as outlined in `README_DATABASE_MIGRATION.md` *after* the `mssql-server` is up and running for the first time.
    *   For application updates: The `mssql-server` container should ideally be running with the restored database. The script can be configured to not restart the database during application updates.

### How to Use

1.  **Transfer Script:** Upload `deploy_on_linode.sh` to your Linode server (e.g., into a dedicated directory like `/opt/snapp/` or `~/snapp_deploy/`).
2.  **Make Executable:**
    ```bash
    chmod +x deploy_on_linode.sh
    ```
3.  **Run Script:**
    ```bash
    ./deploy_on_linode.sh
    ```
    You can also set the `RESTART_DATABASE` environment variable if needed:
    ```bash
    RESTART_DATABASE=true ./deploy_on_linode.sh # To force database restart
    ```

### Customization

*   **Configuration Variables:** At the top of `deploy_on_linode.sh`, you can modify:
    *   `COMPOSE_MSSQL_FILE`: Path to the MS SQL Docker Compose file.
    *   `COMPOSE_APP_FILE`: Path to the application Docker Compose file.
    *   `APP_DEPLOY_DIR`: Path to the directory containing `SNP-WIP.war` and `SNP-WIP.xml`.
    *   `RESTART_DATABASE`: Set to `true` or `false` to control if the database container is restarted.
*   **Fetching Artifacts:** The current script assumes `SNP-WIP.war` and `SNP-WIP.xml` are manually placed. You can extend the script to fetch these artifacts:
    *   **From a Git repository:** Add `git pull` commands if these files are versioned.
    *   **From a URL:** Use `wget` or `curl` if they are hosted on an artifact repository or server.
    *   **Using SCP:** Add `scp` commands to copy from a build server.
    Example placeholder:
    ```bash
    # ... (in the script before pre-flight checks for WAR/XML)
    # echo "Fetching latest artifacts..."
    # scp user@buildserver:/path/to/SNP-WIP.war $APP_DEPLOY_DIR/
    # scp user@buildserver:/path/to/SNP-WIP.xml $APP_DEPLOY_DIR/ # Ensure this is the Linode-specific XML
    ```

## Manual Steps Still Required

It's important to understand that `deploy_on_linode.sh` automates the Docker aspects but **does not** cover the entire CI/CD pipeline:

1.  **Building `SNP-WIP.war`:** You still need a process (e.g., your local development environment, a Jenkins build job) to compile your Java application and produce the `SNP-WIP.war` file.
2.  **Configuring `SNP-WIP.xml`:** The `SNP-WIP.xml` file must be correctly configured with the Linode database details (hostname `mssql-server`, the correct SA password) *before* it's placed in the `app-deploy` directory. This might involve maintaining a separate version of this file for Linode or a templating mechanism.
3.  **Transferring Artifacts:** The `SNP-WIP.war` and the correctly configured `SNP-WIP.xml` must be transferred to the `app-deploy` directory on the Linode server before running the script (unless you customize the script to fetch them).

## Future Enhancements

The `deploy_on_linode.sh` script can be further enhanced:

*   **Integration with a Build Server:** Trigger the script remotely from Jenkins (or another CI tool) after artifacts are built and transferred.
*   **Automated Artifact Fetching:** Implement `scp`, `rsync`, `wget`, or `git pull` within the script to automatically retrieve the latest `SNP-WIP.war` and `SNP-WIP.xml` (ensure the XML is the correct one for Linode).
*   **More Sophisticated Health Checks:** Instead of just `docker ps`, add checks that query application endpoints or database status.
*   **Rollback Capabilities:** Add logic to revert to a previous version if a deployment fails.
*   **Secrets Management:** For sensitive data like passwords, integrate with a secrets management tool instead of having them in `SNP-WIP.xml` directly (though Tomcat's context.xml parameters are a common way, consider Docker secrets or environment variables if an alternative is sought).

This script provides a solid foundation for managing your SnApp deployment on Linode. Consider these enhancements as your operational needs evolve.
