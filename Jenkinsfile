pipeline {
    agent any

     stages {
        stage('Compile') {
            steps {
               script{
                   echo "Compiling the code"
               }
            }
        }
        stage('CodeReview') {
            steps {
               script{
                   echo "Codereview using pmd"
               }
            }
        }
        stage('UnitTest') {
            steps {
               script{
                   echo "UnitTest in Junit"
               }
            }
        }
        stage('CodeCoverage') {
            steps {
               script{
                   echo "geting xml files"
               }
            }
        }
        stage('Package') {
            steps {
               script{
                   echo "packing code"
               }
            }
        }
        
    }
}
