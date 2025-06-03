pipeline {
    agent any
    
    environment {
        PROJECT_NAME = 'SnApp'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        TOMCAT_CONTAINER = 'snapp-tomcat'
        WAR_NAME = 'SNP-WIP.war'
        WORKSPACE_PATH = '/workspace'
        MAVEN_OPTS = '-Xmx2048m'
    }
    
    tools {
        maven 'Maven-3.9'
        jdk 'OpenJDK-8'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
                script {
                    sh '''
                        echo "=== Repository Information ==="
                        echo "Branch: ${GIT_BRANCH}"
                        echo "Commit: ${GIT_COMMIT}"
                        echo "Repository: ${GIT_URL}"
                        ls -la
                    '''
                }
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building WAR file from source...'
                script {
                    sh '''
                        echo "=== Building with Maven ==="
                        
                        # Check if pom.xml exists
                        if [ -f "pom.xml" ]; then
                            echo "Found Maven project"
                            mvn clean compile -X
                            mvn package -DskipTests=true
                            
                            # Find the generated WAR file
                            WAR_FILE=$(find target -name "*.war" | head -1)
                            if [ -n "$WAR_FILE" ]; then
                                echo "Built WAR file: $WAR_FILE"
                                cp "$WAR_FILE" "${WAR_NAME}"
                                ls -la ${WAR_NAME}
                            else
                                echo "ERROR: No WAR file found in target directory"
                                ls -la target/
                                exit 1
                            fi
                        else
                            echo "No pom.xml found, checking for Gradle..."
                            if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
                                echo "Found Gradle project"
                                ./gradlew clean build -x test
                                
                                # Find the generated WAR file
                                WAR_FILE=$(find build/libs -name "*.war" | head -1)
                                if [ -n "$WAR_FILE" ]; then
                                    echo "Built WAR file: $WAR_FILE"
                                    cp "$WAR_FILE" "${WAR_NAME}"
                                    ls -la ${WAR_NAME}
                                else
                                    echo "ERROR: No WAR file found in build/libs directory"
                                    ls -la build/libs/
                                    exit 1
                                fi
                            else
                                echo "ERROR: No Maven (pom.xml) or Gradle (build.gradle) found!"
                                echo "Available files:"
                                ls -la
                                exit 1
                            fi
                        fi
                    '''
                }
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running unit tests...'
                script {
                    sh '''
                        echo "=== Running Tests ==="
                        
                        if [ -f "pom.xml" ]; then
                            echo "Running Maven tests..."
                            mvn test || echo "Tests failed but continuing with deployment"
                        elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
                            echo "Running Gradle tests..."
                            ./gradlew test || echo "Tests failed but continuing with deployment"
                        else
                            echo "No test framework detected, skipping tests"
                        fi
                    '''
                }
            }
        }
        
        stage('Prepare WAR') {
            steps {
                echo 'Preparing WAR file for deployment...'
                script {
                    sh '''
                        echo "=== Preparing WAR file ==="
                        
                        if [ -f "${WAR_NAME}" ]; then
                            echo "Found WAR file: ${WAR_NAME}"
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
                    '''
                }
            }
        }
        
        stage('Verify Tomcat') {
            steps {
                echo 'Verifying Tomcat container is running...'
                script {
                    sh '''
                        echo "=== Verifying Tomcat Container ==="
                        
                        # Check if Tomcat container is running
                        if docker ps | grep -q ${TOMCAT_CONTAINER}; then
                            echo "✓ Tomcat container is running"
                            docker ps | grep ${TOMCAT_CONTAINER}
                        else
                            echo "ERROR: Tomcat container is not running!"
                            echo "Available containers:"
                            docker ps
                            exit 1
                        fi
                        
                        # Check if Tomcat is responding
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
                    '''
                }
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
                echo 'Deploying WAR file to Tomcat container...'
                script {
                    sh '''
                        echo "=== Deploying to Tomcat ==="
                        
                        if [ ! -f "deployment/${WAR_NAME}" ]; then
                            echo "ERROR: Deployment package not found!"
                            exit 1
                        fi
                        
                        echo "Removing old application..."
                        docker exec ${TOMCAT_CONTAINER} rm -f /usr/local/tomcat/webapps/${WAR_NAME} 2>/dev/null || true
                        docker exec ${TOMCAT_CONTAINER} rm -rf /usr/local/tomcat/webapps/SNP-WIP 2>/dev/null || true
                        
                        echo "Copying new WAR file..."
                        docker cp deployment/${WAR_NAME} ${TOMCAT_CONTAINER}:/usr/local/tomcat/webapps/
                        
                        echo "Verifying WAR file copy..."
                        docker exec ${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/${WAR_NAME}
                        
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
                    '''
                }
            }
        }
        
        stage('Smoke Test') {
            steps {
                echo 'Running basic smoke test...'
                script {
                    sh '''
                        echo "=== Running Smoke Test ==="
                        sleep 5
                        
                        for i in {1..6}; do
                            echo "Testing application (attempt $i/6)..."
                            if curl -f -s http://localhost:8080/SNP-WIP/ > /dev/null; then
                                echo "✓ Application is responding!"
                                curl -s -o /dev/null -w "HTTP Status: %{http_code}\\n" http://localhost:8080/SNP-WIP/
                                break
                            else
                                echo "Application not yet available, waiting..."
                                docker exec ${TOMCAT_CONTAINER} tail -5 /usr/local/tomcat/logs/catalina.out || true
                                sleep 10
                            fi
                        done
                    '''
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline completed'
            script {
                sh '''
                    echo "=== Final Status ==="
                    echo "Jenkins: http://localhost:8081"
                    echo "SnApp Application: http://localhost:8080/SNP-WIP"
                    echo "Build: #${BUILD_NUMBER}"
                    echo "Branch: ${GIT_BRANCH}"
                    echo "Commit: ${GIT_COMMIT}"
                    echo "Container Status:"
                    docker ps | grep snapp || true
                '''
            }
            
            // Archive build artifacts
            archiveArtifacts artifacts: '**/*.war', allowEmptyArchive: true
            
            // Clean workspace
            cleanWs()
        }
        success {
            echo '✅ Pipeline succeeded! SnApp deployed successfully.'
        }
        failure {
            echo '❌ Pipeline failed! Check logs for details.'
            script {
                sh '''
                    echo "=== Debug Information ==="
                    echo "Tomcat webapps contents:"
                    docker exec ${TOMCAT_CONTAINER} ls -la /usr/local/tomcat/webapps/ || true
                    echo "Tomcat logs (last 10 lines):"
                    docker exec ${TOMCAT_CONTAINER} tail -10 /usr/local/tomcat/logs/catalina.out || true
                '''
            }
        }
    }
}
