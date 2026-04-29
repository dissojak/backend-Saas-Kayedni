package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.exceptions.BookingSlotContentionException;
import com.bookify.backendbookify_saas.exceptions.BookingTooSoonException;
import com.bookify.backendbookify_saas.models.dtos.ServiceBookingCreateRequest;
import com.bookify.backendbookify_saas.models.dtos.ServiceBookingResponse;
import com.bookify.backendbookify_saas.models.entities.Booking;
import com.bookify.backendbookify_saas.models.entities.Business;
import com.bookify.backendbookify_saas.models.entities.BusinessClient;
import com.bookify.backendbookify_saas.models.entities.Service;
import com.bookify.backendbookify_saas.models.entities.ServiceBooking;
import com.bookify.backendbookify_saas.models.entities.ServiceBookingOccupancy;
import com.bookify.backendbookify_saas.models.entities.Staff;
import com.bookify.backendbookify_saas.models.entities.StaffAvailability;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.models.enums.AvailabilityStatus;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import com.bookify.backendbookify_saas.repositories.BookingRepository;
import com.bookify.backendbookify_saas.repositories.BusinessClientRepository;
import com.bookify.backendbookify_saas.repositories.BusinessRepository;
import com.bookify.backendbookify_saas.repositories.ServiceBookingOccupancyRepository;
import com.bookify.backendbookify_saas.repositories.ServiceBookingRepository;
import com.bookify.backendbookify_saas.repositories.ServiceRepository;
import com.bookify.backendbookify_saas.repositories.StaffAvailabilityRepository;
import com.bookify.backendbookify_saas.repositories.StaffRepository;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import com.bookify.backendbookify_saas.services.BookingNotificationService;
import com.bookify.backendbookify_saas.services.BookingService;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implementation of BookingService with support for both User and BusinessClient.
 * Conflict detection is staff-based, not service-based.
 */
@org.springframework.stereotype.Service
@RequiredArgsConstructor
@Slf4j
public class BookingServiceImpl implements BookingService {

    private static final long MIN_BOOKING_LEAD_MINUTES = 3;

    private final ServiceBookingRepository serviceBookingRepository;
    private final ServiceRepository serviceRepository;
    private final UserRepository userRepository;
    private final BusinessClientRepository businessClientRepository;
    private final BookingRepository bookingRepository;
    private final StaffRepository staffRepository;
    private final StaffAvailabilityRepository staffAvailabilityRepository;
    private final ServiceBookingOccupancyRepository serviceBookingOccupancyRepository;
    private final BusinessRepository businessRepository;
    private final BookingNotificationService bookingNotificationService;

    @Override
    @Transactional
    public ServiceBooking createServiceBooking(ServiceBooking booking) {
        return serviceBookingRepository.save(booking);
    }

