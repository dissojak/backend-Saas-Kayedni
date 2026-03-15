package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.dtos.ResolvedBehaviorProfileResponse;

import java.util.Map;

public interface BehaviorProfileResolverService {
    ResolvedBehaviorProfileResponse resolveProfile(String userId);
    Map<String, Object> getHealthSummary();
}