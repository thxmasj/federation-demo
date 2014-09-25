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

# Configure IDP with address to STS
sed -i .old 's/localhost/stshost/' services/idp/src/main/webapp/WEB-INF/security-config.xml
sed -i .old 's/<property name="stsUrl" value="https:\/\/localhost:0\/fediz-idp-sts\/REALMA" \/>/<property name="stsUrl" value="https:\/\/stshost:0\/fediz-idp-sts\/REALMA" \/>/' services/idp/src/main/webapp/WEB-INF/idp-config-realma.xml
sed -i .old 's/<property name="stsUrl" value="https:\/\/localhost:0\/fediz-idp-sts\/REALMB" \/>/<property name="stsUrl" value="https:\/\/stshost:0\/fediz-idp-sts\/REALMB" \/>/' services/idp/src/main/webapp/WEB-INF/idp-config-realmb.xml
sed -i .old 's/<property name="wsdlLocation" value="https:\/\/localhost:0\/fediz-idp-sts\/\${realm\.STS_URI}\/STSServiceTransport?wsdl"\/>/<property name="wsdlLocation" value="https:\/\/stshost:0\/fediz-idp-sts\/\${realm\.STS_URI}\/STSServiceTransport?wsdl"\/>/' services/idp/src/main/webapp/WEB-INF/idp-servlet.xml

# Configure Crypto for IDP
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.file=stsrealm_a.jks/org.apache.ws.security.crypto.merlin.keystore.file=realma-sts.jks/' services/idp/src/main/resources/stsKeystoreA.properties
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.alias=realma/org.apache.ws.security.crypto.merlin.keystore.alias=realma-sts/' services/idp/src/main/resources/stsKeystoreA.properties
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.password=storepass/org.apache.ws.security.crypto.merlin.keystore.password=changeit/' services/idp/src/main/resources/stsKeystoreA.properties

# Configure Crypto for STS signing
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.file=stsrealm_a.jks/org.apache.ws.security.crypto.merlin.keystore.file=realma-sts.jks/' services/sts/src/main/resources/stsKeystoreA.properties
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.alias=realma/org.apache.ws.security.crypto.merlin.keystore.alias=realma-sts/' services/sts/src/main/resources/stsKeystoreA.properties
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.password=storepass/org.apache.ws.security.crypto.merlin.keystore.password=changeit/' services/sts/src/main/resources/stsKeystoreA.properties
echo 'org.apache.ws.security.crypto.merlin.keystore.private.password=changeit' >> services/sts/src/main/resources/stsKeystoreA.properties

# Configure Crypto for STS trust verification
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.file=ststrust.jks/org.apache.ws.security.crypto.merlin.keystore.file=trust-sts.jks/' services/sts/src/main/resources/stsTruststore.properties
sed -i .old 's/org.apache.ws.security.crypto.merlin.keystore.password=storepass/org.apache.ws.security.crypto.merlin.keystore.password=changeit/' services/sts/src/main/resources/stsTruststore.properties

cp ../keys/ssl/idp-ssl-trust.jks services/idp/src/main/resources/idp-ssl-trust.jks

rm services/idp/src/main/resources/stsrealm_a.jks
rm services/idp/src/main/resources/stsrealm_b.jks

rm services/sts/src/main/resources/stsrealm_a.jks
rm services/sts/src/main/resources/stsrealm_b.jks
rm services/sts/src/main/resources/ststrust.jks

rm examples/simpleWebapp/src/main/webapp/META-INF/context.xml
mvn clean package -DskipTests

