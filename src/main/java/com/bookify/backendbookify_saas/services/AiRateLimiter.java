package com.bookify.backendbookify_saas.services;

import java.time.LocalDate;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


@Component
public class AiRateLimiter {

    @Value("${ai.max-reevaluations-per-day:5}")
    private int maxCallsPerDay;
    private final ConcurrentHashMap<Long, DailyCounter> counters = new ConcurrentHashMap<>();

    public boolean tryConsume(Long businessId) {
        LocalDate today = LocalDate.now();

        DailyCounter counter = counters.compute(businessId, (id, existing) -> {
            if (existing == null || !existing.date.equals(today)) {
                return new DailyCounter(today, new AtomicInteger(0));
            }
            return existing;
        });

        int next = counter.count.incrementAndGet();
        if (next > maxCallsPerDay) {
            counter.count.decrementAndGet();
            return false;
        }

        return true;
    }

    private static final class DailyCounter {
        private final LocalDate date;
        private final AtomicInteger count;

        private DailyCounter(LocalDate date, AtomicInteger count) {
            this.date = date;
            this.count = count;
        }
    }
}
