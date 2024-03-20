pipeline {
    agent any
     environment {
     AWS_ACCOUNT_ID="740395013651"
     AWS_DEFAULT_REGION="us-west-1b" 
     IMAGE_REPO_NAME="ecrjenkins"
     IMAGE_TAG="latest"
     REPOSITORY_URI = "public.ecr.aws/c2h4z6p2/ecrjenkins"
   }

    stages {
        stage('LOGIN INTO ECR') {
            steps {
                script{
                    sh " aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c2h4z6p2"
                }
            }
        }
        
        stage('GIT CLONE '){
            steps{
                script{
                    git url:'https://github.com/Devraj240/testing.git', branch: 'main'
                }
            }
        }
        
        stage('BUILDING') {
            steps {
                echo 'Building kuch image '
                sh 'docker build -t ${IMAGE_REPO_NAME}:${IMAGE_TAG} .' 
            }
        }
        
        stage('PUSHIN INTO ECR') {
            steps {
                script {
                    
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker push public.ecr.aws/c2h4z6p2/ecrjenkins:latest"
                    
                }
            }
        }
        
        stage('DEPLOYMENT') {
            steps{
                script {
                    sh "docker ps -a -q | xargs docker stop || true "
                    sh "docker ps -a -f status=exited -f status=created -q | xargs docker rm || 'true' "
                    sh "docker push ${REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker run -d --name prod${BUILD_NUMBER} -p 8001:8001 ${REPOSITORY_URI}:$IMAGE_TAG"
                }
            }
        }
      
    }
}

