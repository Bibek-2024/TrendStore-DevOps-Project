pipeline {
    agent any

    environment {
        // Your Docker Hub details
        DOCKER_HUB_USER = "bibekdec2022"
        IMAGE_NAME = "trend-app"
        
        // These IDs must match the Credentials IDs you created in Jenkins UI
        DOCKER_CRED_ID = "dockerhub-creds"
        KUBE_CONFIG_ID = "eks-config"
        
        // EKS Cluster Details
        CLUSTER_NAME = "trendstore-cluster"
        REGION = "ap-south-1"
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Bibek-2024/TrendStore-DevOps-Project.git'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
                    sh "docker tag ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED_ID}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    // This block ensures kubectl uses your EKS credentials
                    withKubeConfig([credentialsId: "${KUBE_CONFIG_ID}", clusterName: "${CLUSTER_NAME}"]) {
                        sh "kubectl apply -f kubernetes/deployment.yaml"
                        sh "kubectl apply -f kubernetes/service.yaml"
                        
                        // Forces Kubernetes to pull the new image even if tag is 'latest'
                        sh "kubectl rollout restart deployment/trendstore-deployment"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Successfully deployed TrendStore version ${BUILD_NUMBER}"
        }
        failure {
            echo "Deployment failed. Check Jenkins logs for details."
        }
    }
}
