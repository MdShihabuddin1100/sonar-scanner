#!/bin/bash
# Define API endpoint URL
SONAR_PROJECT_KEY="code"
GIT_BRANCH="main"
API_URL="http://172.18.255.200:9000/sonarqube/api/ce/component?component=${SONAR_PROJECT_KEY}&branch=${GIT_BRANCH}"
SONAR_TOKEN="squ_d918cdb2cc2143427334155c177dc15d930ce10e"

# Polling interval in seconds
interval=10

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

    # Wait for the defined interval before polling again
    sleep $interval
done

echo "Polling completed."
