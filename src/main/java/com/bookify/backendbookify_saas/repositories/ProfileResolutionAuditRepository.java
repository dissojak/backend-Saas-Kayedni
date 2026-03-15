package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.ProfileResolutionAudit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;

public interface ProfileResolutionAuditRepository extends JpaRepository<ProfileResolutionAudit, Long> {
    long countBySourceUsedAndCreatedAtAfter(String sourceUsed, LocalDateTime createdAt);
}