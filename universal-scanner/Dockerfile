FROM sonarsource/sonar-scanner-cli:latest

# Switch to root to install packages and set permissions
USER root

# Install CA certificates
RUN apk --no-cache add ca-certificates

# Install Git using apk
RUN apk --no-cache update
RUN apk --no-cache add git

# Set the working directory
WORKDIR /usr/src

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Switch to the existing user with UID 1000 or the appropriate user
USER scanner-cli 

# Set the entrypoint script as the default command
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
