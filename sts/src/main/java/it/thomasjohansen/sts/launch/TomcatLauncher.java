package it.thomasjohansen.sts.launch;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.Wrapper;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.loader.WebappLoader;
import org.apache.catalina.startup.Tomcat;
import org.apache.cxf.transport.servlet.CXFServlet;
import org.springframework.web.context.ContextLoaderListener;

import java.io.File;
import java.nio.file.FileSystems;

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
        context.setLoader(new WebappLoader(Thread.currentThread().getContextClassLoader()));
        Connector connector = new Connector();
        connector.setPort(8443);
        connector.setSecure(true);
        connector.setScheme("https");
        connector.setAttribute("ciphers", "ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM");
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
        connector.setAttribute("sslEnabledProtocols", "TLSv1.2");
        connector.setAttribute("sslProtocol", "TLSv1.2");
        tomcat.getService().addConnector(connector);
        tomcat.setConnector(connector);
        tomcat.start();
        tomcat.getServer().await();
    }

}
