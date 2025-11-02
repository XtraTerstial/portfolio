# Stage 1: Build the Spring Boot application
# CHANGED: from -focal to -noble
FROM eclipse-temurin:21-jdk-noble AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper files and the pom.xml
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Make the Maven wrapper executable
RUN chmod +x mvnw

# Download all dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of your source code
COPY src src

# Build the Spring Boot application into an executable JAR
RUN ./mvnw package -DskipTests

# Stage 2: Create the final, lightweight runtime image
# CHANGED: from -focal to -noble
FROM eclipse-temurin:21-jre-noble

# Set the working directory
WORKDIR /app

# Copy the executable JAR from the builder stage
COPY --from=builder /app/target/portfolio-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot application listens on (default is 8080)
EXPOSE 8080

# Define the command to run your application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
