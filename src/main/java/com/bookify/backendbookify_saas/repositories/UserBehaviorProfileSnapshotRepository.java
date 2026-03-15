package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.UserBehaviorProfileSnapshot;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserBehaviorProfileSnapshotRepository extends JpaRepository<UserBehaviorProfileSnapshot, Long> {
    Optional<UserBehaviorProfileSnapshot> findByUserId(String userId);
}