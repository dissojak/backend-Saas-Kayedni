package com.bookify.backendbookify_saas;

import io.github.cdimascio.dotenv.Dotenv;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.scheduling.annotation.EnableScheduling;


@SpringBootApplication
@EnableScheduling
public class BackendBookifySaasApplication {

    static Dotenv dotenv = Dotenv.configure()
            .ignoreIfMalformed()
            .ignoreIfMissing()
            .load();

    public static void main(String[] args) {
        promoteDotenvToSystemProperties();
        SpringApplication.run(BackendBookifySaasApplication.class, args);
    }

    private static void promoteDotenvToSystemProperties() {
        setIfPresent("SPRING_MAIL_PASSWORD", "spring.mail.password");
        setIfPresent("GEMINI_API_KEY", "GEMINI_API_KEY");

        // Telegram + booking notification variables used by application.properties placeholders
        setIfPresent("TELEGRAM_BOT_TOKEN", "TELEGRAM_BOT_TOKEN");
        setIfPresent("TELEGRAM_CHAT_ID", "TELEGRAM_CHAT_ID");
        setIfPresent("BOOKING_NOTIFICATIONS_TELEGRAM_BOT_TOKEN", "BOOKING_NOTIFICATIONS_TELEGRAM_BOT_TOKEN");
        setIfPresent("BOOKING_NOTIFICATIONS_TELEGRAM_CHAT_ID", "BOOKING_NOTIFICATIONS_TELEGRAM_CHAT_ID");
        setIfPresent("BOOKING_NOTIFICATIONS_STAFF_ALERT_TELEGRAM_BOT_TOKEN", "BOOKING_NOTIFICATIONS_STAFF_ALERT_TELEGRAM_BOT_TOKEN");
        setIfPresent("BOOKING_NOTIFICATIONS_STAFF_ALERT_TELEGRAM_CHAT_ID", "BOOKING_NOTIFICATIONS_STAFF_ALERT_TELEGRAM_CHAT_ID");

        // Flow B admin alert variables
        setIfPresent("FLOW_B_ADMIN_ALERT_EMAIL_ENABLED", "FLOW_B_ADMIN_ALERT_EMAIL_ENABLED");
        setIfPresent("FLOW_B_ADMIN_ALERT_EMAIL", "FLOW_B_ADMIN_ALERT_EMAIL");
        setIfPresent("FLOW_B_ADMIN_TELEGRAM_ENABLED", "FLOW_B_ADMIN_TELEGRAM_ENABLED");
        setIfPresent("FLOW_B_ADMIN_TELEGRAM_BOT_TOKEN", "FLOW_B_ADMIN_TELEGRAM_BOT_TOKEN");
        setIfPresent("FLOW_B_ADMIN_TELEGRAM_CHAT_ID", "FLOW_B_ADMIN_TELEGRAM_CHAT_ID");
    }

    private static void setIfPresent(String dotenvKey, String systemPropertyKey) {
        String value = dotenv.get(dotenvKey);
        if (value != null && !value.isBlank()) {
            System.setProperty(systemPropertyKey, value);
        }
    }

    private static final Logger logger = LoggerFactory.getLogger(BackendBookifySaasApplication.class);
    @Bean
    public CommandLineRunner commandLineRunner(Environment environment) {

        return args -> {
            String port = environment.getProperty("server.port", "8088");
            String contextPath = environment.getProperty("server.servlet.context-path", "");

            System.out.println("\n----------------------------------------------------------");
            System.out.println("🚀 Kayedni SaaS Server is running!");
            System.out.println("    📡 Local:   http://localhost:" + port + contextPath);
            try {
                String hostAddress = java.net.InetAddress.getLocalHost().getHostAddress();
                System.out.println("    🌐 Network: http://" + hostAddress + ":" + port + contextPath);
            } catch (Exception e) {
                // Ignore network address error
            }
            System.out.println("    ⚙️  API Documentation: http://localhost:" + port + contextPath + "/swagger-ui.html");

            if (isDevMode(environment)) {
                printDotenvDiagnostics();
            }

            System.out.println("----------------------------------------------------------\n");
        };
    }

    private static boolean isDevMode(Environment environment) {
        return !environment.acceptsProfiles(org.springframework.core.env.Profiles.of("prod"));
    }

    private static void printDotenvDiagnostics() {
        Set<String> fileKeys = readDotenvFileKeys();
        ArrayList<String> keys = new ArrayList<>(fileKeys);

        Collections.sort(keys);

        System.out.println("    🛠 .env loaded keys (dev diagnostics):");
        if (keys.isEmpty()) {
            System.out.println("      - (no .env file found, or no keys defined)");
            return;
        }

        for (String key : keys) {
            System.out.println("      - " + key + ": " + maskSecret(dotenv.get(key)));
        }
    }

    private static Set<String> readDotenvFileKeys() {
        LinkedHashSet<String> keys = new LinkedHashSet<>();
        Path dotenvPath = Path.of(".env");

        if (!Files.exists(dotenvPath)) {
            return keys;
        }

        try {
            for (String line : Files.readAllLines(dotenvPath)) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("#")) {
                    continue;
                }

                String cleaned = trimmed.startsWith("export ")
                        ? trimmed.substring(7).trim()
                        : trimmed;

                int equalsIndex = cleaned.indexOf('=');
                if (equalsIndex <= 0) {
                    continue;
                }

                String key = cleaned.substring(0, equalsIndex).trim();
                if (!key.isEmpty()) {
                    keys.add(key);
                }
            }
        } catch (Exception ignored) {
            // Keep diagnostics non-fatal.
        }

        return keys;
    }

    private static String maskSecret(String value) {
        if (value == null || value.isBlank()) {
            return "(missing)";
        }
        if (value.length() <= 8) {
            return "***";
        }
        return value.substring(0, 4) + "..." + value.substring(value.length() - 4);
    }
}