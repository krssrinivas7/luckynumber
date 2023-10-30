pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('<AWS_ACCESS_KEY_ID_CREDENTIAL_ID>')
        AWS_SECRET_ACCESS_KEY = credentials('<AWS_SECRET_ACCESS_KEY_CREDENTIAL_ID>')
    }

    stages {
        stage('Stage 1 - Git Clone') {
            steps {
                sshagent(['Srinivas']) {
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 git branch: 'main', credentialsId: 'Git-Srinivas', url: 'https://github.com/krssrinivas7/luckynumber.git'
                    
                }
            }
        }
        stage('Stage 2 - Installation of softwares') {
            steps {
                sshagent(['Srinivas']) {
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 ./install.sh
                }
            }
        }
        stage('Stage 3 - AWS Login') {
            steps {
                sshagent(['Srinivas']) {
                    withAWS(credentials: 'AWS-Srinivas', region: 'us-east-1') {
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 aws --version
                    }
                }
            }
        }              
        stage('Stage 3 - EKS Cluster Creation') {
            steps {
                sshagent(['Srinivas']) {
                    dir(EKS-Terraform){
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform init
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform validate
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform plan
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform apply -auto-approve
                    }
                }
            }
        }
        stage('Stage 3 - EKS Cluster Updation') {
            steps {
                sshagent(['Srinivas']) {
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 aws eks --region us-east-1 describe-cluster --name pc-eks --query cluster.status
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 aws eks --region us-east-1 update-kubeconfig --name pc-eks
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 kubectl get nodes
                }
            }
        }        
        stage('Stage 3 - Docker Image Creation') {
            steps {
                sshagent(['Srinivas']) {
                    ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 docker build -t krssrinivas/luckynumber:${env.BUILD_NUMBER} .
                }
            }
        }
        stage('Stage 4 - Deployment using Docker Image') {
            steps {
                sshagent(['Srinivas']) {
                    sh '''
                    # Commands for deploying using the Docker image
                    '''
                }
            }
        }
    }
}
