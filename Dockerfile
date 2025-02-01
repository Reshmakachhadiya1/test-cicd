# Stage 1: Build the application
FROM registry.access.redhat.com/ubi8/openjdk-17:latest as builder

WORKDIR /workspace/source

# Debug: List directory contents
RUN ls -la

# Copy source code
COPY . .

# Debug: List directory contents after copy
RUN ls -la

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the runtime image
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:latest

COPY --from=builder /workspace/source/target/quarkus-app/lib/ /deployments/lib/
COPY --from=builder /workspace/source/target/quarkus-app/*.jar /deployments/
COPY --from=builder /workspace/source/target/quarkus-app/app/ /deployments/app/
COPY --from=builder /workspace/source/target/quarkus-app/quarkus/ /deployments/quarkus/

ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"
