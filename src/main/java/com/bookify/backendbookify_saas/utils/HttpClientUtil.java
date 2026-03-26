package com.bookify.backendbookify_saas.utils;

import java.net.http.HttpClient;
import java.time.Duration;

/**
 * Singleton utility class for managing a shared HttpClient instance.
 * Ensures a single, reusable HttpClient is used across the application.
 */
public class HttpClientUtil {
    
    private static final HttpClientUtil INSTANCE = new HttpClientUtil();
    private final HttpClient client;
    
    /**
     * Private constructor prevents instantiation.
     * HttpClient is configured with a 10-second connection timeout.
     */
    private HttpClientUtil() {
        this.client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }
    
    /**
     * Returns the singleton HttpClient instance.
     * 
     * @return the shared HttpClient instance
     */
    public static HttpClient getClient() {
        return INSTANCE.client;
    }
}
