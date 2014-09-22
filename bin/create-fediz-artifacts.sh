#!/bin/sh

DIR=target/cxf-fediz
rm -rf $DIR
git clone https://git-wip-us.apache.org/repos/asf/cxf-fediz.git $DIR
cd $DIR
git checkout tags/fediz-1.1.1
sed -i .old 's/^realmA.port=.*/realmA.port=8443/' services/idp/src/main/filters/realm-a/env.properties
sed -i .old 's/^realmB.port=.*/realmB.port=8443/' services/idp/src/main/filters/realm-a/env.properties
sed -i .old 's/WS Federation Tomcat Examples/Federation APP_INDEX/' examples/simpleWebapp/src/main/webapp/index.html
sed -i .old 's/WS Federation Tomcat Examples/Federation APP_SERCURE_TEST/' examples/simpleWebapp/src/main/webapp/secure/test.html
sed -i .old 's/WS Federation Tomcat Examples/Federation IDP_INDEX/' services/idp/src/main/webapp/index.html
sed -i .old 's/ispass/changeit/' services/idp/src/main/webapp/WEB-INF/applicationContext.xml

#sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.file=stsrealm_a.jks/org.apache.ws.security.crypto.merlin.keystore.file=realma_sts.jks/' services/idp/src/main/resources/stsKeystoreA.properties
#sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.alias=realma/org.apache.ws.security.crypto.merlin.keystore.alias=realma_sts/' services/idp/src/main/resources/stsKeystoreA.properties
#sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.password=storepass/org.apache.ws.security.crypto.merlin.keystore.password=changeit/' services/idp/src/main/resources/stsKeystoreA.properties

cp ../keys/ssl/idp-ssl-trust.jks services/idp/src/main/resources/idp-ssl-trust.jks

rm examples/simpleWebapp/src/main/webapp/META-INF/context.xml
mvn clean package -DskipTests

