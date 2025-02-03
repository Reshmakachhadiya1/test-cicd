# Stage 1: Build the application
FROM registry.access.redhat.com/ubi8/openjdk-17:latest AS builder

# Set the working directory
WORKDIR /workspace/source

# Debug: Print workspace contents before copy
RUN pwd && ls -la /workspace/source

# Copy everything from the current directory
COPY . .

# Debug: Print workspace contents after copy
RUN pwd && ls -la /workspace/source

# Make mvnw executable
RUN chmod +x mvnw

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the runtime image
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:latest

# Copy deployment artifacts
COPY --from=builder /workspace/source/target/quarkus-app/lib/ /deployments/lib/
COPY --from=builder /workspace/source/target/quarkus-app/*.jar /deployments/
COPY --from=builder /workspace/source/target/quarkus-app/app/ /deployments/app/
COPY --from=builder /workspace/source/target/quarkus-app/quarkus/ /deployments/quarkus/

# Set the JAVA_APP_JAR environment variable
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"