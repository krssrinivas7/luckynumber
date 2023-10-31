pipeline {
    agent any

    parameters {
    string(name: 'AWS_ACCESS_KEY_ID', description: 'AWS Access Key ID', defaultValue: 'key', trim: true)
    string(name: 'AWS_SECRET_ACCESS_KEY', description: 'AWS Secret Access Key', defaultValue: 'password', trim: true)
    }

    stages {
        stage('SSH Agent Check') {
            steps {
                script {
                    withAWS(credentials: 'AWS-Srinivas', region: 'us-east-1') {
                        sshagent(['srinivas']) {
                            sh 'ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 git --version'
                       }
                    }
                }
            }
        }
        stage('Git Clone') {
            steps {
                sshagent(['srinivas']) {
                    script {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 rm -rf luckynumber || true'       
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 git clone -b main https://github.com/krssrinivas7/luckynumber.git'
                    }
                }
            }
        }

        stage('Installation of Software') {
            steps {
                script {
                    sshagent(['srinivas']) {
                        dir('luckynumber') {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 sh install.sh'
                        }
                    }
                }
            }
        }

        stage('EKS Cluster Creation') {
            steps {
                script {
                    sshagent(['srinivas']) {
                        dir('EKS-Terraform') {
                            sh """
                                ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 export AWS_ACCESS_KEY_ID="${params.AWS_ACCESS_KEY_ID}"
                                ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 export AWS_SECRET_ACCESS_KEY="${params.AWS_SECRET_ACCESS_KEY}"
                                ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 terraform init
                                ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 terraform validate
                                ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 terraform plan
                                ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 terraform apply -auto-approve
                            """
                        }
                    }
                }
            }
        }

        stage('EKS Cluster Updation') {
            steps {
                script {
                    sshagent(['srinivas']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 aws eks --region us-east-1 describe-cluster --name pc-eks --query cluster.status
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 aws eks --region us-east-1 update-kubeconfig --name pc-eks
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 kubectl get nodes
                        """
                    }
                }
            }
        }

        stage('Docker Image Creation') {
            steps {
                script {
                    sshagent(['srinivas']) {
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 sudo chmod 666 /var/run/docker.sock'
                        sh 'ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 docker build -t krssrinivas/luckynumber:${env.BUILD_NUMBER} .'
                    }
                }
            }
        }

        stage('Deployment using Docker Image') {
            steps {
                script {
                    sshagent(['srinivas']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 kubectl create ns Srinivas
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 cat deployment.yaml
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 sed -i 's/tag/${env.BUILD_NUMBER}/g' deployment.yaml
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 cat deployment.yaml
                            ssh -o StrictHostKeyChecking=no ubuntu@107.20.123.209 kubectl apply -f deployment.yaml
                        """
                    }
                }
            }
        }
    }
}
