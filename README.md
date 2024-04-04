# Theta_Edge_Node_script

Tested on Linux server - Ubuntu 22.04 LTS 64bit

This script that combines all the commands to install the Theta Edge Node Docker container and set up a systemd service to manage it.

* Save this script to a file named `install_theta_edge_node.sh`.
* Make it executable `chmod +x install_theta_edge_node.sh`.
* Execute it with root privileges `sudo ./install_theta_edge_node.sh`.

* Optional: You can copy/paste from here to your server machine and create/open file with following command: `sudo nano path/to/your/install_theta_edge_node.sh`.

This script will perform the following tasks:

1. Install Docker if not already installed.
2. Pull the latest Theta Edge Node Docker image.
3. Stop and remove any existing Theta Edge Node containers.
4. Start the Theta Edge Node Docker container.
5. Create a systemd service to manage the Theta Edge Node container.
6. Enable the systemd service to start automatically on boot.

Make sure to replace <YOUR_PASSWORD> with a secure password when prompted.
