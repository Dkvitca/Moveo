#!/bin/bash

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# AWS Region & ECR Repository
AWS_REGION="ap-south-1"  # Change to your AWS region
ECR_REPOSITORY="686255960799.dkr.ecr.ap-south-1.amazonaws.com/deployment"

# # Authenticate with ECR (IAM Role allows this without credentials)
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY

# Pull the latest image from ECR
#docker pull $ECR_REPOSITORY:latest
docker pull "$ECR_REPOSITORY:latest"

# Stop and remove any existing container (if running)
docker stop nginx-server 2>/dev/null || true
docker rm nginx-server 2>/dev/null || true

# Run the container
docker run -d -p 80:80 --name nginx-server $ECR_REPOSITORY:latest

# Ensure the container starts on reboot
echo "@reboot root docker start nginx-server" >> /etc/crontab
