#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# Pull the latest Theta Edge Node Docker image
echo "Pulling the latest Theta Edge Node Docker image..."
docker pull thetalabsorg/edgelauncher_mainnet:latest

# Stop and remove any existing Theta Edge Node containers
echo "Stopping and removing any existing Theta Edge Node containers..."
docker rm -f edgelauncher &> /dev/null

# Start the Theta Edge Node Docker container
echo "Starting the Theta Edge Node Docker container..."
echo -n "Enter a secure password for the edge node: "
read -s PASSWORD
echo
docker run -d --restart=always -e EDGELAUNCHER_CONFIG_PATH=/edgelauncher/data/mainnet -e PASSWORD="$PASSWORD" -v ~/.edgelauncher:/edgelauncher/data/mainnet -p 127.0.0.1:15888:15888 -p 127.0.0.1:17888:17888 -p 127.0.0.1:17935:17935 --name edgelauncher thetalabsorg/edgelauncher_mainnet:latest

echo "Theta Edge Node installation and setup completed successfully!"
