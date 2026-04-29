package com.bookify.backendbookify_saas.models.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

/**
 * Occupied minute-bucket rows for bookings.
 * Rows are created only for existing bookings (no pre-generation by day/staff).
 */
@Entity
@Table(
    name = "service_booking_occupancy",
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_booking_occupancy_staff_date_slot", columnNames = {"staff_id", "date", "slot_index"})
    },
    indexes = {
        @Index(name = "idx_booking_occupancy_booking", columnList = "booking_id"),
        @Index(name = "idx_booking_occupancy_staff_date", columnList = "staff_id,date")
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ServiceBookingOccupancy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "booking_id", nullable = false)
    private Long bookingId;

    @Column(name = "staff_id", nullable = false)
    private Long staffId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "slot_index", nullable = false)
    private Integer slotIndex;
}
