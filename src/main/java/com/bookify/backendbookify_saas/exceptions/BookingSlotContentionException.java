package com.bookify.backendbookify_saas.exceptions;

/**
 * Raised when concurrent booking operations contend on the same staff/date slot.
 */
public class BookingSlotContentionException extends RuntimeException {

    public BookingSlotContentionException(String message) {
        super(message);
    }

    public BookingSlotContentionException(String message, Throwable cause) {
        super(message, cause);
    }
}
