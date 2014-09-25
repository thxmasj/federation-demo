#!/bin/sh

if [ ! $# -eq 1 ]; then echo "No EC2 instance name specified"; exit 1; fi

name=$1

aws ec2 describe-instances --filters "Name=tag:Name,Values=$name" | jq -r '.Reservations[0].Instances[0].PublicIpAddress'
