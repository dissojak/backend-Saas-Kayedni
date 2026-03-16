package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.entities.ServiceBooking;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import com.bookify.backendbookify_saas.services.impl.BookingServiceImpl;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class StaffTelegramCallbackPollingService {

    private final BookingServiceImpl bookingService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${booking.notifications.enabled:true}")
    private boolean notificationsEnabled;

    @Value("${booking.notifications.staff-alert.enabled:true}")
    private boolean staffAlertEnabled;

    @Value("${booking.notifications.staff-alert.telegram.polling.enabled:true}")
    private boolean pollingEnabled;

    @Value("${booking.notifications.staff-alert.telegram.bot-token:}")
    private String staffBotToken;

    private volatile long lastUpdateId = 0L;

    @Scheduled(fixedDelayString = "${booking.notifications.staff-alert.telegram.polling.fixed-delay-ms:2500}")
    public void pollCallbackQueries() {
        if (!notificationsEnabled || !staffAlertEnabled || !pollingEnabled) {
            return;
        }
        if (staffBotToken == null || staffBotToken.isBlank()) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + staffBotToken + "/getUpdates?timeout=0&allowed_updates=%5B%22callback_query%22%5D";
            if (lastUpdateId > 0) {
                url += "&offset=" + lastUpdateId;
            }

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .GET()
                    .timeout(Duration.ofSeconds(5))
                    .build();

            HttpResponse<String> response = HttpClient.newHttpClient()
                    .send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                return;
            }

            JsonNode root = objectMapper.readTree(response.body());
            JsonNode result = root.path("result");
            if (!result.isArray()) {
                return;
            }

            for (JsonNode update : result) {
                long updateId = update.path("update_id").asLong(0L);
                if (updateId >= lastUpdateId) {
                    lastUpdateId = updateId + 1;
                }

                JsonNode callback = update.path("callback_query");
                if (callback.isMissingNode() || callback.isNull()) {
                    continue;
                }

                handleCallback(callback);
            }
        } catch (Exception e) {
            log.debug("Staff telegram callback polling skipped: {}", e.getMessage());
        }
    }

    private void handleCallback(JsonNode callback) {
        String callbackId = callback.path("id").asText("");
        String data = callback.path("data").asText("");
        JsonNode messageNode = callback.path("message");
        String chatId = messageNode.path("chat").path("id").asText("");
        long messageId = messageNode.path("message_id").asLong(0L);
        String originalMessageText = messageNode.path("text").asText("");

        if (callbackId.isBlank()) {
            return;
        }

        String responseText;
        String followUpMessage;
        try {
            String[] parts = data.split("_", 2);
            if (parts.length != 2) {
                answerCallback(callbackId, "Invalid action");
                return;
            }

            String action = parts[0].trim().toLowerCase();
            Long bookingId = Long.parseLong(parts[1]);

            Optional<ServiceBooking> bookingOpt = bookingService.getServiceBookingById(bookingId);
            if (bookingOpt.isEmpty()) {
                answerCallback(callbackId, "Booking not found");
                return;
            }

            ServiceBooking booking = bookingOpt.get();
            if (!"accept".equals(action) && !"reject".equals(action)) {
                answerCallback(callbackId, "Invalid action");
                return;
            }

            String bookingSummary = buildBookingSummaryFromMessage(originalMessageText, bookingId);
            if ("accept".equals(action)) {
                if (booking.getStatus() == BookingStatusEnum.PENDING) {
                    boolean confirmed = runAcceptAndVerify(bookingId);
                    responseText = confirmed ? "Booking accepted" : "Action failed";
                    followUpMessage = confirmed
                            ? "You have accepted the " + bookingSummary + "."
                            : "Action failed. Please try again.";
                } else {
                    responseText = "Already " + booking.getStatus();
                    followUpMessage = "No change: booking is already " + booking.getStatus() + ".";
                }
            } else {
                if (booking.getStatus() == BookingStatusEnum.PENDING) {
                    boolean rejected = runRejectAndVerify(bookingId);
                    responseText = rejected ? "Booking rejected" : "Action failed";
                    followUpMessage = rejected
                            ? "You have rejected the " + bookingSummary + "."
                            : "Action failed. Please try again.";
                } else {
                    responseText = "Already " + booking.getStatus();
                    followUpMessage = "No change: booking is already " + booking.getStatus() + ".";
                }
            }
        } catch (Exception e) {
            log.warn("Telegram callback action failed for data '{}': {}", data, e.getMessage());
            responseText = "Action failed";
            followUpMessage = "Action failed. Please try again.";
        }

        removeInlineKeyboard(chatId, messageId);
        sendChatMessage(chatId, followUpMessage);
        answerCallback(callbackId, responseText);
    }

    private boolean runAcceptAndVerify(Long bookingId) {
        try {
            bookingService.updateBookingStatus(bookingId, BookingStatusEnum.CONFIRMED);
        } catch (Exception e) {
            log.warn("Accept action raised error for booking {}: {}", bookingId, e.getMessage());
        }

        Optional<ServiceBooking> refreshed = bookingService.getServiceBookingById(bookingId);
        return refreshed.isPresent() && refreshed.get().getStatus() == BookingStatusEnum.CONFIRMED;
    }

    private boolean runRejectAndVerify(Long bookingId) {
        try {
            bookingService.cancelServiceBooking(bookingId, "Rejected by staff from Telegram");
        } catch (Exception e) {
            log.warn("Reject action raised error for booking {}: {}", bookingId, e.getMessage());
        }

        Optional<ServiceBooking> refreshed = bookingService.getServiceBookingById(bookingId);
        if (refreshed.isEmpty()) {
            return false;
        }

        BookingStatusEnum status = refreshed.get().getStatus();
        return status == BookingStatusEnum.REJECTED || status == BookingStatusEnum.CANCELLED;
    }

    private String buildBookingSummaryFromMessage(String messageText, Long bookingId) {
        if (messageText != null && !messageText.isBlank()) {
            String firstLine = messageText.split("\\R", 2)[0].trim();
            if (!firstLine.isBlank()) {
                return firstLine;
            }
        }
        return "booking #" + bookingId;
    }

    private void removeInlineKeyboard(String chatId, long messageId) {
        if (staffBotToken == null || staffBotToken.isBlank() || chatId == null || chatId.isBlank() || messageId <= 0) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + staffBotToken + "/editMessageReplyMarkup";
            String payload = "{\"chat_id\":\"" + escapeJson(chatId) + "\",\"message_id\":" + messageId
                    + ",\"reply_markup\":{\"inline_keyboard\":[]}}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .timeout(Duration.ofSeconds(5))
                    .build();

            HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            log.debug("Failed to remove Telegram inline keyboard: {}", e.getMessage());
        }
    }

    private void sendChatMessage(String chatId, String text) {
        if (staffBotToken == null || staffBotToken.isBlank() || chatId == null || chatId.isBlank() || text == null || text.isBlank()) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + staffBotToken + "/sendMessage";
            String payload = "{\"chat_id\":\"" + escapeJson(chatId) + "\",\"text\":\"" + escapeJson(text) + "\"}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .timeout(Duration.ofSeconds(5))
                    .build();

            HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            log.debug("Failed to send Telegram follow-up message: {}", e.getMessage());
        }
    }

    private void answerCallback(String callbackQueryId, String text) {
        if (staffBotToken == null || staffBotToken.isBlank() || callbackQueryId == null || callbackQueryId.isBlank()) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + staffBotToken + "/answerCallbackQuery";
            String payload = "{\"callback_query_id\":\"" + escapeJson(callbackQueryId) + "\",\"text\":\""
                    + escapeJson(text == null ? "Done" : text) + "\",\"show_alert\":false}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(payload))
                    .timeout(Duration.ofSeconds(5))
                    .build();

            HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
        } catch (Exception e) {
            log.debug("Failed to answer Telegram callback: {}", e.getMessage());
        }
    }

    private String escapeJson(String text) {
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
