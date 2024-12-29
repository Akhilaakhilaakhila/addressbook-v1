pipeline {
    agent none
    tools {
        maven 'mymaven'
    }
    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Environment to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'App version to deploy')
    }
    environment {
        DEV_SERVER = 'ec2-user@172.31.1.231'
        IMAGE_NAME = 'akhila708/newfile:$BUILD_NUMBER'
        DEPLOY_SERVER = 'ec2-user@172.31.0.80'
    }
    stages {
        stage('Compile') {
            agent any
            steps {
                echo 'Compiling the code...'
                echo "Compiling in environment: ${params.Env}"
                sh "mvn compile"
            }
        }
        stage('CodeReview') {
            agent any
            steps {
                echo 'Reviewing the code...'
                echo "App version: ${params.APPVERSION}"
                sh "mvn pmd:pmd"
            }
        }
        stage('Unit Test') {
            agent any
            when {
                expression { params.executeTests }
            }
            steps {
                echo 'Running unit tests...'
                sh "mvn test"
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Code Coverage') {
            agent any
            steps {
                echo "Static code coverage analysis..."
                sh "mvn verify"
            }
        }
        stage('Containerize and Push to Docker Hub') {
            agent any
            steps {
                script {
                    sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'username', passwordVariable: 'password')]) {
                            sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER}:/home/ec2-user"
                            sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                            sh "ssh ${DEV_SERVER} sudo docker login -u ${username} -p ${password}"
                            sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}"
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            agent any
            input {
                message "Select the platform to deploy"
                ok "Proceed with Deployment"
                parameters {
                    choice(name: 'Platform', choices: ['On-prem', 'EKS', 'EC2'], description: 'Select deployment platform.')
                }
            }
            steps {
                script {
                    sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'username', passwordVariable: 'password')]) {
                            sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y"
                            sh "ssh ${DEPLOY_SERVER} sudo systemctl start docker"
                            sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${username} -p ${password}"
                            sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}"
                        }
                    }
                }
            }
        }
    }
}
