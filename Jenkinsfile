pipeline {
  agent any

 parameters {
  string(name: 'IMAGE_TAG', defaultValue: "v${BUILD_NUMBER}", description: 'Tag based on build number')
}
  environment {
    AWS_REGION = 'us-east-1'
    IMAGE_NAME = "laly9999/netflix-app:${params.IMAGE_TAG}"
  }

  stages {
    stage('Checkout Code') {
      steps {
        git 'https://github.com/lily4499/netflix-react-clone.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} ."
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
          sh "docker push ${IMAGE_NAME}"
        }
      }
    }

    stage('Terraform Init and Apply') {
      steps {
        dir('terraform') {
          withCredentials([string(credentialsId: 'lil_AWS_Access_key_ID', variable: 'AWS_ACCESS_KEY'),
                           string(credentialsId: 'lil_AWS_Secret_access_key', variable: 'AWS_SECRET_KEY')]) {
            sh '''
              export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
              export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
              terraform init
              terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo 'Netflix Clone deployed successfully on ECS via Jenkins!'
    }
  }
}
