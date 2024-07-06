pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPOSITORY = 'ecr-jenkins'
        IMAGE_TAG = 'v2'
        AWS_ACCOUNT_ID = '637423529262'
        CREDENTIALS_ID = 'aws-ecr-jenkins-credentials-id' // The ID of the AWS credentials stored in Jenkins
        AWS_PROFILE = 'ecr-jenkins-user' // The AWS profile name
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from your source control
                git url: 'https://github.com/lily4499/netflix-react-clone.git', branch: 'main'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}")
                }
            }
        }

       //  stage('Trivy Scan (Aqua)') {
        //    steps {
             //   sh 'trivy image --format template --output trivy_report.html ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}'
           //     sh 'trivy image --format json --output trivy_report.json ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}'

         //   }
      // }

         stage('Update Trivy DB') {
            steps {
                sh 'trivy image --download-db-only'
            }
        }

        stage('Run Trivy Scan') {
            steps {
                sh '''
                    echo '{{- range . }}\n{{ .Target }}\n{{ range .Vulnerabilities }}\n{{ .VulnerabilityID }} {{ .PkgName }} {{ .InstalledVersion }} {{ .FixedVersion }} {{ .Severity }} {{ .Title }}\n{{ end }}\n{{ end }}' > trivy-template.tpl
                    trivy image --template trivy-template.tpl --output trivy_report.html ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}
                '''
            }
        }
        
        stage('Login to AWS ECR') {
            steps {
                script {
                    withCredentials([aws(credentialsId: "${CREDENTIALS_ID}", profileName: "${AWS_PROFILE}")]) {
                        sh """
                        aws ecr get-login-password --region ${AWS_REGION} --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        """
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push("${IMAGE_TAG}")
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
