# You can change this base image to anything else
# But make sure to use the correct version of Java
FROM adoptopenjdk/openjdk11:alpine-jre

WORKDIR /opt/app

COPY target/*.jar app.jar

# This should not be changed
ENTRYPOINT ["java","-jar","app.jar"]
