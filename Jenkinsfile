pipeline {
    agent any
    options {
        timeout(time: 20, unit: 'MINUTES')
    }

    environment {
        DOCKER_CREDENTIALS = 'lily-docker-credentials'
        DOCKER_IMAGE_NAME = 'netflix-clone'
        DOCKER_IMAGE_TAG = 'latest'
        DOCKER_USERNAME = 'laly9999'

    }


    stages{
        // NPM dependencies
        stage('pull npm dependencies') {
            steps {
                sh 'npm install'
            }
        }
       stage('build Docker Image') {
            steps {
                script {
                    // build image
                    docker.build("$DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG")
               }
            }
        }
        stage('Trivy Scan (Aqua)') {
            steps {
                sh 'trivy image --format template --output trivy_report.html $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG'
            }
       }
        stage('Push to DockerHub') {
            steps {
                script{
                    withDockerRegistry(credentialsId: '$DOCKER_CREDENTIALS', toolName: 'docker') {
                        sh "docker push $DOCKER_USERNAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"
                }   }
            }
        }
        
    }
}
