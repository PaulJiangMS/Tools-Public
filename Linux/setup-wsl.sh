#!/bin/bash

# Install Python
echo "Installing Python..."
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3
sudo DEBIAN_FRONTEND=noninteractive apt install -y python-is-python3
sudo DEBIAN_FRONTEND=noninteractive apt install -y python3-pip

# Install Docker and Docker Compose
echo "Installing Docker and Docker Compose..."
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo chmod 666 /var/run/docker.sock

# Install Git
echo "Installing Git..."
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y git

# Install jq
echo "Installing jq..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y jq

# Install Miniconda
echo "Installing Miniconda..."
sudo mkdir -p /miniconda3
sudo wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda3/miniconda.sh
sudo bash /miniconda3/miniconda.sh -b -u -p /miniconda3
sudo rm /miniconda3/miniconda.sh

# Enable conda for all users
echo "Enable Miniconda for users..."
CONDA_DIR="/miniconda3"
echo "export PATH=\$PATH:$CONDA_DIR/bin" | sudo tee /etc/profile.d/miniconda.sh > /dev/null
sudo chmod +x /etc/profile.d/miniconda.sh

# Add conda to sudo's secure_path without overwriting the original value
echo "Appending Conda path to sudo's secure_path..."
sudo sed -i "/^Defaults    secure_path/ s|$|:$CONDA_DIR/bin|" /etc/sudoers

# Conda initialization for the current shell session
source /miniconda3/bin/activate
$CONDA_DIR/bin/conda init

echo "Installation complete!"
