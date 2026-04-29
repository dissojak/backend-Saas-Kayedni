package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.IntegrationTestBase;
import com.bookify.backendbookify_saas.exceptions.BookingSlotContentionException;
import com.bookify.backendbookify_saas.models.dtos.ServiceBookingCreateRequest;
import com.bookify.backendbookify_saas.models.entities.*;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import com.bookify.backendbookify_saas.repositories.*;
import com.bookify.backendbookify_saas.util.TestDataBuilder;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Layer 1 Integration Tests for Overbooking Prevention
 *
 * Tests the complete overbooking prevention mechanism using real MySQL database.
 * Each test scenario validates critical paths in the booking service.
 */
@Tag("Layer1")
@DisplayName("Overbooking Prevention Integration Tests")
public class OverbookingL1Test extends IntegrationTestBase {

    @Autowired
        private BookingServiceImpl bookingService;

    @Autowired
    private BusinessRepository businessRepository;

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BusinessClientRepository businessClientRepository;

        @Autowired
        private CategoryRepository categoryRepository;

    @Autowired
    private StaffAvailabilityRepository staffAvailabilityRepository;

    @Autowired
    private ServiceBookingRepository serviceBookingRepository;

    @Autowired
    private ServiceBookingOccupancyRepository occupancyRepository;

    private Business testBusiness;
    private Staff testStaff;
    private Service testService;
    private User testUser;
    private LocalDate testDate;

    @BeforeEach
    @Transactional
    void setUp() {
        testDate = getTestDate();

        // Create test owner and category
        User testOwner = TestDataBuilder.createTestOwner();
        testOwner = userRepository.saveAndFlush(testOwner);

        Category testCategory = TestDataBuilder.createTestCategory(testOwner);
        testCategory = categoryRepository.saveAndFlush(testCategory);

        // Create test business
        testBusiness = TestDataBuilder.createTestBusiness(testOwner, testCategory);
        testBusiness = businessRepository.saveAndFlush(testBusiness);

        // Create test staff
        testStaff = TestDataBuilder.createTestStaff(testBusiness);
        testStaff = staffRepository.saveAndFlush(testStaff);

        // Create staff availability for test date
        StaffAvailability availability = TestDataBuilder.createTestAvailability(testStaff, testDate);
        staffAvailabilityRepository.saveAndFlush(availability);

        // Create test service
        testService = TestDataBuilder.createTestService(testBusiness);
        testService = serviceRepository.saveAndFlush(testService);

        // Create test user
        testUser = TestDataBuilder.createTestUser();
        testUser = userRepository.saveAndFlush(testUser);
    }

