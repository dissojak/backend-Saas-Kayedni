package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.IndustryFeedbackSubmission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface IndustryFeedbackSubmissionRepository extends JpaRepository<IndustryFeedbackSubmission, Long> {
    List<IndustryFeedbackSubmission> findTop200ByOrderByCreatedAtDesc();
}
