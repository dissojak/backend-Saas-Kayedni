package com.bookify.backendbookify_saas;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * Base class for booking integration tests using the application's normal datasource config.
 */
@SpringBootTest
public abstract class IntegrationTestBase {

    protected LocalDate getTestDate() {
        return LocalDate.now().plusDays(5);
    }

    protected LocalTime getMorningStart() {
        return LocalTime.of(10, 0);
    }

    protected LocalTime getMorningEnd() {
        return LocalTime.of(11, 0);
    }

    protected LocalTime getAfternoonStart() {
        return LocalTime.of(14, 0);
    }

    protected LocalTime getAfternoonEnd() {
        return LocalTime.of(15, 0);
    }
}
