<!-- AI Metadata: This file documents the SQL scripts and database initialization process for the SnApp project.
- Purpose: Provides setup, usage, and troubleshooting instructions for database scripts in this environment.
- Dependencies: Relies on files in sql-scripts/ and integration with the MSSQL container defined in docker-compose.yml.
- Integration: Used by developers, CI/CD agents, and automation scripts to initialize or restore the database.
- Maintainers: DevOps and Database teams, see AI_GUIDELINES.md for update instructions. -->

# SQL Scripts for SnApp Project

This directory contains SQL scripts and supporting files for initializing and restoring the SnApp application's database in the local development environment.

## 📄 Contents

- `init-database.sql`: Main script for creating and initializing the database schema and seed data.
- `entrypoint.sh`: Entrypoint script for running database setup automatically when the MSSQL container starts.

## 🚀 Usage

### Automatic Initialization
- When you start the stack with `docker-compose up -d`, the MSSQL container will automatically execute `entrypoint.sh`, which in turn runs `init-database.sql` to set up the database.

### Manual Execution
- You can manually run the scripts inside the MSSQL container if needed:
  ```bash
  docker exec -it snapp-mssql /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P '<YourPassword>' -i /sql-scripts/init-database.sql
  ```

## 🛠️ Configuration
- The database name, user, and password are defined in `docker-compose.yml` and referenced by the scripts.
- Update `init-database.sql` to modify schema or seed data as needed.

## 🔄 Maintenance
- Update or add scripts here as the database schema evolves.
- Ensure any changes are reflected in both the scripts and the documentation.

## 🐛 Troubleshooting
- Check container logs for errors during initialization:
  ```bash
  docker logs snapp-mssql
  ```
- Ensure the SQL scripts have correct permissions and line endings (LF recommended).

## 📚 Additional Resources
- [DATABASE-SETUP-SUMMARY.md](../DATABASE-SETUP-SUMMARY.md): Overview of the database setup and restoration process.
- [AI_GUIDELINES.md](../AI_GUIDELINES.md): Metadata and documentation standards for this project.
