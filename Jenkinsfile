pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ubuntu'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'
        EC2_SERVER_IP = 'your-ec2-server-ip'
        EC2_SSH_KEY = credentials('ec2-ssh-key') // Reference the stored SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://Arjun02BHyour-java-app.git'
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
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // SSH into the EC2 server and deploy the Docker container
                    sh """
                        ssh -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'docker ps -q --filter "name=your-java-app" | xargs -r docker stop'
                        ssh -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'docker rm your-java-app || true'
                        ssh -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'docker run -d --name your-java-app -p 8080:8080 $DOCKER_IMAGE'
                    """
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
