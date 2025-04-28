pipeline {
    environment {
        APP_NAME = "helloworld-angular"
        PORT = 9090
        DOCKER_USER = "neezo"
        DOCKER_IMAGE = "${DOCKER_USER}/${APP_NAME}"
        TAG = sh(script: 'date +%Y%m%d%H%M', returnStdout: true).trim()
    }
    agent any
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${TAG} ."
                }
            }
        }
        
        stage('Run container') {
            agent any
            steps {
                script {
                    sh """
                        docker run --name ${APP_NAME} -d -p ${PORT}:80 ${DOCKER_IMAGE}:${TAG}
                        sleep 20
                    """
                }
            }
        }
        
        stage('Test container') {
            agent any
            steps {
                script {
                    sh """
                        curl -s http://localhost:${PORT} | grep -q "HelloworldAngular!"
                    """
                }
            }
        }
        
        stage('Clean Container') {
            agent any
            steps {
                script {
                    sh """
                        docker stop ${APP_NAME} || true
                        docker rm ${APP_NAME} || true
                    """
                }
            }
        }
        
        stage('Push to DockerHub') {
            agent any
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_HUB_USER',
                    passwordVariable: 'DOCKER_HUB_PASS'
                )]) {
                    script {
                        sh """
                            docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASS}
                            docker push ${DOCKER_IMAGE}:${TAG}
                        """
                    }
                }
            }
        }
    }
}