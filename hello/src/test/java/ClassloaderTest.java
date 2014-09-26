import net.sf.ehcache.config.CacheConfiguration;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;

/**
 * Created by thomas on 26/09/14.
 */
public class ClassloaderTest {

    @Test
    public void test() throws ClassNotFoundException {
        Class<?> clazz = Class.forName("net.sf.ehcache.config.CacheConfiguration");
        Class<?> clazz2 = Class.forName("net.sf.ehcache.config.CacheConfiguration");
        assertEquals(clazz, clazz2);
        assertSame(clazz, clazz2);
    }

}
