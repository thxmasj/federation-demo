#!/bin/sh

mkdir -p target/keys/sts
cd target/keys/sts
rm -f *

# Realm A
keytool -genkeypair -keyalg RSA -validity 3600 -alias realma-sts -keystore realma-sts.jks -dname "CN=REALMA" -storepass changeit -keypass changeit
keytool -export -file realma-sts.cer -alias realma-sts -keystore realma-sts.jks -storepass changeit

# Realm B
keytool -genkeypair -keyalg RSA -validity 3600 -alias realmb-sts -keystore realmb-sts.jks -dname "CN=REALMB" -storepass changeit -keypass changeit
keytool -export -file realmb-sts.cer -alias realmb-sts -keystore realmb-sts.jks -storepass changeit

# Trust
keytool -import -trustcacerts -keystore trust-sts.jks -storepass changeit -alias realma-sts -file realma-sts.cer -noprompt
keytool -import -trustcacerts -keystore trust-sts.jks -storepass changeit -alias realmb-sts -file realmb-sts.cer -noprompt
