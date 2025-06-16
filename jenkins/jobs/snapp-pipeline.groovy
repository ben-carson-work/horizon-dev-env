// filepath: ./jenkins/jobs/snapp-pipeline.groovy
// AI Metadata: This file defines the primary CI/CD pipeline for the SnApp project.
// - Purpose: Automates build, test, deployment, and smoke testing for SnApp using Jenkins.
// - Dependencies: Requires configuration files in the deploy-artifacts folder and supporting scripts in the project root.
// - Integration: Used by Jenkins Job DSL seed job to create/update the pipeline job.
// - Maintainers: DevOps team, see AI_GUIDELINES.md for update instructions.

// SnApp Pipeline Job DSL Script
// This creates the Jenkins pipeline job automatically

// Local WAR deployment pipeline for SnApp
pipelineJob('SnApp-Local-Pipeline') {
    displayName('SnApp Local WAR Deployment')
    description('Deploy WAR from local workspace to Tomcat with optional database restoration')
    
    // Pipeline parameters
    parameters {
        stringParam('BACKUP_FILE', 'deploy-artifacts/B2B-baseline.bak', 'Database backup file to restore (optional)')
        booleanParam('SKIP_DB_RESTORE', true, 'Skip database restoration step')
        booleanParam('SKIP_UI_TESTS', false, 'Skip UI testing step in smoke test stage')
    }
    
    // Keep build history
    logRotator {
        daysToKeep(2)
        numToKeep(5)
    }
    
    // Pipeline script embedded
    definition {
        cps {
            script('''
pipeline {
    agent any
    
    environment {
        PROJECT_NAME = 'SnApp'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        TOMCAT_CONTAINER = 'snapp-tomcat'
        SQL_CONTAINER = 'snapp-mssql'
        SA_PASSWORD = 'P@ssw0rd'
        ARTIFACT_NAME = 'SNP-WIP'
        WAR_NAME = "${ARTIFACT_NAME}.war"
        XML_NAME = "${ARTIFACT_NAME}.xml"
        WORKSPACE_PATH = '/workspace'
        BACKUP_FILE = "${params.BACKUP_FILE ?: 'deploy-artifacts/B2B-baseline.bak'}"
    }
    
    stages {
        stage('Database Setup') {
            when {
                not {
                    equals expected: true, actual: params.SKIP_DB_RESTORE
                }
            }
            steps {
                echo 'Restoring database from backup...'
                script {
                    sh """
                        echo "=== Database Restoration ==="
                        cd \${WORKSPACE_PATH}
                        
                        # Check if restore script exists
                        if [ -f "restore-backup-db.sh" ]; then
                            # Convert Windows line endings to Unix line endings
                            tr -d '\\r' < restore-backup-db.sh > restore-backup-db.sh.tmp && mv restore-backup-db.sh.tmp restore-backup-db.sh
                            chmod +x restore-backup-db.sh
                            
                            echo "Running database restoration..."
                            echo "- Backup file: \${BACKUP_FILE}"
                            echo "- Container: \${SQL_CONTAINER}"
                            
                            ./restore-backup-db.sh "\${BACKUP_FILE}" "\${SQL_CONTAINER}" "\${SA_PASSWORD}"
                        else
                            echo "restore-backup-db.sh not found, skipping database restoration"
                            echo "WARNING: Application may fail without proper database setup"
                        fi
                    """
                }
            }
        }
        
        stage('Prepare WAR') {
            steps {
                echo 'Preparing existing WAR file for deployment...'
                script {
                    sh """
                        echo "=== Preparing WAR file ==="
                        cd \${WORKSPACE_PATH}
                        
                        if [ -f "deploy-artifacts/\${WAR_NAME}" ]; then
                            echo "Found existing WAR file: deploy-artifacts/\${WAR_NAME}"
                        else
                            echo "ERROR: deploy-artifacts/\${WAR_NAME} not found!"
                            echo "Available files in deploy-artifacts/:"
                            ls -la deploy-artifacts/
                            exit 1
                        fi
                    """
                }
            }
        }
        
        stage('Verify Tomcat') {
            steps {
                echo 'Verifying Tomcat container is running...'
                script {
                    sh """
                        echo "=== Verifying Tomcat Container ==="
                        
                        if docker ps | grep -q \${TOMCAT_CONTAINER}; then
                            echo "✓ Tomcat container is running"
                            docker ps | grep \${TOMCAT_CONTAINER}
                        else
                            echo "ERROR: Tomcat container is not running!"
                            echo "Available containers:"
                            docker ps
                            exit 1
                        fi
                        
                        echo "Checking Tomcat health..."
                        for i in {1..3}; do
                            if docker exec \${TOMCAT_CONTAINER} curl -f -s http://localhost:8080/ > /dev/null; then
                                echo "✓ Tomcat is responding"
                                break
                            else
                                echo "Waiting for Tomcat to be ready... (\\\$i/3)"
                                sleep 5
                            fi
                        done
                    """
                }
            }
        }
        
        stage('Tomcat to SQL Server Connectivity Test') {
            steps {
                echo 'Testing if Tomcat can reach the database...'
                script {
                    sh """
                        echo "=== Tomcat to SQL Server Connectivity Test ==="
                        
                        # Test if Tomcat container can connect to the named database
                        echo "Testing connection from Tomcat to database SNP-WIP..."
                        
                        if docker exec \${TOMCAT_CONTAINER} timeout 10 bash -c "echo > /dev/tcp/\${SQL_CONTAINER}/1433" 2>/dev/null; then
                            echo "✓ Tomcat can reach SQL Server container"
                            
                            # Test actual database connection
                            echo "Testing database 'SNP-WIP' accessibility..."
                            if docker exec \${SQL_CONTAINER} /opt/mssql-tools18/bin/sqlcmd -S \${SQL_CONTAINER} -U SA -P "\${SA_PASSWORD}" -C -d "SNP-WIP" -Q "SELECT DB_NAME() AS [DatabaseName];" 2>/dev/null; then
                                echo "✅ SUCCESS: Tomcat can successfully reach database 'SNP-WIP'"
                            else
                                echo "❌ FAILED: Cannot connect to database 'SNP-WIP'"
                                exit 1
                            fi
                        else
                            echo "❌ FAILED: Tomcat cannot reach SQL Server container"
                            exit 1
                        fi
                    """
                }
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying WAR file to Tomcat container...'
                script {
                    sh """
                        echo "=== Deploying to Tomcat ==="
                        cd \${WORKSPACE_PATH}
                        
                        if [ ! -f "deploy-artifacts/\${WAR_NAME}" ]; then
                            echo "ERROR: Deployment package not found!"
                            exit 1
                        fi
                        
                        echo "Removing old application..."
                        docker exec \${TOMCAT_CONTAINER} rm -f /usr/local/tomcat/webapps/\${WAR_NAME} 2>/dev/null || true
                        docker exec \${TOMCAT_CONTAINER} rm -rf /usr/local/tomcat/webapps/\${ARTIFACT_NAME} 2>/dev/null || true

                        echo "Copying new WAR file..."
                        docker cp deploy-artifacts/\${WAR_NAME} \${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/
                        
                        echo "Verifying WAR file copy..."
                        if ! docker exec \${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/\${WAR_NAME}; then
                            echo "ERROR: WAR file verification failed - file not found in Tomcat webapps!"
                            exit 1
                        fi
                        echo "✓ WAR file copy verified successfully"
                        
                        echo "Copying connection XML file..."
                        docker cp deploy-artifacts/\${XML_NAME} \${TOMCAT_CONTAINER}:/usr/local/tomcat/conf/Catalina/localhost/

                        echo "Verifying XML file copy..."
                        if ! docker exec \${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/conf/Catalina/localhost/\${XML_NAME}; then
                            echo "ERROR: XML file verification failed - file not found in Tomcat conf directory!"
                            exit 1
                        fi
                        echo "✓ XML file copy verified successfully"
                        
                        echo "Waiting for deployment..."
                        sleep 15
                        
                        echo "Verifying deployment..."
                        for i in {1..12}; do
                            if docker exec \${TOMCAT_CONTAINER} ls /usr/local/tomcat/webapps/\${ARTIFACT_NAME} 2>/dev/null; then
                                echo "✓ Application deployed successfully!"
                                docker exec \${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/\${ARTIFACT_NAME}
                                break
                            else
                                echo "Waiting for application to deploy... (\\\$i/12)"
                                sleep 5
                            fi
                        done
                    """
                }
            }
        }
        
        stage('Smoke Test') {
            when {
                not {
                    equals expected: true, actual: params.SKIP_UI_TESTS
                }
            }
            steps {
                echo 'Running automated tests from horizon-automation Git repository...'
                script {
                    sh """
                        echo "=== Running Docker-based Smoke Test ==="
                        
                        # Define automation project details
                        AUTOMATION_REPO="git@github.com:accesso/horizon-automation.git"
                        AUTOMATION_PATH="./horizon-automation"
                        
                        # Clean up any existing automation directory
                        rm -rf "\\\$AUTOMATION_PATH"
                        
                        echo "Cloning horizon-automation repository..."
                        git clone "\\\$AUTOMATION_REPO" "\\\$AUTOMATION_PATH"
                        
                        # Check if clone was successful
                        if [ ! -d "\\\$AUTOMATION_PATH" ]; then
                            echo "ERROR: Failed to clone horizon-automation repository"
                            echo "Current directory: \\\$(pwd)"
                            echo "Available directories:"
                            ls -la ./
                            exit 1
                        fi
                        
                        echo "Successfully cloned automation repository"
                        cd "\\\$AUTOMATION_PATH"
                        echo "Building test Docker image..."
                        
                        # Build the Docker image with a specific tag
                        docker build -t horizon-automation-tests:\\\${BUILD_NUMBER} .
                        
                        # Check if build was successful
                        if [ \\\$? -ne 0 ]; then
                            echo "ERROR: Failed to build the Docker image"
                            exit 1
                        fi
                        
                        echo "Running automated tests against deployed application..."
                        
                        # Let the automation framework use its own .env.dev configuration
                        # Just pass ENV=dev so it loads the correct environment file from horizon-automation repo
                        docker run --rm \\
                            -e ENV=dev \\
                            horizon-automation-tests:\\\${BUILD_NUMBER}
                        
                        # Capture the exit code
                        TEST_RESULT=\\\$?
                        
                        # Clean up the image and repository
                        docker rmi horizon-automation-tests:\\\${BUILD_NUMBER} || true
                        cd ..
                        rm -rf "\\\$AUTOMATION_PATH"
                        
                        # Return test result
                        if [ \\\$TEST_RESULT -eq 0 ]; then
                            echo "✅ Automated tests passed successfully!"
                        else
                            echo "❌ Automated tests failed with exit code: \\\$TEST_RESULT"
                            exit \\\$TEST_RESULT
                        fi
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
            script {
                sh """
                    echo "=== Final Status ==="
                    echo "Jenkins: http://localhost:8081"
                    echo "SnApp Application: http://localhost:8080/\\\$ARTIFACT_NAME"
                    echo "Container Status:"
                    docker ps | grep snapp || true
                """
            }
        }
        success {
            echo '✅ Pipeline succeeded! SnApp deployed successfully.'
        }
        failure {
            echo '❌ Pipeline failed! Check logs for details.'
            script {
                sh """
                    echo "=== Debug Information ==="
                    echo "Tomcat webapps contents:"
                    docker exec \${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/ || true
                    echo "Tomcat logs (last 10 lines):"
                    docker exec \${TOMCAT_CONTAINER} tail -10 /usr/local/tomcat/logs/catalina.out || true
                """
            }
        }
    }
}
            ''')
            sandbox()
        }
    }
}
