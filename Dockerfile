# Stage 1: Build the application
FROM docker.io/library/maven:3.9.6-eclipse-temurin-17 AS builder

# Set the working directory
WORKDIR /build

# Copy the pom.xml file
COPY ./pom.xml ./pom.xml

# Copy the src directory
COPY ./src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM docker.io/library/eclipse-temurin:17-jre

WORKDIR /app

# Copy the built artifacts from builder
COPY --from=builder /build/target/quarkus-app/lib/ /app/lib/
COPY --from=builder /build/target/quarkus-app/*.jar /app/
COPY --from=builder /build/target/quarkus-app/app/ /app/app/
COPY --from=builder /build/target/quarkus-app/quarkus/ /app/quarkus/

# Set the command to run the application
ENTRYPOINT ["java", "-jar", "quarkus-run.jar"]