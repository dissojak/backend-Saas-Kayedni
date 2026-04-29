CREATE TABLE IF NOT EXISTS service_booking_occupancy (
    id BIGINT NOT NULL AUTO_INCREMENT,
    booking_id BIGINT NOT NULL,
    staff_id BIGINT NOT NULL,
    date DATE NOT NULL,
    slot_index INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uk_booking_occupancy_staff_date_slot UNIQUE (staff_id, date, slot_index),
    INDEX idx_booking_occupancy_booking (booking_id),
    INDEX idx_booking_occupancy_staff_date (staff_id, date)
);
