package com.bookify.backendbookify_saas.models.entities;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;


@Entity
@Table(name = "industry_feedback_submissions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IndustryFeedbackSubmission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "industry_name", nullable = false, length = 150)
    private String industryName;

    @Column(name = "description", length = 2000)
    private String description;

    @Column(name = "phone_number", nullable = false, length = 30)
    private String phoneNumber;

    @Column(name = "source_slug", length = 60)
    private String sourceSlug;

    @Column(name = "source_category_name", length = 150)
    private String sourceCategoryName;

    @Column(name = "contact_email", length = 320)
    private String contactEmail;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }
}
