# Stage 1: Build the application
FROM registry.access.redhat.com/ubi8/openjdk-17:latest as builder

# Set the working directory
WORKDIR /workspace/source

# Copy the Maven POM and source
COPY pom.xml .
COPY src src/

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:latest

# Copy the built artifact from builder
COPY --from=builder /workspace/source/target/*.jar /deployments/

# Set the startup command
ENV JAVA_APP_JAR="/deployments/*.jar"