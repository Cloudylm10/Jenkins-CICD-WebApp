pipeline {
    agent any
    tools{
        jdk 'Java21'
        maven 'maven3'
    }
     
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Cloudylm10/Jenkins-CICD-WebApp.git'            }
        }
        
        stage('Code Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
         stage('Run Test Cases') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('Build Jar') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        
         stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('sonar-server') {   // must be inside steps/script
                        sh '''
                            $SCANNER_HOME/bin/sonar-scanner \
                            -Dsonar.projectName=JavaWebApp \
                            -Dsonar.projectKey=Java-WebApp \
                            -Dsonar.java.binaries=target/
                        '''
                    }
                }
            }
        }
        
         stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: ' -scan ./  --format HTML', odcInstallation: 'DP-check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
         stage('Docker Build & Push') {
            steps {
                script{
                        withDockerRegistry(credentialsId: 'aba5182c-c628-4fd6-bd4c-418c70e33be4', toolName: 'docker') {
                        sh "docker build -t webapp ."
                        sh "docker tag webapp lubhitdocker/webapp:latest"
                        sh "docker push lubhitdocker/webapp:latest"
                    }
                }
            }
        }
        
       stage('Docker Image Scan') {
          steps {
            sh "trivy image --scanners vuln --no-progress lubhitdocker/webapp:latest"
            }
        }
        
          stage('Docker Container') {
            steps {
               script{
                   withDockerRegistry(credentialsId: 'aba5182c-c628-4fd6-bd4c-418c70e33be4', toolName: 'docker') {
                       sh "docker run --name webapp -p 8081:8081 lubhitdocker/webapp:latest"
                   }
               }
            }
        }
    }
}
