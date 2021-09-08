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
                                             //sh "docker rm -f devops-springbootrest || true"
                                             //sh "docker rmi bathurudocker/devops-springbootrest || true"       //sh 'docker rmi $(docker images bathurudocker/devops-springbootrest)''
                                          }catch(error){
                                          //  do nothing if there is an exception
                                          }
                            }
                          sh "docker build -t bathurudocker/devops-springbootrest:${VER_NUM} ."
                          sh "docker image tag bathurudocker/devops-springbootrest:${VER_NUM}  bathurudocker/devops-springbootrest:latest"
                          withCredentials([string(credentialsId: 'dockerHubPwd', variable: 'dockerpwd')]) {
                                 sh "docker login -u bathurudocker -p ${dockerpwd}"
                         }
                          sh "docker push bathurudocker/devops-springbootrest:${VER_NUM}" 
                          sh "docker rmi bathurudocker/devops-springbootrest" 
                 } 
          }

     stage('Deploy Into DEV') {
       steps {   
           sh "pwd"
           sshagent(['aws-ap-south-pem']) {
               sh "ssh -o StrictHostKeyChecking=no ec2-user@docker.bathur.xyz  sudo docker rm -f devops-springbootrest || true"
               sh "ssh -o StrictHostKeyChecking=no ec2-user@docker.bathur.xyz  sudo docker run  -d -p 8010:8080 --name devops-springbootrest bathurudocker/devops-springbootrest:${VER_NUM}"
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