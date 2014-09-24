#!/bin/sh

home=$PWD

set -e

for image in idp rp 
do
  echo "Building image $image..."
  packer build $home/packer/$image.json &
done
wait
