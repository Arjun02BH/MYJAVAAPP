pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yourusername/your-java-app'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'
        EC2_SERVER_IP = 'your-ec2-server-ip'
        EC2_SSH_KEY = credentials('ec2-ssh-key-id')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/yourusername/your-java-app.git'
            }
        }
        
        stage('Build with Maven') {
            steps {
                script {
                    // Run Maven to build the app
                    sh 'mvn clean package'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub and push the image
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        sh 'docker push $DOCKER_IMAGE'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // SSH to EC2 server and deploy the Docker container
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
