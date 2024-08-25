#!/bin/bash

# Check if REPO_URL environment variable is set
if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL environment variable is not set."
  exit 1
fi

# Clone the repository
git clone -b "$REPO_BRANCH" "$REPO_URL" .

# Generate sonar-project.properties dynamically
echo "sonar.host.url=${SONAR_HOST_URL}" > sonar-project.properties
echo "sonar.projectKey=${SONAR_PROJECT_KEY}" >> sonar-project.properties
echo "sonar.login=${SONAR_LOGIN}" >> sonar-project.properties
echo "sonar.projectName=${SONAR_PROJECT_NAME}" >> sonar-project.properties
echo "sonar.projectVersion=${SONAR_PROJECT_VERSION}" >> sonar-project.properties
echo "sonar.sourceEncoding=UTF-8" >> sonar-project.properties

ls -la
# Run SonarScanner
exec sonar-scanner
