pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'arjuncodeops/your-java-app:latest'  // Name of the Docker image
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials-id'  // Jenkins ID for Docker Hub credentials
        EC2_SERVER_IP = '13.201.77.58'  // EC2 IP address
        EC2_SSH_KEY = credentials('-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA630ODUwjXh6oAX7iPK5oDt8u1ZnXhC6ngdatMkv8gGGTSJrc
HrJPAVv/Zvpl2e/5XlOTcISyl1AFkZuKVF4h+mulL05DS8+busl7g3qQ0FU9W5mR
6Q2rTfQVNZLkwNxWnFpeDuXeQ2bpwbzB+LS67Aan+yIBvcCXTLbZaCer87goTMeG
yL14IqJt0Mi/NMyzp9JhbDQUy36No5GvY+duUnvnh77EbUYRRqcOENgPb8OaKfgz
dsKVoKhdfjpGd4xYMF0LdZopg16scXobbescyerReOmaiI1sKxghhkL7d2QKW3Fg
swUnQVQpDeT+jEL+ZlxCQ0xUeZUFJnNrfCxaswIDAQABAoIBAQCpu5BWS0uuuj/0
HAVrIXZFSd5S/TjWwF3h+t8JQrWzvyDOkzgXNAQ4AZxcGB0zcYF22JyL3ElxQK9S
3R5eYx7whYghSbK9wN0JS9In2T7pupaoIE+IAF85p7Vl0QPqcqZGuefTqyGByXqx
NqFE5tdX6hBHtaI1p8wl8iFPrlCFMBR/mBwZzzrcSLEjpaLZO5199iU8n8EGvUMw
2XUlaeCbR97DZTyYzSdFkhIRSy0sVvxUyAcFd4HcOJKUJLNpfWXpSEVARl4t+Rpr
nz6VFo7NHVdapX0dwF11D9RKcXt5RR9urw01/LhiV4nbzE3ORK2WLYsSWKJLqyYO
/vvGukHhAoGBAPdCZDbVpZfqCXc24AGucWZf9Kq/fFsnnHKKRfP7rqn/K6uq08gv
jPwFfX8rtecMax+wTC0KPcfnMEeHReplI+gWYUEerFxGyKpWKnb2aZEpa85/pGty
+DvYMB6Cb4EKCJZlXOB2O7diwlSwr0KOWcIWZ9SNMIMX1KMuZ9FiMq0jAoGBAPPQ
JDhpyJRuqigxatfWTWQ9bLjEkaDLarGCrfXNftXS93ktcis7s+8iqkGtI1Yw0wlN
MT4Ov4APM/KgMq5AeuDSsHZOvJnoK60HGoqQuNzW8eQnN6tFOQpLBPdVoQMxzKEt
UXcZmTqL+4vYHg8MNeDwz0g27mpZt6iniIWwFt0xAoGAUrr8HPzPM00zbZgGy4k6
mC5zBs6bJUTTq99oGIKVpnuieQXnZovCeHC91NcjPfOBxFCQrGFI2qIYHVa9pffB
U95pHAjPUvC8I4JBIxy/pbpeP/Glae5F8IAdWZf7Bwn8ZZX0xYXJ5Uo+C2gyu+o1
TiOBCjVTjgljNFZKllxs6FECgYEAxEWswtU1qXgk9tJBZpuYFbf1DBECAuV+cIP4
ssXI8y0wF5bkL7WSNlI7qT9OERag7P39RC3vL5INiaY45ln2EYLKl5Lu9R8X+eSc
EyxKBU3r0HVZtUC2mHin+MwwIDg4uQ+YYz5yQdVqnLtQB2EXBowU8dd2upqa5ORp
XOXSoiECgYEA381B2/qxAhaDq9Kt0jresdiyevz8hknpoXts1DNvV0zIOhmDvkmw
rZkMXztgrb8mSZ/zoQ4Fk/cPBVFIhf5NFtiIUuM8mnGBlTOT+cIcsS6eINqLL0H0
764ifdaJO8wIQaxJUeJnH8uYAcfopRjd7JsiMzLPmvpNz1Rni8U9ltY=
-----END RSA PRIVATE KEY-----')  // Jenkins ID for EC2 SSH private key credentials
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/yourusername/your-java-app.git'  // Git repository URL
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
                        ssh -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'docker ps -q --filter "name=your-java-app" | xargs -r docker stop'
                        ssh -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'docker rm your-java-app || true'
                        ssh -o StrictHostKeyChecking=no -i ${EC2_SSH_KEY} ubuntu@${EC2_SERVER_IP} 'docker run -d --name your-java-app -p 8080:8080 $DOCKER_IMAGE'
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
