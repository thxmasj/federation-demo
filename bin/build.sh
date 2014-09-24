#!/bin/sh

export PATH=$PWD/bin:$PATH

# Run these in parallell
create-ssl-keys.sh &
create-sts-keys.sh &
wait

create-fediz-artifacts.sh
create-machine-images.sh

