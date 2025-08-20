# You can change this base image to anything else
# But make sure to use the correct version of Java
FROM alpine:3.18.6

WORKDIR /opt/app

COPY target/*.jar app.jar

# This should not be changed
ENTRYPOINT ["java","-jar","app.jar"]
