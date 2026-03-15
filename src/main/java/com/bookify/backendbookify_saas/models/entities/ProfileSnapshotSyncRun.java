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
@Table(name = "profile_snapshot_sync_runs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProfileSnapshotSyncRun {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "started_at", nullable = false)
    private LocalDateTime startedAt;

    @Column(name = "ended_at")
    private LocalDateTime endedAt;

    @Column(nullable = false, length = 32)
    private String status;

    @Column(name = "triggered_by", length = 32)
    private String triggeredBy;

    @Column(name = "synced_count", nullable = false)
    private Integer syncedCount = 0;

    @Column(name = "failed_count", nullable = false)
    private Integer failedCount = 0;

    @Column(name = "source_updated_through")
    private LocalDateTime sourceUpdatedThrough;

    @Lob
    @Column(name = "error_summary", columnDefinition = "LONGTEXT")
    private String errorSummary;

    @Column(name = "alert_sent_at")
    private LocalDateTime alertSentAt;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = createdAt;
        if (startedAt == null) {
            startedAt = createdAt;
        }
        if (syncedCount == null) {
            syncedCount = 0;
        }
        if (failedCount == null) {
            failedCount = 0;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}