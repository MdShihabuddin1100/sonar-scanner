#!/bin/bash
set -e

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

# Function to save or update the queue_status in .bashrc
save_to_bashrc() {
    local current_status=$1
    local BASHRC_FILE="$HOME/.bashrc"
    local VARIABLE_NAME="SCANNING_STATUS"

    if [ ! -f "$BASHRC_FILE" ]; then
        echo "# .bashrc created by script" > "$BASHRC_FILE"
    fi
    
    # Check if the variable already exists in .bashrc
    if grep -q "^export $VARIABLE_NAME=" "$BASHRC_FILE"; then
        # If found, replace the existing value
        sed -i "s/^export $VARIABLE_NAME=.*/export $VARIABLE_NAME=\"$current_status\"/" "$BASHRC_FILE"
    else
        # If not found, append the new value
        echo "export $VARIABLE_NAME=\"$current_status\"" >> "$BASHRC_FILE"
    fi

    echo "Queue status '$current_status' saved to .bashrc."
}

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

    if [[ "$queue_status" != "IN_PROGRESS" ]] && [[ "$current_status" == "SUCCESS" || "$current_status" == "FAILED" ]]; then
        echo "Found status successfully."
        break
    elif [[ "$queue_status" == "IN_PROGRESS" && "$watch" -lt 1 ]]; then
        echo "Queue is in progress"
        watch=$((watch + 1))
    # else
    #     echo "Current status: $current_status"
    #     echo "Queue status: $queue_status"
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

save_to_bashrc "$current_status" 