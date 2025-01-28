pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'arjuncodeops/your-java-app'
        EC2_SERVER_IP = 'your-ec2-server-ip'
        EC2_SSH_KEY = credentials('ec2-ssh-key')
        DOCKER_USERNAME = 'arjuncodeops@gmail.com'
        DOCKER_PASSWORD = 'Boxer@0204'
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
                script {
                    sh """
                        ssh -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker ps -q --filter "name=your-java-app" | xargs -r docker stop'
                        ssh -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker rm your-java-app || true'
                        ssh -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'sudo docker run -d --name your-java-app -p 8080:8080 $DOCKER_IMAGE'
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
            echo 'Something went wrong.'
        }
    }
}
