package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.entities.BusinessInviteToken;
import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;

import java.util.List;

public interface BusinessInviteTokenService {

    List<String> generateBulkKeys(int count);

    boolean validateKey(String rawKey);

    /**
     * Validate and consume the key for a user. Returns the consumed token entity.
     */
    BusinessInviteToken validateAndConsume(String rawKey, Long userId);

    List<BusinessInviteToken> listKeys(InviteTokenStatus status);

    void revokeKey(Long keyId);

}
