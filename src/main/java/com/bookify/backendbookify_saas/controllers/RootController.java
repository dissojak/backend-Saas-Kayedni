package com.bookify.backendbookify_saas.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * Root controller for Railway health checks and API information
 */
@RestController
@RequestMapping("/")
public class RootController {

    @GetMapping("")
    public Map<String, Object> root() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "online");
        response.put("application", "Bookify SaaS Backend");
        response.put("version", "1.0.0");
        response.put("apiPath", "/api");
        response.put("documentation", "/api/swagger-ui.html");
        response.put("health", "/health");
        response.put("actuatorHealth", "/api/actuator/health");
        response.put("message", "API is running. Access API at /api/v1/*");
        return response;
    }

    @GetMapping("health")
    public Map<String, String> simpleHealth() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "UP");
        response.put("message", "Application is healthy");
        return response;
    }
}

