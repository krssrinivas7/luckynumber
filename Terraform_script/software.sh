#!/bin/bash

# Update package lists
echo "Updating packages..."
sudo apt update -y

# Install necessary tools if not already installed
echo "Checking and installing Unzip..."
if ! dpkg -l | grep -q "unzip"; then
  sudo apt install unzip -y
else
  echo "Unzip is already installed."
fi

# Function to check if Docker is installed
docker_installed() {
  if command -v docker &>/dev/null; then
    return 0 # Docker is installed
  else
    return 1 # Docker is not installed
  fi
}

# Install Docker if not already installed
echo "Checking and installing Docker..."
if ! docker_installed; then
  sudo apt install docker.io -y

  # Add the current user to the Docker group (to run Docker without sudo)
  echo "Adding the current user to the Docker group..."
  sudo usermod -aG docker $USER

  # Start the Docker service
  echo "Starting Docker service..."
  sudo service docker start

  # Verify Docker installation
  if docker_installed; then
    echo "Docker installed successfully. Version: $(docker --version)"
  else
    echo "Failed to install Docker."
    exit 1
  fi
else
  echo "Docker is already installed. Version: $(docker --version)"
fi

# Function to check if AWS CLI is installed
aws_cli_installed() {
  if command -v aws &>/dev/null; then
    return 0 # AWS CLI is installed
  else
    return 1 # AWS CLI is not installed
  fi
}

# Install AWS CLI if not already installed
echo "Checking and installing AWS CLI..."
if ! aws_cli_installed; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  # Verify AWS CLI installation
  if aws_cli_installed; then
    echo "AWS CLI installed successfully. Version: $(aws --version)"
  else
    echo "Failed to install AWS CLI."
    exit 1
  fi

  # Clean up downloaded files
  echo "Cleaning up..."
  rm -rf awscliv2.zip aws
else
  echo "AWS CLI is already installed. Version: $(aws --version)"
fi

echo "Setup completed successfully."