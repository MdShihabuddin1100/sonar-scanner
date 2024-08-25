#!/bin/bash

# Check if required environment variables are set
if [ -z "$SONAR_PROJECT_KEY" ]; then
  echo "Error: SONAR_PROJECT_KEY is not set."
  exit 1
fi

if [ -z "$SONAR_PROJECT_NAME" ]; then
  echo "Error: SONAR_PROJECT_NAME is not set."
  exit 1
fi

if [ -z "$SONAR_HOST_URL" ]; then
  echo "Error: SONAR_HOST_URL is not set."
  exit 1
fi

if [ -z "$SONAR_LOGIN" ]; then
  echo "Error: SONAR_LOGIN is not set."
  exit 1
fi

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64
export MAVEN_HOME=/opt/maven
export PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

# Run Maven commands
echo "test.skip is ${TEST_SKIP}"

mvn clean verify sonar:sonar \
  -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
  -Dsonar.projectName=${SONAR_PROJECT_NAME} \
  -Dsonar.host.url=${SONAR_HOST_URL} \
  -Dsonar.token=${SONAR_LOGIN} \
  -Dsonar.projectVersion=${SONAR_PROJECT_VERSION} \
  -Dmaven.test.skip=${TEST_SKIP}

