FROM docker.io/library/maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /workspace/source

COPY . .

RUN mvn clean package -DskipTests

FROM docker.io/library/eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /workspace/source/target/quarkus-app/lib/ /app/lib/
COPY --from=builder /workspace/source/target/quarkus-app/*.jar /app/
COPY --from=builder /workspace/source/target/quarkus-app/app/ /app/app/
COPY --from=builder /workspace/source/target/quarkus-app/quarkus/ /app/quarkus/

ENTRYPOINT ["java", "-jar", "quarkus-run.jar"]