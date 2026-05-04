package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.models.entities.BusinessInviteToken;
import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;
import com.bookify.backendbookify_saas.repositories.BusinessInviteTokenRepository;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import com.bookify.backendbookify_saas.services.BusinessInviteTokenService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
public class BusinessInviteTokenServiceImpl implements BusinessInviteTokenService {

    private final BusinessInviteTokenRepository repository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public List<String> generateBulkKeys(int count) {
        List<String> rawKeys = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            String raw = generateRandomDigits(6);
            String hash = sha256(raw);

            // ensure uniqueness
            if (repository.findByTokenHash(hash).isPresent()) {
                i--; // retry
                continue;
            }

            BusinessInviteToken token = new BusinessInviteToken();
            token.setRawToken(raw);
            token.setTokenHash(hash);
            token.setStatus(InviteTokenStatus.ACTIVE);
            token.setCreatedAt(LocalDateTime.now());
            repository.save(token);
            rawKeys.add(raw);
        }
        return rawKeys;
    }

    @Override
    public boolean validateKey(String rawKey) {
        String hash = sha256(rawKey);
        Optional<BusinessInviteToken> t = repository.findByTokenHash(hash);
        if (t.isEmpty()) return false;
        BusinessInviteToken token = t.get();
        if (token.getStatus() != InviteTokenStatus.ACTIVE) return false;
        if (token.getExpiresAt() != null && token.getExpiresAt().isBefore(LocalDateTime.now())) return false;
        return true;
    }

    @Override
    @Transactional
    public BusinessInviteToken validateAndConsume(String rawKey, Long userId) {
        String hash = sha256(rawKey);
        BusinessInviteToken token = repository.findByTokenHash(hash)
                .orElseThrow(() -> new IllegalArgumentException("Invalid invite key"));

        if (token.getStatus() != InviteTokenStatus.ACTIVE) throw new IllegalStateException("Invite key not active");
        if (token.getExpiresAt() != null && token.getExpiresAt().isBefore(LocalDateTime.now())) throw new IllegalStateException("Invite key expired");

        // mark used
        token.setStatus(InviteTokenStatus.USED);
        token.setUsedAt(LocalDateTime.now());
        if (userId != null) {
            userRepository.findById(userId).ifPresent(token::setUsedByUser);
        }
        repository.save(token);
        return token;
    }

    @Override
    public List<BusinessInviteToken> listKeys(InviteTokenStatus status) {
        if (status == null) return repository.findAll();
        return repository.findByStatus(status);
    }

    @Override
    @Transactional
    public void revokeKey(Long keyId) {
        repository.findById(keyId).ifPresent(t -> {
            t.setStatus(InviteTokenStatus.REVOKED);
            repository.save(t);
        });
    }

    private String generateRandomDigits(int len) {
        int min = (int) Math.pow(10, len - 1);
        int max = (int) Math.pow(10, len) - 1;
        int num = min + (int) (Math.random() * (max - min + 1));
        return String.valueOf(num);
    }

    private String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
