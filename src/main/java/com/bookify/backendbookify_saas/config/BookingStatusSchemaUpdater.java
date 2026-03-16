package com.bookify.backendbookify_saas.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Ensures MySQL enum column for bookings.status includes REJECTED.
 * Some existing databases were created without this enum value.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class BookingStatusSchemaUpdater implements ApplicationRunner {

    private final JdbcTemplate jdbcTemplate;

    @Value("${booking.schema.auto-fix-status-enum:true}")
    private boolean autoFixStatusEnum;

    @Override
    public void run(ApplicationArguments args) {
        if (!autoFixStatusEnum) {
            return;
        }

        try {
            String alterSql = "ALTER TABLE bookings MODIFY COLUMN status "
                    + "ENUM('PENDING','CONFIRMED','CANCELLED','REJECTED','COMPLETED','NO_SHOW') NOT NULL";
            jdbcTemplate.execute(alterSql);
            log.info("Verified bookings.status enum includes REJECTED");
        } catch (Exception e) {
            log.warn("Could not auto-fix bookings.status enum: {}", e.getMessage());
        }
    }
}
