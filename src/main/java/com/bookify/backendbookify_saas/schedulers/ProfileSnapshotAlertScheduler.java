package com.bookify.backendbookify_saas.schedulers;

import com.bookify.backendbookify_saas.email_SMTP.MailService;
import com.bookify.backendbookify_saas.models.entities.ProfileAlertState;
import com.bookify.backendbookify_saas.models.entities.ProfileSnapshotSyncRun;
import com.bookify.backendbookify_saas.repositories.ProfileAlertStateRepository;
import com.bookify.backendbookify_saas.repositories.ProfileResolutionAuditRepository;
import com.bookify.backendbookify_saas.repositories.ProfileSnapshotSyncRunRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
@Slf4j
public class ProfileSnapshotAlertScheduler {

    // Separate alert state keys per channel so cooldowns are independent
    private static final String EMAIL_STALE_KEY    = "email-profile-sync-stale";
    private static final String EMAIL_FALLBACK_KEY = "email-profile-fallback-high";
    private static final String EMAIL_RUN_FAIL_KEY = "email-profile-run-fail";
    private static final String TG_STALE_KEY       = "tg-profile-sync-stale";
    private static final String TG_FALLBACK_KEY    = "tg-profile-fallback-high";
    private static final String TG_RUN_FAIL_KEY    = "tg-profile-run-fail";

    private final ProfileSnapshotSyncRunRepository syncRunRepository;
    private final ProfileResolutionAuditRepository resolutionAuditRepository;
    private final ProfileAlertStateRepository alertStateRepository;
    private final MailService mailService;

    @Value("${tracking.profile.alert.enabled:false}")
    private boolean alertsEnabled;

    @Value("${tracking.profile.alert-email:}")
    private String alertEmail;

    @Value("${tracking.profile.alert.stale-threshold-hours:12}")
    private long staleThresholdHours;

    @Value("${tracking.profile.alert.fallback-window-minutes:60}")
    private long fallbackWindowMinutes;

    @Value("${tracking.profile.alert.fallback-threshold:10}")
    private long fallbackThreshold;

    // Email: at most once per day per alert type
    @Value("${tracking.profile.alert.email-cooldown-minutes:1440}")
    private long emailCooldownMinutes;

    // Telegram: at most once per hour per alert type
    @Value("${tracking.profile.alert.telegram-cooldown-minutes:60}")
    private long telegramCooldownMinutes;

    @Value("${telegram.alert.enabled:false}")
    private boolean telegramEnabled;

    @Value("${telegram.bot.token:}")
    private String telegramBotToken;

    @Value("${telegram.chat.id:}")
    private String telegramChatId;

    @Scheduled(cron = "0 */15 * * * *")
    public void checkProfileSnapshotHealth() {
        if (!alertsEnabled) {
            log.debug("Profile snapshot alert scheduler skipped (alerts disabled)");
            return;
        }

        log.debug("Profile snapshot alert scheduler started");
        try {
            sendRunFailureAlerts();
            sendStaleSyncAlerts();
            sendFallbackUsageAlerts();
            log.debug("Profile snapshot alert scheduler finished");
        } catch (Exception ex) {
            log.error("Profile snapshot alert scheduler failed", ex);
        }
    }

    private void sendRunFailureAlerts() {
        List<ProfileSnapshotSyncRun> pending = syncRunRepository
                .findByStatusInAndAlertSentAtIsNullOrderByCreatedAtAsc(List.of("FAILED", "PARTIAL"));
        if (pending.isEmpty()) {
            return;
        }

        // Telegram: one summary message per hour listing all new failures
        if (isTelegramReady() && shouldSendAlert(TG_RUN_FAIL_KEY, telegramCooldownMinutes)) {
            String lines = pending.stream()
                    .map(r -> "• Run #" + r.getId() + " [" + r.getStatus() + "] synced=" + r.getSyncedCount() + " failed=" + r.getFailedCount() + " at " + r.getEndedAt())
                    .collect(Collectors.joining("\n"));
            sendTelegramMessage("[Kayedni] Snapshot sync failures\n" + lines);
            markAlertSent(TG_RUN_FAIL_KEY);
        }

        // Email: one batched email per day
        if (isEmailReady() && shouldSendAlert(EMAIL_RUN_FAIL_KEY, emailCooldownMinutes)) {
            StringBuilder body = new StringBuilder();
            for (ProfileSnapshotSyncRun run : pending) {
                body.append("Run ID: ").append(run.getId()).append("\n")
                    .append("Status: ").append(run.getStatus()).append("\n")
                    .append("Triggered by: ").append(run.getTriggeredBy()).append("\n")
                    .append("Synced: ").append(run.getSyncedCount()).append(" / Failed: ").append(run.getFailedCount()).append("\n")
                    .append("Ended at: ").append(run.getEndedAt()).append("\n")
                    .append("Error: ").append(run.getErrorSummary() == null ? "n/a" : run.getErrorSummary()).append("\n\n");
            }
            mailService.sendSimpleMessage(alertEmail,
                    "[Kayedni] " + pending.size() + " snapshot sync run(s) failed", body.toString().trim());
            markAlertSent(EMAIL_RUN_FAIL_KEY);
        }

        // Mark each run as alerted so it won't reappear in future queries
        pending.forEach(r -> r.setAlertSentAt(LocalDateTime.now()));
        syncRunRepository.saveAll(pending);
    }

