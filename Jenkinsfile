pipeline {
    agent any
    parameters{
        string(name:'Env',defaultValue:'Test',description:'environment to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])
    }

     stages {
        stage('Compile') {
            steps {
               script{
                   echo "Compiling the code"
                   echo "Compile ing in ${params.Env}"
                   sh "mvn compile"
               }
            }
        }
        stage('CodeReview') {
            steps {
               script{
                   echo "Codereview using pmd"
                   sh "mvn pmd:pmd"
               }
            }
        }
        stage('UnitTest') {
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
        }
        stage('CodeCoverage') {
            steps {
               script{
                   echo "geting xml files"
                   sh "mvn verify"
               }
            }
        }
        stage('Package') {
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
