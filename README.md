# 🚀 Jenkins CI/CD Deployment – Java WebApp

This repository documents a **CI/CD pipeline setup using Jenkins** to deploy a **Spring Boot web application** with code quality and security checks, containerization, and image scanning.

---

## 📌 Project Description

I deployed a **Java-based web application** (shopping-cart style) using **Jenkins pipelines**.  
The application was originally developed as a demo shopping cart system in **Spring Boot + Thymeleaf**, and I forked it from **[jaiswaladi246](https://github.com/jaiswaladi246)**.  
Special thanks to the original author 🙏.

---

## ⚙️ CI/CD Pipeline Overview

The pipeline automates:  

1. **Source Code Management (SCM):** GitHub commit triggers Jenkins via Webhook.  
2. **Build & Test:** Maven compiles code and runs unit tests.  
3. **Code Quality Checks:** SonarQube scans for bugs, vulnerabilities, and code smells.  
4. **Security Scans:** OWASP Dependency Check runs for dependency vulnerabilities.  
5. **Docker Build & Push:** Application is containerized and pushed to DockerHub.  
6. **Image Scan:** Docker image scanned with **Trivy**.  
7. **Deployment:** Runs in Docker container on port `8081`.  

### 🔄 Pipeline Flow Diagram

![j2](https://github.com/user-attachments/assets/5b0a16ef-7a96-43ef-9f62-7e847e53bd1f)


---

## 🏗️ Jenkins Pipeline Script (CI/CD)

Below is the Jenkinsfile used for this automation:

```groovy
pipeline {
    agent any
    tools {
        jdk 'Java21'
        maven 'maven3'
    }
     
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/Cloudylm10/Jenkins-CICD-WebApp.git'
            }
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
                    withSonarQubeEnv('sonar-server') {
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
                script {
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
               script {
                   withDockerRegistry(credentialsId: 'aba5182c-c628-4fd6-bd4c-418c70e33be4', toolName: 'docker') {
                       sh "docker run --name webapp -p 8081:8081 lubhitdocker/webapp:latest"
                   }
               }
            }
        }
    }
}
````

---

## 🔑 Explanation of Stages

* **Git Checkout:** Pulls code from GitHub repo.
* **Code Compile:** Compiles the source code with Maven.
* **Run Test Cases:** Executes unit tests.
* **Build Jar:** Packages the application as a `.jar` file.
* **SonarQube Analysis:** Performs static code analysis for code quality.
* **OWASP Dependency Check:** Scans dependencies for vulnerabilities.
* **Docker Build & Push:** Creates Docker image and pushes to DockerHub.
* **Docker Image Scan (Trivy):** Scans Docker image for known CVEs.
* **Docker Container:** Deploys containerized app on port `8081`.

---

## 🛠️ Technologies Used

* **Java 21 (OpenJDK)**
* **Spring Boot + Thymeleaf**
* **Maven 3**
* **Jenkins**
* **SonarQube**
* **OWASP Dependency Check**
* **Docker & DockerHub**
* **Trivy (Docker Image Scanning)**
* **GitHub (SCM)**

---

## 🙌 Acknowledgements

* Original project forked from [Adi Jaiswal (jaiswaladi246)](https://github.com/jaiswaladi246)
* Jenkins & plugin ecosystem for CI/CD automation
* Open-source community for tools like **SonarQube**, **Trivy**, and **OWASP**

---

## 📜 License

This project is for **educational/demo purposes** only.
The original application belongs to [jaiswaladi246](https://github.com/jaiswaladi246).


