/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package it.thomasjohansen.sts.realms;

import org.apache.cxf.sts.RealmParser;
import org.apache.cxf.ws.security.sts.provider.STSException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.ws.WebServiceContext;
import java.util.StringTokenizer;

public class UriRealmParser implements RealmParser {

    public enum REALMS { REALMA, REALMB };

    private static final Logger LOG = LoggerFactory.getLogger(UriRealmParser.class);

    @Override
    public String parseRealm(WebServiceContext context) throws STSException {
        String url = (String)context.getMessageContext().get("org.apache.cxf.request.url");

        // Get the realm of the request url
        // Example: https://localhost:9443/fediz-idp-sts/REALMA/STSServiceTransport
        // realm = REALMA
        StringTokenizer st = new StringTokenizer(url, "/");
        String realm = null;
        int count = st.countTokens();
        if (count <= 1) {
            return null;
        }
        count--;
        for (int i = 0; i < count; i++) {
            realm = st.nextToken();
        }
        realm = realm.toUpperCase();
        try {
            REALMS.valueOf(realm);
        } catch (IllegalArgumentException ex) {
            LOG.warn("Unknown realm: " + realm);
            throw new STSException("Unknown realm: " + realm);
        }
        return realm;
    }

}
