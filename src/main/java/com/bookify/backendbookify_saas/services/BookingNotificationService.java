package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.email_SMTP.MailService;
import com.bookify.backendbookify_saas.models.entities.ServiceBooking;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.LocalDateTime;

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

        String effectiveStatus = resolveStatusLabel(booking.getStatus(), previousStatus);
        String headline = buildStatusHeadline(effectiveStatus);

        String subject = "[Kayedni Booking Update] " + headline;
        String body = buildBookingDetails(booking,
                headline,
                "Booking Update",
                effectiveStatus);
        String htmlBody = buildBookingHtml(booking, headline, "Booking Update", effectiveStatus);

        sendClientEmail(booking, subject, body, htmlBody);
        sendTelegram(body);
    }

    public void sendReminder(ServiceBooking booking, long minutesBefore) {
        if (!notificationsEnabled || booking == null) {
            return;
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

        sendClientEmail(booking, subject, body, htmlBody);
        sendTelegram(body);
    }

    public void notifyStaffActionRequired(ServiceBooking booking) {
        if (!notificationsEnabled || !staffAlertEnabled || booking == null) {
            return;
        }

        String text = buildStaffActionRequiredText(booking);
        sendTelegramWithBot(staffAlertTelegramBotToken, staffAlertTelegramChatId, text);
    }

    private void sendClientEmail(ServiceBooking booking, String subject, String plainBody, String htmlBody) {
        try {
            String clientEmail = extractClientEmail(booking);
            if (clientEmail == null || clientEmail.isBlank()) {
                log.warn("Skipping booking email notification for booking {} because client email is missing", booking.getId());
                return;
            }

            MimeMessage msg = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msg, true, "UTF-8");
            helper.setFrom(new InternetAddress(fromEmail, fromDisplayName));
            helper.setTo(clientEmail);
            helper.setSubject(subject);
            helper.setText(plainBody, htmlBody);
            mailSender.send(msg);
        } catch (Exception e) {
            log.warn("Failed to send booking email notification for booking {}: {}", booking.getId(), e.getMessage());
            // Fallback to plain text if HTML send fails for any reason.
            try {
                String clientEmail = extractClientEmail(booking);
                if (clientEmail != null && !clientEmail.isBlank()) {
                    mailService.sendSimpleMessage(clientEmail, subject, plainBody);
                }
            } catch (Exception inner) {
                log.warn("Fallback plain email also failed for booking {}: {}", booking.getId(), inner.getMessage());
            }
        }
    }

    private void sendTelegram(String text) {
        if (!telegramEnabled
                || telegramBotToken == null || telegramBotToken.isBlank()
                || telegramDefaultChatId == null || telegramDefaultChatId.isBlank()) {
            return;
        }

        sendTelegramWithBot(telegramBotToken, telegramDefaultChatId, text);
    }

    private void sendTelegramWithBot(String botToken, String chatId, String text) {
        if (botToken == null || botToken.isBlank() || chatId == null || chatId.isBlank()) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + botToken + "/sendMessage";
            String payload = "{\"chat_id\":\"" + escapeJson(chatId)
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
                log.warn("Telegram booking notification returned {}: {}", response.statusCode(), response.body());
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.warn("Telegram send interrupted: {}", e.getMessage());
        } catch (Exception e) {
            log.warn("Failed to send Telegram booking notification: {}", e.getMessage());
        }
    }

    private String buildStaffActionRequiredText(ServiceBooking booking) {
        String businessName = booking.getService() != null && booking.getService().getBusiness() != null
                ? booking.getService().getBusiness().getName()
                : "Unknown";
        String serviceName = booking.getService() != null ? booking.getService().getName() : "Unknown";
        Integer serviceDuration = booking.getService() != null ? booking.getService().getDurationMinutes() : null;
        String staffName = booking.getStaff() != null ? booking.getStaff().getName() : "Unassigned";
        String clientName = extractClientName(booking);
        String clientPhone = extractClientPhone(booking);

        return "[Kayedni Staff Alert]\n"
                + "New booking requires action (Accept / Reject).\n\n"
                + "Booking ID: " + booking.getId() + "-Kayedni-Booking\n"
                + "Status: " + booking.getStatus() + "\n"
                + "Business: " + businessName + "\n"
                + "Staff: " + staffName + "\n"
                + "Service: " + serviceName + (serviceDuration != null ? (" (" + serviceDuration + " min)") : "") + "\n"
                + "Date: " + booking.getDate() + "\n"
                + "Time: " + booking.getStartTime() + " - " + booking.getEndTime() + "\n"
                + "Price: " + booking.getPrice() + "\n"
                + "Client: " + clientName + "\n"
                + "Client Phone: " + valueOrDash(clientPhone) + "\n"
                + "Notes: " + valueOrDash(booking.getNotes()) + "\n"
                + "Created At: " + LocalDateTime.now();
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
        if (currentStatus == BookingStatusEnum.CANCELLED) {
            if (previousStatus == BookingStatusEnum.CONFIRMED) {
                return "CANCELED";
            }
            if (previousStatus == BookingStatusEnum.PENDING) {
                return "REJECTED";
            }
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
}
