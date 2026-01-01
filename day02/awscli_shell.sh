#!/bin/bash
set -e

if [[ $# -ne 6 ]]; then
  echo "Usage: $0 <AMI_ID> <INSTANCE_TYPE> <KEY_NAME> <SUBNET_ID> <SECURITY_GROUP_ID> <INSTANCE_NAME>"
  exit 1
fi

AMI_ID=$1
INSTANCE_TYPE=$2
KEY_NAME=$3
SUBNET_ID=$4
SECURITY_GROUP_ID=$5
INSTANCE_NAME=$6

# Check AWS CLI
command -v aws >/dev/null || { echo "AWS CLI not installed"; exit 1; }

echo "Launching EC2 instance..."

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instance ID: $INSTANCE_ID"

aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

echo "EC2 instance $INSTANCE_ID is running 🚀"

