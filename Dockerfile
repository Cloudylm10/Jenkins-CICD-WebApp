FROM alpine:3.18.6

RUN apk add --no-cache openjdk11

WORKDIR /opt/app

COPY target/*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]
