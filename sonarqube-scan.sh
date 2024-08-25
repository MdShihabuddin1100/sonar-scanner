#!/bin/bash
# Define API endpoint URL
SONAR_PROJECT_KEY="code"
GIT_BRANCH="main"
# Define API endpoint URL
API_URL="http://172.18.255.200/sonarqube/api/ce/component?component=${SONAR_PROJECT_KEY}&branch=${GIT_BRANCH}"
SONAR_TOKEN="squ_83ad5e8e3ee77f40a203933cea2a8aa9d5252654"
# Polling interval in seconds
interval=10
TARGET_DURATION=3600

echo "Polling API at ${API_URL}"
echo "SONAR_PROJECT_KEY: ${SONAR_PROJECT_KEY}"
echo "GIT_BRANCH: ${GIT_BRANCH}"
echo "Polling interval: ${interval} seconds"

while true; do
    # Make a GET request to the API endpoint with verbose output
    response=$(curl -v -u "${SONAR_TOKEN}": "${API_URL}")

    # Check for errors in the curl command
    if [ $? -ne 0 ]; then
        echo "Error occurred while executing curl."
        exit 1
    fi

    # Parse the JSON response to extract the status from the 'current' object
    current_status=$(echo $response | jq -r '.current.status')

    # Check if there's a 'current' status and if it's success or failed
    if [[ ! -z "$current_status" ]] && [[ "$current_status" == "SUCCESS" || "$current_status" == "FAILED" ]]; then
        echo "Current status: $current_status"
        break
    fi

    if [[ ! -z "$current_status" ]]; then
        echo "Current status is: $current_status"
    fi

    if [ "$SECONDS" -ge "$TARGET_DURATION" ]; then
        echo "2 hours have passed. Terminating..."
        break
    fi

    # Wait for the defined interval before polling again
    sleep $interval
done
