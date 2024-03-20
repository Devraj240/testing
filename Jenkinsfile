pipeline {
    environment {
        DOCKERHUB_CREDENTIALS= credentials('dockerHub')
        
        
    }
    agent any

    stages {
        stage('CLONEING') {
            steps {
                echo 'Cloning github repository'
                git url:'https://github.com/Devraj240/kuchbhi.git', branch: 'main'
                
            }
        }
        
            steps {
                echo 'Building kuch image '
                sh 'docker build -t $DOCKERHUB_CREDENTIALS_USR/img:latest .' 
            }
        }
        
        stage('LOGIN INTO DOCKER HUB') {
            steps {
                sh ' echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin '
                echo 'You have login sucessfully'
                
            }
        }
        
        stage('PUSHING IMAGE') {
            steps {
                
                sh 'docker push $DOCKERHUB_CREDENTIALS_USR/img:latest'
                echo 'You have sucessfully pushed images on Dockerhub '
            }
        }
        
        stage('SSH-LOGIN AND DEPLOYMENT') {
            steps {
                
                withCredentials([sshUserPrivateKey(credentialsId: 'sshlogin', usernameVariable: 'name', 
                keyFileVariable: 'MY_SSH_KEY')]){
                    sshagent(['30524d69-8f7b-45df-9112-ca758c1ca31a']) {
                      sh '''
                      ssh -o StrictHostKeyChecking=no ubuntu@54.183.191.12 " 
                      sudo -i 
                      docker ps -a -q | xargs docker stop || 'true'  
                      docker ps -a -f status=exited -f status=created -q | xargs docker rm || 'true'
                      docker pull $DOCKERHUB_CREDENTIALS_USR/img:latest 
                      docker run -d --name dev${BUILD_NUMBER}  -p 8000:8000 $DOCKERHUB_CREDENTIALS_USR/img:latest "
                      '''
                      echo 'sucessfully deployed'
                    }
                    
                }
                
            }
        }
        
    }
}

