package com.bookify.backendbookify_saas.models.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_behavior_profile_snapshots")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserBehaviorProfileSnapshot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false, unique = true, length = 128)
    private String userId;

    @Lob
    @Column(name = "profile_json", nullable = false, columnDefinition = "LONGTEXT")
    private String profileJson;

    @Column(name = "source_last_updated_at")
    private LocalDateTime sourceLastUpdatedAt;

    @Column(name = "synced_at", nullable = false)
    private LocalDateTime syncedAt;

    @Column(name = "snapshot_version", nullable = false)
    private Integer snapshotVersion = 1;

    @Column(name = "stale", nullable = false)
    private boolean stale;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = createdAt;
        if (syncedAt == null) {
            syncedAt = createdAt;
        }
        if (snapshotVersion == null) {
            snapshotVersion = 1;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}