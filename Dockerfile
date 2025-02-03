# Stage 1: Build the application
FROM registry.access.redhat.com/ubi8/openjdk-17:latest AS builder

# Set the working directory
WORKDIR /workspace/source

# Debug: Print current directory
RUN pwd && ls -la

# Copy the project files
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn
COPY src src

# Make mvnw executable
RUN chmod +x mvnw

# Debug: List files after copy
RUN ls -la

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