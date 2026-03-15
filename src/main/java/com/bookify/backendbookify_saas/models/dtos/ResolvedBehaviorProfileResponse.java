package com.bookify.backendbookify_saas.models.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.Map;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResolvedBehaviorProfileResponse {
    private String userId;
    private String sourceUsed;
    private boolean stale;
    private String liveFailureReason;
    private LocalDateTime resolvedAt;
    private LocalDateTime snapshotSyncedAt;
    private Map<String, Object> profile;
}