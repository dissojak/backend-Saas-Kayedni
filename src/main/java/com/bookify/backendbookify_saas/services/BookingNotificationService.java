package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.email_SMTP.MailService;
import com.bookify.backendbookify_saas.models.entities.ServiceBooking;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class BookingNotificationService {

    private final MailService mailService;
    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Value("${application.email.from-display-name:Kayedni}")
    private String fromDisplayName;

    @Value("${booking.notifications.enabled:true}")
    private boolean notificationsEnabled;

    @Value("${booking.notifications.telegram.enabled:true}")
    private boolean telegramEnabled;

    @Value("${booking.notifications.telegram.bot-token:}")
    private String telegramBotToken;

    @Value("${booking.notifications.telegram.default-chat-id:}")
    private String telegramDefaultChatId;

    @Value("${booking.notifications.staff-alert.enabled:true}")
    private boolean staffAlertEnabled;

    @Value("${booking.notifications.staff-alert.telegram.bot-token:}")
    private String staffAlertTelegramBotToken;

    @Value("${booking.notifications.staff-alert.telegram.chat-id:}")
    private String staffAlertTelegramChatId;

    public void notifyStatusChange(ServiceBooking booking, BookingStatusEnum previousStatus) {
        if (!notificationsEnabled || booking == null) {
            return;
        }

        if (booking.getStatus() == BookingStatusEnum.COMPLETED) {
            return;
        }

        String effectiveStatus = resolveStatusLabel(booking.getStatus(), previousStatus);

        // Only notify for client-visible status outcomes.
        if (!"CONFIRMED".equals(effectiveStatus)
                && !"REJECTED".equals(effectiveStatus)
                && !"CANCELED".equals(effectiveStatus)) {
            return;
        }

        String headline = buildStatusHeadline(effectiveStatus);

        String subject = "[Kayedni Booking Update] " + headline;
        String body = buildBookingDetails(booking,
                headline,
                "Booking Update",
                effectiveStatus);
        String htmlBody = buildBookingHtml(booking, headline, "Booking Update", effectiveStatus);

        sendClientEmail(booking, subject, body, htmlBody);

        sendStatusTelegram(booking, effectiveStatus, body);
    }

    public boolean sendReminder(ServiceBooking booking, long minutesBefore) {
        if (!notificationsEnabled || booking == null) {
            return false;
        }

        String subject = "[Kayedni] Reminder: your booking starts in " + minutesBefore + " minutes";
        String body = buildBookingDetails(booking,
                "Reminder: your booking starts in about " + minutesBefore + " minutes.",
                "Booking Reminder",
                booking.getStatus().name());
        String htmlBody = buildBookingHtml(
                booking,
                "Reminder: your booking starts in about " + minutesBefore + " minutes.",
                "Booking Reminder",
                booking.getStatus().name()
        );

        boolean emailSent = sendClientEmail(booking, subject, body, htmlBody);

        String reminderText = buildReminderTelegramText(booking, minutesBefore);
        String replyMarkup = buildReminderReplyMarkup(booking);
        String recipientChatId = resolveRecipientChatId(booking);
        if (recipientChatId == null) {
            return emailSent;
        }

        boolean telegramSent = sendTelegramMarkdownWithFallback(telegramBotToken, recipientChatId, reminderText, replyMarkup);
        if (!telegramSent) {
            telegramSent = sendTelegramToChatId(recipientChatId, stripTelegramMarkdown(reminderText));
        }

        return emailSent || telegramSent;
    }

    public void notifyStaffActionRequired(ServiceBooking booking) {
        if (!notificationsEnabled || !staffAlertEnabled || booking == null) {
            return;
        }

        String text = buildStaffActionRequiredText(booking);
        String callbackReplyMarkup = buildStaffActionRequiredReplyMarkup(booking);

        // Callback buttons are Telegram-native and do not require public URLs.
        boolean sent = sendTelegramWithBot(staffAlertTelegramBotToken, staffAlertTelegramChatId, text, null, callbackReplyMarkup);
        if (!sent) {
            sendTelegramWithBot(staffAlertTelegramBotToken, staffAlertTelegramChatId, text, null, null);
        }
    }

    public void sendStaffComeNowReminder(ServiceBooking booking) {
        if (!notificationsEnabled || booking == null) {
            return;
        }

        String text = buildStaffComeNowTelegramText(booking);
        String replyMarkup = buildReminderReplyMarkup(booking);
        String recipientChatId = resolveRecipientChatId(booking);
        if (recipientChatId == null) {
            return;
        }

        boolean sent = sendTelegramMarkdownWithFallback(telegramBotToken, recipientChatId, text, replyMarkup);
        if (!sent) {
            sendTelegramToChatId(recipientChatId, stripTelegramMarkdown(text));
        }
    }

    public void notifyStaffClientCancellation(ServiceBooking booking, BookingStatusEnum previousStatus) {
        if (!notificationsEnabled || !staffAlertEnabled || booking == null) {
            return;
        }

        String text = buildStaffClientCancellationText(booking, previousStatus);
        sendTelegramWithBot(staffAlertTelegramBotToken, staffAlertTelegramChatId, text, null, null);
    }

    public void notifyStaffClientReschedule(ServiceBooking booking, LocalDate oldDate, LocalTime oldStart, LocalTime oldEnd) {
        if (!notificationsEnabled || !staffAlertEnabled || booking == null) {
            return;
        }

        String text = buildStaffClientRescheduleText(booking, oldDate, oldStart, oldEnd);
        String callbackReplyMarkup = buildStaffActionRequiredReplyMarkup(booking);
        boolean sent = sendTelegramWithBot(staffAlertTelegramBotToken, staffAlertTelegramChatId, text, null, callbackReplyMarkup);
        if (!sent) {
            sendTelegramWithBot(staffAlertTelegramBotToken, staffAlertTelegramChatId, text, null, null);
        }
    }

    private boolean sendClientEmail(ServiceBooking booking, String subject, String plainBody, String htmlBody) {
        try {
            String clientEmail = extractClientEmail(booking);
            if (clientEmail == null || clientEmail.isBlank()) {
                log.warn("Skipping booking email notification for booking {} because client email is missing", booking.getId());
                return false;
            }

            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setFrom(new InternetAddress(fromEmail, fromDisplayName));
            helper.setTo(clientEmail);
            helper.setSubject(subject);
            helper.setText(plainBody, htmlBody);
            mailSender.send(msg);
            return true;
        } catch (Exception e) {
            log.warn("Failed to send booking email notification for booking {}: {}", booking.getId(), e.getMessage());
            // Fallback to plain text if HTML send fails for any reason.
            try {
                String clientEmail = extractClientEmail(booking);
                if (clientEmail != null && !clientEmail.isBlank()) {
                    mailService.sendSimpleMessage(clientEmail, subject, plainBody);
                    return true;
                }
            } catch (Exception inner) {
                log.warn("Fallback plain email also failed for booking {}: {}", booking.getId(), inner.getMessage());
            }
            return false;
        }
    }

    private boolean sendTelegramToChatId(String chatId, String text) {
        if (!telegramEnabled
                || telegramBotToken == null || telegramBotToken.isBlank()
                || chatId == null || chatId.isBlank()) {
            return false;
        }

        return sendTelegramWithBot(telegramBotToken, chatId, text, null, null);
    }

    private void sendTelegramWithBot(String botToken, String chatId, String text) {
        sendTelegramWithBot(botToken, chatId, text, null, null);
    }

    private boolean sendTelegramWithBot(String botToken, String chatId, String text, String parseMode, String replyMarkupJson) {
        if (botToken == null || botToken.isBlank() || chatId == null || chatId.isBlank()) {
            return false;
        }

        try {
            String url = "https://api.telegram.org/bot" + botToken + "/sendMessage";

            StringBuilder payloadBuilder = new StringBuilder();
            payloadBuilder.append("{\"chat_id\":\"").append(escapeJson(chatId)).append("\"");
            payloadBuilder.append(",\"text\":\"").append(escapeJson(text)).append("\"");
            if (parseMode != null && !parseMode.isBlank()) {
                payloadBuilder.append(",\"parse_mode\":\"").append(escapeJson(parseMode)).append("\"");
            }
            if (replyMarkupJson != null && !replyMarkupJson.isBlank()) {
                payloadBuilder.append(",\"reply_markup\":").append(replyMarkupJson);
            }
            payloadBuilder.append("}");

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payloadBuilder.toString()))
                    .timeout(Duration.ofSeconds(5))
                    .build();

            HttpResponse<String> response = HttpClient.newHttpClient()
                    .send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.warn("Telegram booking notification returned {}: {}", response.statusCode(), response.body());
                return false;
            }
            return true;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.warn("Telegram send interrupted: {}", e.getMessage());
            return false;
        } catch (Exception e) {
            log.warn("Failed to send Telegram booking notification: {}", e.getMessage());
            return false;
        }
    }

    private String buildStaffActionRequiredText(ServiceBooking booking) {
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        String clientName = extractClientName(booking);
        String clientPhone = extractClientPhone(booking);

        return "New " + serviceName + " Booking From " + clientName + "\n\n"
                + "Date: " + booking.getDate() + "\n"
                + "Time: " + booking.getStartTime() + " - " + booking.getEndTime() + "\n"
            + "Client Phone: " + valueOrDash(clientPhone) + "\n"
            + "Price: " + booking.getPrice() + "\n"
            + "Notes: " + valueOrDash(booking.getNotes()) + "\n\n"
                + "Booking ID: " + booking.getId() + "-Kayedni-Booking";
    }

    private String buildStaffClientCancellationText(ServiceBooking booking, BookingStatusEnum previousStatus) {
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        String clientName = extractClientName(booking);
        String clientPhone = extractClientPhone(booking);
        String action = previousStatus == BookingStatusEnum.PENDING ? "rejected" : "cancelled";

        StringBuilder sb = new StringBuilder();
        sb.append("Client ").append(action).append(" booking\n\n");
        sb.append("Client: ").append(clientName).append("\n");
        sb.append("Service: ").append(serviceName).append("\n");
        sb.append("Date: ").append(booking.getDate()).append("\n");
        sb.append("Time: ").append(booking.getStartTime()).append(" - ").append(booking.getEndTime()).append("\n");
        sb.append("Client Phone: ").append(valueOrDash(clientPhone)).append("\n");
        if (booking.getCancellationReason() != null && !booking.getCancellationReason().isBlank()) {
            sb.append("Reason: ").append(booking.getCancellationReason()).append("\n");
        }
        sb.append("\nBooking ID: ").append(booking.getId()).append("-Kayedni-Booking");
        return sb.toString();
    }

    private String buildStaffClientRescheduleText(ServiceBooking booking, LocalDate oldDate, LocalTime oldStart, LocalTime oldEnd) {
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        String clientName = extractClientName(booking);
        String clientPhone = extractClientPhone(booking);

        StringBuilder sb = new StringBuilder();
        sb.append("Client rescheduled booking - action required\n\n");
        sb.append("Client: ").append(clientName).append("\n");
        sb.append("Service: ").append(serviceName).append("\n");
        sb.append("Old Date: ").append(oldDate).append("\n");
        sb.append("Old Time: ").append(oldStart).append(" - ").append(oldEnd).append("\n");
        sb.append("New Date: ").append(booking.getDate()).append("\n");
        sb.append("New Time: ").append(booking.getStartTime()).append(" - ").append(booking.getEndTime()).append("\n");
        sb.append("Status: ").append(booking.getStatus()).append("\n");
        sb.append("Client Phone: ").append(valueOrDash(clientPhone)).append("\n");
        sb.append("\nPlease accept or reject this reschedule request.\n");
        sb.append("\nBooking ID: ").append(booking.getId()).append("-Kayedni-Booking");
        return sb.toString();
    }

    private String buildStaffActionRequiredReplyMarkup(ServiceBooking booking) {
        return "{\"inline_keyboard\":["
                + "[{\"text\":\"✅ Accept\",\"callback_data\":\"accept_" + booking.getId() + "\"},"
                + "{\"text\":\"❌ Reject\",\"callback_data\":\"reject_" + booking.getId() + "\"}]"
            + "]}";
    }

    private String buildBookingDetails(ServiceBooking booking, String headline, String eventType, String statusLabel) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName()
                : "Unknown";
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        Integer serviceDuration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
        String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Unassigned";
        String clientName = extractClientName(booking);
        String clientEmail = extractClientEmail(booking);
        String clientPhone = extractClientPhone(booking);

        return "[Kayedni " + eventType + "]\n"
                + headline + "\n\n"
            + "Booking ID: " + booking.getId() + "-Kayedni-Booking\n"
                + "Status: " + statusLabel + "\n"
                + "Business: " + businessName + "\n"
                + "Staff: " + staffName + "\n"
                + "Service: " + serviceName + (serviceDuration != null ? (" (" + serviceDuration + " min)") : "") + "\n"
                + "Date: " + booking.getDate() + "\n"
                + "Time: " + booking.getStartTime() + " - " + booking.getEndTime() + "\n"
                + "Price: " + booking.getPrice() + "\n"
                + "Client: " + clientName + "\n"
                + "Client Email: " + valueOrDash(clientEmail) + "\n"
                + "Client Phone: " + valueOrDash(clientPhone) + "\n"
                + "Notes: " + valueOrDash(booking.getNotes()) + "\n"
                + "Updated At: " + LocalDateTime.now();
    }

            private String buildBookingHtml(ServiceBooking booking, String headline, String eventType, String statusLabel) {
            String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName()
                : "Unknown";
            String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
            Integer serviceDuration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
            String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Unassigned";
            String clientName = extractClientName(booking);
            String clientEmail = extractClientEmail(booking);
            String clientPhone = extractClientPhone(booking);

            String statusColor = "#0ea5e9";
            if ("CONFIRMED".equals(statusLabel)) statusColor = "#16a34a";
            if ("REJECTED".equals(statusLabel)) statusColor = "#dc2626";
            if ("CANCELED".equals(statusLabel)) statusColor = "#ea580c";
            if ("PENDING".equals(statusLabel)) statusColor = "#ca8a04";

            return "<div style=\"margin:0;padding:24px;background:#f4f7fb;font-family:Arial,sans-serif;color:#111827;\">"
                + "<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"max-width:640px;width:100%;margin:0 auto;background:#ffffff;border-radius:14px;overflow:hidden;border:1px solid #e5e7eb;\">"
                + "<tr><td style=\"padding:20px 24px;background:#0f172a;color:#ffffff;\">"
                + "<div style=\"font-size:18px;font-weight:700;\">Kayedni " + escapeHtml(eventType) + "</div>"
                + "<div style=\"font-size:13px;opacity:.9;margin-top:4px;\">Service booking notification</div>"
                + "</td></tr>"
                + "<tr><td style=\"padding:22px 24px;\">"
                + "<div style=\"font-size:22px;font-weight:700;margin:0 0 12px;\">" + escapeHtml(headline) + "</div>"
                + "<div style=\"display:inline-block;padding:6px 12px;border-radius:999px;background:" + statusColor + ";color:#fff;font-size:12px;font-weight:700;letter-spacing:.3px;\">" + escapeHtml(statusLabel) + "</div>"
                + "</td></tr>"
                + "<tr><td style=\"padding:0 24px 24px;\">"
                + "<table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" style=\"width:100%;border-collapse:collapse;\">"
                + htmlRow("Booking ID", booking.getId() + "-Kayedni-Booking")
                + htmlRow("Status", statusLabel)
                + htmlRow("Business", businessName)
                + htmlRow("Staff", staffName)
                + htmlRow("Service", serviceName + (serviceDuration != null ? (" (" + serviceDuration + " min)") : ""))
                + htmlRow("Date", String.valueOf(booking.getDate()))
                + htmlRow("Time", booking.getStartTime() + " - " + booking.getEndTime())
                + htmlRow("Price", String.valueOf(booking.getPrice()))
                + htmlRow("Client", clientName)
                + htmlRow("Client Email", valueOrDash(clientEmail))
                + htmlRow("Client Phone", valueOrDash(clientPhone))
                + htmlRow("Notes", valueOrDash(booking.getNotes()))
                + htmlRow("Updated At", String.valueOf(LocalDateTime.now()))
                + "</table>"
                + "</td></tr>"
                + "<tr><td style=\"padding:16px 24px;background:#f8fafc;color:#475569;font-size:12px;\">"
                + "This email was generated automatically by Kayedni notifications."
                + "</td></tr>"
                + "</table></div>";
            }

            private String htmlRow(String label, String value) {
            return "<tr>"
                + "<td style=\"padding:9px 0;border-bottom:1px solid #eef2f7;width:38%;font-size:13px;color:#64748b;\">" + escapeHtml(label) + "</td>"
                + "<td style=\"padding:9px 0;border-bottom:1px solid #eef2f7;font-size:13px;color:#0f172a;font-weight:600;\">" + escapeHtml(valueOrDash(value)) + "</td>"
                + "</tr>";
            }

    private String resolveStatusLabel(BookingStatusEnum currentStatus, BookingStatusEnum previousStatus) {
        if (currentStatus == BookingStatusEnum.REJECTED) {
            return "REJECTED";
        }
        if (currentStatus == BookingStatusEnum.CANCELLED) {
            return "CANCELED";
        }
        return currentStatus.name();
    }

    private String buildStatusHeadline(String effectiveStatus) {
        if ("REJECTED".equals(effectiveStatus)) {
            return "Booking Rejected !";
        }
        if ("CANCELED".equals(effectiveStatus)) {
            return "Booking Canceled !";
        }
        if ("CONFIRMED".equals(effectiveStatus)) {
            return "Booking Confirmed !";
        }
        if ("PENDING".equals(effectiveStatus)) {
            return "Booking Pending !";
        }
        return "Booking " + effectiveStatus + " !";
    }

    private String buildReminderTelegramText(ServiceBooking booking, long minutesBefore) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName() : "Unknown";
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        Integer duration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
        String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Unassigned";

        String date = booking.getDate() != null
                ? booking.getDate().getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH)
                + " " + booking.getDate().getDayOfMonth()
                + ", " + booking.getDate().getYear()
                : "-";

        String timeRange = booking.getStartTime() + " to " + booking.getEndTime();

        StringBuilder sb = new StringBuilder();
        sb.append("⏰ *Booking Reminder*\n\n");
        sb.append("Your booking starts in *").append(minutesBefore).append(" minutes*.\n\n");
        sb.append("*Service:* ").append(escapeTelegramMarkdown(serviceName));
        if (duration != null) {
            sb.append(" (").append(duration).append(" min)");
        }
        sb.append("\n");
        sb.append("*Business:* ").append(escapeTelegramMarkdown(businessName)).append("\n");
        sb.append("*Staff:* ").append(escapeTelegramMarkdown(staffName)).append("\n");
        sb.append("*Date:* ").append(escapeTelegramMarkdown(date)).append("\n");
        sb.append("*Time:* ").append(escapeTelegramMarkdown(timeRange)).append("\n\n");
        sb.append("*Booking ID:* ").append(booking.getId()).append("-Kayedni-Booking");
        return sb.toString();
    }

    private String buildStaffComeNowTelegramText(ServiceBooking booking) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName() : "Unknown";
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        Integer duration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
        String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Staff";

        String date = booking.getDate() != null
                ? booking.getDate().getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH)
                + " " + booking.getDate().getDayOfMonth()
                + ", " + booking.getDate().getYear()
                : "-";

        String timeRange = booking.getStartTime() + " to " + booking.getEndTime();

        StringBuilder sb = new StringBuilder();
        sb.append("🔔 *Message From Your Staff*\n\n");
        sb.append("*").append(escapeTelegramMarkdown(staffName)).append("* from *")
                .append(escapeTelegramMarkdown(businessName))
                .append("* asks you to come now for your appointment.\n\n");
        sb.append("*Service:* ").append(escapeTelegramMarkdown(serviceName));
        if (duration != null) {
            sb.append(" (").append(duration).append(" min)");
        }
        sb.append("\n");
        sb.append("*Scheduled Date:* ").append(escapeTelegramMarkdown(date)).append("\n");
        sb.append("*Scheduled Time:* ").append(escapeTelegramMarkdown(timeRange)).append("\n\n");
        sb.append("If you're already on your way, you can ignore this reminder.\n\n");
        sb.append("*Booking ID:* ").append(booking.getId()).append("-Kayedni-Booking");
        return sb.toString();
    }

    private String buildReminderReplyMarkup(ServiceBooking booking) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName() : "Business";
        String businessPhone = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getPhone() : null;

        String contactUrl = buildBusinessTelegramContactUrl(businessPhone);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"inline_keyboard\":[");
        if (contactUrl != null) {
            sb.append("[{\"text\":\"\\uD83D\\uDCAC Contact ")
                    .append(escapeJson(businessName))
                    .append("\",\"url\":\"")
                    .append(escapeJson(contactUrl))
                    .append("\"}]");
        }
        sb.append("]}");
        return sb.toString();
    }

    private void sendStatusTelegram(ServiceBooking booking, String effectiveStatus, String plainFallbackBody) {
        String recipientChatId = resolveRecipientChatId(booking);
        if (recipientChatId == null) {
            return;
        }

        if ("CONFIRMED".equals(effectiveStatus)) {
            String text = buildConfirmedTelegramText(booking);
            String replyMarkup = buildConfirmedReplyMarkup(booking);
            boolean sent = sendTelegramMarkdownWithFallback(telegramBotToken, recipientChatId, text, replyMarkup);
            if (!sent) {
                sendTelegramToChatId(recipientChatId, stripTelegramMarkdown(text));
            }
            return;
        }

        if ("REJECTED".equals(effectiveStatus) || "CANCELED".equals(effectiveStatus)) {
            sendCancelRejectTelegram(booking, effectiveStatus, recipientChatId);
            return;
        }

        // For other statuses, keep the default plain update format.
        sendTelegramToChatId(recipientChatId, plainFallbackBody);
    }

        private String buildConfirmedTelegramText(ServiceBooking booking) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
            ? booking.getService().getBusiness().getName() : "Unknown";
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        Integer duration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
        String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Unassigned";

        String date = booking.getDate() != null
            ? booking.getDate().getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH)
            + " " + booking.getDate().getDayOfMonth()
            + ", " + booking.getDate().getYear()
            : "-";

        StringBuilder sb = new StringBuilder();
        sb.append("✅ *Booking Confirmed!*\n\n");
        sb.append("Your appointment for *").append(escapeTelegramMarkdown(serviceName));
        if (duration != null) {
            sb.append(" (").append(duration).append(" min)");
        }
        sb.append("* at *").append(escapeTelegramMarkdown(businessName))
            .append("* with *").append(escapeTelegramMarkdown(staffName))
            .append("* on *").append(escapeTelegramMarkdown(date))
            .append("* from *").append(escapeTelegramMarkdown(booking.getStartTime() + " to " + booking.getEndTime()))
            .append("* is now confirmed.\n\n We look forward to seeing you!\n\n")
            .append("*Booking ID:* ").append(booking.getId()).append("-Kayedni-Booking");

        return sb.toString();
        }

        private String buildConfirmedReplyMarkup(ServiceBooking booking) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
            ? booking.getService().getBusiness().getName() : "Business";
        String businessPhone = booking.getService() != null && booking.getService().getBusiness() != null
            ? booking.getService().getBusiness().getPhone() : null;

        String contactUrl = buildBusinessTelegramContactUrl(businessPhone);

        StringBuilder sb = new StringBuilder();
            sb.append("{\"inline_keyboard\":[");
            if (contactUrl != null) {
                sb.append("[{\"text\":\"\uD83D\uDCAC Contact ")
                        .append(escapeJson(businessName))
                        .append("\",\"url\":\"")
                        .append(escapeJson(contactUrl))
                        .append("\"}]");
            }
            sb.append("]}");
        return sb.toString();
        }

    private String extractClientName(ServiceBooking booking) {
        if (booking.getClient() != null) {
            return booking.getClient().getName();
        }
        if (booking.getBusinessClient() != null) {
            return booking.getBusinessClient().getName();
        }
        return "Unknown";
    }

    private String extractClientEmail(ServiceBooking booking) {
        if (booking.getClient() != null) {
            return booking.getClient().getEmail();
        }
        if (booking.getBusinessClient() != null) {
            return booking.getBusinessClient().getEmail();
        }
        return null;
    }

    private String extractClientPhone(ServiceBooking booking) {
        if (booking.getClient() != null) {
            return booking.getClient().getPhoneNumber();
        }
        if (booking.getBusinessClient() != null) {
            return booking.getBusinessClient().getPhone();
        }
        return null;
    }

    private String valueOrDash(String value) {
        return value == null || value.isBlank() ? "-" : value;
    }

    private String escapeHtml(String value) {
        return valueOrDash(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String escapeJson(String text) {
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    // ─── Rich cancel/reject Telegram ─────────────────────────────────────────

    private void sendCancelRejectTelegram(ServiceBooking booking, String effectiveStatus, String recipientChatId) {
        if (!telegramEnabled
                || telegramBotToken == null || telegramBotToken.isBlank()
                || recipientChatId == null || recipientChatId.isBlank()) {
            return;
        }

        String text = buildCancelRejectTelegramText(booking, effectiveStatus);
        String replyMarkup = buildCancelRejectReplyMarkup(booking);
        boolean sent = sendTelegramMarkdownWithFallback(telegramBotToken, recipientChatId, text, replyMarkup);
        if (!sent) {
            sendTelegramToChatId(recipientChatId, stripTelegramMarkdown(text));
        }
    }

    private String resolveRecipientChatId(ServiceBooking booking) {
        if (!telegramEnabled || booking == null) {
            return null;
        }

        // BusinessClient bookings must not leak to default chat.
        if (booking.getBusinessClient() != null) {
            String businessClientTarget = normalizeRecipient(booking.getBusinessClient().getTelegramChatId());
            if (businessClientTarget == null) {
                log.info("Skipping telegram for booking {}: business client has not linked Telegram chat id", booking.getId());
            }
            return businessClientTarget;
        }

        if (booking.getClient() != null) {
            String userTarget = normalizeRecipient(booking.getClient().getTelegramChatId());
            if (userTarget == null) {
                log.info("Skipping telegram for booking {}: client has not linked Telegram chat id", booking.getId());
            }
            return userTarget;
        }

        return null;
    }

    private String normalizeRecipient(String raw) {
        if (raw == null) {
            return null;
        }

        String value = raw.trim();
        if (value.isEmpty()) {
            return null;
        }

        return value.isBlank() ? null : value;
    }

    private String buildCancelRejectTelegramText(ServiceBooking booking, String effectiveStatus) {
        boolean isRejected = "REJECTED".equals(effectiveStatus);

        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName() : "Unknown";
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        Integer duration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
        String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Unassigned";

        // Format date nicely: "March 14, 2026"
        String date = booking.getDate() != null
                ? booking.getDate().getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH)
                + " " + booking.getDate().getDayOfMonth()
                + ", " + booking.getDate().getYear()
                : "-";

        String timeRange = booking.getStartTime() + " to " + booking.getEndTime();
        String action = isRejected ? "rejected" : "canceled";
        String emoji = "❌";
        String title = isRejected ? "Booking Rejected" : "Booking Canceled";

        StringBuilder sb = new StringBuilder();
        sb.append(emoji).append(" *").append(escapeTelegramMarkdown(title)).append("*\n\n");
        sb.append("Your booking for *").append(escapeTelegramMarkdown(serviceName));
        if (duration != null) sb.append(" (").append(duration).append(" min)");
        sb.append("* at *").append(escapeTelegramMarkdown(businessName))
          .append("* with *").append(escapeTelegramMarkdown(staffName))
          .append("* on *").append(escapeTelegramMarkdown(date))
          .append("* from *").append(escapeTelegramMarkdown(timeRange))
          .append("* has been ").append(action).append(".\n");

        String reason = booking.getCancellationReason();
        if (reason != null && !reason.isBlank()) {
            sb.append("\n*Reason:* ").append(escapeTelegramMarkdown(reason)).append("\n");
        }

                String businessPhone = booking.getService() != null && booking.getService().getBusiness() != null
                                ? booking.getService().getBusiness().getPhone() : null;
                String businessTelegramContact = buildBusinessTelegramContactUrl(businessPhone);

        sb.append("\nIf you think this ").append(action)
            .append(" was a mistake, you can contact the business directly on Telegram.");
        if (businessTelegramContact != null) {
            sb.append("\n").append(escapeTelegramMarkdown(businessTelegramContact));
        }
        sb.append("\n\n");
        sb.append("*Booking ID:* ").append(booking.getId()).append("-Kayedni-Booking");

        return sb.toString();
    }

    private String buildCancelRejectReplyMarkup(ServiceBooking booking) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName() : "Business";
        String businessPhone = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getPhone() : null;

        String contactUrl = buildBusinessTelegramContactUrl(businessPhone);

        StringBuilder sb = new StringBuilder();
        sb.append("{\"inline_keyboard\":[");
        if (contactUrl != null) {
            sb.append("[{\"text\":\"\\uD83D\\uDCAC Contact ")
                .append(escapeJson(businessName))
                .append("\",\"url\":\"")
                .append(escapeJson(contactUrl))
                .append("\"}]");
        }
        sb.append("]}");
        return sb.toString();
    }

    /**
     * Escape special characters for Telegram Markdown v1.
     * Only *, _, `, [ need escaping.
     */
    private String escapeTelegramMarkdown(String text) {
        if (text == null) return "-";
        return text
                .replace("_", "\\_")
                .replace("*", "\\*")
                .replace("`", "\\`")
                .replace("[", "\\[")
                .replace("]", "\\]");
    }

    private boolean sendTelegramMarkdownWithFallback(String botToken, String chatId, String markdownText, String replyMarkupJson) {
        boolean sent = sendTelegramWithBot(botToken, chatId, markdownText, "Markdown", replyMarkupJson);
        if (sent) {
            return true;
        }

        String plain = stripTelegramMarkdown(markdownText);

        // Keep buttons even when markdown parsing fails.
        return sendTelegramWithBot(botToken, chatId, plain, null, replyMarkupJson);
    }

    private String stripTelegramMarkdown(String markdownText) {
        if (markdownText == null) {
            return "";
        }
        return markdownText
                .replace("*", "")
                .replace("_", "")
                .replace("`", "")
                .replace("\\", "");
    }

    private String buildBusinessTelegramContactUrl(String businessPhone) {
        if (businessPhone == null || businessPhone.isBlank()) {
            return null;
        }

        return "https://t.me/" + businessPhone;
    }

}
