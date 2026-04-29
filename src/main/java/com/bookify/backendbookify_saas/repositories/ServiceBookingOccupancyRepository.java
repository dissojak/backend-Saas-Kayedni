package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.ServiceBookingOccupancy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface ServiceBookingOccupancyRepository extends JpaRepository<ServiceBookingOccupancy, Long> {

    @Modifying(clearAutomatically = true)
    @Transactional
    void deleteByBookingId(Long bookingId);
}
