#!/bin/bash

# Step 1: List all VPCs
vpcs=$(aws ec2 describe-vpcs --query "Vpcs[*].VpcId" --output text)

# Step 2: Delete all subnets
for vpc in $vpcs; do
    echo "Deleting subnets for VPC: $vpc"
    subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc" --query "Subnets[*].SubnetId" --output text)
    for subnet in $subnets; do
        echo "Deleting subnet: $subnet"
        aws ec2 delete-subnet --subnet-id $subnet
    done
done

# Step 3: Detach and delete Internet Gateways
igws=$(aws ec2 describe-internet-gateways --query "InternetGateways[*].InternetGatewayId" --output text)
for igw in $igws; do
    attachments=$(aws ec2 describe-internet-gateways --internet-gateway-ids $igw --query "InternetGateways[0].Attachments[*].VpcId" --output text)
    for attachment in $attachments; do
        echo "Detaching Internet Gateway $igw from VPC $attachment"
        aws ec2 detach-internet-gateway --internet-gateway-id $igw --vpc-id $attachment
    done

    echo "Deleting Internet Gateway: $igw"
    aws ec2 delete-internet-gateway --internet-gateway-id $igw
done

# Step 4: Delete all VPCs
vpcs=$(aws ec2 describe-vpcs --query "Vpcs[*].VpcId" --output text)
for vpc in $vpcs; do
    echo "Deleting VPC: $vpc"
    aws ec2 delete-vpc --vpc-id $vpc
done