    private void sendStaleSyncAlerts() {
        Optional<ProfileSnapshotSyncRun> latestSuccess = syncRunRepository.findTopByStatusOrderByEndedAtDesc("SUCCESS");
        boolean stale = latestSuccess.isEmpty()
                || latestSuccess.get().getEndedAt() == null
                || latestSuccess.get().getEndedAt().isBefore(LocalDateTime.now().minusHours(staleThresholdHours));

        if (!stale) {
            return;
        }

        String detail = latestSuccess
                .map(r -> "Last success: " + r.getEndedAt() + " (>" + staleThresholdHours + "h ago)")
                .orElse("No successful sync recorded yet.");

        if (isTelegramReady() && shouldSendAlert(TG_STALE_KEY, telegramCooldownMinutes)) {
            sendTelegramMessage("[Kayedni] Profile snapshot sync is STALE\n" + detail);
            markAlertSent(TG_STALE_KEY);
        }

        if (isEmailReady() && shouldSendAlert(EMAIL_STALE_KEY, emailCooldownMinutes)) {
            mailService.sendSimpleMessage(alertEmail, "[Kayedni] Profile snapshot sync is stale", detail);
            markAlertSent(EMAIL_STALE_KEY);
        }
    }

    private void sendFallbackUsageAlerts() {
        LocalDateTime windowStart = LocalDateTime.now().minusMinutes(fallbackWindowMinutes);
        long count = resolutionAuditRepository.countBySourceUsedAndCreatedAtAfter("SNAPSHOT", windowStart);

        if (count < fallbackThreshold) {
            return;
        }

        String detail = "Snapshot fallback used " + count + "x in the last " + fallbackWindowMinutes
                + " min. Live tracking service may be degraded.";

        if (isTelegramReady() && shouldSendAlert(TG_FALLBACK_KEY, telegramCooldownMinutes)) {
            sendTelegramMessage("[Kayedni] Elevated fallback usage\n" + detail);
            markAlertSent(TG_FALLBACK_KEY);
        }

        if (isEmailReady() && shouldSendAlert(EMAIL_FALLBACK_KEY, emailCooldownMinutes)) {
            mailService.sendSimpleMessage(alertEmail, "[Kayedni] Snapshot fallback usage is elevated", detail);
            markAlertSent(EMAIL_FALLBACK_KEY);
        }
    }

    private boolean shouldSendAlert(String alertKey, long cooldown) {
        Optional<ProfileAlertState> state = alertStateRepository.findByAlertKey(alertKey);
        return state.isEmpty() || state.get().getLastSentAt().isBefore(LocalDateTime.now().minusMinutes(cooldown));
    }

    private void markAlertSent(String alertKey) {
        ProfileAlertState state = alertStateRepository.findByAlertKey(alertKey).orElseGet(ProfileAlertState::new);
        state.setAlertKey(alertKey);
        state.setLastSentAt(LocalDateTime.now());
        alertStateRepository.save(state);
    }

    private boolean isEmailReady() {
        return alertEmail != null && !alertEmail.isBlank();
    }

    private boolean isTelegramReady() {
        return telegramEnabled
                && telegramBotToken != null && !telegramBotToken.isBlank()
                && telegramChatId != null && !telegramChatId.isBlank();
    }

    private void sendTelegramMessage(String text) {
        try {
            String url = "https://api.telegram.org/bot" + telegramBotToken + "/sendMessage";
            String payload = "{\"chat_id\":\"" + escapeJson(telegramChatId)
                    + "\",\"text\":\"" + escapeJson(text) + "\"}";
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .timeout(Duration.ofSeconds(5))
                    .build();
            HttpResponse<String> response = HttpClient.newHttpClient()
                    .send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() != 200) {
                log.warn("Telegram alert returned {}: {}", response.statusCode(), response.body());
            }
        } catch (Exception e) {
            log.warn("Failed to send Telegram alert: {}", e.getMessage());
        }
    }

    private String escapeJson(String text) {
        return text.replace("\\", "\\\\").replace("\"", "\\\"")
                   .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}