#!/bin/sh

mkdir -p target/keys
cd target/keys
rm -f *

# SSL: IdP
keytool -genkeypair -validity 730 -alias idp-ssl -keystore idp-ssl.jks -dname "cn=localhost" -storepass changeit -keypass changeit
keytool -export -file idp-ssl.cer -alias idp-ssl -keystore idp-ssl.jks -storepass changeit

# SSL: RP
keytool -genkeypair -validity 730 -alias rp-ssl -keystore rp-ssl.jks -dname "cn=localhost" -storepass changeit -keypass changeit
keytool -export -file rp-ssl.cer -alias rp-ssl -keystore rp-ssl.jks -storepass changeit

# SSL: WSP
keytool -genkeypair -validity 730 -alias wsp-ssl -keystore wsp-ssl.jks -dname "cn=localhost" -storepass changeit -keypass changeit
keytool -export -file wsp-ssl.cer -alias wsp-ssl -keystore wsp-ssl.jks -storepass changeit
