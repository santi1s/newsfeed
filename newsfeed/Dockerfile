FROM openjdk:18-jdk-alpine3.15

COPY ./build/newsfeed.jar /home/newsfeed.jar

EXPOSE 8002

CMD ["java","-jar","/home/newsfeed.jar"]
