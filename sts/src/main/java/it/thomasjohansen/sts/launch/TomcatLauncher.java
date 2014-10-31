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
        // The two cipher lists below are equivalents
//        connector.setAttribute("ciphers", "ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM");
//        connector.setAttribute("ciphers", "TLS_RSA_WITH_RC4_128_MD5:TLS_RSA_WITH_RC4_128_SHA:TLS_RSA_WITH_AES_128_CBC_SHA:TLS_RSA_WITH_AES_128_CBC_SHA256:TLS_RSA_WITH_3DES_EDE_CBC_SHA:TLS_RSA_WITH_AES_256_CBC_SHA:TLS_RSA_WITH_AES_256_CBC_SHA256");
        connector.setAttribute("ciphers", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA, TLS_ECDHE_RSA_WITH_RC4_128_SHA,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,SSL_RSA_WITH_RC4_128_SHA");
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
