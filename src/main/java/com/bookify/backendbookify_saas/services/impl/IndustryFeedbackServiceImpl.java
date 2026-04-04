package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.email_SMTP.MailService;
import com.bookify.backendbookify_saas.models.dtos.IndustryFeedbackRequest;
import com.bookify.backendbookify_saas.models.dtos.IndustryFeedbackResponse;
import com.bookify.backendbookify_saas.models.entities.IndustryFeedbackSubmission;
import com.bookify.backendbookify_saas.repositories.IndustryFeedbackSubmissionRepository;
import com.bookify.backendbookify_saas.services.IndustryFeedbackService;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.format.DateTimeFormatter;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;


@Service
@RequiredArgsConstructor
@Slf4j
public class IndustryFeedbackServiceImpl implements IndustryFeedbackService {

    private final IndustryFeedbackSubmissionRepository repository;
    private final MailService mailService;

    @Value("${flow-b.admin.alert.email.enabled:true}")
    private boolean emailAlertEnabled;

    @Value("${flow-b.admin.alert-email:}")
    private String adminAlertEmail;

    @Value("${tracking.profile.alert-email:}")
    private String trackingFallbackAlertEmail;

    @Value("${spring.mail.username:}")
    private String mailSenderAddress;

    @Value("${flow-b.admin.telegram.enabled:false}")
    private boolean telegramAlertEnabled;

    @Value("${flow-b.admin.telegram.bot-token:}")
    private String telegramBotToken;

    @Value("${flow-b.admin.telegram.chat-id:}")
    private String telegramChatId;

    @Value("${telegram.bot.token:}")
    private String alertBotToken;

    @Value("${telegram.chat.id:}")
    private String alertChatId;

    private static final DateTimeFormatter EMAIL_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");


    @Override
    @Transactional
    public IndustryFeedbackResponse submitFeedback(IndustryFeedbackRequest request) {
        IndustryFeedbackSubmission submission = IndustryFeedbackSubmission.builder()
                .industryName(safeTrim(request.getIndustryName()))
                .description(safeTrim(request.getDescription()))
                .phoneNumber(safeTrim(request.getPhoneNumber()))
                .sourceSlug(safeTrim(request.getSourceSlug()))
                .sourceCategoryName(safeTrim(request.getSourceCategoryName()))
                .contactEmail(safeTrim(request.getContactEmail()))
                .build();

        IndustryFeedbackSubmission saved = repository.save(submission);
        dispatchAlertsAfterCommit(saved);

        return IndustryFeedbackResponse.builder()
                .id(saved.getId())
                .message("Thank you. Your industry suggestion has been received.")
                .submittedAt(saved.getCreatedAt())
                .build();
    }

    @Override
    public List<IndustryFeedbackSubmission> getLatestFeedback() {
        return repository.findTop200ByOrderByCreatedAtDesc();
    }

    private void sendAdminAlerts(IndustryFeedbackSubmission submission) {
        String emailSubject = "[Kayedni] New 'Other industry' request";
        String emailBody = buildEmailBody(submission);
        String emailHtml = buildEmailHtml(submission);
        String resolvedEmailRecipient = resolveAdminAlertEmail();
        String resolvedTelegramToken = resolveTelegramBotToken();
        String resolvedTelegramChatId = resolveTelegramChatId();

        if (isEmailReady(resolvedEmailRecipient)) {
            try {
                mailService.sendRichMessage(resolvedEmailRecipient, emailSubject, emailBody, emailHtml);
                log.info("Flow B admin email alert sent for submission {} to {}", submission.getId(), resolvedEmailRecipient);
            } catch (Exception ex) {
                log.warn("Failed to send admin feedback email alert for submission {}: {}", submission.getId(), ex.getMessage());
            }
        } else if (emailAlertEnabled) {
            log.warn("Flow B email alert enabled but no recipient configured. Set flow-b.admin.alert-email, TRACKING_PROFILE_ALERT_EMAIL, or SPRING_MAIL_USERNAME.");
        }

        if (isTelegramReady(resolvedTelegramToken, resolvedTelegramChatId)) {
            try {
                String telegramText = buildTelegramBody(submission);
                sendTelegramMessage(resolvedTelegramToken, resolvedTelegramChatId, telegramText);
                log.info("Flow B Telegram alert sent for submission {} using chat {}", submission.getId(), resolvedTelegramChatId);
            } catch (Exception ex) {
                log.warn("Failed to send admin feedback Telegram alert for submission {}: {}", submission.getId(), ex.getMessage());
            }
        } else if (telegramAlertEnabled) {
            log.warn("Flow B Telegram alert enabled but bot token/chat id are missing. Configure flow-b.admin.telegram.* or telegram.*");
        }
    }

