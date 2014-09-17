#!/bin/sh

DIR=target/cxf-fediz
rm -rf $DIR
git clone -v https://git-wip-us.apache.org/repos/asf/cxf-fediz.git $DIR
git checkout tags/fediz-1.1.1
sed -i .old 's/^realmA.port=.*/realmA.port=8443/' $DIR/services/idp/src/main/filters/realm-a/env.properties
sed -i .old 's/^realmB.port=.*/realmB.port=8443/' $DIR/services/idp/src/main/filters/realm-a/env.properties
cd $DIR
mvn clean package

