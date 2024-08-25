#!/bin/bash
# Define API endpoint URL
API_URL="http://aescontroller-sonarqube-sonarqube.core-ns:9000/sonarqube/api/ce/component?component=${SONAR_PROJECT_KEY}&branch=${GIT_BRANCH}"
# Polling interval in seconds
interval=10
TARGET_DURATION=3600

while true; do
    # Make a GET request to the API endpoint
    response=$(curl -u "${SONAR_TOKEN}": "${API_URL}")

    # Parse the JSON response to extract the status from the 'current' object
    current_status=$(echo $response | jq -r '.current.status')

    # Check if there's a 'current' status and if it's success or failed
    if [[ ! -z "$current_status" ]] && [[ "$current_status" == "SUCCESS" || "$current_status" == "FAILED" ]]; then
        echo "Current status: $current_status"
        break
    fi

    # Check if there's a 'current' status
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

# echo "Polling completed."
