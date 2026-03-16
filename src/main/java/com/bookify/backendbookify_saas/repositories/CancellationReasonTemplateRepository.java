package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.CancellationReasonTemplate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CancellationReasonTemplateRepository extends JpaRepository<CancellationReasonTemplate, Long> {

    List<CancellationReasonTemplate> findAllByBusiness_IdOrderByCreatedAtAsc(Long businessId);

    boolean existsByBusiness_IdAndReason(Long businessId, String reason);
}
