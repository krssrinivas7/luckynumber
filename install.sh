#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update package lists
echo "Updating packages..."
sudo apt update -y

# Install necessary tools if not already installed
echo "Checking and installing Unzip..."
if ! command_exists unzip; then
  sudo apt install unzip -y
fi

# Define the Terraform version you want to install
TERRAFORM_VERSION="1.5.7"

# Check if Terraform is already installed
if ! command_exists terraform; then
  # URL to download Terraform binary from the official releases
  TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

  # Installation directory for Terraform
  INSTALL_DIR="/usr/local/bin"

  # Download and install Terraform
  echo "Downloading Terraform ${TERRAFORM_VERSION}..."
  curl -O $TERRAFORM_URL

  echo "Extracting Terraform..."
  unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d $INSTALL_DIR

  # Clean up downloaded files
  rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

  # Verify Terraform installation
  if [ $(terraform version | grep -c "Terraform v${TERRAFORM_VERSION}") -gt 0 ]; then
    echo "Terraform ${TERRAFORM_VERSION} installed successfully."
  else
    echo "Failed to install Terraform ${TERRAFORM_VERSION}."
    exit 1
  fi
else
  echo "Terraform is already installed. Version: $(terraform version)"
fi

# Install Docker if not already installed
echo "Checking and installing Docker..."
if ! command_exists docker; then
  sudo apt install docker.io -y

  # Add the current user to the Docker group (to run Docker without sudo)
  echo "Adding the current user to the Docker group..."
  sudo usermod -aG docker $USER

  # Start the Docker service
  echo "Starting Docker service..."
  sudo service docker start

  # Verify Docker installation
  if [ $(docker --version | grep -c "Docker version") -gt 0 ]; then
    echo "Docker installed successfully. Version: $(docker --version)"
  else
    echo "Failed to install Docker."
    exit 1
  fi
else
  echo "Docker is already installed. Version: $(docker --version)"
fi

# Install AWS CLI if not already installed
echo "Checking and installing AWS CLI..."
if ! command_exists aws; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install

  # Verify AWS CLI installation
  if [ $(aws --version | grep -c "aws-cli") -gt 0 ]; then
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