# Stage 1: Build the Spring Boot application
# Uses a JDK 21 image, as specified in your pom.xml
FROM eclipse-temurin:21-jdk-focal AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper files and the pom.xml
# We copy pom.xml first to leverage Docker's layer caching.
# If pom.xml doesn't change, dependencies won't be re-downloaded.
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
# -DskipTests skips running tests, which is standard for Docker builds.
# This will create portfolio-0.0.1-SNAPSHOT.jar in the /app/target/ directory
RUN ./mvnw package -DskipTests

# Stage 2: Create the final, lightweight runtime image
# Uses a JRE (Java Runtime Environment) image, which is much smaller
FROM eclipse-temurin:21-jre-focal

# Set the working directory
WORKDIR /app

# Copy the executable JAR from the builder stage
# The JAR name is based on your pom.xml <artifactId> and <version>
COPY --from=builder /app/target/portfolio-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot application listens on (default is 8080)
EXPOSE 8080

# Define the command to run your application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
