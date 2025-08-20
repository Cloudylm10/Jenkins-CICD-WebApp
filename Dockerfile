FROM alpine:3.18.6

# Install OpenJDK 21 instead of 11
RUN apk add --no-cache openjdk21

WORKDIR /opt/app

COPY target/*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]
