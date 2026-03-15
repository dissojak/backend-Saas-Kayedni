package com.bookify.backendbookify_saas.controllers;

import com.bookify.backendbookify_saas.models.dtos.ResolvedBehaviorProfileResponse;
import com.bookify.backendbookify_saas.services.BehaviorProfileResolverService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/v1/behavior-profiles")
@RequiredArgsConstructor
public class BehaviorProfileController {

    private final BehaviorProfileResolverService behaviorProfileResolverService;

    @GetMapping("/{userId}/resolved")
    public ResponseEntity<ResolvedBehaviorProfileResponse> resolve(@PathVariable String userId) {
        return ResponseEntity.ok(behaviorProfileResolverService.resolveProfile(userId));
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        return ResponseEntity.ok(behaviorProfileResolverService.getHealthSummary());
    }
}