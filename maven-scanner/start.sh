#!/bin/bash

# Run the installation script as root
/usr/local/bin/install-jdk-maven.sh

# Switch to mavenuser and run the entrypoint script
exec su -s /bin/bash mavenuser -c "/usr/local/bin/maven-scan.sh"
