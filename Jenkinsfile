pipeline {
    agent any

    environment {
        WORK_DIR        = "/var/lib/jenkins/workspace/nextflix"
        IMAGE_NAME     = "your-dockerhub-username/nextflix-app"
        IMAGE_TAG       = "latest"
        CONTAINER_NAME = "nextflix-container"
        PORT           = "3000"
        NODE_OPTIONS   = "--openssl-legacy-provider"
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-credentials'  // Add your Docker Hub credentials in Jenkins
    }

    stages {
        stage('Checkout Code') {
            steps {
                dir("${WORK_DIR}") {
                    git branch: 'main', url: 'https://github.com/SukeshKaicharla/nextflix.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${WORK_DIR}") {
                    sh '''
                        docker rmi -f ${IMAGE_NAME}:${IMAGE_TAG} || true
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f ${WORK_DIR}/Dockerfile ${WORK_DIR}
                    '''
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", 
                                                 usernameVariable: 'DOCKERHUB_USER', 
                                                 passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                dir("${WORK_DIR}") {
                    sh '''
                        docker rm -f ${CONTAINER_NAME} || true
                        docker run -d --name ${CONTAINER_NAME} -p 3000:3000 ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }
}
