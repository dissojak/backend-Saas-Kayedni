package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.ProfileSnapshotSyncRun;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProfileSnapshotSyncRunRepository extends JpaRepository<ProfileSnapshotSyncRun, Long> {
    Optional<ProfileSnapshotSyncRun> findTopByOrderByCreatedAtDesc();
    Optional<ProfileSnapshotSyncRun> findTopByStatusOrderByEndedAtDesc(String status);
    List<ProfileSnapshotSyncRun> findByStatusInAndAlertSentAtIsNullOrderByCreatedAtAsc(List<String> statuses);
}