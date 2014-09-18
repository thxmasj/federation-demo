#!/bin/sh

home=$PWD

set -e

images=(idp rp)
pids=()
for image in ${images[@]}
do
  echo "Building image $image..."
  packer build $home/packer/$image.json &
  pids[$image]=$!
done
for image in ${images[@]}
do
  pid=${pids[$image]}
  if ps -p $pid > /dev/null
  then
    echo "Waiting for image $image (pid $pid)..."
    wait $pid
  fi
  echo "Image $image (pid $pid) done"
done

