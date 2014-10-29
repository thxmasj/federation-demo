package it.thomasjohansen.sts.launch;

import org.apache.catalina.*;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.startup.Tomcat;
import org.apache.cxf.transport.servlet.CXFServlet;
import org.springframework.web.context.ContextLoaderListener;

import java.io.File;
import java.io.IOException;
import java.security.UnrecoverableKeyException;
import java.util.Scanner;

public class TomcatLauncher {

    public static void main(String[] args) throws LifecycleException {
        Tomcat tomcat = new Tomcat();
        Context context = tomcat.addContext("/sts", "/tmp");
        context.addApplicationListener(ContextLoaderListener.class.getName());
        context.addParameter("contextConfigLocation", "classpath:applicationContext.xml");
        Wrapper wrapper = context.createWrapper();
        wrapper.setName("sts");
        wrapper.setServletClass(CXFServlet.class.getName());
        wrapper.setLoadOnStartup(1);
        context.addChild(wrapper);
        context.addServletMapping("/*", "sts");
        Connector connector = new Connector();
        connector.setPort(8443);
        connector.setSecure(true);
        connector.setScheme("https");
        //connector.setAttribute("ciphers", "EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH+aRSA+RC4:EECDH:EDH+aRSA:RC4:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS");
        if (System.getProperty("javax.net.ssl.keyStore") == null)
            throw new IllegalArgumentException("System property \"javax.net.ssl.keyStore\" must specify the path to a JKS keystore");
        connector.setAttribute("keystoreFile", new File(System.getProperty("javax.net.ssl.keyStore")).getAbsolutePath());
        String keystorePassword = System.getProperty("javax.net.ssl.keyStorePassword");
        if (keystorePassword == null) {
            if (System.console() == null)
                throw new IllegalArgumentException("System property \"javax.net.ssl.keyStorePassword\" must specify a keystore password");
            keystorePassword = String.valueOf(System.console().readPassword("Enter keystore password: ", null));
        }
        connector.setAttribute("keystorePass", keystorePassword);
        connector.setAttribute("clientAuth", false);
        connector.setAttribute("SSLEnabled", "true");
        connector.setAttribute("sslProtocol", "TLS");
        tomcat.getService().addConnector(connector);
        tomcat.setConnector(connector);
        tomcat.start();
        tomcat.getServer().await();
    }

}
