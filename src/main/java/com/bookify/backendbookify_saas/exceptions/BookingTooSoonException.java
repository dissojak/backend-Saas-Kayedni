package com.bookify.backendbookify_saas.exceptions;


@Getter
public class BookingTooSoonException extends RuntimeException {
    private final long minLeadMinutes;

    public BookingTooSoonException(long minLeadMinutes) {
        super("This slot starts too soon. Online booking requires at least " + minLeadMinutes + " minutes before start time.");
        this.minLeadMinutes = minLeadMinutes;
    }
}
