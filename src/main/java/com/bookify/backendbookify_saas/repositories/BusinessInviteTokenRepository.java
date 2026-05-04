package com.bookify.backendbookify_saas.repositories;

import com.bookify.backendbookify_saas.models.entities.BusinessInviteToken;
import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BusinessInviteTokenRepository extends JpaRepository<BusinessInviteToken, Long> {

    Optional<BusinessInviteToken> findByTokenHash(String tokenHash);

    List<BusinessInviteToken> findByStatus(InviteTokenStatus status);

}
