package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.models.dtos.ResolvedBehaviorProfileResponse;
import com.bookify.backendbookify_saas.models.entities.ProfileResolutionAudit;
import com.bookify.backendbookify_saas.models.entities.ProfileSnapshotSyncRun;
import com.bookify.backendbookify_saas.models.entities.UserBehaviorProfileSnapshot;
import com.bookify.backendbookify_saas.repositories.ProfileResolutionAuditRepository;
import com.bookify.backendbookify_saas.repositories.ProfileSnapshotSyncRunRepository;
import com.bookify.backendbookify_saas.repositories.UserBehaviorProfileSnapshotRepository;
import com.bookify.backendbookify_saas.services.BehaviorProfileResolverService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class BehaviorProfileResolverServiceImpl implements BehaviorProfileResolverService {

    private static final String SOURCE_LIVE_TRACKER = "LIVE_TRACKER";
    private static final String SOURCE_SNAPSHOT = "SNAPSHOT";
    private static final String SOURCE_DEFAULT_EMPTY = "DEFAULT_EMPTY";

    private final UserBehaviorProfileSnapshotRepository snapshotRepository;
    private final ProfileSnapshotSyncRunRepository syncRunRepository;
    private final ProfileResolutionAuditRepository resolutionAuditRepository;
    private final ObjectMapper objectMapper;

    @Value("${tracking.service.base-url}")
    private String trackingServiceBaseUrl;

    @Value("${tracking.service.api-key:}")
    private String trackingServiceApiKey;

    @Value("${tracking.service.timeout-ms:500}")
    private int trackingServiceTimeoutMs;

    @Value("${tracking.profile.snapshot.stale-hours:12}")
    private long snapshotStaleHours;

    @Override
    public ResolvedBehaviorProfileResponse resolveProfile(String userId) {
        String liveFailureReason = null;

        try {
            Map<String, Object> liveProfile = fetchLiveProfile(userId);
            audit(userId, SOURCE_LIVE_TRACKER, null, false);
            return ResolvedBehaviorProfileResponse.builder()
                    .userId(userId)
                    .sourceUsed(SOURCE_LIVE_TRACKER)
                    .stale(false)
                    .resolvedAt(LocalDateTime.now())
                    .profile(liveProfile)
                    .build();
        } catch (Exception ex) {
            liveFailureReason = ex.getMessage();
            log.warn("Live tracker profile fetch failed for user {}: {}", userId, liveFailureReason);
        }

        Optional<UserBehaviorProfileSnapshot> snapshotOpt = snapshotRepository.findByUserId(userId);
        if (snapshotOpt.isPresent()) {
            UserBehaviorProfileSnapshot snapshot = snapshotOpt.get();
            boolean stale = isSnapshotStale(snapshot);
            audit(userId, SOURCE_SNAPSHOT, liveFailureReason, stale);
            return ResolvedBehaviorProfileResponse.builder()
                    .userId(userId)
                    .sourceUsed(SOURCE_SNAPSHOT)
                    .stale(stale)
                    .liveFailureReason(liveFailureReason)
                    .resolvedAt(LocalDateTime.now())
                    .snapshotSyncedAt(snapshot.getSyncedAt())
                    .profile(parseSnapshot(snapshot.getProfileJson()))
                    .build();
        }

        audit(userId, SOURCE_DEFAULT_EMPTY, liveFailureReason, true);
        return ResolvedBehaviorProfileResponse.builder()
                .userId(userId)
                .sourceUsed(SOURCE_DEFAULT_EMPTY)
                .stale(true)
                .liveFailureReason(liveFailureReason)
                .resolvedAt(LocalDateTime.now())
                .profile(defaultProfile(userId))
                .build();
    }

    @Override
    public Map<String, Object> getHealthSummary() {
        Optional<ProfileSnapshotSyncRun> latestRun = syncRunRepository.findTopByOrderByCreatedAtDesc();
        Optional<ProfileSnapshotSyncRun> latestSuccess = syncRunRepository.findTopByStatusOrderByEndedAtDesc("SUCCESS");
        LocalDateTime fallbackWindow = LocalDateTime.now().minusHours(1);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("trackingServiceBaseUrl", trackingServiceBaseUrl);
        response.put("latestRun", latestRun.orElse(null));
        response.put("latestSuccess", latestSuccess.orElse(null));
        response.put("fallbackCountLastHour", resolutionAuditRepository.countBySourceUsedAndCreatedAtAfter(SOURCE_SNAPSHOT, fallbackWindow));
        response.put("defaultCountLastHour", resolutionAuditRepository.countBySourceUsedAndCreatedAtAfter(SOURCE_DEFAULT_EMPTY, fallbackWindow));
        response.put("snapshotStaleHours", snapshotStaleHours);
        response.put("healthy", latestSuccess.isPresent() && latestSuccess.get().getEndedAt() != null
                && latestSuccess.get().getEndedAt().isAfter(LocalDateTime.now().minusHours(snapshotStaleHours)));
        return response;
    }

    private Map<String, Object> fetchLiveProfile(String userId) throws IOException, InterruptedException {
        String encodedUserId = URLEncoder.encode(userId, StandardCharsets.UTF_8);
        HttpRequest.Builder builder = HttpRequest.newBuilder()
                .uri(URI.create(trackingServiceBaseUrl + "/analytics/user/" + encodedUserId + "/profile"))
                .timeout(Duration.ofMillis(trackingServiceTimeoutMs))
                .GET()
                .header("Accept", "application/json");

        if (trackingServiceApiKey != null && !trackingServiceApiKey.isBlank()) {
            builder.header("x-api-key", trackingServiceApiKey);
        }

        HttpResponse<String> response = HttpClient.newHttpClient().send(builder.build(), HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() >= 400) {
            throw new IOException("Tracking service responded with status " + response.statusCode());
        }

        JsonNode root = objectMapper.readTree(response.body());
        JsonNode dataNode = root.path("data");
        if (dataNode.isMissingNode() || dataNode.isNull()) {
            throw new IOException("Tracking service returned no profile data");
        }

        return objectMapper.convertValue(dataNode, new TypeReference<>() {});
    }

    private Map<String, Object> parseSnapshot(String profileJson) {
        try {
            return objectMapper.readValue(profileJson, new TypeReference<>() {});
        } catch (IOException ex) {
            throw new IllegalStateException("Unable to parse snapshot profile JSON", ex);
        }
    }

    private Map<String, Object> defaultProfile(String userId) {
        Map<String, Object> profile = new LinkedHashMap<>();
        profile.put("userId", userId);
        profile.put("message", "No live or snapshot behavior profile available");
        profile.put("totalEvents", 0);
        profile.put("totalSessions", 0);
        return profile;
    }

    private boolean isSnapshotStale(UserBehaviorProfileSnapshot snapshot) {
        if (snapshot.getSyncedAt() == null) {
            return true;
        }
        return snapshot.getSyncedAt().isBefore(LocalDateTime.now().minusHours(snapshotStaleHours));
    }

    private void audit(String userId, String sourceUsed, String failureReason, boolean snapshotStale) {
        ProfileResolutionAudit audit = new ProfileResolutionAudit();
        audit.setUserId(userId);
        audit.setSourceUsed(sourceUsed);
        audit.setFailureReason(truncate(failureReason, 512));
        audit.setSnapshotStale(snapshotStale);
        resolutionAuditRepository.save(audit);
    }

    private String truncate(String value, int maxLength) {
        if (value == null || value.length() <= maxLength) {
            return value;
        }
        return value.substring(0, maxLength);
    }
}