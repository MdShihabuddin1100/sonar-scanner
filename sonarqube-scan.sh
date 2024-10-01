#!/bin/bash
set -e

SONAR_PROJECT_KEY=code
SONAR_TOKEN=squ_6acda43ffb0080d0abf21f446ba9a1bfdfe5fe3d
# Define API endpoint URL
# API_URL="http://aescontroller-sonarqube-sonarqube.core-ns:9000/sonarqube/api/ce/component?component=${SONAR_PROJECT_KEY}&branch=${GIT_BRANCH}"
API_URL="http://172.18.255.200/sonarqube/api/ce/component?component=${SONAR_PROJECT_KEY}"

# Polling interval in seconds
interval=10
TARGET_DURATION=3600

echo "Polling API at ${API_URL}"
echo "SONAR_PROJECT_KEY: ${SONAR_PROJECT_KEY}"
echo "GIT_BRANCH: ${GIT_BRANCH}"
echo "Polling interval: ${interval} seconds"

start_time=$(date +%s)  # Initialize the start time

while true; do
    # Make a GET request to the API endpoint
    response=$(curl -u "${SONAR_TOKEN}": "${API_URL}")

    # Check for errors in the curl command
    if [ $? -ne 0 ]; then
        echo "Error occurred while executing curl."
        exit 1
    fi

    # Parse the JSON response
    current_status=$(echo $response | jq -r '.current.status')
    queue_status=$(echo $response | jq -r '.queue[0].status')

    if [[ "$queue_status" != "IN_PROGRESS" && "$current_status" == "SUCCESS" ]]; then
        echo "Analysis completed successfully."
        break
    elif [[ "$queue_status" == "IN_PROGRESS" ]]; then
        echo "Queue is in progress"but current component succeeded. Waiting...
    else
        echo "Current status: $current_status"
        echo "Queue status: $queue_status"
    fi

    # Calculate elapsed time
    elapsed_time=$(( $(date +%s) - start_time ))
    if [ "$elapsed_time" -ge "$TARGET_DURATION" ]; then
        echo "Time over, terminating..."
        break
    fi

    # Wait for the defined interval before polling again
    sleep $interval
done
