FROM openjdk:11 AS MAVEN_BUILD

RUN mkdir -p build
WORKDIR /build

COPY pom.xml ./
COPY src ./src                             
COPY mvnw ./         
COPY . ./

RUN ./mvnw clean package -Dmaven.test.skip=true

#
# Package stage
#
# production environment

#FROM eclipse-temurin:17.0.2_8-jre-alpine
#FROM ghcr.io/shclub/jre17-runtime:v1.0.0
FROM openjdk:11

WORKDIR /app

ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar

COPY --from=MAVEN_BUILD /build/target/*.jar /app/spring-petclinic-2.4.5.jar

#COPY target/spring-petclinic-2.4.5.jar /app/spring-petclinic-2.4.5.jar

EXPOSE 8080

CMD ["java", "-javaagent:/app/opentelemetry-javaagent.jar", "-jar", "spring-petclinic-2.4.5.jar"]
