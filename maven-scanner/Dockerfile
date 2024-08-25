# Use Ubuntu as the base image
FROM ubuntu:22.04

# ARG MAVEN_VERSION=3.9.4

# Switch to root to perform installation and setup
USER root

# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    openjdk-17-jdk \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

# RUN wget https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
# tar xzvf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
# ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
# rm apache-maven-${MAVEN_VERSION}-bin.tar.gz    

WORKDIR /usr/src/app

# Copy the installation and startup scripts into the container
COPY install-jdk-maven.sh /usr/local/bin/install-jdk-maven.sh
COPY maven-scan.sh /usr/local/bin/maven-scan.sh
COPY start.sh /usr/local/bin/start.sh
COPY java-8-openjdk-amd64/ /usr/lib/jvm/java-8-openjdk-amd64/
COPY java-11-openjdk-amd64/ /usr/lib/jvm/java-11-openjdk-amd64/
COPY java-21-openjdk-amd64/ /usr/lib/jvm/java-21-openjdk-amd64/

# Make the scripts executable
RUN chmod +x /usr/local/bin/install-jdk-maven.sh /usr/local/bin/maven-scan.sh /usr/local/bin/start.sh

# Create a non-root user
RUN useradd -m -d /home/mavenuser -s /bin/bash mavenuser
RUN chown -R mavenuser:mavenuser /usr/src/app

# Set the default command to execute the startup script
ENTRYPOINT ["/usr/local/bin/start.sh"]
