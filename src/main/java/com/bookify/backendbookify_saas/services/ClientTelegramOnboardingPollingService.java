package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.entities.BusinessClient;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.repositories.BusinessClientRepository;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class ClientTelegramOnboardingPollingService {

    private static final String START_PREFIX = "kyd_u_";

    private final UserRepository userRepository;
    private final BusinessClientRepository businessClientRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${booking.notifications.enabled:true}")
    private boolean notificationsEnabled;

    @Value("${booking.notifications.telegram.enabled:true}")
    private boolean telegramEnabled;

    @Value("${booking.notifications.telegram.polling.enabled:true}")
    private boolean pollingEnabled;

    @Value("${booking.notifications.telegram.bot-token:}")
    private String clientBotToken;

    private volatile long lastUpdateId = 0L;

    @Scheduled(fixedDelayString = "${booking.notifications.telegram.polling.fixed-delay-ms:2500}")
    public void pollClientBotUpdates() {
        if (!notificationsEnabled || !telegramEnabled || !pollingEnabled) {
            return;
        }
        if (clientBotToken == null || clientBotToken.isBlank()) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + clientBotToken + "/getUpdates?timeout=0&allowed_updates=%5B%22message%22%5D";
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

                JsonNode message = update.path("message");
                if (message.isMissingNode() || message.isNull()) {
                    continue;
                }

                handleMessage(message);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.debug("Client telegram polling interrupted: {}", e.getMessage());
        } catch (Exception e) {
            log.debug("Client telegram polling skipped: {}", e.getMessage());
        }
    }

    private void handleMessage(JsonNode message) {
        String chatId = message.path("chat").path("id").asText("").trim();
        if (chatId.isBlank()) {
            return;
        }

        JsonNode contactNode = message.path("contact");
        if (!contactNode.isMissingNode() && !contactNode.isNull()) {
            handleContactMessage(chatId, contactNode);
            return;
        }

        String text = message.path("text").asText("").trim();
        if (!text.startsWith("/start")) {
            return;
        }

        String[] parts = text.split("\\s+", 2);
        if (parts.length < 2) {
            sendPhoneSharePrompt(chatId);
            return;
        }

        String payload = parts[1].trim();
        if (!payload.startsWith(START_PREFIX)) {
            sendPhoneSharePrompt(chatId);
            return;
        }

        String userIdPart = payload.substring(START_PREFIX.length());
        Long userId;
        try {
            userId = Long.parseLong(userIdPart);
        } catch (Exception ignored) {
            return;
        }

        userRepository.findById(userId).ifPresent(user -> {
            if (chatId.equals(user.getTelegramChatId())) {
                return;
            }

            user.setTelegramChatId(chatId);
            userRepository.save(user);
            log.info("Linked Telegram chat id for user {}", userId);
            sendChatMessage(chatId, "Telegram notifications are now linked to your account.");
        });
    }

    private void handleContactMessage(String chatId, JsonNode contactNode) {
        String rawPhone = contactNode.path("phone_number").asText("").trim();
        if (rawPhone.isBlank()) {
            sendChatMessage(chatId, "Could not read your phone number. Please try again.");
            return;
        }

        Set<String> candidates = buildPhoneCandidates(rawPhone);
        int linkedCount = 0;

        List<User> matchedUsers = new ArrayList<>();
        for (String phone : candidates) {
            matchedUsers.addAll(userRepository.findByPhoneNumber(phone));
        }
        for (User user : matchedUsers) {
            if (!chatId.equals(user.getTelegramChatId())) {
                user.setTelegramChatId(chatId);
                userRepository.save(user);
            }
            linkedCount++;
        }

        List<BusinessClient> matchedBusinessClients = new ArrayList<>();
        for (String phone : candidates) {
            matchedBusinessClients.addAll(businessClientRepository.findByPhone(phone));
        }
        for (BusinessClient client : matchedBusinessClients) {
            if (!chatId.equals(client.getTelegramChatId())) {
                client.setTelegramChatId(chatId);
                businessClientRepository.save(client);
            }
            linkedCount++;
        }

        if (linkedCount > 0) {
            sendChatMessage(chatId, "Telegram notifications are now linked.");
        } else {
            sendChatMessage(chatId, "No account matched this phone number in Bookify. Please verify your phone in the app.");
        }
    }

    private Set<String> buildPhoneCandidates(String rawPhone) {
        LinkedHashSet<String> values = new LinkedHashSet<>();

        String trimmed = rawPhone.trim();
        if (trimmed.isEmpty()) {
            return values;
        }

        values.add(trimmed);

        String withoutPlus = trimmed.startsWith("+") ? trimmed.substring(1) : trimmed;
        values.add(withoutPlus);
        values.add("+" + withoutPlus);

        String digitsOnly = withoutPlus.replaceAll("[^0-9]", "");
        if (!digitsOnly.isBlank()) {
            values.add(digitsOnly);
            values.add("+" + digitsOnly);
        }

        return values;
    }

    private void sendPhoneSharePrompt(String chatId) {
        String text = "To enable notifications, please share your phone number so we can link your account.";
        String replyMarkup = "{\"keyboard\":[[{\"text\":\"Share Phone Number\",\"request_contact\":true}]],\"resize_keyboard\":true,\"one_time_keyboard\":true}";
        sendChatMessage(chatId, text, replyMarkup);
    }

    private void sendChatMessage(String chatId, String text) {
        sendChatMessage(chatId, text, null);
    }

    private void sendChatMessage(String chatId, String text, String replyMarkupJson) {
        if (clientBotToken == null || clientBotToken.isBlank() || chatId == null || chatId.isBlank() || text == null || text.isBlank()) {
            return;
        }

        try {
            String url = "https://api.telegram.org/bot" + clientBotToken + "/sendMessage";

            StringBuilder payloadBuilder = new StringBuilder();
            payloadBuilder.append("{\"chat_id\":\"").append(escapeJson(chatId)).append("\"");
            payloadBuilder.append(",\"text\":\"").append(escapeJson(text)).append("\"");
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

            HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            log.debug("Failed to send Telegram onboarding message: {}", e.getMessage());
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
