#!/bin/bash

# Ensure that the required environment variables are set
if [ -z "$JDK_VERSION" ]; then
  echo "Error: JDK_VERSION is not set."
  exit 1
fi

if [ -z "$MAVEN_VERSION" ]; then
  echo "Error: MAVEN_VERSION is not set."
  exit 1
fi

# # Update package list and install necessary packages
# apt-get update
# apt-get install -y openjdk-${JDK_VERSION}-jdk

# # Download and install Maven
wget https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
tar xzvf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt
ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven
rm apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
export MAVEN_HOME=/opt/maven
export PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

java --version
mvn --version

# Clone the repository
git clone -b "$REPO_BRANCH" "$REPO_URL" .
ls -la
