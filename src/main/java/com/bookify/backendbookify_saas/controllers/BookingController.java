package com.bookify.backendbookify_saas.controllers;

import com.bookify.backendbookify_saas.exceptions.BookingTooSoonException;
import com.bookify.backendbookify_saas.models.dtos.ServiceBookingCreateRequest;
import com.bookify.backendbookify_saas.models.dtos.ServiceBookingResponse;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import com.bookify.backendbookify_saas.services.BookingNotificationService;
import com.bookify.backendbookify_saas.services.impl.BookingServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;



/**
 * REST Controller for Booking operations.
 * Exposes endpoints for creating, retrieving, and managing bookings.
 */
@RestController
@RequestMapping("/v1/bookings")
@RequiredArgsConstructor
@Tag(name = "Bookings", description = "Endpoints for managing bookings")
@Slf4j
public class BookingController {

    private final BookingServiceImpl bookingService;
    private final BookingNotificationService bookingNotificationService;

    /**
     * Create a new booking.
     * Backend performs full validation: availability, conflicts, staff assignment.
     */
    @PostMapping
    @Operation(summary = "Create a new booking", description = "Creates a service booking with server-side validation for availability and conflicts")
    public ResponseEntity<?> createBooking(
            Authentication authentication,
            @Valid @RequestBody ServiceBookingCreateRequest request
    ) {
        try {
            log.info("Creating booking: serviceId={}, staffId={}, date={}, startTime={}",
                    request.getServiceId(), request.getStaffId(), request.getDate(), request.getStartTime());
            
            ServiceBookingResponse response = bookingService.createServiceBookingFromRequest(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (BookingTooSoonException e) {
            log.warn("Booking blocked by lead-time rule: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "errorCode", "BOOKING_TOO_SOON",
                    "error", e.getMessage(),
                    "minLeadMinutes", e.getMinLeadMinutes()
            ));
        } catch (RuntimeException e) {
            log.error("Booking creation failed: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Get a booking by ID.
     */
    @GetMapping("/{bookingId}")
    @Operation(summary = "Get booking by ID", description = "Retrieve a specific booking by its ID")
    public ResponseEntity<?> getBookingById(@PathVariable Long bookingId) {
        return bookingService.getServiceBookingById(bookingId)
                .map(booking -> ResponseEntity.ok(bookingService.mapToPublicResponse(booking)))
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Get bookings for a staff member on a specific date.
     * Used by frontend to filter out occupied time slots.
     * Returns empty list if no bookings found (not an error).
     */
    @GetMapping("/staff/{staffId}/date/{date}")
    @Operation(summary = "Get bookings for staff on date", description = "Returns all non-cancelled bookings for a staff member on a specific date")
    public ResponseEntity<List<ServiceBookingResponse>> getBookingsForStaffOnDate(
            @PathVariable Long staffId,
            @PathVariable String date
    ) {
        try {
            LocalDate localDate = LocalDate.parse(date);
            List<ServiceBookingResponse> bookings = bookingService.getBookingsForStaffOnDate(staffId, localDate);
            // Always return OK with the list (may be empty)
            return ResponseEntity.ok(bookings != null ? bookings : List.of());
        } catch (java.time.format.DateTimeParseException e) {
            log.warn("Invalid date format for staff {} date {}: {}", staffId, date, e.getMessage());
            return ResponseEntity.ok(List.of()); // Return empty list for bad date format
        } catch (Exception e) {
            log.error("Error fetching bookings for staff {} on date {}: {}", staffId, date, e.getMessage(), e);
            // Return empty list instead of 400 - this is a read operation for slot filtering
            return ResponseEntity.ok(List.of());
        }
    }

    /**
     * Get bookings for a staff member within a date range.
     */
    @GetMapping("/staff/{staffId}")
    @Operation(summary = "Get bookings for staff", description = "Returns all bookings for a staff member within an optional date range")
    public ResponseEntity<List<ServiceBookingResponse>> getBookingsForStaff(
            @PathVariable Long staffId,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to
    ) {
        try {
            LocalDate startDate = from != null ? LocalDate.parse(from) : LocalDate.now().minusMonths(1);
            LocalDate endDate = to != null ? LocalDate.parse(to) : LocalDate.now().plusMonths(1);
            List<ServiceBookingResponse> bookings = bookingService.getBookingsForStaffBetweenDatesDto(staffId, startDate, endDate);
            return ResponseEntity.ok(bookings);
        } catch (Exception e) {
            log.error("Error fetching bookings for staff {}: {}", staffId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Get bookings for a business within a date range.
     */
    @GetMapping("/business/{businessId}")
    @Operation(summary = "Get bookings for business", description = "Returns all bookings for a business within an optional date range")
    public ResponseEntity<List<ServiceBookingResponse>> getBookingsForBusiness(
            @PathVariable Long businessId,
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to
    ) {
        try {
            LocalDate startDate = from != null ? LocalDate.parse(from) : LocalDate.now().minusMonths(1);
            LocalDate endDate = to != null ? LocalDate.parse(to) : LocalDate.now().plusMonths(1);
            List<ServiceBookingResponse> bookings = bookingService.getBookingsForBusinessBetweenDatesDto(businessId, startDate, endDate);
            return ResponseEntity.ok(bookings);
        } catch (Exception e) {
            log.error("Error fetching bookings for business {}: {}", businessId, e.getMessage());
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Get bookings for the authenticated client.
     */
    @GetMapping("/my-bookings")
    @Operation(summary = "Get my bookings", description = "Returns all bookings for the authenticated user")
    public ResponseEntity<?> getMyBookings(Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Authentication required"));
        }
        
        try {
            Long userId = Long.parseLong(authentication.getName());
            List<ServiceBookingResponse> bookings = bookingService.getBookingsForClientDto(userId);
            return ResponseEntity.ok(bookings);
        } catch (Exception e) {
            log.error("Error fetching bookings for user: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    /**
     * Update booking status.
     */
    @PutMapping("/{bookingId}/status")
    @Operation(summary = "Update booking status", description = "Update the status of a booking (PENDING, CONFIRMED, CANCELLED, COMPLETED, NO_SHOW)")
    public ResponseEntity<?> updateBookingStatus(
            @PathVariable Long bookingId,
            @RequestBody Map<String, String> body
    ) {
        try {
            String statusStr = body.get("status");
            if (statusStr == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Status is required"));
            }
            
            BookingStatusEnum status = BookingStatusEnum.valueOf(statusStr.toUpperCase());
            var updated = bookingService.updateBookingStatus(bookingId, status);
            return ResponseEntity.ok(bookingService.mapToPublicResponse(updated));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Invalid status value"));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Cancel a booking.
     */
    @PostMapping("/{bookingId}/cancel")
    @Operation(summary = "Cancel a booking", description = "Cancel a booking with an optional reason")
    public ResponseEntity<?> cancelBooking(
            @PathVariable Long bookingId,
            @RequestBody(required = false) Map<String, Object> body,
            Authentication authentication
    ) {
        try {
            var bookingOpt = bookingService.getServiceBookingById(bookingId);
            if (bookingOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            var booking = bookingOpt.get();
            String reason = body != null ? String.valueOf(body.getOrDefault("reason", "")) : null;
            if (reason != null && reason.isBlank()) {
                reason = null;
            }

            boolean initiatedByClient = parseBooleanFlag(body, "initiatedByClient")
                    || isClientBookingInitiator(authentication, booking);
            bookingService.cancelServiceBooking(bookingId, reason, initiatedByClient);
            return ResponseEntity.ok(Map.of("message", "Booking cancelled successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Staff-triggered immediate reminder for an upcoming confirmed booking.
     */
    @PostMapping("/{bookingId}/staff-reminder-now")
    @Operation(summary = "Send immediate reminder", description = "Staff sends an immediate Telegram reminder asking the client to come now")
    public ResponseEntity<?> sendStaffReminderNow(
            @PathVariable Long bookingId,
            Authentication authentication
    ) {
        if (authentication == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Authentication required"));
        }

        try {
            var bookingOpt = bookingService.getServiceBookingById(bookingId);
            if (bookingOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", "Booking not found"));
            }

            var booking = bookingOpt.get();
            if (booking.getStatus() != BookingStatusEnum.CONFIRMED) {
                return ResponseEntity.badRequest().body(Map.of("error", "Only confirmed bookings can receive this reminder"));
            }

            LocalDateTime bookingStart = LocalDateTime.of(booking.getDate(), booking.getStartTime());
            if (!bookingStart.isAfter(LocalDateTime.now())) {
                return ResponseEntity.badRequest().body(Map.of("error", "This reminder is only available for upcoming bookings"));
            }

            bookingNotificationService.sendStaffComeNowReminder(booking);
            return ResponseEntity.ok(Map.of("message", "Reminder sent successfully"));
        } catch (Exception e) {
            log.error("Failed to send immediate reminder for booking {}: {}", bookingId, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Failed to send reminder"));
        }
    }

    /**
     * Reschedule a booking to a new date/time.
     */
    @PutMapping("/{bookingId}/reschedule")
    @Operation(summary = "Reschedule a booking", description = "Reschedule a booking to a new date and time")
    public ResponseEntity<?> rescheduleBooking(
            @PathVariable Long bookingId,
            @RequestBody Map<String, Object> body,
            Authentication authentication
    ) {
        try {
            var bookingOpt = bookingService.getServiceBookingById(bookingId);
            if (bookingOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            var booking = bookingOpt.get();
            String newDate = body.get("date") != null ? String.valueOf(body.get("date")) : null;
            String newStartTime = body.get("startTime") != null ? String.valueOf(body.get("startTime")) : null;
            Object endTimeObj = body.get("endTime");
            String newEndTime = endTimeObj != null ? String.valueOf(endTimeObj) : null;
            
            if (newDate == null || newDate.isBlank() || newStartTime == null || newStartTime.isBlank()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Date and start time are required"));
            }
            
            LocalDate date = LocalDate.parse(newDate);
            java.time.LocalTime startTime = java.time.LocalTime.parse(newStartTime);
            java.time.LocalTime endTime = newEndTime != null && !newEndTime.isBlank()
                ? java.time.LocalTime.parse(newEndTime) 
                : null;
            boolean initiatedByClient = parseBooleanFlag(body, "initiatedByClient")
                    || isClientBookingInitiator(authentication, booking);
            
            ServiceBookingResponse response = bookingService.rescheduleBooking(bookingId, date, startTime, endTime, initiatedByClient);
            return ResponseEntity.ok(response);
        } catch (BookingTooSoonException e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "errorCode", "BOOKING_TOO_SOON",
                    "error", e.getMessage(),
                    "minLeadMinutes", e.getMinLeadMinutes()
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        } catch (RuntimeException e) {
            log.error("Reschedule failed: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    private boolean parseBooleanFlag(Map<String, Object> body, String key) {
        if (body == null || !body.containsKey(key)) {
            return false;
        }
        Object value = body.get(key);
        if (value instanceof Boolean boolValue) {
            return boolValue;
        }
        return Boolean.parseBoolean(String.valueOf(value));
    }

    private boolean isClientBookingInitiator(Authentication authentication, com.bookify.backendbookify_saas.models.entities.ServiceBooking booking) {
        if (authentication == null || booking == null || booking.getClient() == null) {
            return false;
        }

        try {
            Long authUserId = Long.parseLong(authentication.getName());
            return booking.getClient().getId().equals(authUserId);
        } catch (Exception ignored) {
            return false;
        }
    }
}
