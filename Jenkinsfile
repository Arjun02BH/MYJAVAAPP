pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'arjuncodeops/your-java-app'
        EC2_SERVER_IP = '13.201.77.58' // Replace with your actual EC2 public IP or DNS
        DOCKER_USERNAME = 'arjuncodeops@gmail.com'
        DOCKER_PASSWORD = 'Boxer@0204' // Store securely in Jenkins credentials if possible
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Arjun02BH/MYJAVAAPP.git'
            }
        }

        stage('Build with Maven') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    docker.image(DOCKER_IMAGE).push()
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh """
                            ssh -i ${SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker ps -q --filter "name=your-java-app" | xargs -r docker stop'
                            ssh -i ${SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker rm your-java-app || true'
                            ssh -i ${SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker run -d --name your-java-app -p 8080:8080 $DOCKER_IMAGE'
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo 'Something went wrong.'
        }
    }
}
