#!/bin/sh

if [ ! $# -eq 1 ]; then echo "No AMI id specified"; exit 1; fi

aws ec2 run-instances --image-id $1 --instance-type t2.micro --key-name thomasjohansen.it --security-groups IdP --placement AvailabilityZone=us-east-1a --region=us-east-1
