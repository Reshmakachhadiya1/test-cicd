# Stage 1: Build the application
FROM docker.io/library/maven:3.9.6-eclipse-temurin-17 AS builder

# Set the working directory
WORKDIR /workspace/source

# List contents before copying
RUN ls -la

# Copy the entire repository content
COPY . .

# List contents after copying
RUN ls -la

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM docker.io/library/eclipse-temurin:17-jre

WORKDIR /app

# Copy the built artifacts from builder
COPY --from=builder /workspace/source/target/quarkus-app/lib/ /app/lib/
COPY --from=builder /workspace/source/target/quarkus-app/*.jar /app/
COPY --from=builder /workspace/source/target/quarkus-app/app/ /app/app/
COPY --from=builder /workspace/source/target/quarkus-app/quarkus/ /app/quarkus/

ENTRYPOINT ["java", "-jar", "quarkus-run.jar"]
