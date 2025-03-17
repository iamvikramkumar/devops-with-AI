#!/bin/bash

#############################
# Script Name: aws_vpc.sh
# Author: Vikram Kumar
# Date: 18-March-2025
# Description: Create or Delete AWS VPC and Subnet using AWS CLI.
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

# Check if the script receives exactly one argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <create|delete>"
    exit 1
fi

# Assigning input argument
action=$1

if [ "$action" == "create" ]; then
    echo "Creating VPC and Subnet..."

    # Create VPC
    VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
    if [ -z "$VPC_ID" ]; then
        echo "Error: Failed to create VPC."
        exit 1
    fi
    echo "VPC Created: $VPC_ID"

    # Tag VPC
    aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION

    # Create Subnet inside the VPC
    SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)
    if [ -z "$SUBNET_ID" ]; then
        echo "Error: Failed to create Subnet."
        exit 1
    fi
    echo "Subnet Created: $SUBNET_ID"

    # Tag Subnet
    aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$SUBNET_NAME --region $REGION





elif [ "$action" == "delete" ]; then
    echo "Enter the VPC ID to delete:"
    read VPC_ID

    # Get the subnet associated with the VPC
    SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[0].SubnetId" --output text --region $REGION)


    # Delete the subnet
    if [ "$SUBNET_ID" != "None" ]; then
        aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $REGION
        echo "Subnet Deleted: $SUBNET_ID"
    else
        echo "No subnet found for VPC: $VPC_ID"
    fi

    # Delete the VPC
    aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
    echo "VPC Deleted: $VPC_ID"

else
    echo "Invalid parameter. Please use 'create' or 'delete'."
    exit 1
fi
