pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'arjuncodeops/your-java-app'
        EC2_SERVER_IP = 'your-ec2-server-ip' // Replace with the actual EC2 public IP or DNS
        DOCKER_USERNAME = 'arjuncodeops@gmail.com'
        DOCKER_PASSWORD = credentials('docker-hub-creds') // Reference Docker credentials from Jenkins
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
                    // Build the Docker image
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    
                    // Push Docker image to Docker Hub
                    docker.image(DOCKER_IMAGE).push()
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                // Use withCredentials to securely retrieve the SSH private key
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        // SSH into the EC2 server and deploy the application
                        sh """
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker ps -q --filter "name=your-java-app" | xargs -r docker stop'
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker rm your-java-app || true'
                            ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker run -d --name your-java-app -p 8080:8080 $DOCKER_IMAGE'
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
            echo 'Something went wrong during the pipeline execution.'
        }
    }
}
