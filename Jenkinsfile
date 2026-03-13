pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "bibekdec2022"
        IMAGE_NAME = "trend-app"
        DOCKER_CRED_ID = "dockerhub-creds"
        KUBE_CONFIG_ID = "eks-config"
        CLUSTER_NAME = "trendstore-cluster"
        REGION = "ap-south-1"
    }

    stages {
        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Bibek-2024/TrendStore-DevOps-Project.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED_ID}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo \$PASS | docker login -u \$USER --password-stdin"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withKubeConfig([credentialsId: "${KUBE_CONFIG_ID}", clusterName: "${CLUSTER_NAME}"]) {
                        // Explicitly update kubeconfig to ensure we aren't hitting a local redirect
                        sh "aws eks update-kubeconfig --region ${REGION} --name ${CLUSTER_NAME}"
                        
                        // Apply manifests with validation disabled to bypass the redirect issue
                        sh "kubectl apply -f kubernetes/deployment.yaml --validate=false"
                        sh "kubectl apply -f kubernetes/service.yaml --validate=false"
                        
                        // Restart to pull the fresh image
                        sh "kubectl rollout restart deployment/trendstore-deployment"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "SUCCESS: TrendStore version ${BUILD_NUMBER} is live!"
        }
        failure {
            echo "FAILURE: Check logs for the specific stage failure."
        }
    }
}
