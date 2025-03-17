#!/bin/bash

#############################
# Script Name: vpc_manager.sh
# Author: Vikram Kumar
# Date: 18-March-2025
# Description: Create or Delete AWS VPC and Subnet using AWS CLI.
#############################

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

# Ask user for input
echo "Do you want to create or delete resources? (create/delete)"
read action

# AWS Region (Modify as needed)
AWS_REGION="ap-southeast-2"

if [ "$action" == "create" ]; then
    echo "Creating VPC and Subnet..."

    # Create VPC
    VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text --region $AWS_REGION)
    if [ -z "$VPC_ID" ]; then
        echo "Error: Failed to create VPC."
        exit 1
    fi
    echo "VPC Created: $VPC_ID"

    # Create Subnet inside the VPC
    SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text --region $AWS_REGION)
    if [ -z "$SUBNET_ID" ]; then
        echo "Error: Failed to create Subnet."
        exit 1
    fi
    echo "Subnet Created: $SUBNET_ID"

elif [ "$action" == "delete" ]; then
    echo "Enter the VPC ID to delete:"
    read VPC_ID

    # Check if VPC exists
    VPC_COUNT=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID --query 'Vpcs' --output text --region $AWS_REGION 2>/dev/null | wc -l)
    
    if [ $VPC_COUNT -eq 0 ]; then
        echo "You don't have any VPC with the given ID: $VPC_ID. Deletion aborted."
        exit 1
    fi

    # Get the subnet associated with the VPC
    SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[0].SubnetId" --output text --region $AWS_REGION)

    # Delete the subnet
    if [ "$SUBNET_ID" != "None" ]; then
        aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $AWS_REGION
        echo "Subnet Deleted: $SUBNET_ID"
    else
        echo "No subnet found for VPC: $VPC_ID"
    fi

    # Delete the VPC
    aws ec2 delete-vpc --vpc-id $VPC_ID --region $AWS_REGION
    echo "VPC Deleted: $VPC_ID"

else
    echo "Invalid parameter. Please enter 'create' or 'delete'."
fi

# End of script