# AI Guidelines for Horizon SnApp Development Environment

This document provides an AI-friendly overview of the repository. Future automation agents or AI assistants can use this file to quickly understand:

1. **Project Structure & Key Files**
   - **deploy-artifacts/**: Contains deployment artifacts (e.g., WAR files, XML configs, database backups).
   - **jenkins/**: Jenkins configuration files, Job DSL scripts, and CI/CD pipeline instructions.
   - **sql-scripts/**: Contains SQL scripts and entrypoint for database initialization and restoration. See [sql-scripts/README.md](sql-scripts/README.md) for details.
   - **README.md**: Main installation and troubleshooting guide.
   - **DATABASE-SETUP-SUMMARY.md**: Documentation covering automatic database creation.

2. **CI/CD & Deployment Workflow**
   - **Jenkins Pipeline**: Defined in `jenkins/jobs/snapp-pipeline.groovy` which deploys the WAR and configuration files.
   - **Database Setup**: SQL Server auto-initializes using scripts in `sql-scripts/`.
   - **SSH & GitHub**: Setup scripts under `jenkins/ssh/` for secure access.

3. **Automation & Testing**
   - **Automated Testing**: Refer to the `Smoke Test` stage in the pipeline for verifying deployments.
   - **Deployment Commands**: Use `docker-compose up -d` and other commands as detailed in the main [README.md](README.md).

4. **AI Metadata Headers**
   - **Purpose**: AI metadata headers provide context and intent for each file, making it easier for both humans and AI agents to understand, maintain, and automate the project.
   - **Placement**: Place the AI metadata header at the very top of the file, immediately after any shebang or license comments (if present).
   - **Format Example**:
     ```groovy
     // filepath: <absolute or project-relative path to this file>
     // AI Metadata: <Short description of the file's role>
     // - Purpose: <What this file does>
     // - Dependencies: <Key files or scripts this depends on>
     // - Integration: <How/where this file is used in the project>
     // - Maintainers: <Team or contact for this file>
     // ...existing code...
     ```
   - **Example (snapp-pipeline.groovy)**:
     ```groovy
     // filepath: /Users/bencarson/dev/projects/horizon-dev-env/jenkins/jobs/snapp-pipeline.groovy
     // AI Metadata: This file defines the primary CI/CD pipeline for the SnApp project.
     // - Purpose: Automates build, test, deployment, and smoke testing for SnApp using Jenkins.
     // - Dependencies: Requires configuration files in the deploy-artifacts folder and supporting scripts in the project root.
     // - Integration: Used by Jenkins Job DSL seed job to create/update the pipeline job.
     // - Maintainers: DevOps team, see AI_GUIDELINES.md for update instructions.
     // ...existing code...
     ```
   - **Update Instructions**:
     - When creating or modifying a key file (scripts, configs, pipelines, major modules), add or update the AI metadata header.
     - Keep the metadata accurate and up to date as the file's purpose or dependencies change.
     - Reference this section for formatting and content guidelines.

5. **Usage Recommendations for AI Systems**
   - When parsing the project, look for the inline comments starting with `// AI Metadata:` or `<!-- AI Metadata:` for context.
   - Use the structured guidelines here to map dependencies and deployment flows.
   - For CI/CD pipelines, refer to the [Jenkins Job DSL](jenkins/jobs/snapp-pipeline.groovy) and [jenkins.yaml](jenkins/jenkins.yaml).

---
*This file is maintained as part of our forward-thinking integration strategy to support future AI automation and documentation generation.*