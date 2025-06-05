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
        WAR_NAME = 'SNP-WIP.war'
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
                    \'\'\'
                }
            }
        }
        
        stage('Smoke Test') {
            steps {
                echo 'Running basic smoke test...'
                script {
                    sh \'\'\'
                        echo "=== Running Smoke Test ==="
                        sleep 5
                        
                        for i in {1..6}; do
                            echo "Testing application (attempt $i/6)..."
                            if curl -f -s http://localhost:8080/SNP-WIP/ > /dev/null; then
                                echo "✓ Application is responding!"
                                curl -s -o /dev/null -w "HTTP Status: %{http_code}\\\\n" http://localhost:8080/SNP-WIP/
                                break
                            else
                                echo "Application not yet available, waiting..."
                                docker exec ${TOMCAT_CONTAINER} tail -5 /usr/local/tomcat/logs/catalina.out || true
                                sleep 10
                            fi
                        done
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