    private void dispatchAlertsAfterCommit(IndustryFeedbackSubmission submission) {
        if (!TransactionSynchronizationManager.isActualTransactionActive()) {
            sendAdminAlerts(submission);
            return;
        }

        TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
            @Override
            public void afterCommit() {
                sendAdminAlerts(submission);
            }
        });
    }

    private void sendTelegramMessage(String botToken, String chatId, String text) {
        String url = "https://api.telegram.org/bot" + botToken + "/sendMessage";
        String payload = "{\"chat_id\":\"" + escapeJson(chatId)
                + "\",\"text\":\"" + escapeJson(text) + "\"}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(payload))
                .timeout(Duration.ofSeconds(5))
                .build();

        HttpResponse<String> response;
        try {
            response = com.bookify.backendbookify_saas.utils.HttpClientUtil.getClient()
                    .send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("Telegram alert request was interrupted", ex);
        } catch (IOException ex) {
            throw new IllegalStateException("Failed to call Telegram alert API", ex);
        }

        if (response.statusCode() != 200) {
            log.warn("Admin feedback Telegram alert returned {}: {}", response.statusCode(), response.body());
        }
    }

    private boolean isEmailReady(String emailRecipient) {
        return emailAlertEnabled && emailRecipient != null && !emailRecipient.isBlank();
    }

    private boolean isTelegramReady(String botToken, String chatId) {
        return telegramAlertEnabled
                && botToken != null && !botToken.isBlank()
                && chatId != null && !chatId.isBlank();
    }

    private String resolveAdminAlertEmail() {
        if (adminAlertEmail != null && !adminAlertEmail.isBlank()) {
            return adminAlertEmail.trim();
        }

        if (trackingFallbackAlertEmail != null && !trackingFallbackAlertEmail.isBlank()) {
            return trackingFallbackAlertEmail.trim();
        }

        if (mailSenderAddress != null && !mailSenderAddress.isBlank()) {
            return mailSenderAddress.trim();
        }

        return null;
    }

    private String resolveTelegramBotToken() {
        if (telegramBotToken != null && !telegramBotToken.isBlank()) {
            return telegramBotToken.trim();
        }

        if (alertBotToken != null && !alertBotToken.isBlank()) {
            return alertBotToken.trim();
        }

        return null;
    }

    private String resolveTelegramChatId() {
        if (telegramChatId != null && !telegramChatId.isBlank()) {
            return telegramChatId.trim();
        }

        if (alertChatId != null && !alertChatId.isBlank()) {
            return alertChatId.trim();
        }

        return null;
    }

    private String buildEmailBody(IndustryFeedbackSubmission submission) {
        String sourceNiche = sourceNicheForDisplay(submission);
        String sourceSlug = valueOrDash(safeTrim(submission.getSourceSlug()));

        return "A new 'Other industry' suggestion was submitted.\n\n"
                + "ID: " + submission.getId() + "\n"
                + "Industry: " + valueOrDash(submission.getIndustryName()) + "\n"
                + "Description: " + valueOrDash(submission.getDescription()) + "\n"
                + "Phone: " + valueOrDash(submission.getPhoneNumber()) + "\n"
                + "Contact Email: " + valueOrDash(submission.getContactEmail()) + "\n"
                + "Source Niche: " + sourceNiche + "\n"
                + "Source Slug: " + sourceSlug + "\n"
                + "Submitted At: " + submission.getCreatedAt();
    }

            private String buildEmailHtml(IndustryFeedbackSubmission submission) {
            String submittedAt = submission.getCreatedAt() == null
                ? "-"
                : EMAIL_TIME_FORMAT.format(submission.getCreatedAt());
            String sourceNiche = sourceNicheForDisplay(submission);
            String sourceSlug = valueOrDash(safeTrim(submission.getSourceSlug()));

            return "<div style=\"font-family:system-ui,-apple-system,'Segoe UI',Roboto,Arial,sans-serif;background:#f8fafc;padding:24px;color:#0f172a;\">"
                + "<div style=\"max-width:640px;margin:0 auto;background:#ffffff;border:1px solid #e2e8f0;border-radius:14px;overflow:hidden;\">"
                + "<div style=\"padding:18px 20px;background:linear-gradient(135deg,#0f172a,#1e293b);color:#ffffff;\">"
                + "<p style=\"margin:0;font-size:12px;letter-spacing:.08em;text-transform:uppercase;opacity:.85;\">Kayedni Admin Alert</p>"
                + "<h2 style=\"margin:6px 0 0;font-size:20px;\">New Other Industry Request</h2>"
                + "</div>"
                + "<div style=\"padding:20px;\">"
                + "<p style=\"margin:0 0 14px;font-size:14px;color:#334155;\">A business owner submitted an unsupported industry from signup. Review details below.</p>"
                + "<table role=\"presentation\" style=\"width:100%;border-collapse:collapse;font-size:14px;\">"
                + rowHtml("Submission ID", String.valueOf(submission.getId()))
                + rowHtml("Industry", valueOrDash(submission.getIndustryName()))
                + rowHtml("Description", valueOrDash(submission.getDescription()))
                + rowHtml("Phone", valueOrDash(submission.getPhoneNumber()))
                + rowHtml("Contact Email", valueOrDash(submission.getContactEmail()))
                + rowHtml("Source Niche", sourceNiche)
                + rowHtml("Source Slug", sourceSlug)
                + rowHtml("Submitted At", submittedAt)
                + "</table>"
                + "<div style=\"margin-top:16px;padding:12px;border-radius:10px;background:#ecfeff;border:1px solid #a5f3fc;color:#0f766e;font-size:13px;\">"
                + "Source Niche shows the human-readable landing category. Source Slug is the technical tracking key. \"-\" means no source context was captured."
                + "</div>"
                + "</div>"
                + "</div>"
                + "</div>";
            }

            private String rowHtml(String label, String value) {
            return "<tr>"
                + "<td style=\"padding:10px 0;border-bottom:1px solid #f1f5f9;width:170px;color:#64748b;font-weight:600;vertical-align:top;\">" + escapeHtml(label) + "</td>"
                + "<td style=\"padding:10px 0;border-bottom:1px solid #f1f5f9;color:#0f172a;\">" + escapeHtml(value) + "</td>"
                + "</tr>";
            }

    private String buildTelegramBody(IndustryFeedbackSubmission submission) {
        String sourceNiche = sourceNicheForDisplay(submission);
        String sourceSlug = valueOrDash(safeTrim(submission.getSourceSlug()));

        return "[Kayedni] New Other Industry Request\n"
                + "ID: " + submission.getId() + "\n"
                + "Industry: " + valueOrDash(submission.getIndustryName()) + "\n"
                + "Phone: " + valueOrDash(submission.getPhoneNumber()) + "\n"
                + "Email: " + valueOrDash(submission.getContactEmail()) + "\n"
                + "Source Niche: " + sourceNiche + "\n"
                + "Source Slug: " + sourceSlug + "\n"
                + "Description: " + valueOrDash(submission.getDescription());
    }

    private String sourceNicheForDisplay(IndustryFeedbackSubmission submission) {
        String explicitCategoryName = safeTrim(submission.getSourceCategoryName());
        if (explicitCategoryName != null) {
            return explicitCategoryName;
        }

        String slug = safeTrim(submission.getSourceSlug());
        String derived = readableNicheFromSlug(slug);
        return valueOrDash(derived);
    }

    private String readableNicheFromSlug(String slug) {
        if (slug == null || slug.isBlank()) {
            return null;
        }

        String normalized = slug.trim().replaceAll("\\s*&\\s*", "&");
        if (normalized.isEmpty()) {
            return null;
        }

        StringBuilder builder = new StringBuilder();
        String[] segments = normalized.split("&");
        for (int i = 0; i < segments.length; i++) {
            String segment = segments[i].trim();
            if (segment.isEmpty()) {
                continue;
            }

            if (builder.length() > 0) {
                builder.append(" & ");
            }
            builder.append(toTitleCaseWords(segment.replace('-', ' ')));
        }

        return builder.length() == 0 ? null : builder.toString();
    }

    private String toTitleCaseWords(String value) {
        if (value == null || value.isBlank()) {
            return "";
        }

        String[] words = value.trim().toLowerCase().split("\\s+");
        StringBuilder builder = new StringBuilder();
        for (String word : words) {
            if (word.isEmpty()) {
                continue;
            }

            if (builder.length() > 0) {
                builder.append(' ');
            }

            builder.append(Character.toUpperCase(word.charAt(0)));
            if (word.length() > 1) {
                builder.append(word.substring(1));
            }
        }

        return builder.toString();
    }

    private String valueOrDash(String value) {
        if (value == null || value.isBlank()) {
            return "-";
        }
        return value;
    }

    private String safeTrim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String escapeJson(String text) {
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String escapeHtml(String text) {
        if (text == null) {
            return "";
        }
        return text
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
}
