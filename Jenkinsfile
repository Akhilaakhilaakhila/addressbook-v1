pipeline {
    agent none
    
    parameters{
        string(name:'Env',defaultValue:'Test',description:'environment to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])

    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                    echo "Compiling the code"
                   echo "Compiling in ${params.Env}"
                   sh "mvn compile"
                }
                
            }
            
        }
        stage('CodeReview') {
            agent any
            steps {
                script{
                    echo "Code Review Using pmd plugin"
                    sh "mvn pmd:pmd"
                }
                
            }
            
        }
         stage('UnitTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                    echo "UnitTest in junit"
                    sh "mvn test"
                }
                
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
            
        }
        stage('CodeCoverage') {
            agent {label 'linux_slave'}
            steps {
                script{
                    echo "Code Coverage by jacoco"
                    sh "mvn verify"
                }
                
            }
            
        }
        stage('Package') {
            agent any
            input{
                message "Select the platform for deployment"
                ok "Platform Selected"
                parameters{
                    choice(name:'Platform',choices:['EKS','EC2','On-prem'])
                }
            }
            steps {
                script{
                    echo "packaging the code"
                    echo 'platform is ${Platform}'
                    echo "packing the version ${params.APPVERSION}"
                    sh "mvn package"
                }
                
            }
            
        }
    }
}
