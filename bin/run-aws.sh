#!/bin/sh

if [ ! $# -eq 1 ]; then echo "No AMI id specified"; exit 1; fi

image_id=$1

instance_details=$(aws ec2 run-instances --image-id $image_id --instance-type t2.micro --key-name thomasjohansen.it --security-groups federation-demo --placement AvailabilityZone=us-east-1a --region=us-east-1 --count=1)

# Get id of the started instance
#instance_id=$(aws ec2 describe-instances --filters "Name=image-id,Values=$image_id" | jq ".Reservations[]|.Instances[]|.InstanceId" | sed 's/"//g')
instance_id=$(echo $instance_details | jq ".Instances[0].InstanceId" | sed 's/"//g')

# Set the Name tag of the instance from the Name tag of the image
name=$(aws ec2 describe-images --image-ids $image_id | jq ".Images[0].Tags[0].Value" | sed 's/"//g')
aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$name

# Print the public IP of the instance
#public_ip=$(aws ec2 describe-instances --filters "Name=instance-id,Values=$instance_id" | jq ".Reservations[0].Instances[0].PublicIpAddress" | sed 's/"//g')
public_ip=$(echo $instance_details | jq ".Instances[0].PublicIpAddress" | sed 's/"//g')
echo "Instance $name launched. Id=$instance_id, IP=$public_ip"

