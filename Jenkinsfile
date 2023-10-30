pipeline {
    agent any

    parameters {
    string(name: 'AWS_ACCESS_KEY_ID', description: 'AWS Access Key ID', defaultValue: '', trim: true)
    string(name: 'AWS_SECRET_ACCESS_KEY', description: 'AWS Secret Access Key', defaultValue: '', trim: true)
    }

    stages {
        stage('AWS Login') {
            steps {
                script {
                    withAWS(credentials: 'AWS-Srinivas', region: 'us-east-1') {
                        sshagent(['srinivas']) {
                            sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 aws --version'
                       }
                    }
                }
            }
        }
        stage('Git Clone') {
            steps {
                sshagent(['srinivas']) {
                    script {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 git clone -b main https://github.com/krssrinivas7/luckynumber.git'
                    }
                }
            }
        }

        stage('Installation of Software') {
            steps {
                script {
                    sshagent(['Srinivas']) {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 ./install.sh'
                    }
                }
            }
        }

        stage('EKS Cluster Creation') {
            steps {
                script {
                    sshagent(['Srinivas']) {
                        dir('EKS-Terraform') {
                            sh """
                                ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 export AWS_ACCESS_KEY_ID="${params.AWS_ACCESS_KEY_ID}"
                                ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 export AWS_SECRET_ACCESS_KEY="${params.AWS_SECRET_ACCESS_KEY}"
                                ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform init
                                ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform validate
                                ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform plan
                                ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 terraform apply -auto-approve
                            """
                        }
                    }
                }
            }
        }

        stage('EKS Cluster Updation') {
            steps {
                script {
                    sshagent(['Srinivas']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 aws eks --region us-east-1 describe-cluster --name pc-eks --query cluster.status
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 aws eks --region us-east-1 update-kubeconfig --name pc-eks
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 kubectl get nodes
                        """
                    }
                }
            }
        }

        stage('Docker Image Creation') {
            steps {
                script {
                    sshagent(['Srinivas']) {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 sudo chmod 666 /var/run/docker.sock'
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 docker build -t krssrinivas/luckynumber:${env.BUILD_NUMBER} .'
                    }
                }
            }
        }

        stage('Deployment using Docker Image') {
            steps {
                script {
                    sshagent(['Srinivas']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 kubectl create ns Srinivas
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 cat deployment.yaml
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 sed -i 's/tag/${env.BUILD_NUMBER}/g' deployment.yaml
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 cat deployment.yaml
                            ssh -o StrictHostKeyChecking=no ubuntu@18.207.234.166 kubectl apply -f deployment.yaml
                        """
                    }
                }
            }
        }
    }
}
