#!/bin/sh

mkdir -p target/keys/sts
cd target/keys/sts
rm -f *

# STS: Realm A
keytool -genkeypair -validity 730 -alias realma-sts -keystore realma-sts.jks -dname "cn=realma" -storepass changeit -keypass changeit
keytool -export -file realma-sts.cer -alias realma-sts -keystore realma-sts.jks -storepass changeit

# STS: Realm B
keytool -genkeypair -validity 730 -alias realmb-sts -keystore realmb-sts.jks -dname "cn=realmb" -storepass changeit -keypass changeit
keytool -export -file realmb-sts.cer -alias realmb-sts -keystore realmb-sts.jks -storepass changeit

# STS: Trust
keytool -import -trustcacerts -keystore trust-sts.jks -storepass changeit -alias realma-sts -file realma-sts.cer -noprompt
keytool -import -trustcacerts -keystore trust-sts.jks -storepass changeit -alias realmb-sts -file realmb-sts.cer -noprompt