    /**
     * Create a service booking with full validation:
     * - Staff availability check
     * - Staff conflict detection (not service-based)
     * - Business client validation
     */
    @Transactional
    public ServiceBookingResponse createServiceBookingFromRequest(ServiceBookingCreateRequest request) {
        // Validate that either clientId or businessClientId is provided
        if (request.getClientId() == null && request.getBusinessClientId() == null) {
            throw new RuntimeException("Either clientId or businessClientId must be provided");
        }
        if (request.getClientId() != null && request.getBusinessClientId() != null) {
            throw new RuntimeException("Only one of clientId or businessClientId can be provided");
        }

        // Staff is required for booking
        if (request.getStaffId() == null) {
            throw new RuntimeException("Staff ID is required for booking");
        }

        validateBookingLeadTime(request.getDate(), request.getStartTime());

        // Fetch service
        com.bookify.backendbookify_saas.models.entities.Service service = serviceRepository.findById(request.getServiceId())
                .orElseThrow(() -> new RuntimeException("Service not found"));

        // Fetch staff with business eagerly loaded
        log.info("Attempting to fetch staff with ID: {}", request.getStaffId());
        Staff staff = staffRepository.findByIdWithBusiness(request.getStaffId())
                .orElseThrow(() -> new RuntimeException("Staff not found"));
        
        // Workaround: If business is null due to entity mapping issues, fetch it using native query
        Business staffBusiness = staff.getBusiness();
        if (staffBusiness == null) {
            Optional<Long> businessIdOpt = staffRepository.findBusinessIdById(staff.getId());
            if (businessIdOpt.isPresent()) {
                staffBusiness = businessRepository.findById(businessIdOpt.get()).orElse(null);
                log.info("Fetched business via native query: {}", staffBusiness != null ? staffBusiness.getId() : "NULL");
            }
        }
        
        log.info("Found staff: ID={}, Name={}, Business={}", 
                staff.getId(), 
                staff.getName(), 
                staffBusiness != null ? staffBusiness.getId() : "NULL");

        // Validate staff belongs to the same business as the service
        if (staffBusiness == null) {
            throw new RuntimeException("Staff does not have a business associated. Staff ID: " + staff.getId());
        }
        if (!staffBusiness.getId().equals(service.getBusiness().getId())) {
            throw new RuntimeException("Staff does not belong to the same business as the service");
        }

        // 1. Check staff availability for the date (no day-level lock)
        Optional<StaffAvailability> availabilityOpt = staffAvailabilityRepository.findByStaff_IdAndDate(
            request.getStaffId(), request.getDate());
        
        if (availabilityOpt.isEmpty()) {
            throw new RuntimeException("Staff has no availability data for this date");
        }
        
        StaffAvailability availability = availabilityOpt.get();
        if (availability.getStatus() != AvailabilityStatus.AVAILABLE) {
            throw new RuntimeException("Staff is not available on this date (status: " + availability.getStatus() + ")");
        }

        // 2. Check booking time is within staff working hours
        if (request.getStartTime().isBefore(availability.getStartTime()) ||
            request.getEndTime().isAfter(availability.getEndTime())) {
            throw new RuntimeException("Booking time is outside staff working hours (" + 
                    availability.getStartTime() + " - " + availability.getEndTime() + ")");
        }

        // 3. Fast read for user-friendly response before the guaranteed occupancy write.
        boolean hasConflict = serviceBookingRepository.existsOverlappingForStaff(
                request.getStaffId(), request.getDate(), request.getStartTime(), request.getEndTime());
        if (hasConflict) {
            throw new BookingSlotContentionException("Time slot is already booked for this staff member. Please retry with a different time.");
        }

        // Build the booking
        ServiceBooking booking = new ServiceBooking();
        booking.setService(service);
        booking.setStaff(staff);
        booking.setDate(request.getDate());
        booking.setStartTime(request.getStartTime());
        booking.setEndTime(request.getEndTime());
        booking.setNotes(request.getNotes());
        booking.setPrice(request.getPrice());
        booking.setStatus(request.getStatus() != null ? request.getStatus() : BookingStatusEnum.PENDING);

        // Handle User client
        if (request.getClientId() != null) {
            User client = userRepository.findById(request.getClientId())
                    .orElseThrow(() -> new RuntimeException("User client not found"));
            booking.setClient(client);
        }

        // Handle BusinessClient
        if (request.getBusinessClientId() != null) {
            BusinessClient businessClient = businessClientRepository.findById(request.getBusinessClientId())
                    .orElseThrow(() -> new RuntimeException("Business client not found"));

            // Validate that the BusinessClient belongs to the same business as the service
            if (!businessClient.getBusiness().getId().equals(service.getBusiness().getId())) {
                throw new RuntimeException("Business client does not belong to the same business as the service");
            }

            booking.setBusinessClient(businessClient);
        }

        log.info("Creating booking: staffId={}, date={}, time={}-{}", 
                staff.getId(), request.getDate(), request.getStartTime(), request.getEndTime());

        ServiceBooking savedBooking = serviceBookingRepository.saveAndFlush(booking);
        if (isSlotBlockingStatus(savedBooking.getStatus())) {
            reserveOccupancy(savedBooking);
        }

        if (savedBooking.getStatus() == BookingStatusEnum.PENDING) {
            safeNotifyStaffActionRequired(savedBooking);
        }

        return mapToResponse(savedBooking);
    }

