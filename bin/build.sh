#!/bin/sh

export PATH=$PWD/bin:$PATH

create-ssl-keys.sh
create-sts-keys.sh
create-fediz-artifacts.sh
create-machine-images.sh

