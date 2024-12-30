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
                   echo "Compile ing in ${params.Env}"
                   sh "mvn compile"
               }
            }
        }
        stage('CodeReview') {
            agent any
            steps {
               script{
                   echo "Codereview using pmd"
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
                   echo "UnitTest in Junit"
                   sh "mvn test"
               }
            }
            post{
            always{
                junit 'target/surefire-reports/*xml'
            }
        }
        }
        
        stage('CodeCoverage') {
            agent {label 'linux_slave'}
            steps {
               script{
                   echo "geting xml files"
                   sh "mvn verify"
               }
            }
        }
        stage('Package') {
            agent any
            input{
                message "Select name of package"
                ok "platform Seleted"
                parameters{
                    choice(name:'Platform',choices:['EKS','EC2','On-prem'])
                }
            }
            steps {
               script{
                   echo "packing code"
                   echo "platform is ${Platform}"
                   echo "packing version ${params.APPVERSION}"
                   sh "mvn package"
               }
            }
        }
        
    }
}