    @Override
    @Transactional
    public ServiceBooking updateServiceBooking(Long id, ServiceBooking booking) {
        ServiceBooking existing = serviceBookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        BookingStatusEnum previousStatus = existing.getStatus();
        boolean wasBlocking = isSlotBlockingStatus(previousStatus);
        boolean willBeBlocking = isSlotBlockingStatus(booking.getStatus());

        if (wasBlocking) {
            serviceBookingOccupancyRepository.deleteByBookingId(existing.getId());
        }

        existing.setDate(booking.getDate());
        existing.setStartTime(booking.getStartTime());
        existing.setEndTime(booking.getEndTime());
        existing.setStatus(booking.getStatus());
        existing.setNotes(booking.getNotes());
        existing.setPrice(booking.getPrice());

        ServiceBooking saved = serviceBookingRepository.saveAndFlush(existing);
        if (willBeBlocking) {
            reserveOccupancy(saved);
        }
        if (previousStatus != saved.getStatus()) {
            safeNotifyStatusChange(saved, previousStatus);
        }
        return saved;
    }

    @Override
    @Transactional
    public ServiceBooking updateBookingStatus(Long id, BookingStatusEnum status) {
        ServiceBooking booking = serviceBookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        BookingStatusEnum previousStatus = booking.getStatus();
        boolean wasBlocking = isSlotBlockingStatus(previousStatus);
        boolean willBeBlocking = isSlotBlockingStatus(status);

        booking.setStatus(status);
        ServiceBooking saved = serviceBookingRepository.saveAndFlush(booking);

        if (wasBlocking && !willBeBlocking) {
            serviceBookingOccupancyRepository.deleteByBookingId(saved.getId());
        } else if (!wasBlocking && willBeBlocking) {
            reserveOccupancy(saved);
        }

        safeNotifyStatusChange(saved, previousStatus);
        return saved;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ServiceBooking> getServiceBookingById(Long id) {
        return serviceBookingRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceBooking> getBookingsByClient(User client) {
        return serviceBookingRepository.findByClient(client);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceBooking> getBookingsByService(com.bookify.backendbookify_saas.models.entities.Service service) {
        return serviceBookingRepository.findByService(service);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceBooking> getBookingsByStatus(BookingStatusEnum status) {
        return serviceBookingRepository.findByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ServiceBooking> getBookingsForBusinessBetweenDates(Long businessId, LocalDate startDate, LocalDate endDate) {
        return serviceBookingRepository.findByBusinessIdAndDateBetween(businessId, startDate, endDate);
    }

    /**
     * Get bookings by BusinessClient
     */
    @Transactional(readOnly = true)
    public List<ServiceBookingResponse> getBookingsByBusinessClient(Long businessClientId) {
        BusinessClient businessClient = businessClientRepository.findById(businessClientId)
                .orElseThrow(() -> new RuntimeException("Business client not found"));

        List<ServiceBooking> bookings = serviceBookingRepository.findByBusinessClientIdWithServiceAndBusiness(
            businessClient.getId()
        );

        return bookings.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isTimeSlotAvailable(com.bookify.backendbookify_saas.models.entities.Service service, LocalDate date, LocalTime startTime, LocalTime endTime) {
        // Query bookings by service and filter by date
        List<ServiceBooking> existingBookings = serviceBookingRepository.findByService(service).stream()
                .filter(booking -> booking.getDate().equals(date))
                .collect(Collectors.toList());

        for (ServiceBooking booking : existingBookings) {
            if (booking.getStatus() == BookingStatusEnum.CANCELLED) {
                continue;
            }

            // Check for time overlap
            if (startTime.isBefore(booking.getEndTime()) && endTime.isAfter(booking.getStartTime())) {
                return false; // Overlap detected
            }
        }

        return true;
    }

    @Override
    @Transactional
    public void cancelServiceBooking(Long id, String reason) {
        cancelServiceBooking(id, reason, false);
    }

    @Transactional
    public void cancelServiceBooking(Long id, String reason, boolean initiatedByClient) {
        ServiceBooking booking = serviceBookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        BookingStatusEnum previousStatus = booking.getStatus();

        // PENDING bookings → REJECTED; everything else (CONFIRMED) → CANCELLED
        if (previousStatus == BookingStatusEnum.PENDING) {
            booking.setStatus(BookingStatusEnum.REJECTED);
        } else {
            booking.setStatus(BookingStatusEnum.CANCELLED);
        }

        if (reason != null && !reason.isBlank()) {
            booking.setCancellationReason(reason.trim());
        }

        ServiceBooking saved = serviceBookingRepository.saveAndFlush(booking);
        serviceBookingOccupancyRepository.deleteByBookingId(saved.getId());
        if (initiatedByClient) {
            safeNotifyStaffClientCancellation(saved, previousStatus);
        } else {
            safeNotifyStatusChange(saved, previousStatus);
        }
    }

    @Override
    @Transactional
    public void deleteServiceBooking(Long id) {
        if (!serviceBookingRepository.existsById(id)) {
            throw new RuntimeException("Booking not found");
        }
        serviceBookingOccupancyRepository.deleteByBookingId(id);
        serviceBookingRepository.deleteById(id);
    }

    @Override
    @Transactional
    public ServiceBookingResponse rescheduleBooking(Long bookingId, LocalDate newDate, LocalTime newStartTime, LocalTime newEndTime) {
        return rescheduleBooking(bookingId, newDate, newStartTime, newEndTime, false);
    }

    @Transactional
    public ServiceBookingResponse rescheduleBooking(Long bookingId, LocalDate newDate, LocalTime newStartTime, LocalTime newEndTime, boolean initiatedByClient) {
        // Use the query that eagerly loads Service and Business to avoid LAZY loading issues
        ServiceBooking booking = serviceBookingRepository.findByIdWithServiceAndBusiness(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        LocalDate oldDate = booking.getDate();
        LocalTime oldStart = booking.getStartTime();
        LocalTime oldEnd = booking.getEndTime();

        // Validate booking can be rescheduled (not cancelled or completed)
        if (booking.getStatus() == BookingStatusEnum.CANCELLED || booking.getStatus() == BookingStatusEnum.COMPLETED) {
            throw new IllegalArgumentException("Cannot reschedule a " + booking.getStatus().name().toLowerCase() + " booking");
        }

        validateBookingLeadTime(newDate, newStartTime);

        // Calculate final end time if not provided (use service duration)
        final LocalTime finalEndTime;
        if (newEndTime == null) {
            Integer durationMinutes = booking.getService().getDurationMinutes();
            if (durationMinutes == null) durationMinutes = 30; // default 30 minutes
            finalEndTime = newStartTime.plusMinutes(durationMinutes);
        } else {
            finalEndTime = newEndTime;
        }

        Long staffId = booking.getStaff().getId();
        List<ServiceBooking> conflictingBookings = serviceBookingRepository.findByStaffIdAndDateExcludingCancelled(staffId, newDate);
        for (ServiceBooking existing : conflictingBookings) {
            if (existing.getId().equals(bookingId)) {
                continue;
            }
            if (newStartTime.isBefore(existing.getEndTime()) && finalEndTime.isAfter(existing.getStartTime())) {
                throw new BookingSlotContentionException("The selected time slot is not available. Please retry with a different time.");
            }
        }

        serviceBookingOccupancyRepository.deleteByBookingId(bookingId);

        // Update booking
        BookingStatusEnum previousStatus = booking.getStatus();
        booking.setDate(newDate);
        booking.setStartTime(newStartTime);
        booking.setEndTime(finalEndTime);
        booking.setStatus(BookingStatusEnum.PENDING); // Reset to pending after reschedule
        
        serviceBookingRepository.saveAndFlush(booking);
        reserveOccupancy(booking);
        
        // Re-fetch with all associations to avoid lazy loading issues when mapping to response
        ServiceBooking saved = serviceBookingRepository.findByIdWithServiceAndBusiness(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found after save"));
        if (initiatedByClient) {
            safeNotifyStaffClientReschedule(saved, oldDate, oldStart, oldEnd);
        } else {
            safeNotifyStatusChange(saved, previousStatus);
        }
        return mapToResponse(saved);
    }

    private void safeNotifyStatusChange(ServiceBooking booking, BookingStatusEnum previousStatus) {
        try {
            bookingNotificationService.notifyStatusChange(booking, previousStatus);
        } catch (Exception e) {
            log.warn("Booking {} status persisted but status notification failed: {}", booking.getId(), e.getMessage());
        }
    }

    private void validateBookingLeadTime(LocalDate date, LocalTime startTime) {
        LocalDateTime requestedStart = LocalDateTime.of(date, startTime);
        LocalDateTime minAllowedStart = LocalDateTime.now().plusMinutes(MIN_BOOKING_LEAD_MINUTES);

        // Exactly +3 minutes is blocked; booking must be strictly after now + 3 minutes.
        if (!requestedStart.isAfter(minAllowedStart)) {
            throw new BookingTooSoonException(MIN_BOOKING_LEAD_MINUTES);
        }
    }

    private void reserveOccupancy(ServiceBooking booking) {
        try {
            serviceBookingOccupancyRepository.saveAll(toOccupancyRows(booking));
            serviceBookingOccupancyRepository.flush();
        } catch (DataIntegrityViolationException ex) {
            throw new BookingSlotContentionException("Time slot is being booked by another request. Please retry.", ex);
        }
    }

    private List<ServiceBookingOccupancy> toOccupancyRows(ServiceBooking booking) {
        int startMinute = booking.getStartTime().toSecondOfDay() / 60;
        int endMinute = booking.getEndTime().toSecondOfDay() / 60;

        List<ServiceBookingOccupancy> rows = new ArrayList<>(Math.max(0, endMinute - startMinute));
        for (int slot = startMinute; slot < endMinute; slot++) {
            rows.add(new ServiceBookingOccupancy(
                    null,
                    booking.getId(),
                    booking.getStaff().getId(),
                    booking.getDate(),
                    slot
            ));
        }
        return rows;
    }

    private boolean isSlotBlockingStatus(BookingStatusEnum status) {
        return status == BookingStatusEnum.PENDING || status == BookingStatusEnum.CONFIRMED;
    }

    private void safeNotifyStaffActionRequired(ServiceBooking booking) {
        try {
            bookingNotificationService.notifyStaffActionRequired(booking);
        } catch (Exception e) {
            log.warn("Booking {} persisted but staff action-required notification failed: {}", booking.getId(), e.getMessage());
        }
    }

    private void safeNotifyStaffClientCancellation(ServiceBooking booking, BookingStatusEnum previousStatus) {
        try {
            bookingNotificationService.notifyStaffClientCancellation(booking, previousStatus);
        } catch (Exception e) {
            log.warn("Booking {} cancellation persisted but staff cancellation notification failed: {}", booking.getId(), e.getMessage());
        }
    }

    private void safeNotifyStaffClientReschedule(ServiceBooking booking, LocalDate oldDate, LocalTime oldStart, LocalTime oldEnd) {
        try {
            bookingNotificationService.notifyStaffClientReschedule(booking, oldDate, oldStart, oldEnd);
        } catch (Exception e) {
            log.warn("Booking {} reschedule persisted but staff reschedule notification failed: {}", booking.getId(), e.getMessage());
        }
    }

    /**
     * Map ServiceBooking entity to response DTO
     */
    private ServiceBookingResponse mapToResponse(ServiceBooking booking) {
        ServiceBookingResponse.ServiceBookingResponseBuilder builder = ServiceBookingResponse.builder()
                .id(booking.getId())
                .serviceId(booking.getService().getId())
                .serviceName(booking.getService().getName())
                .serviceDuration(booking.getService().getDurationMinutes())
                .businessId(booking.getService().getBusiness() != null ? booking.getService().getBusiness().getId() : null)
                .businessName(booking.getService().getBusiness() != null ? booking.getService().getBusiness().getName() : null)
                .date(booking.getDate())
                .startTime(booking.getStartTime())
                .endTime(booking.getEndTime())
                .status(booking.getStatus())
                .notes(booking.getNotes())
                .cancellationReason(booking.getCancellationReason())
                .price(booking.getPrice())
                .createdAt(booking.getCreatedAt())
                .updatedAt(booking.getUpdatedAt());

        // Set client information based on type
        if (booking.getClient() != null) {
            builder.clientId(booking.getClient().getId())
                    .clientName(booking.getClient().getName())
                    .clientEmail(booking.getClient().getEmail())
                    .clientPhone(booking.getClient().getPhoneNumber())
                    .clientType("USER");
        } else if (booking.getBusinessClient() != null) {
            builder.clientId(booking.getBusinessClient().getId())
                    .clientName(booking.getBusinessClient().getName())
                    .clientEmail(booking.getBusinessClient().getEmail())
                    .clientPhone(booking.getBusinessClient().getPhone())
                    .clientType("BUSINESS_CLIENT");
        }

        // Set staff information if available
        if (booking.getStaff() != null) {
            builder.staffId(booking.getStaff().getId())
                    .staffName(booking.getStaff().getName());
        }

        return builder.build();
    }

    /**
     * Public method to map booking to response (used by controller).
     */
    public ServiceBookingResponse mapToPublicResponse(ServiceBooking booking) {
        return mapToResponse(booking);
    }

    /**
     * Get all bookings for a staff member on a specific date.
     * Returns non-cancelled bookings only.
     */
    @Transactional(readOnly = true)
    public List<ServiceBookingResponse> getBookingsForStaffOnDate(Long staffId, LocalDate date) {
        List<ServiceBooking> bookings = serviceBookingRepository.findByStaffIdAndDateExcludingCancelled(staffId, date);
        return bookings.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Get bookings for a staff member between dates as DTOs.
     */
    @Transactional(readOnly = true)
    public List<ServiceBookingResponse> getBookingsForStaffBetweenDatesDto(Long staffId, LocalDate startDate, LocalDate endDate) {
        List<ServiceBooking> bookings = serviceBookingRepository.findByStaffIdAndDateBetween(staffId, startDate, endDate);
        return bookings.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Get bookings for a business between dates as DTOs.
     */
    @Transactional(readOnly = true)
    public List<ServiceBookingResponse> getBookingsForBusinessBetweenDatesDto(Long businessId, LocalDate startDate, LocalDate endDate) {
        List<ServiceBooking> bookings = serviceBookingRepository.findByServiceBusinessIdAndDateBetween(businessId, startDate, endDate);
        return bookings.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Get bookings for a client (User) as DTOs.
     * Uses eager loading to fetch Service and Business to avoid LAZY loading issues.
     */
    @Transactional(readOnly = true)
    public List<ServiceBookingResponse> getBookingsForClientDto(Long clientId) {
        List<ServiceBooking> bookings = serviceBookingRepository.findByClientIdWithServiceAndBusiness(clientId);
        return bookings.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }
}

