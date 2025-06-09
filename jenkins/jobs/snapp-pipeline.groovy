// SnApp Pipeline Job DSL Script
// This creates the Jenkins pipeline job automatically

// Local WAR deployment pipeline for SnApp
pipelineJob('SnApp-Local-Pipeline') {
    displayName('SnApp Local WAR Deployment')
    description('Deploy pre-built SNP-WIP.war from local workspace to Tomcat')
    
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
        ARTIFACT_NAME = 'SNP-WIP'
        WAR_NAME = "${ARTIFACT_NAME}.war"
        XML_NAME = "${ARTIFACT_NAME}.xml"
        WORKSPACE_PATH = '/workspace'
    }
    
    stages {
        stage('Prepare WAR') {
            steps {
                echo 'Preparing existing WAR file for deployment...'
                script {
                    sh \'\'\'
                        echo "=== Preparing WAR file ==="
                        cd ${WORKSPACE_PATH}
                        
                        if [ -f "${WAR_NAME}" ]; then
                            echo "Found existing WAR file: ${WAR_NAME}"
                            ls -la ${WAR_NAME}
                            mkdir -p deployment
                            cp ${WAR_NAME} deployment/
                            echo "WAR file prepared for deployment"
                            ls -la deployment/
                        else
                            echo "ERROR: ${WAR_NAME} not found!"
                            echo "Available files:"
                            ls -la
                            exit 1
                        fi
                    \'\'\'
                }
            }
        }
        
        stage('Verify Tomcat') {
            steps {
                echo 'Verifying Tomcat container is running...'
                script {
                    sh \'\'\'
                        echo "=== Verifying Tomcat Container ==="
                        
                        if docker ps | grep -q ${TOMCAT_CONTAINER}; then
                            echo "✓ Tomcat container is running"
                            docker ps | grep ${TOMCAT_CONTAINER}
                        else
                            echo "ERROR: Tomcat container is not running!"
                            echo "Available containers:"
                            docker ps
                            exit 1
                        fi
                        
                        echo "Checking Tomcat health..."
                        for i in {1..3}; do
                            if docker exec ${TOMCAT_CONTAINER} curl -f -s http://localhost:8080/ > /dev/null; then
                                echo "✓ Tomcat is responding"
                                break
                            else
                                echo "Waiting for Tomcat to be ready... ($i/3)"
                                sleep 5
                            fi
                        done
                    \'\'\'
                }
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying WAR file to Tomcat container...'
                script {
                    sh \'\'\'
                        echo "=== Deploying to Tomcat ==="
                        cd ${WORKSPACE_PATH}
                        
                        if [ ! -f "deployment/${WAR_NAME}" ]; then
                            echo "ERROR: Deployment package not found!"
                            exit 1
                        fi
                        
                        echo "Removing old application..."
                        docker exec ${TOMCAT_CONTAINER} rm -f /usr/local/tomcat/webapps/${WAR_NAME} 2>/dev/null || true
                        docker exec ${TOMCAT_CONTAINER} rm -rf /usr/local/tomcat/webapps/SNP-WIP 2>/dev/null || true
                        
                        echo "Copying new WAR file..."
                        docker cp ${WAR_NAME} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/
                        
                        echo "Verifying WAR file copy..."
                        docker exec ${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/${WAR_NAME}
                        
                        echo "Copying connection XML file..."
                        docker cp ${XML_NAME} ${TOMCAT_CONTAINER}:/usr/local/tomcat/conf/Catalina/localhost/

                        echo "Verifying XML file copy..."
                        docker exec ${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/conf/Catalina/localhost/${XML_NAME}

                        echo "Waiting for deployment..."
                        sleep 15
                        
                        echo "Verifying deployment..."
                        for i in {1..12}; do
                            if docker exec ${TOMCAT_CONTAINER} ls /usr/local/tomcat/webapps/SNP-WIP 2>/dev/null; then
                                echo "✓ Application deployed successfully!"
                                docker exec ${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/SNP-WIP
                                break
                            else
                                echo "Waiting for application to deploy... ($i/12)"
                                sleep 5
                            fi
                        done
                    \'\'\'
                }
            }
        }
        
        stage('Smoke Test') {
            steps {
                echo 'Running automated tests from horizon-automation Git repository...'
                script {
                    sh \'\'\'
                        echo "=== Running Docker-based Smoke Test ==="
                        
                        # Define automation project details
                        AUTOMATION_REPO="git@github.com:accesso/horizon-automation.git"
                        AUTOMATION_PATH="./horizon-automation"
                        
                        # Clean up any existing automation directory
                        rm -rf "$AUTOMATION_PATH"
                        
                        echo "Cloning horizon-automation repository..."
                        git clone "$AUTOMATION_REPO" "$AUTOMATION_PATH"
                        
                        # Check if clone was successful
                        if [ ! -d "$AUTOMATION_PATH" ]; then
                            echo "ERROR: Failed to clone horizon-automation repository"
                            echo "Current directory: $(pwd)"
                            echo "Available directories:"
                            ls -la ./
                            exit 1
                        fi
                        
                        echo "Successfully cloned automation repository"
                        cd "$AUTOMATION_PATH"
                        echo "Building test Docker image..."
                        
                        # Build the Docker image with a specific tag
                        docker build -t horizon-automation-tests:${BUILD_NUMBER} .
                        
                        # Check if build was successful
                        if [ $? -ne 0 ]; then
                            echo "ERROR: Failed to build the Docker image"
                            exit 1
                        fi
                        
                        echo "Running automated tests against deployed application..."
                        
                        # Let the automation framework use its own .env.dev configuration
                        # Just pass ENV=dev so it loads the correct environment file from horizon-automation repo
                        docker run --rm \
                            -e ENV=dev \
                            horizon-automation-tests:${BUILD_NUMBER}
                        
                        # Capture the exit code
                        TEST_RESULT=$?
                        
                        # Clean up the image and repository
                        docker rmi horizon-automation-tests:${BUILD_NUMBER} || true
                        cd ..
                        rm -rf "$AUTOMATION_PATH"
                        
                        # Return test result
                        if [ $TEST_RESULT -eq 0 ]; then
                            echo "✅ Automated tests passed successfully!"
                        else
                            echo "❌ Automated tests failed with exit code: $TEST_RESULT"
                            exit $TEST_RESULT
                        fi
                    \'\'\'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
            script {
                sh \'\'\'
                    echo "=== Final Status ==="
                    echo "Jenkins: http://localhost:8081"
                    echo "SnApp Application: http://localhost:8080/SNP-WIP"
                    echo "Container Status:"
                    docker ps | grep snapp || true
                \'\'\'
            }
        }
        success {
            echo '✅ Pipeline succeeded! SnApp deployed successfully.'
        }
        failure {
            echo '❌ Pipeline failed! Check logs for details.'
            script {
                sh \'\'\'
                    echo "=== Debug Information ==="
                    echo "Tomcat webapps contents:"
                    docker exec ${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/ || true
                    echo "Tomcat logs (last 10 lines):"
                    docker exec ${TOMCAT_CONTAINER} tail -10 /usr/local/tomcat/logs/catalina.out || true
                \'\'\'
            }
        }
    }
}
            ''')
            sandbox()
        }
    }
}
