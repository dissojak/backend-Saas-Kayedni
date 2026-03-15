package com.bookify.backendbookify_saas.schedulers;

import com.bookify.backendbookify_saas.models.entities.ServiceBooking;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import com.bookify.backendbookify_saas.repositories.ServiceBookingRepository;
import com.bookify.backendbookify_saas.services.BookingNotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class BookingReminderScheduler {

    private final ServiceBookingRepository serviceBookingRepository;
    private final BookingNotificationService bookingNotificationService;

    @Value("${booking.notifications.enabled:true}")
    private boolean notificationsEnabled;

    @Value("${booking.notifications.reminder.enabled:true}")
    private boolean reminderEnabled;

    @Value("${booking.notifications.reminder.minutes-before:30}")
    private long minutesBefore;

    @Value("${booking.notifications.reminder.window-minutes:1}")
    private long windowMinutes;

    @Scheduled(cron = "${booking.notifications.reminder.cron:0 * * * * *}")
    @Transactional
    public void sendUpcomingBookingReminders() {
        if (!notificationsEnabled || !reminderEnabled) {
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime windowStart = now.plusMinutes(minutesBefore);
        LocalDateTime windowEnd = windowStart.plusMinutes(windowMinutes);

        List<ServiceBooking> candidates = serviceBookingRepository.findReminderCandidates(
                BookingStatusEnum.CONFIRMED,
                windowStart.toLocalDate(),
                windowEnd.toLocalDate()
        );

        int sent = 0;
        for (ServiceBooking booking : candidates) {
            LocalDateTime bookingStart = LocalDateTime.of(booking.getDate(), booking.getStartTime());
            if (bookingStart.isBefore(windowStart) || !bookingStart.isBefore(windowEnd)) {
                continue;
            }

            bookingNotificationService.sendReminder(booking, minutesBefore);
            booking.setReminderSentAt(LocalDateTime.now());
            serviceBookingRepository.save(booking);
            sent++;
        }

        if (sent > 0) {
            log.info("Booking reminders sent: {} ({} min before)", sent, minutesBefore);
        }
    }
}
