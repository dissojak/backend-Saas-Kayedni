package com.bookify.backendbookify_saas.util;

import com.bookify.backendbookify_saas.models.entities.Business;
import com.bookify.backendbookify_saas.models.entities.BusinessClient;
import com.bookify.backendbookify_saas.models.entities.Category;
import com.bookify.backendbookify_saas.models.entities.Service;
import com.bookify.backendbookify_saas.models.entities.ServiceBooking;
import com.bookify.backendbookify_saas.models.entities.Staff;
import com.bookify.backendbookify_saas.models.entities.StaffAvailability;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.models.enums.AvailabilityStatus;
import com.bookify.backendbookify_saas.models.enums.BookingStatusEnum;
import com.bookify.backendbookify_saas.models.enums.BusinessStatus;
import com.bookify.backendbookify_saas.models.enums.RoleEnum;
import com.bookify.backendbookify_saas.models.enums.UserStatusEnum;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 * Utility methods for creating integration test entities.
 */
public final class TestDataBuilder {

    private TestDataBuilder() {
    }

    private static String uniqueSuffix() {
        return String.valueOf(System.nanoTime());
    }

    public static User createTestOwner() {
        String suffix = uniqueSuffix();
        User owner = new User();
        owner.setName("Test Owner " + suffix);
        owner.setEmail("owner+" + suffix + "@test.com");
        owner.setPassword("password");
        owner.setPhoneNumber("+12345" + suffix.substring(Math.max(0, suffix.length() - 6)));
        owner.setRole(RoleEnum.BUSINESS_OWNER);
        owner.setStatus(UserStatusEnum.VERIFIED);
        return owner;
    }

    public static Category createTestCategory(User createdBy) {
        String suffix = uniqueSuffix();
        Category category = new Category();
        category.setName("Test Category " + suffix);
        category.setDescription("Integration test category");
        category.setIcon("test-icon");
        category.setCreatedBy(createdBy);
        return category;
    }

    public static Business createTestBusiness(User owner, Category category) {
        String suffix = uniqueSuffix();
        Business business = new Business();
        business.setName("Test Business " + suffix);
        business.setLocation("Test Location");
        business.setPhone("+12346" + suffix.substring(Math.max(0, suffix.length() - 6)));
        business.setEmail("business+" + suffix + "@test.com");
        business.setDescription("Test business for integration tests");
        business.setStatus(BusinessStatus.ACTIVE);
        business.setEnableResources(Boolean.FALSE);
        business.setEnableServices(Boolean.TRUE);
        business.setOwner(owner);
        business.setCategory(category);
        return business;
    }

    public static Staff createTestStaff(Business business) {
        String suffix = uniqueSuffix();
        Staff staff = new Staff();
        staff.setName("Test Staff " + suffix);
        staff.setEmail("staff+" + suffix + "@test.com");
        staff.setPassword("password");
        staff.setPhoneNumber("+98765" + suffix.substring(Math.max(0, suffix.length() - 6)));
        staff.setRole(RoleEnum.STAFF);
        staff.setStatus(UserStatusEnum.VERIFIED);
        staff.setEmployerBusiness(business);
        return staff;
    }

    public static StaffAvailability createTestAvailability(Staff staff, LocalDate date) {
        StaffAvailability availability = new StaffAvailability();
        availability.setStaff(staff);
        availability.setDate(date);
        availability.setStatus(AvailabilityStatus.AVAILABLE);
        availability.setStartTime(LocalTime.of(8, 0));
        availability.setEndTime(LocalTime.of(18, 0));
        availability.setUserEdited(Boolean.FALSE);
        return availability;
    }

    public static Service createTestService(Business business) {
        Service service = new Service();
        service.setName("Test Service");
        service.setDescription("Test service for integration tests");
        service.setDurationMinutes(60);
        service.setPrice(BigDecimal.valueOf(50.0));
        service.setActive(Boolean.TRUE);
        service.setBusiness(business);
        return service;
    }

    public static User createTestUser() {
        String suffix = uniqueSuffix();
        User user = new User();
        user.setName("Test Client " + suffix);
        user.setEmail("client+" + suffix + "@test.com");
        user.setPassword("password");
        user.setPhoneNumber("+11111" + suffix.substring(Math.max(0, suffix.length() - 6)));
        user.setRole(RoleEnum.CLIENT);
        user.setStatus(UserStatusEnum.VERIFIED);
        return user;
    }

    public static BusinessClient createTestBusinessClient(Business business) {
        String suffix = uniqueSuffix();
        BusinessClient client = new BusinessClient();
        client.setName("Test Business Client " + suffix);
        client.setEmail("bclient+" + suffix + "@test.com");
        client.setPhone("+22222" + suffix.substring(Math.max(0, suffix.length() - 6)));
        client.setBusiness(business);
        return client;
    }

    public static ServiceBooking createTestBooking(
            Service service,
            Staff staff,
            LocalDate date,
            LocalTime startTime,
            LocalTime endTime) {
        ServiceBooking booking = new ServiceBooking();
        booking.setService(service);
        booking.setStaff(staff);
        booking.setDate(date);
        booking.setStartTime(startTime);
        booking.setEndTime(endTime);
        booking.setStatus(BookingStatusEnum.PENDING);
        booking.setNotes("Test booking");
        booking.setPrice(BigDecimal.valueOf(50.0));
        return booking;
    }
}
