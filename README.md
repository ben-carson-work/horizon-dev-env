# Horizon SnApp Installation

This project sets up a local development environment for the Horizon SnApp application. It uses Docker to run:

- **MS SQL Server 2019**
- **Apache Tomcat 9** with Java 8

## Prerequisites

- Docker and Docker Compose installed on your system.

## Project Structure

- `dockerfile`: Builds the MS SQL Server container.
- `Dockerfile.tomcat`: Builds the Tomcat container.
- `docker-compose.yml`: Orchestrates the containers.
- `snapp_8_12_2_137.war`: The application WAR file.
- `SNP-WIP.xml`: Configuration file for the application.
- `powershell/`: Contains setup scripts for Windows environments.

## Setup Instructions

1. Clone this repository.
2. Ensure Docker is running on your system.
3. Place the latest version of the WAR file in the project root (replace `snapp_8_12_2_137.war` if needed).

## Running the Containers

To build and start the containers:

```bash
docker-compose up --build
```

This will:
- Start the MS SQL Server container (`snapp-mssql`) on port `1433`.
- Start the Tomcat container (`snapp-tomcat`) on port `8080`.

## Stopping the Containers

To stop the containers:

```bash
docker-compose down
```

## Accessing the Application

- The application will be available at: [http://localhost:8080/snapp](http://localhost:8080/snapp)
- The database can be accessed at `localhost:1433` using the following credentials:
  - **Username:** `sa`
  - **Password:** `P@ssw0rd`

## monitoring tomcat container logs
### For real-time application-specific logs
`docker exec tomcatdemo tail -f /usr/local/tomcat/logs/localhost.2025-05-15.log`
### For last 50 lines of log
`docker exec tomcatdemo tail -n 50 /usr/local/tomcat/logs/localhost.2025-05-15.log`

### For access logs
`docker exec tomcatdemo tail -f /usr/local/tomcat/logs/localhost_access_log.2025-05-15.txt`

### For Tomcat main logs
`docker exec tomcatdemo tail -f /usr/local/tomcat/logs/catalina.2025-05-15.log`

## Notes

- The `SNP-WIP.xml` file is automatically mounted into the Tomcat container at `/usr/local/tomcat/conf/Catalina/localhost/SNP-WIP.xml`.
- The database name is set to `SNP_WIP`.
- Ensure the `snapp_8_12_2_137.war` file is up-to-date before starting the containers.

## Troubleshooting

- If the MS SQL Server container shows as `unhealthy`, ensure the `SA_PASSWORD` meets the complexity requirements.
- Check container logs for errors:
  ```bash
  docker logs horizon-mssql
  docker logs horizon-tomcat
  ```# Horizon Dev Env for ARM
