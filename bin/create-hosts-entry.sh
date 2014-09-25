#!/bin/sh

echo $(get-ip-address.sh federation-demo/IDP) idphost
echo $(get-ip-address.sh federation-demo/STS) stshost
echo $(get-ip-address.sh federation-demo/RP) rphost

