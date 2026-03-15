package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.ProfileAlertState;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ProfileAlertStateRepository extends JpaRepository<ProfileAlertState, Long> {
    Optional<ProfileAlertState> findByAlertKey(String alertKey);
}