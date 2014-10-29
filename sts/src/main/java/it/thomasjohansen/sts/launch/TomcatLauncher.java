package it.thomasjohansen.sts.launch;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.Wrapper;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.startup.Tomcat;
import org.apache.cxf.transport.servlet.CXFServlet;
import org.springframework.web.context.ContextLoaderListener;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import java.io.File;

public class TomcatLauncher {

    public static void main(String[] args) throws LifecycleException, ServletException {
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
        connector.setAttribute("keystoreFile", "sts-ssl.jks");
        connector.setAttribute("keystorePass", "changeit");
        connector.setAttribute("clientAuth", false);
        connector.setAttribute("SSLEnabled", "true");
        connector.setAttribute("sslProtocol", "TLS");
        tomcat.getService().addConnector(connector);
        tomcat.setConnector(connector);
        tomcat.start();
        tomcat.getServer().await();
    }

}