    /**
     * Scenario 1: Basic Overlapping Booking Prevention
     *
     * Setup: Create a booking for staff member from 10:00-11:00
     * Action: Attempt to create overlapping booking (10:30-11:30)
     * Expected: BookingSlotContentionException thrown
     */
    @Test
    @Transactional
    @DisplayName("Should prevent basic overlapping bookings")
    void testBasicOverlappingBookingPrevention() {
        // Arrange: Create first booking 10:00-11:00
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())  // 10:00
                .endTime(getMorningEnd())      // 11:00
                .price(BigDecimal.valueOf(50.0))
                .notes("First booking")
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);
        assertNotNull(firstBooking.getId());

        // Act: Attempt overlapping booking 10:30-11:30
        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(LocalTime.of(10, 30))
                .endTime(LocalTime.of(11, 30))
                .price(BigDecimal.valueOf(50.0))
                .notes("Overlapping booking")
                .build();

        // Assert: Should throw exception
        assertThrows(BookingSlotContentionException.class, 
                () -> bookingService.createServiceBookingFromRequest(secondRequest),
                "Should prevent overlapping bookings");
    }

    /**
     * Scenario 2: Partial Overlap Detection
     *
     * Setup: Booking exists 10:00-11:00
     * Action: Attempt booking that partially overlaps (09:30-10:30)
     * Expected: BookingSlotContentionException thrown
     */
    @Test
    @Transactional
    @DisplayName("Should detect partial overlaps - start boundary")
    void testPartialOverlapDetectionStartBoundary() {
        // Arrange: Create booking 10:00-11:00
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())  // 10:00
                .endTime(getMorningEnd())      // 11:00
                .price(BigDecimal.valueOf(50.0))
                .build();

        bookingService.createServiceBookingFromRequest(firstRequest);

        // Act: Attempt partial overlap 09:30-10:30
        ServiceBookingCreateRequest overlappingRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(LocalTime.of(9, 30))
                .endTime(LocalTime.of(10, 30))
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert
        assertThrows(BookingSlotContentionException.class, 
                () -> bookingService.createServiceBookingFromRequest(overlappingRequest));
    }

    /**
     * Scenario 3: Partial Overlap Detection (end boundary)
     *
     * Setup: Booking exists 10:00-11:00
     * Action: Attempt booking that partially overlaps (10:45-11:45)
     * Expected: BookingSlotContentionException thrown
     */
    @Test
    @Transactional
    @DisplayName("Should detect partial overlaps - end boundary")
    void testPartialOverlapDetectionEndBoundary() {
        // Arrange: Create booking 10:00-11:00
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())  // 10:00
                .endTime(getMorningEnd())      // 11:00
                .price(BigDecimal.valueOf(50.0))
                .build();

        bookingService.createServiceBookingFromRequest(firstRequest);

        // Act: Attempt partial overlap 10:45-11:45
        ServiceBookingCreateRequest overlappingRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(LocalTime.of(10, 45))
                .endTime(LocalTime.of(11, 45))
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert
        assertThrows(BookingSlotContentionException.class, 
                () -> bookingService.createServiceBookingFromRequest(overlappingRequest));
    }

    /**
     * Scenario 4: Minute-Level Slot Validation
     *
     * Setup: Booking exists 10:00-11:00
     * Action: Attempt booking 11:00-12:00 (adjacent, not overlapping)
     * Expected: Booking created successfully
     */
    @Test
    @Transactional
    @DisplayName("Should allow adjacent bookings without overlap")
    void testMinuteLevelSlotValidation() {
        // Arrange: Create booking 10:00-11:00
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())  // 10:00
                .endTime(getMorningEnd())      // 11:00
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);

        // Act: Create adjacent booking 11:00-12:00
        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningEnd())        // 11:00
                .endTime(LocalTime.of(12, 0))     // 12:00
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert: Should succeed
        var secondBooking = bookingService.createServiceBookingFromRequest(secondRequest);
        assertNotNull(secondBooking.getId());
        assertNotEquals(firstBooking.getId(), secondBooking.getId());
    }

    /**
     * Scenario 5: Cancelled Bookings Don't Block Slots
     *
     * Setup: Booking created 10:00-11:00, then cancelled
     * Action: Create new booking for same time slot
     * Expected: New booking created successfully
     */
    @Test
    @Transactional
    @DisplayName("Should allow rebooking of cancelled slot")
    void testCancelledBookingsDontBlockSlots() {
        // Arrange: Create and cancel first booking
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);
        bookingService.cancelServiceBooking(firstBooking.getId(), "Test cancellation");

        // Act: Create new booking for same slot
        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert: Should succeed
        var secondBooking = bookingService.createServiceBookingFromRequest(secondRequest);
        assertNotNull(secondBooking.getId());
        assertEquals(BookingStatusEnum.PENDING, secondBooking.getStatus());
    }

    /**
     * Scenario 6: Rejected Bookings Don't Block Slots
     *
     * Setup: PENDING booking created 10:00-11:00, then rejected
     * Action: Create new booking for same time slot
     * Expected: New booking created successfully
     */
    @Test
    @Transactional
    @DisplayName("Should allow rebooking after booking rejection")
    void testRejectedBookingsDontBlockSlots() {
        // Arrange: Create booking and update status to REJECTED
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);
        bookingService.updateBookingStatus(firstBooking.getId(), BookingStatusEnum.REJECTED);

        // Act: Create new booking for same slot
        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert: Should succeed
        var secondBooking = bookingService.createServiceBookingFromRequest(secondRequest);
        assertNotNull(secondBooking.getId());
    }

    /**
     * Scenario 7: CONFIRMED Booking Blocks Slots
     *
     * Setup: CONFIRMED booking exists 10:00-11:00
     * Action: Attempt overlapping booking
     * Expected: BookingSlotContentionException thrown
     */
    @Test
    @Transactional
    @DisplayName("Should block slots for CONFIRMED bookings")
    void testConfirmedBookingBlocksSlots() {
        // Arrange: Create and confirm booking
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .status(BookingStatusEnum.CONFIRMED)
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);
        assertEquals(BookingStatusEnum.CONFIRMED, firstBooking.getStatus());

        // Act: Attempt overlapping booking
        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(LocalTime.of(10, 30))
                .endTime(LocalTime.of(11, 30))
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert
        assertThrows(BookingSlotContentionException.class, 
                () -> bookingService.createServiceBookingFromRequest(secondRequest));
    }

    /**
     * Scenario 8: Rescheduling with Conflict Detection
     *
     * Setup: Booking A (10:00-11:00), Booking B (11:00-12:00)
     * Action: Reschedule Booking A to 10:30-11:30
     * Expected: BookingSlotContentionException thrown
     */
    @Test
    @Transactional
    @DisplayName("Should prevent rescheduling to conflicting time slot")
    void testReschedulingWithConflictDetection() {
        // Arrange: Create two adjacent bookings
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())      // 10:00
                .endTime(getMorningEnd())          // 11:00
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);

        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningEnd())         // 11:00
                .endTime(LocalTime.of(12, 0))     // 12:00
                .price(BigDecimal.valueOf(50.0))
                .build();

        var secondBooking = bookingService.createServiceBookingFromRequest(secondRequest);

        // Act: Attempt to reschedule first booking to overlap with second
        // New time: 10:30-11:30 (overlaps with second booking at 11:00-12:00)

        // Assert
        assertThrows(BookingSlotContentionException.class, 
                () -> bookingService.rescheduleBooking(
                        firstBooking.getId(),
                        testDate,
                        LocalTime.of(10, 30),
                        LocalTime.of(11, 30)));
    }

    /**
     * Scenario 9: Successful Rescheduling to Available Slot
     *
     * Setup: Booking exists 10:00-11:00
     * Action: Reschedule to 14:00-15:00 (available slot)
     * Expected: Booking rescheduled successfully
     */
    @Test
    @Transactional
    @DisplayName("Should successfully reschedule to available time slot")
    void testSuccessfulReschedulingToAvailableSlot() {
        // Arrange: Create booking at morning slot
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);
        Long bookingId = firstBooking.getId();

        // Act: Reschedule to afternoon slot
        var rescheduledBooking = bookingService.rescheduleBooking(
                bookingId,
                testDate,
                getAfternoonStart(),
                getAfternoonEnd());

        // Assert
        assertNotNull(rescheduledBooking);
        assertEquals(getAfternoonStart(), rescheduledBooking.getStartTime());
        assertEquals(getAfternoonEnd(), rescheduledBooking.getEndTime());
        assertEquals(BookingStatusEnum.PENDING, rescheduledBooking.getStatus());

        // Verify original slot is now available
        ServiceBookingCreateRequest newRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        var newBooking = bookingService.createServiceBookingFromRequest(newRequest);
        assertNotNull(newBooking.getId());
    }

    /**
     * Scenario 10: Multiple Staff Independence
     *
     * Setup: Booking for Staff A (10:00-11:00)
     * Action: Create booking for Staff B at same time
     * Expected: Both bookings succeed (different staff)
     */
    @Test
    @Transactional
    @DisplayName("Should allow simultaneous bookings for different staff")
    void testMultipleStaffIndependence() {
        // Arrange: Create second staff
        Staff staffB = TestDataBuilder.createTestStaff(testBusiness);
        staffB.setName("Staff B");
        staffB = staffRepository.saveAndFlush(staffB);

        StaffAvailability availabilityB = TestDataBuilder.createTestAvailability(staffB, testDate);
        staffAvailabilityRepository.saveAndFlush(availabilityB);

        // Create booking for Staff A
        ServiceBookingCreateRequest firstRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(testStaff.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        var firstBooking = bookingService.createServiceBookingFromRequest(firstRequest);

        // Act: Create booking for Staff B at same time
        ServiceBookingCreateRequest secondRequest = ServiceBookingCreateRequest.builder()
                .serviceId(testService.getId())
                .staffId(staffB.getId())
                .clientId(testUser.getId())
                .date(testDate)
                .startTime(getMorningStart())
                .endTime(getMorningEnd())
                .price(BigDecimal.valueOf(50.0))
                .build();

        // Assert: Both should succeed
        var secondBooking = bookingService.createServiceBookingFromRequest(secondRequest);
        assertNotNull(secondBooking.getId());
        assertNotEquals(firstBooking.getId(), secondBooking.getId());
        assertEquals(testStaff.getId(), serviceBookingRepository.findById(firstBooking.getId()).get().getStaff().getId());
        assertEquals(staffB.getId(), serviceBookingRepository.findById(secondBooking.getId()).get().getStaff().getId());
    }
}
