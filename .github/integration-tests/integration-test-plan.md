# Integration Test Plan: Overbooking Prevention

## Project Overview

**Application**: Kayedni Booking Service (backend-Saas-Kayedni)
**Technology Stack**: Spring Boot 3.5.6, Java 21, MySQL 8.0, JPA/Hibernate
**Focus Area**: Overbooking Prevention & Slot Reservation

## Testing Strategy

This document outlines integration tests for the overbooking prevention mechanism in the Kayedni booking service.

### Identified Components Requiring Integration Testing

1. **BookingServiceImpl** - Core booking creation, rescheduling, and cancellation logic
2. **ServiceBookingRepository** - Booking data persistence and conflict queries
3. **ServiceBookingOccupancyRepository** - Minute-level slot reservation and conflict detection
4. **BookingController** - REST API layer for booking operations
5. **StaffAvailabilityRepository** - Staff scheduling constraints

### Dependencies and Test Setup Requirements

**Container Requirements**:
- MySQL 8.0 TestContainer for database integration
- Real database schema with all migrations applied

**Test Data**:
- Business entities (owner, business)
- Staff with availability schedules
- Service definitions with duration
- User/BusinessClient entities

## Layer 1: Local Integration Tests (TestContainers)

### Purpose
Validate overbooking prevention logic using real MySQL database in a TestContainer, ensuring:
- Booking slot reservations work correctly
- Concurrent booking attempts are properly handled
- Minute-level occupancy tracking prevents overlaps
- Status transitions properly manage slot availability

### Test Scenarios

#### Scenario 1: Basic Overlapping Booking Prevention
- **Setup**: Create a booking for staff member from 10:00-11:00
- **Action**: Attempt to create overlapping booking (10:30-11:30) for same staff
- **Expected Result**: `BookingSlotContentionException` thrown

#### Scenario 2: Partial Overlap Detection
- **Setup**: Booking exists 10:00-11:00
- **Action**: Attempt booking that partially overlaps (09:30-10:30)
- **Expected Result**: `BookingSlotContentionException` thrown

#### Scenario 3: Race Condition Handling
- **Setup**: Two concurrent booking requests for same time slot
- **Action**: Submit both booking requests simultaneously/near-simultaneously
- **Expected Result**: One succeeds, other gets `BookingSlotContentionException`

#### Scenario 4: Minute-Level Slot Validation
- **Setup**: Booking exists 10:00-11:00 (60 minutes)
- **Action**: Attempt booking 11:00-12:00 (should succeed - adjacent, not overlapping)
- **Expected Result**: Booking created successfully

#### Scenario 5: Cancelled Bookings Don't Block Slots
- **Setup**: Booking created 10:00-11:00, then cancelled
- **Action**: Create new booking for same time slot
- **Expected Result**: New booking created successfully

#### Scenario 6: Rejected Bookings Don't Block Slots
- **Setup**: PENDING booking created 10:00-11:00, then rejected
- **Action**: Create new booking for same time slot
- **Expected Result**: New booking created successfully

#### Scenario 7: CONFIRMED Booking Blocks Slots
- **Setup**: CONFIRMED booking exists 10:00-11:00
- **Action**: Attempt overlapping booking
- **Expected Result**: `BookingSlotContentionException` thrown

#### Scenario 8: Rescheduling with Conflict Detection
- **Setup**: Booking A (10:00-11:00), Booking B (11:00-12:00)
- **Action**: Reschedule Booking A to 10:30-11:30
- **Expected Result**: `BookingSlotContentionException` thrown

#### Scenario 9: Successful Rescheduling to Available Slot
- **Setup**: Booking exists 10:00-11:00
- **Action**: Reschedule to 14:00-15:00 (available slot)
- **Expected Result**: Booking rescheduled successfully

#### Scenario 10: Multiple Staff Independence
- **Setup**: Booking for Staff A (10:00-11:00)
- **Action**: Create booking for Staff B at same time
- **Expected Result**: Both bookings succeed (different staff)

## Test Execution Order

Tests should run in order:
1. Basic overlap detection
2. Partial overlap detection
3. Minute-level validation
4. Cancelled/Rejected bookings
5. Status-based blocking
6. Rescheduling scenarios
7. Race conditions (concurrency)
8. Multi-staff independence

## Expected Test Coverage

- **Booking Creation**: 100% coverage with conflict scenarios
- **Occupancy Reservation**: All slot blocking/unblocking paths
- **Status Transitions**: PENDING→CONFIRMED→COMPLETED, cancellation flows
- **Rescheduling**: All conflict detection paths
- **Concurrency**: Race condition handling with DataIntegrityViolationException

## Success Criteria

- All 10 test scenarios pass without modification to source code
- No test timeouts or flakiness
- 100% occupancy validation logic coverage
- Concurrent booking attempts handled gracefully
- All status transitions properly manage slot availability

## Test Isolation Convention

- All test classes use `L1Test` suffix
- All classes annotated with `@Tag("Layer1")` for JUnit 5
- Tests run in isolated container environment with fresh data per test

## Notes

- Tests use real MySQL database via TestContainers (no mocking of SDK clients)
- Each test is independent and can run in any order
- Test data cleanup handled by container lifecycle
- Spring context cached across tests for performance
