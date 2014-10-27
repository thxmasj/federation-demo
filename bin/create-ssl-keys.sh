#!/bin/sh

mkdir -p target/keys/ssl
cd target/keys/ssl
rm -f *

# SSL: STS
keytool -genkeypair -validity 730 -alias sts-ssl -keystore sts-ssl.jks -dname "cn=localhost" -storepass changeit -keypass changeit
keytool -export -file sts-ssl.cer -alias sts-ssl -keystore sts-ssl.jks -storepass changeit

# SSL: IdP
keytool -genkeypair -validity 730 -alias idp-ssl -keystore idp-ssl.jks -dname "cn=localhost" -storepass changeit -keypass changeit
keytool -import -trustcacerts -keystore idp-trust-ssl.jks -file sts-ssl.cer -alias sts-ssl -storepass changeit -noprompt

# SSL: RP
keytool -genkeypair -validity 730 -alias rp-ssl -keystore rp-ssl.jks -dname "cn=localhost" -storepass changeit -keypass changeit
