pipeline {
    agent { label 'docker-maven-slave' } 
    triggers {
          pollSCM('4 4 4 * *')
    }
    environment {
          VER_NUM = "1.0.${BUILD_NUMBER}";
          REL_NUM = "1.0.${BUILD_NUMBER}.RELEASE";
          mavenHome =  tool name: "maven", type: "maven"
     }
    tools{
          maven 'maven'
     }
    stages {
           stage ('Git Checkout') {
                 steps {
                     echo "Heloo!!!!";
                     git credentialsId: 'github-credentials' , url: 'https://github.com/bathuru/devops-angularui.git',  branch: 'master'   
                }
           }

          stage('Docker Build & Push') {    
                  steps {
                          script{        // To add Scripted Pipeline sentences into a Declarative
                                    try{
                                            sh "echo pwd"
                                             //sh "docker rm -f devops-devops-angularui || true"
                                             //sh "docker rmi bathurudocker/devops-devops-angularui || true"       //sh 'docker rmi $(docker images bathurudocker/devops-devops-angularui)''
                                          }catch(error){
                                          //  do nothing if there is an exception
                                          }
                            }

                          withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerpwd')]) {
                                 sh "docker login -u bathurudocker -p ${dockerpwd}"
                         }
                          //sh "docker build -t bathurudocker/devops-angularui:${VER_NUM} ."
                          //sh "docker image tag bathurudocker/devops-angularui:${VER_NUM}  bathurudocker/devops-angularui:latest"
                          //sh "docker push bathurudocker/devops-angularui:${VER_NUM}" 

                         sh "docker build -t bathurudocker/devops-angularui:latest ."
                          sh "docker image tag bathurudocker/devops-angularui:latest  bathurudocker/devops-angularui:latest"
                          sh "docker push bathurudocker/devops-angularui:latest" 

                          sh "docker rmi bathurudocker/devops-angularui" 
                 } 
          }

     stage('Deploy Into DEV') {
       steps {   
           sh "pwd"
           sshagent(['aws-ap-south-pem']) {
               sh "ssh -o StrictHostKeyChecking=no ec2-user@docker.bathur.xyz  sudo docker rm -f devops-angularui || true"
               sh "ssh -o StrictHostKeyChecking=no ec2-user@docker.bathur.xyz  sudo docker run  -d -p 80:80 --name devops-angularui bathurudocker/devops-angularui:${VER_NUM}"
          }
       }
     }     
    }
    post {
           success {
                echo 'Pipeline Sucessfully Finished'
    }
    }
}