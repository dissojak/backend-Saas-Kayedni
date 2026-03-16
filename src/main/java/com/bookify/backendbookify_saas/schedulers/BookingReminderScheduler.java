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

import java.time.LocalTime;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
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

    @Scheduled(cron = "${booking.notifications.reminder.cron:0 */5 * * * *}")
    @Transactional
    public void sendUpcomingBookingReminders() {
        if (!notificationsEnabled || !reminderEnabled) {
            log.debug("Booking reminder scheduler skipped (notificationsEnabled={}, reminderEnabled={})",
                    notificationsEnabled, reminderEnabled);
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime windowStart = now.plusMinutes(minutesBefore);
        LocalDateTime windowEnd = windowStart.plusMinutes(windowMinutes);
        log.debug("Booking reminder scheduler started (windowStart={}, windowEnd={}, minutesBefore={})",
                windowStart, windowEnd, minutesBefore);

        try {
            List<ServiceBooking> candidates = new ArrayList<>();
            LocalDate startDate = windowStart.toLocalDate();
            LocalDate endDate = windowEnd.toLocalDate();
            LocalTime startTime = windowStart.toLocalTime();
            LocalTime endTime = windowEnd.toLocalTime();

            if (startDate.equals(endDate)) {
            candidates.addAll(serviceBookingRepository.findReminderCandidatesForDateWindow(
                BookingStatusEnum.CONFIRMED,
                startDate,
                startTime,
                endTime
            ));
            } else {
            candidates.addAll(serviceBookingRepository.findReminderCandidatesFromTime(
                BookingStatusEnum.CONFIRMED,
                startDate,
                startTime
            ));
            candidates.addAll(serviceBookingRepository.findReminderCandidatesUntilTime(
                BookingStatusEnum.CONFIRMED,
                endDate,
                endTime
            ));
            }

            log.debug("Booking reminder scheduler loaded {} candidate(s)", candidates.size());

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
            } else {
                log.debug("Booking reminder scheduler finished with no reminders to send");
            }
        } catch (Exception ex) {
            log.error("Booking reminder scheduler failed", ex);
        }
    }
}
