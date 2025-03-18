#!/bin/bash

#############################
# Script Name: aws_vpc_create.sh
# Author: Vikram Kumar
# Date: 18-March-2025
# Description: Create or Delete AWS VPC and Subnet using AWS CLI.
#############################


#############################
# - Create VPC
# - Create a Public Subnet
# 
# - Verify if user has AWS CLI is installed, User might be using windows, linux or mac.
# - Verify if AWS CLI is configured
#############################


# Define AWS Configuration Variables
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.0.0/24"
REGION="ap-southeast-2"
VPC_NAME="my_vpc"
SUBNET_NAME="my_subnet"

# Verify if AWS CLI is installed
if ! [ -x "$(command -v aws)" ]; then
  echo "Error: AWS CLI is not installed. Please install it and configure it."
  exit 1
fi

# Verify if AWS CLI is configured
aws sts get-caller-identity &>/dev/null
if [ $? -ne 0 ]; then
  echo "Error: AWS CLI is not configured. Please configure it using 'aws configure' command."
  exit 1
fi  

# Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
if [ -z "$VPC_ID" ]; then
    echo "Error: Failed to create VPC."
    exit 1
fi

# Add Name tag to VPC
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION
if [ $? -ne 0 ]; then
    echo "Error: Failed to tag VPC."
    exit 1
fi

# Create Subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)
if [ -z "$SUBNET_ID" ]; then
    echo "Error: Failed to create Subnet."
    exit 1
fi    

# Add Name tag to Subnet
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$SUBNET_NAME --region $REGION
if [ $? -ne 0 ]; then
    echo "Error: Failed to tag Subnet."
    exit 1
fi

# Display VPC and Subnet ID
echo "VPC ID: $VPC_ID"
echo "Subnet ID: $SUBNET_ID"

# End of the Script
