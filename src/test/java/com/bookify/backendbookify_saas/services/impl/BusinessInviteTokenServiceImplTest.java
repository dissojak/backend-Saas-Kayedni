package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.models.entities.BusinessInviteToken;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;
import com.bookify.backendbookify_saas.repositories.BusinessInviteTokenRepository;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;


import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BusinessInviteTokenServiceImplTest {

    @Mock
    private BusinessInviteTokenRepository repository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private BusinessInviteTokenServiceImpl service;

    @Test
    void validateKeyReturnsTrueForActiveToken() {
        String rawKey = "123456";
        BusinessInviteToken token = new BusinessInviteToken();
        token.setTokenHash(sha256(rawKey));
        token.setStatus(InviteTokenStatus.ACTIVE);
        token.setExpiresAt(LocalDateTime.now().plusDays(1));

        when(repository.findByTokenHash(any())).thenReturn(Optional.of(token));

        assertTrue(service.validateKey(rawKey));
        verify(repository).findByTokenHash(sha256(rawKey));
    }

    @Test
    void validateKeyReturnsFalseForExpiredToken() {
        String rawKey = "654321";
        BusinessInviteToken token = new BusinessInviteToken();
        token.setTokenHash(sha256(rawKey));
        token.setStatus(InviteTokenStatus.ACTIVE);
        token.setExpiresAt(LocalDateTime.now().minusMinutes(1));

        when(repository.findByTokenHash(any())).thenReturn(Optional.of(token));

        assertFalse(service.validateKey(rawKey));
    }

    @Test
    void validateAndConsumeMarksTokenUsedAndSetsUser() {
        String rawKey = "111222";
        String hash = sha256(rawKey);

        User usedByUser = new User();
        usedByUser.setId(77L);

        BusinessInviteToken token = new BusinessInviteToken();
        token.setId(10L);
        token.setTokenHash(hash);
        token.setStatus(InviteTokenStatus.ACTIVE);
        token.setExpiresAt(LocalDateTime.now().plusDays(1));

        when(repository.findByTokenHash(hash)).thenReturn(Optional.of(token));
        when(userRepository.findById(77L)).thenReturn(Optional.of(usedByUser));
        when(repository.save(any(BusinessInviteToken.class))).thenAnswer(invocation -> invocation.getArgument(0));

        BusinessInviteToken consumed = service.validateAndConsume(rawKey, 77L);

        assertEquals(InviteTokenStatus.USED, consumed.getStatus());
        assertNotNull(consumed.getUsedAt());
        assertEquals(usedByUser, consumed.getUsedByUser());

        ArgumentCaptor<BusinessInviteToken> captor = ArgumentCaptor.forClass(BusinessInviteToken.class);
        verify(repository).save(captor.capture());
        assertEquals(InviteTokenStatus.USED, captor.getValue().getStatus());
        assertEquals(usedByUser, captor.getValue().getUsedByUser());
    }

    @Test
    void revokeKeyMarksExistingTokenRevoked() {
        BusinessInviteToken token = new BusinessInviteToken();
        token.setId(22L);
        token.setStatus(InviteTokenStatus.ACTIVE);

        when(repository.findById(22L)).thenReturn(Optional.of(token));
        when(repository.save(any(BusinessInviteToken.class))).thenAnswer(invocation -> invocation.getArgument(0));

        service.revokeKey(22L);

        assertEquals(InviteTokenStatus.REVOKED, token.getStatus());
        verify(repository).save(token);
    }

    private static String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
