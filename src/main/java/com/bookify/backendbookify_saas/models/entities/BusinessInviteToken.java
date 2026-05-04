package com.bookify.backendbookify_saas.models.entities;

import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "business_invite_tokens",
        indexes = {
                @Index(name = "idx_token_hash", columnList = "token_hash"),
                @Index(name = "idx_status", columnList = "status"),
                @Index(name = "idx_assigned_email", columnList = "assigned_email"),
                @Index(name = "idx_expires_at", columnList = "expires_at")
        })
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BusinessInviteToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "raw_token", length = 8)
    private String rawToken;

    @Column(name = "token_hash", length = 64, nullable = false, unique = true)
    private String tokenHash;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by_admin_id", foreignKey = @ForeignKey(name = "fk_invite_created_by_admin"))
    private User createdByAdmin;

    @Column(name = "assigned_email", length = 255)
    private String assignedEmail;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "used_at")
    private LocalDateTime usedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "used_by_user_id", foreignKey = @ForeignKey(name = "fk_invite_used_by_user"))
    private User usedByUser;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 20, nullable = false)
    private InviteTokenStatus status = InviteTokenStatus.ACTIVE;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) createdAt = LocalDateTime.now();
        if (status == null) status = InviteTokenStatus.ACTIVE;
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

}
