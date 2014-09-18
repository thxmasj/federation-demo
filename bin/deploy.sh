#!/bin/sh

export PATH=$PWD/bin:$PATH
export LC_CTYPE=en_US.UTF-8

for ami_id in $@
do
  run-aws.sh $ami_id
done

