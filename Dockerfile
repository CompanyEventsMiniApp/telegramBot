ARG BOT_TOKEN

FROM maven:3.8-openjdk-17 AS builder
LABEL authors="ded_mikhey"

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim
LABEL authors="ded_mikhey"

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

ENV BOT_TOKEN=$BOT_TOKEN

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
