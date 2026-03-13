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
            steps { cleanWs() }
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
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    withKubeConfig([credentialsId: "${KUBE_CONFIG_ID}", clusterName: "${CLUSTER_NAME}"]) {
                        sh "kubectl apply -f kubernetes/deployment.yaml"
                        sh "kubectl apply -f kubernetes/service.yaml"
                        sh "kubectl rollout restart deployment/trendstore-deployment"
                    }
                }
            }
        }
    }
}
