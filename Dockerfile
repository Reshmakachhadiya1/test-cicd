# Build stage
FROM registry.access.redhat.com/ubi8/openjdk-17:latest AS build
WORKDIR /app
COPY . /app
RUN ./mvnw package -DskipTests

# Runtime stage
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:latest
COPY --from=build /app/target/quarkus-app/lib/ /deployments/lib/
COPY --from=build /app/target/quarkus-app/*.jar /deployments/
COPY --from=build /app/target/quarkus-app/app/ /deployments/app/
COPY --from=build /app/target/quarkus-app/quarkus/ /deployments/quarkus/
EXPOSE 8080
CMD ["java", "-jar", "/deployments/quarkus-run.jar"]
