#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing curl..."
    sudo apt-get update
    sudo apt-get install -y curl
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

# Create a systemd service for the Theta Edge Node
echo "Creating systemd service for Theta Edge Node..."
sudo tee /etc/systemd/system/theta_edge_node.service << EOF
[Unit]
Description=Theta Edge Node
Requires=docker.service
After=docker.service

[Service]
Restart=always
RestartSec=30
ExecStart=/usr/bin/docker start -a edgelauncher
ExecStop=/usr/bin/docker stop -t 2 edgelauncher

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Enable the service to start automatically on boot
echo "Enabling systemd service..."
sudo systemctl enable theta_edge_node.service

echo "Theta Edge Node installation and setup completed successfully!"
