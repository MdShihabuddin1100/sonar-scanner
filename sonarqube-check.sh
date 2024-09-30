#!/bin/bash
set -x

# Define API endpoint URL
API_URL="http://aescontroller-sonarqube-sonarqube.core-ns:9000/sonarqube/api/ce/component?component=${SONAR_PROJECT_KEY}&branch=${GIT_BRANCH}"

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

    # Parse the JSON response to extract the status from the 'current' object
    current_status=$(echo $response | jq -r '.current.status')
    SCANNER_STATUS=current_status
    export SCANNER_STATUS

    if [[ ! -z "$current_status" ]]; then 
        if [[ "$current_status" == "SUCCESS" || "$current_status" == "FAILED" ]]; then
            echo "Current status: $current_status"
            break
        # else
        #     echo "Current status is not SUCCESS or FAILED: $current_status"
        fi    
    else
        echo "Current status is empty or unset."
        break
    fi


    # Calculate elapsed time
    elapsed_time=$(($(date +%s) - start_time))
    if [ "$elapsed_time" -ge "$TARGET_DURATION" ]; then
        echo "Time over, terminating..."
        break
    fi

    # Wait for the defined interval before polling again
    sleep $interval
done
