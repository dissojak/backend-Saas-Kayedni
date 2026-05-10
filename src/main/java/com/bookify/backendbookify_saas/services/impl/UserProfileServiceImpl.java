package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.models.dtos.ChangePasswordRequest;
import com.bookify.backendbookify_saas.models.dtos.ProfileImageResponse;
import com.bookify.backendbookify_saas.models.dtos.UserProfileResponse;
import com.bookify.backendbookify_saas.models.dtos.UserProfileUpdateRequest;
import com.bookify.backendbookify_saas.models.entities.User;
import com.bookify.backendbookify_saas.models.enums.TwoFactorMethod;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import com.bookify.backendbookify_saas.services.UserProfileService;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.IOException;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional
public class UserProfileServiceImpl implements UserProfileService {

    private static final Logger log = LoggerFactory.getLogger(
        UserProfileServiceImpl.class
    );

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final Cloudinary cloudinary;

    @Value("${cloudinary.folder}")
    private String folder;

    @Value("${cloudinary.public-id-prefix}")
    private String publicIdPrefix;

    @Override
    @Transactional(readOnly = true)
    public UserProfileResponse getProfile(Long userId) {
        User user = userRepository
            .findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));
        return toResponse(user);
    }

    @Override
    public UserProfileResponse updateProfile(
        Long userId,
        UserProfileUpdateRequest request
    ) {
        User user = userRepository
            .findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String requestedEmail = safeTrim(request.getEmail());
        if (
            requestedEmail != null &&
            !requestedEmail.equalsIgnoreCase(user.getEmail())
        ) {
            throw new IllegalArgumentException("Email cannot be changed");
        }

        if (request.getName() != null) {
            user.setName(safeTrim(request.getName()));
        }

        if (request.getPhoneNumber() != null) {
            user.setPhoneNumber(safeTrim(request.getPhoneNumber()));
        }
        if (request.getAvatarUrl() != null) {
            user.setAvatarUrl(safeTrim(request.getAvatarUrl()));
        }

        userRepository.save(user);
        return toResponse(user);
    }

    @Override
    public void changePassword(Long userId, ChangePasswordRequest request) {
        User user = userRepository
            .findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (
            !passwordEncoder.matches(
                request.getCurrentPassword(),
                user.getPassword()
            )
        ) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        if (!request.getNewPassword().equals(request.getConfirmNewPassword())) {
            throw new IllegalArgumentException(
                "New password and confirmation do not match"
            );
        }

        if (request.getNewPassword().equals(request.getCurrentPassword())) {
            throw new IllegalArgumentException(
                "New password must be different from current password"
            );
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
    }

    @Override
    public ProfileImageResponse uploadProfileImage(
        Long userId,
        MultipartFile file
    ) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("No file provided");
        }

        User user = userRepository
            .findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String publicId = publicIdPrefix + "-user-" + userId;
        try {
            Map<?, ?> result = cloudinary
                .uploader()
                .upload(
                    file.getBytes(),
                    ObjectUtils.asMap(
                        "folder",
                        folder,
                        "public_id",
                        publicId,
                        "overwrite",
                        true,
                        "invalidate",
                        true
                    )
                );

            String secureUrl =
                result.get("secure_url") != null
                    ? result.get("secure_url").toString()
                    : null;
            String uploadedPublicId =
                result.get("public_id") != null
                    ? result.get("public_id").toString()
                    : publicId;

            if (secureUrl == null) {
                throw new IllegalStateException(
                    "Failed to obtain uploaded image URL"
                );
            }

            user.setAvatarUrl(secureUrl);
            userRepository.save(user);

            return ProfileImageResponse.builder()
                .url(secureUrl)
                .publicId(uploadedPublicId)
                .build();
        } catch (IOException e) {
            log.error("Cloudinary upload failed", e);
            throw new IllegalStateException("Unable to upload profile image");
        }
    }

    private UserProfileResponse toResponse(User user) {
        // ── Resolve active 2FA methods ──────────────────────────────────────
        Set<TwoFactorMethod> enabledMethods = EnumSet.noneOf(
            TwoFactorMethod.class
        );

        String storedMethods = user.getTwoFactorMethods();
        if (storedMethods != null && !storedMethods.isBlank()) {
            Arrays.stream(storedMethods.split(","))
                .map(String::trim)
                .filter(v -> !v.isBlank())
                .forEach(v -> {
                    try {
                        enabledMethods.add(TwoFactorMethod.valueOf(v));
                    } catch (IllegalArgumentException ignored) {
                        // Skip unknown / legacy values
                    }
                });
        }

        // Fallback: if the user has a TOTP secret but the methods list is empty
        // (accounts created before the methods column was introduced)
        if (
            enabledMethods.isEmpty() &&
            user.getTwoFactorSecret() != null &&
            !user.getTwoFactorSecret().isBlank()
        ) {
            enabledMethods.add(TwoFactorMethod.APP);
        }

        // Include BACKUP_CODE only when backup codes are actually stored
        if (
            user.getTwoFactorBackupCodesHash() != null &&
            !user.getTwoFactorBackupCodesHash().isBlank()
        ) {
            enabledMethods.add(TwoFactorMethod.BACKUP_CODE);
        }

        List<String> methodNames = enabledMethods
            .stream()
            .map(Enum::name)
            .collect(Collectors.toList());
        // ────────────────────────────────────────────────────────────────────

        return UserProfileResponse.builder()
            .userId(user.getId())
            .name(safeTrim(user.getName()))
            .email(user.getEmail())
            .phoneNumber(user.getPhoneNumber())
            .role(user.getRole())
            .status(user.getStatus())
            .avatarUrl(user.getAvatarUrl())
            .twoFactorEnabled(user.isTwoFactorEnabled())
            .twoFactorMethods(methodNames)
            .hasBusiness(user.getBusiness() != null)
            .businessId(
                user.getBusiness() != null ? user.getBusiness().getId() : null
            )
            .businessName(
                user.getBusiness() != null ? user.getBusiness().getName() : null
            )
            .businessCategoryName(
                user.getBusiness() != null &&
                    user.getBusiness().getCategory() != null
                    ? user.getBusiness().getCategory().getName()
                    : null
            )
            .build();
    }

    private String safeTrim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
