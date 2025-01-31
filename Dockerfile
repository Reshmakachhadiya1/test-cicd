# Stage 1: Build the application
FROM docker.io/library/eclipse-temurin:17-jdk as builder

# Set the working directory
WORKDIR /workspace/source

# Copy the Maven POM and source
COPY pom.xml .
COPY src src/
COPY mvnw .
COPY .mvn .mvn

# Make the mvnw script executable
RUN chmod +x mvnw

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the runtime image
FROM docker.io/library/eclipse-temurin:17-jre

WORKDIR /app

# Copy the built artifact from builder
COPY --from=builder /workspace/source/target/*.jar app.jar

# Set the startup command
ENTRYPOINT ["java", "-jar", "app.jar"]