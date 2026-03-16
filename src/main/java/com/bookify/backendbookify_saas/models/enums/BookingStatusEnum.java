package com.bookify.backendbookify_saas.models.enums;

/**
 * Possible states for a booking
 */
public enum BookingStatusEnum {
    PENDING,     // Waiting for confirmation
    CONFIRMED,   // Confirmed
    CANCELLED,   // Cancelled by staff after confirmation
    REJECTED,    // Rejected by staff while still pending
    COMPLETED,   // Completed
    NO_SHOW      // Client did not show up
}
