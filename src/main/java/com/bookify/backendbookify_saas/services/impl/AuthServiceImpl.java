package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.email_SMTP.MailService;
import com.bookify.backendbookify_saas.exceptions.InvalidTokenException;
import com.bookify.backendbookify_saas.exceptions.UserAlreadyExistsException;
import com.bookify.backendbookify_saas.models.dtos.*;
import com.bookify.backendbookify_saas.models.entities.*;
import com.bookify.backendbookify_saas.models.enums.RoleEnum;
import com.bookify.backendbookify_saas.models.enums.TwoFactorMethod;
import com.bookify.backendbookify_saas.models.enums.UserStatusEnum;
import com.bookify.backendbookify_saas.repositories.ActivationTokenRepository;
import com.bookify.backendbookify_saas.repositories.BusinessRepository;
import com.bookify.backendbookify_saas.repositories.CategoryRepository;
import com.bookify.backendbookify_saas.repositories.StaffRepository;
import com.bookify.backendbookify_saas.repositories.UserRepository;
import com.bookify.backendbookify_saas.security.JwtService;
import com.bookify.backendbookify_saas.services.AuthService;
import com.bookify.backendbookify_saas.services.BusinessInviteTokenService;
import com.bookify.backendbookify_saas.services.IndustryFeedbackService;
import com.bookify.backendbookify_saas.services.SmsService;
import com.bookify.backendbookify_saas.services.TwoFactorAuthService;
import jakarta.transaction.Transactional;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * Implémentation du service d'authentification
 * Architecture: Controller → DTO → Service Interface → Service Implementation → Repository → Entity
 */
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private static final Logger logger = LoggerFactory.getLogger(
        AuthServiceImpl.class
    );
    private static final Long OTHER_INDUSTRY_CATEGORY_ID = 10L;
    private static final int TWO_FACTOR_CODE_TTL_MINUTES = 10;
    private static final int BACKUP_CODES_COUNT = 10;

    private final UserRepository userRepository;
    private final ActivationTokenRepository activationTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final MailService mailService;
    private final BusinessRepository businessRepository;
    private final CategoryRepository categoryRepository;
    private final StaffRepository staffRepository;
    private final IndustryFeedbackService industryFeedbackService;
    private final BusinessInviteTokenService inviteTokenService;
    private final TwoFactorAuthService twoFactorAuthService;
    private final SmsService smsService;

    /**
     * Inscription d'un nouveau client/utilisateur avec rôle optionnel
     */
    @Override
    @Transactional
    public AuthResponse signup(SignupRequest request) {
        // 1. Vérifier l'unicité de l'email
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new UserAlreadyExistsException(
                "A user with that email already exists"
            );
        }

        // 2. Déterminer le rôle à utiliser (par défaut CLIENT)
        RoleEnum role =
            request.getRole() == null ? RoleEnum.CLIENT : request.getRole();

        // 3. Créer un utilisateur
        User user = new User();

        // 4. Définir les champs communs (single display name)
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(role);

        // 5. Définir avatar/phone pour tous les utilisateurs
        user.setPhoneNumber(request.getPhoneNumber());
        user.setAvatarUrl(request.getAvatarUrl());

        // 6. Définir le statut initial: ADMIN → VERIFIED, autres → PENDING
        if (role == RoleEnum.ADMIN) {
            user.setStatus(UserStatusEnum.VERIFIED);
        } else {
            user.setStatus(UserStatusEnum.PENDING);
        }

        // 7. Sauvegarder
        User savedUser = userRepository.save(user);

        // 7.1 For business owners, create business in the same transaction.
        // If anything fails below, the user record is rolled back too.
        if (role == RoleEnum.BUSINESS_OWNER) {
            SignupBusinessRequest businessRequest = request.getBusiness();
            if (businessRequest == null) {
                throw new IllegalArgumentException(
                    "Business information is required for business owner signup"
                );
            }

            // Require invite key for business owner signup
            if (
                request.getInviteKey() == null ||
                request.getInviteKey().isBlank()
            ) {
                throw new IllegalArgumentException(
                    "inviteKey is required for Business Owner signup"
                );
            }

            if (businessRepository.existsByOwner(savedUser)) {
                throw new IllegalArgumentException(
                    "You already have a business associated with your account"
                );
            }

            businessRepository
                .findByName(businessRequest.getName())
                .ifPresent(b -> {
                    throw new IllegalArgumentException(
                        "A business with that name already exists"
                    );
                });

            SignupOtherIndustryFeedbackRequest feedbackRequest =
                businessRequest.getOtherIndustryFeedback();
            Long resolvedCategoryId =
                feedbackRequest != null
                    ? OTHER_INDUSTRY_CATEGORY_ID
                    : businessRequest.getCategoryId();

            Category category = categoryRepository
                .findById(resolvedCategoryId)
                .orElseThrow(() ->
                    new IllegalArgumentException("Category not found")
                );

            Business business = new Business();
            business.setName(businessRequest.getName().trim());
            business.setLocation(businessRequest.getLocation().trim());
            business.setPhone(
                businessRequest.getPhone() != null
                    ? businessRequest.getPhone().trim()
                    : null
            );
            business.setEmail(
                businessRequest.getEmail() != null
                    ? businessRequest.getEmail().trim()
                    : null
            );
            business.setDescription(
                businessRequest.getDescription() != null
                    ? businessRequest.getDescription().trim()
                    : null
            );
            business.setEnableResources(Boolean.FALSE);
            business.setEnableServices(Boolean.FALSE);
            business.setOwner(savedUser);
            business.setCategory(category);
            businessRepository.save(business);

            if (feedbackRequest != null) {
                industryFeedbackService.submitFeedback(
                    IndustryFeedbackRequest.builder()
                        .industryName(feedbackRequest.getIndustryName())
                        .description(feedbackRequest.getDescription())
                        .phoneNumber(feedbackRequest.getPhoneNumber())
                        .sourceSlug(feedbackRequest.getSourceSlug())
                        .sourceCategoryName(
                            feedbackRequest.getSourceCategoryName()
                        )
                        .contactEmail(feedbackRequest.getContactEmail())
                        .build()
                );
            }

            // Consume the invite key (mark USED) after successful business creation. This participates in the
            // surrounding transaction so it will rollback if business creation fails.
            inviteTokenService.validateAndConsume(
                request.getInviteKey(),
                savedUser.getId()
            );
        }

        // 8. Si non VERIFIED, créer un token d'activation et envoyer l'email
        if (savedUser.getStatus() != UserStatusEnum.VERIFIED) {
            String activationTokenValue = UUID.randomUUID().toString();
            ActivationToken activationToken = ActivationToken.builder()
                .token(activationTokenValue)
                .user(savedUser)
                .expiryDate(LocalDateTime.now().plusDays(7))
                .build();
            activationTokenRepository.save(activationToken);

            mailService.sendActivationEmail(
                savedUser.getEmail(),
                savedUser.getName(),
                activationTokenValue
            );
        }

        // 9. Build response (generate access token only if account is VERIFIED)
        // Refresh token will be set in httpOnly cookie by the controller
        String token = null;
        if (savedUser.getStatus() == UserStatusEnum.VERIFIED) {
            String subject = String.valueOf(savedUser.getId());
            token = jwtService.generateTokenForSubject(subject);
        }

        AuthResponse response = AuthResponse.builder()
            .token(token)
            .userId(savedUser.getId())
            .name(savedUser.getName())
            .email(savedUser.getEmail())
            .phone(savedUser.getPhoneNumber())
            .role(savedUser.getRole())
            .status(savedUser.getStatus())
            .avatar(savedUser.getAvatarUrl())
            .hasBusiness(role == RoleEnum.BUSINESS_OWNER ? Boolean.TRUE : null)
            .message(
                savedUser.getStatus() == UserStatusEnum.VERIFIED
                    ? "Administrator signup successful. The account is already verified."
                    : "Signup successful. Please check your email to activate your account."
            )
            .build();

        logger.info(
            "Signup response being returned: status={} avatarUrl={} response={}",
            savedUser.getStatus(),
            savedUser.getAvatarUrl(),
            response
        );
        return response;
    }

    /**
     * Activate a user account
     */
    @Override
    @Transactional
    public String activateAccount(String token) {
        // 1. Retrieve the activation token
        ActivationToken activationToken = activationTokenRepository
            .findByToken(token)
            .orElseThrow(() ->
                new InvalidTokenException(
                    "Invalid activation token or already used"
                )
            );

        // 2. Check if the token has expired
        if (activationToken.isExpired()) {
            activationTokenRepository.delete(activationToken);
            throw new InvalidTokenException("Activation token has expired");
        }

        // 3. Retrieve the user
        User user = activationToken.getUser();

        // 4. Check if the account is already activated
        if (user.getStatus() == UserStatusEnum.VERIFIED) {
            activationTokenRepository.delete(activationToken);
            return "Account is already activated.";
        }

        // 5. Activate the account
        user.setStatus(UserStatusEnum.VERIFIED);
        userRepository.save(user);

        // 6. Delete the activation token
        activationTokenRepository.delete(activationToken);

        // 7. Send activation confirmation email
        mailService.sendActivationConfirmationEmail(
            user.getEmail(),
            user.getName()
        );

        // 8. Return success message in English
        return "Your account has been activated successfully. You can now log in.";
    }

    private AuthResponse buildAuthenticatedResponse(User user, String token) {
        AuthResponse.AuthResponseBuilder builder = AuthResponse.builder()
            .token(token)
            .userId(user.getId())
            .name(user.getName())
            .email(user.getEmail())
            .phone(user.getPhoneNumber())
            .role(user.getRole())
            .status(user.getStatus())
            .avatar(user.getAvatarUrl())
            .twoFactorEnabled(user.isTwoFactorEnabled())
            .twoFactorMethods(
                getMethodsForResponse(user).stream().map(Enum::name).toList()
            )
            .message("Login successful");

        if (user.getRole() == RoleEnum.BUSINESS_OWNER) {
            boolean hasBusiness = false;
            Long businessId = null;
            String businessName = null;
            String businessCategoryName = null;
            boolean isAlsoStaff = false;
            Long staffId = null;

            Optional<Business> maybeBusiness = businessRepository.findByOwnerId(
                user.getId()
            );
            if (maybeBusiness.isPresent()) {
                Business b = maybeBusiness.get();
                hasBusiness = true;
                businessId = b.getId();
                businessName = b.getName();
                businessCategoryName =
                    b.getCategory() != null ? b.getCategory().getName() : null;
            }

            Optional<Staff> maybeStaff = staffRepository.findByIdWithBusiness(
                user.getId()
            );
            if (maybeStaff.isPresent()) {
                Staff staff = maybeStaff.get();
                isAlsoStaff = true;
                staffId = staff.getId();
            }

            builder
                .hasBusiness(hasBusiness)
                .businessId(businessId)
                .businessName(businessName)
                .businessCategoryName(businessCategoryName)
                .isAlsoStaff(isAlsoStaff)
                .staffId(staffId);
        }

        if (user.getRole() == RoleEnum.STAFF) {
            Optional<Staff> maybeStaff = staffRepository.findByIdWithBusiness(
                user.getId()
            );
            if (
                maybeStaff.isPresent() && maybeStaff.get().getBusiness() != null
            ) {
                Business b = maybeStaff.get().getBusiness();
                builder
                    .hasBusiness(true)
                    .businessId(b.getId())
                    .businessName(b.getName())
                    .businessCategoryName(
                        b.getCategory() != null
                            ? b.getCategory().getName()
                            : null
                    );
            }
        }

        return builder.build();
    }

    /**
     * Login user
     */
    @Override
    public AuthResponse login(LoginRequest request) {
        logger.info("Login attempt for email: {}", request.getEmail());

        // 1. Find user by email
        var user = userRepository
            .findByEmail(request.getEmail())
            .orElseThrow(() ->
                new IllegalArgumentException("Invalid email or password")
            );

        logger.info(
            "User found - ID: {}, Role: {}, Status: {}",
            user.getId(),
            user.getRole(),
            user.getStatus()
        );

        // 2. Verify password manually (since UserDetailsService now expects ID, not email)
        if (
            !passwordEncoder.matches(request.getPassword(), user.getPassword())
        ) {
            logger.error("Password mismatch for user: {}", user.getEmail());
            throw new IllegalArgumentException("Invalid email or password");
        }

        logger.info("Password verified successfully");

        // 3. Check if account is activated
        if (user.getStatus() == UserStatusEnum.PENDING) {
            throw new IllegalArgumentException(
                "Please activate your account using the activation email we've sent to you"
            );
        }

        if (user.getStatus() == UserStatusEnum.SUSPENDED) {
            throw new IllegalArgumentException(
                "Your account has been suspended. Please contact support."
            );
        }

        if (user.isTwoFactorEnabled()) {
            Set<TwoFactorMethod> enabledMethods = getEnabledMethods(user);
            Set<TwoFactorMethod> responseMethods = getMethodsForResponse(user);
            if (enabledMethods.isEmpty()) {
                throw new IllegalArgumentException(
                    "Two-factor authentication is enabled but no method is configured for this account"
                );
            }

            String challengeToken =
                jwtService.generateTwoFactorChallengeTokenForSubject(
                    String.valueOf(user.getId())
                );

            return AuthResponse.builder()
                .userId(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .phone(user.getPhoneNumber())
                .role(user.getRole())
                .status(user.getStatus())
                .avatar(user.getAvatarUrl())
                .twoFactorEnabled(true)
                .requiresTwoFactor(true)
                .twoFactorToken(challengeToken)
                .twoFactorMethods(
                    responseMethods.stream().map(Enum::name).toList()
                )
                .message("Two-factor authentication code required")
                .build();
        }

        // 4. Generate access token only (refresh token will be set in httpOnly cookie by controller)
        String token = jwtService.generateTokenForSubject(
            String.valueOf(user.getId())
        );
        logger.info("JWT token generated for user ID: {}", user.getId());

        AuthResponse response = buildAuthenticatedResponse(user, token);
        logger.info(
            "Login response being returned: status={} avatar={} response={}",
            user.getStatus(),
            user.getAvatarUrl(),
            response
        );
        return response;
    }

    @Override
    public AuthResponse verifyTwoFactorLogin(
        TwoFactorLoginVerifyRequest request
    ) {
        String userId;
        try {
            userId = jwtService.extractUsername(request.getTwoFactorToken());
        } catch (Exception ex) {
            throw new InvalidTokenException(
                "Invalid or expired two-factor challenge token"
            );
        }

        if (
            !jwtService.isTwoFactorChallengeTokenValid(
                request.getTwoFactorToken(),
                userId
            )
        ) {
            throw new InvalidTokenException(
                "Invalid or expired two-factor challenge token"
            );
        }

        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isTwoFactorEnabled()) {
            throw new IllegalArgumentException(
                "Two-factor authentication is not enabled for this account"
            );
        }

        TwoFactorMethod method =
            request.getMethod() == null
                ? TwoFactorMethod.APP
                : request.getMethod();
        if (!validateTwoFactorCode(user, method, request.getCode(), true)) {
            throw new IllegalArgumentException(
                "Invalid two-factor authentication code"
            );
        }

        String token = jwtService.generateTokenForSubject(
            String.valueOf(user.getId())
        );
        return buildAuthenticatedResponse(user, token);
    }

    @Override
    @Transactional
    public String sendTwoFactorLoginCode(
        TwoFactorLoginSendCodeRequest request
    ) {
        String userId;
        try {
            userId = jwtService.extractUsername(request.getTwoFactorToken());
        } catch (Exception ex) {
            throw new InvalidTokenException(
                "Invalid or expired two-factor challenge token"
            );
        }

        if (
            !jwtService.isTwoFactorChallengeTokenValid(
                request.getTwoFactorToken(),
                userId
            )
        ) {
            throw new InvalidTokenException(
                "Invalid or expired two-factor challenge token"
            );
        }

        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        sendMethodCode(user, request.getMethod(), "LOGIN");
        userRepository.save(user);

        return request.getMethod() == TwoFactorMethod.EMAIL
            ? "A verification code has been sent to your email"
            : "A verification code has been sent by SMS";
    }

    @Override
    @Transactional
    public TwoFactorSetupResponse setupTwoFactor(String userId) {
        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (
            user.getTwoFactorSecret() == null ||
            user.getTwoFactorSecret().isBlank()
        ) {
            String secret = twoFactorAuthService.createCredentials().getKey();
            user.setTwoFactorSecret(secret);
            userRepository.save(user);
        }

        String otpauthUri = twoFactorAuthService.buildOtpAuthUri(
            user.getEmail(),
            user.getTwoFactorSecret()
        );
        String qrCodeDataUrl = twoFactorAuthService.buildQrCodeDataUrl(
            otpauthUri
        );

        return TwoFactorSetupResponse.builder()
            .enabled(user.isTwoFactorEnabled())
            .secret(user.getTwoFactorSecret())
            .manualEntryKey(user.getTwoFactorSecret())
            .otpauthUri(otpauthUri)
            .qrCodeDataUrl(qrCodeDataUrl)
            .enabledMethods(
                getEnabledMethods(user).stream().map(Enum::name).toList()
            )
            .availableMethods(
                Arrays.stream(TwoFactorMethod.values()).map(Enum::name).toList()
            )
            .message(
                user.isTwoFactorEnabled()
                    ? "Two-factor authentication is already enabled"
                    : "Scan the QR code with your authenticator app and enter the generated code to enable 2FA"
            )
            .build();
    }

    @Override
    @Transactional
    public TwoFactorSetupResponse enableTwoFactor(
        String userId,
        TwoFactorCodeRequest request
    ) {
        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        TwoFactorMethod method =
            request.getMethod() == null
                ? TwoFactorMethod.APP
                : request.getMethod();

        if (!validateOrPrepareEnableMethod(user, method, request.getCode())) {
            throw new IllegalArgumentException(
                "Invalid two-factor authentication code"
            );
        }

        Set<TwoFactorMethod> enabledMethods = getEnabledMethods(user);
        enabledMethods.add(method);
        setEnabledMethods(user, enabledMethods);

        user.setTwoFactorEnabled(true);
        user.setTwoFactorEnabledAt(LocalDateTime.now());

        List<String> plainBackupCodes = null;
        if (
            user.getTwoFactorBackupCodesHash() == null ||
            user.getTwoFactorBackupCodesHash().isBlank()
        ) {
            plainBackupCodes = generateBackupCodes();
            storeBackupCodes(user, plainBackupCodes);
        }

        String otpauthUri = twoFactorAuthService.buildOtpAuthUri(
            user.getEmail(),
            user.getTwoFactorSecret()
        );
        String qrCodeDataUrl = twoFactorAuthService.buildQrCodeDataUrl(
            otpauthUri
        );

        userRepository.save(user);

        return TwoFactorSetupResponse.builder()
            .enabled(true)
            .secret(user.getTwoFactorSecret())
            .manualEntryKey(user.getTwoFactorSecret())
            .otpauthUri(otpauthUri)
            .qrCodeDataUrl(qrCodeDataUrl)
            .enabledMethods(enabledMethods.stream().map(Enum::name).toList())
            .availableMethods(
                Arrays.stream(TwoFactorMethod.values()).map(Enum::name).toList()
            )
            .backupCodes(plainBackupCodes)
            .message("Two-factor authentication method enabled successfully")
            .build();
    }

    @Override
    @Transactional
    public String sendTwoFactorSetupCode(
        String userId,
        TwoFactorSendCodeRequest request
    ) {
        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String ctx = (request.getContext() != null &&
            !request.getContext().isBlank())
            ? request.getContext().toUpperCase()
            : "SETUP";

        sendMethodCode(user, request.getMethod(), ctx);
        userRepository.save(user);

        return request.getMethod() == TwoFactorMethod.EMAIL
            ? "A verification code has been sent to your email"
            : "A verification code has been sent by SMS";
    }

    @Override
    @Transactional
    public String disableTwoFactor(
        String userId,
        TwoFactorCodeRequest request
    ) {
        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isTwoFactorEnabled()) {
            return "Two-factor authentication is already disabled";
        }

        TwoFactorMethod method = request.getMethod();
        if (!validateDisableCode(user, method, request.getCode())) {
            throw new IllegalArgumentException(
                "Invalid two-factor authentication code"
            );
        }

        user.setTwoFactorEnabled(false);
        user.setTwoFactorSecret(null);
        user.setTwoFactorEnabledAt(null);
        user.setTwoFactorMethods("");
        user.setTwoFactorEmailCodeHash(null);
        user.setTwoFactorEmailCodeExpiresAt(null);
        user.setTwoFactorSmsCodeHash(null);
        user.setTwoFactorSmsCodeExpiresAt(null);
        user.setTwoFactorBackupCodesHash(null);
        user.setTwoFactorBackupCodesGeneratedAt(null);
        userRepository.save(user);

        return "Two-factor authentication disabled successfully";
    }

    @Override
    @Transactional
    public TwoFactorBackupCodesResponse regenerateBackupCodes(
        String userId,
        TwoFactorCodeRequest request
    ) {
        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (!user.isTwoFactorEnabled()) {
            throw new IllegalArgumentException(
                "Two-factor authentication must be enabled first"
            );
        }

        TwoFactorMethod method =
            request.getMethod() == null
                ? TwoFactorMethod.APP
                : request.getMethod();
        if (!validateTwoFactorCode(user, method, request.getCode(), false)) {
            throw new IllegalArgumentException(
                "Invalid two-factor authentication code"
            );
        }

        List<String> backupCodes = generateBackupCodes();
        storeBackupCodes(user, backupCodes);
        userRepository.save(user);

        return TwoFactorBackupCodesResponse.builder()
            .backupCodes(backupCodes)
            .message("Backup codes regenerated successfully")
            .build();
    }

    /**
     * Refresh JWT access token using a refresh token
     */
    @Override
    public RefreshTokenResponse refreshToken(String refreshToken) {
        try {
            // Extract userId from refresh token
            String userId = jwtService.extractUsername(refreshToken);

            // Validate the refresh token
            if (!jwtService.isTokenValidForSubject(refreshToken, userId)) {
                throw new InvalidTokenException(
                    "Invalid or expired refresh token"
                );
            }

            // Generate new access token only (new refresh token will be set in cookie by controller)
            String newAccessToken = jwtService.generateTokenForSubject(userId);

            return RefreshTokenResponse.builder()
                .token(newAccessToken)
                .message("Token refreshed successfully")
                .build();
        } catch (Exception e) {
            throw new InvalidTokenException("Invalid or expired refresh token");
        }
    }

    /**
     * Logout user (invalidate session)
     * Note: With JWT, actual invalidation would require a token blacklist/redis
     * For now, we just return success and client should delete tokens
     */
    @Override
    public String logout(String userId, String refreshToken) {
        // Validate user exists
        userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // In production, you would:
        // 1. Add refresh token to blacklist (Redis)
        // 2. Clear any session data
        // Example: if (refreshToken != null) { redisTemplate.opsForValue().set("blacklist:" + refreshToken, "true", refreshTokenExpiration, TimeUnit.MILLISECONDS); }

        logger.info("User {} logged out", userId);
        return "Logged out successfully";
    }

    /**
     * Generate a refresh token for a specific user
     */
    @Override
    public String generateRefreshTokenForUser(Long userId) {
        return jwtService.generateRefreshTokenForSubject(
            String.valueOf(userId)
        );
    }

    /**<
     * Get current authenticated user profile
     */
    @Override
    public UserProfileResponse getCurrentUser(String userId) {
        User user = userRepository
            .findById(Long.parseLong(userId))
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        UserProfileResponse.UserProfileResponseBuilder builder =
            UserProfileResponse.builder()
                .userId(user.getId())
                .name(user.getName())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .role(user.getRole())
                .status(user.getStatus())
                .avatarUrl(user.getAvatarUrl())
                .twoFactorEnabled(user.isTwoFactorEnabled())
                .twoFactorMethods(
                    getMethodsForResponse(user)
                        .stream()
                        .map(Enum::name)
                        .toList()
                );

        // If business owner, include business info
        if (user.getRole() == RoleEnum.BUSINESS_OWNER) {
            Optional<Business> maybeBusiness = businessRepository.findByOwnerId(
                user.getId()
            );
            if (maybeBusiness.isPresent()) {
                Business b = maybeBusiness.get();
                builder
                    .hasBusiness(true)
                    .businessId(b.getId())
                    .businessName(b.getName())
                    .businessCategoryName(
                        b.getCategory() != null
                            ? b.getCategory().getName()
                            : null
                    );
            } else {
                builder.hasBusiness(false);
            }
        }

        return builder.build();
    }

    /**
     * Forgot password - Generate 6-digit code and send via email
     */
    @Override
    @Transactional
    public PasswordResetResponse forgotPassword(ForgotPasswordRequest request) {
        User user = userRepository
            .findByEmail(request.getEmail())
            .orElseThrow(() ->
                new IllegalArgumentException("No user found with this email")
            );

        // Generate 6-digit random code
        String resetCode = String.format(
            "%06d",
            new SecureRandom().nextInt(1000000)
        );

        // Set reset token and expiration (15 minutes from now)
        user.setPasswordResetToken(resetCode);
        user.setPasswordResetExpiresAt(LocalDateTime.now().plusMinutes(15));
        userRepository.save(user);

        // Send email with reset code
        try {
            String subject = "Password Reset Code - Bookify";
            String body = String.format(
                """
                Hello %s,

                You have requested to reset your password. Your password reset code is:

                %s

                This code will expire in 15 minutes.

                If you did not request this password reset, please ignore this email.

                Best regards,
                Bookify Team
                """,
                user.getName(),
                resetCode
            );
            mailService.sendSimpleMessage(user.getEmail(), subject, body);
            logger.info(
                "Password reset code sent to email: {}",
                user.getEmail()
            );
        } catch (Exception e) {
            logger.error(
                "Failed to send password reset email to {}: {}",
                user.getEmail(),
                e.getMessage()
            );
            throw new RuntimeException("Failed to send reset code email");
        }

        return PasswordResetResponse.builder()
            .message("Password reset code has been sent to your email")
            .email(user.getEmail())
            .build();
    }

    /**
     * Reset password - Verify 6-digit code and update password
     */
    @Override
    @Transactional
    public PasswordResetResponse resetPassword(ResetPasswordRequest request) {
        User user = userRepository
            .findByEmail(request.getEmail())
            .orElseThrow(() ->
                new IllegalArgumentException("No user found with this email")
            );

        // Verify reset code exists
        if (user.getPasswordResetToken() == null) {
            throw new IllegalArgumentException(
                "No password reset request found for this email"
            );
        }

        // Verify reset code matches
        if (!user.getPasswordResetToken().equals(request.getResetCode())) {
            throw new IllegalArgumentException("Invalid reset code");
        }

        // Verify reset code hasn't expired
        if (
            user.getPasswordResetExpiresAt() == null ||
            LocalDateTime.now().isAfter(user.getPasswordResetExpiresAt())
        ) {
            throw new IllegalArgumentException(
                "Reset code has expired. Please request a new one"
            );
        }

        // Update password
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));

        // Clear reset token and expiration
        user.setPasswordResetToken(null);
        user.setPasswordResetExpiresAt(null);

        userRepository.save(user);

        logger.info(
            "Password successfully reset for user: {}",
            user.getEmail()
        );

        return PasswordResetResponse.builder()
            .message(
                "Password has been reset successfully. You can now login with your new password"
            )
            .email(user.getEmail())
            .build();
    }

    /**
     * Switch context between BUSINESS_OWNER and STAFF modes
     * Only allowed for BO who also has a staff record
     */
    @Override
    public java.util.Map<String, Object> switchContext(
        String userId,
        String activeMode
    ) {
        Long id = Long.parseLong(userId);

        var user = userRepository
            .findById(id)
            .orElseThrow(() -> new IllegalArgumentException("User not found"));

        // Only BUSINESS_OWNER can switch context
        if (user.getRole() != RoleEnum.BUSINESS_OWNER) {
            throw new IllegalArgumentException(
                "Only business owners can switch context"
            );
        }

        // Check if user has a staff record
        var staffRecord = staffRepository.findByIdWithBusiness(id);
        if (staffRecord.isEmpty()) {
            throw new IllegalArgumentException(
                "You do not have a staff record. Cannot switch to staff mode."
            );
        }

        // Validate activeMode value
        if (!activeMode.equals("owner") && !activeMode.equals("staff")) {
            throw new IllegalArgumentException(
                "activeMode must be 'owner' or 'staff'"
            );
        }

        logger.info("User {} switched context to {}", id, activeMode);

        // For now, we return the mode to be stored in localStorage on frontend
        // In a more advanced setup, this could include a new token with an effectiveRole claim
        return java.util.Map.of(
            "message",
            "Context switched successfully",
            "userId",
            id,
            "activeMode",
            activeMode,
            "isAlsoStaff",
            true
        );
    }

    private Set<TwoFactorMethod> getEnabledMethods(User user) {
        Set<TwoFactorMethod> methods = EnumSet.noneOf(TwoFactorMethod.class);

        if (
            user.getTwoFactorMethods() != null &&
            !user.getTwoFactorMethods().isBlank()
        ) {
            Arrays.stream(user.getTwoFactorMethods().split(","))
                .map(String::trim)
                .filter(v -> !v.isBlank())
                .forEach(v -> {
                    try {
                        methods.add(TwoFactorMethod.valueOf(v));
                    } catch (IllegalArgumentException ignored) {
                        // Skip unknown persisted value
                    }
                });
        }

        if (
            methods.isEmpty() &&
            user.getTwoFactorSecret() != null &&
            !user.getTwoFactorSecret().isBlank()
        ) {
            methods.add(TwoFactorMethod.APP);
        }

        return methods;
    }

    private void setEnabledMethods(User user, Set<TwoFactorMethod> methods) {
        String value = methods
            .stream()
            .filter(m -> m != TwoFactorMethod.BACKUP_CODE)
            .map(Enum::name)
            .sorted()
            .collect(Collectors.joining(","));
        user.setTwoFactorMethods(value);
    }

    private Set<TwoFactorMethod> getMethodsForResponse(User user) {
        Set<TwoFactorMethod> methods = EnumSet.noneOf(TwoFactorMethod.class);
        methods.addAll(getEnabledMethods(user));
        if (
            user.getTwoFactorBackupCodesHash() != null &&
            !user.getTwoFactorBackupCodesHash().isBlank()
        ) {
            methods.add(TwoFactorMethod.BACKUP_CODE);
        }
        return methods;
    }

    private boolean validateOrPrepareEnableMethod(
        User user,
        TwoFactorMethod method,
        String code
    ) {
        if (method == TwoFactorMethod.APP) {
            if (
                user.getTwoFactorSecret() == null ||
                user.getTwoFactorSecret().isBlank()
            ) {
                String secret = twoFactorAuthService
                    .createCredentials()
                    .getKey();
                user.setTwoFactorSecret(secret);
            }
            return twoFactorAuthService.verifyCode(
                user.getTwoFactorSecret(),
                code
            );
        }

        if (method == TwoFactorMethod.EMAIL) {
            return verifyOneTimeCode(
                user.getTwoFactorEmailCodeHash(),
                user.getTwoFactorEmailCodeExpiresAt(),
                code
            );
        }

        if (method == TwoFactorMethod.SMS) {
            return verifyOneTimeCode(
                user.getTwoFactorSmsCodeHash(),
                user.getTwoFactorSmsCodeExpiresAt(),
                code
            );
        }

        return false;
    }

    private boolean validateDisableCode(
        User user,
        TwoFactorMethod preferredMethod,
        String code
    ) {
        if (preferredMethod != null) {
            return validateTwoFactorCode(user, preferredMethod, code, true);
        }

        return (
            validateTwoFactorCode(user, TwoFactorMethod.APP, code, true) ||
            validateTwoFactorCode(user, TwoFactorMethod.EMAIL, code, true) ||
            validateTwoFactorCode(user, TwoFactorMethod.SMS, code, true) ||
            validateTwoFactorCode(user, TwoFactorMethod.BACKUP_CODE, code, true)
        );
    }

    private boolean validateTwoFactorCode(
        User user,
        TwoFactorMethod method,
        String code,
        boolean consumeBackupCode
    ) {
        Set<TwoFactorMethod> enabledMethods = getEnabledMethods(user);

        if (
            method != TwoFactorMethod.BACKUP_CODE &&
            !enabledMethods.contains(method)
        ) {
            return false;
        }

        return switch (method) {
            case APP -> user.getTwoFactorSecret() != null &&
            !user.getTwoFactorSecret().isBlank() &&
            twoFactorAuthService.verifyCode(user.getTwoFactorSecret(), code);
            case EMAIL -> verifyOneTimeCode(
                user.getTwoFactorEmailCodeHash(),
                user.getTwoFactorEmailCodeExpiresAt(),
                code
            );
            case SMS -> verifyOneTimeCode(
                user.getTwoFactorSmsCodeHash(),
                user.getTwoFactorSmsCodeExpiresAt(),
                code
            );
            case BACKUP_CODE -> consumeBackupCode
                ? verifyAndConsumeBackupCode(user, code)
                : verifyBackupCode(user, code);
        };
    }

    private boolean verifyOneTimeCode(
        String hash,
        LocalDateTime expiresAt,
        String code
    ) {
        if (
            hash == null ||
            hash.isBlank() ||
            expiresAt == null ||
            LocalDateTime.now().isAfter(expiresAt)
        ) {
            return false;
        }
        return passwordEncoder.matches(code, hash);
    }

    /**
     * Send a one-time verification code to the user via EMAIL or SMS (Telegram).
     *
     * @param context  Why this code is being sent. Used to compose a clear, helpful email.
     *                 Expected values: "LOGIN", "SETUP", "DISABLE_METHOD", "BACKUP_CODES".
     */
    private void sendMethodCode(
        User user,
        TwoFactorMethod method,
        String context
    ) {
        if (
            method == TwoFactorMethod.APP ||
            method == TwoFactorMethod.BACKUP_CODE
        ) {
            throw new IllegalArgumentException(
                "Code sending is only supported for EMAIL or SMS methods"
            );
        }

        String code = String.format(
            "%06d",
            new SecureRandom().nextInt(1_000_000)
        );
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(
            TWO_FACTOR_CODE_TTL_MINUTES
        );

        if (method == TwoFactorMethod.EMAIL) {
            if (user.getEmail() == null || user.getEmail().isBlank()) {
                throw new IllegalArgumentException(
                    "No email address found for this account"
                );
            }
            user.setTwoFactorEmailCodeHash(passwordEncoder.encode(code));
            user.setTwoFactorEmailCodeExpiresAt(expiresAt);

            String subject = buildEmailSubject(context);
            String body = buildEmailBody(
                context,
                code,
                TWO_FACTOR_CODE_TTL_MINUTES
            );
            mailService.sendSimpleMessage(user.getEmail(), subject, body);
            return;
        }

        if (user.getPhoneNumber() == null || user.getPhoneNumber().isBlank()) {
            throw new IllegalArgumentException(
                "No phone number found for this account"
            );
        }
        user.setTwoFactorSmsCodeHash(passwordEncoder.encode(code));
        user.setTwoFactorSmsCodeExpiresAt(expiresAt);
        smsService.sendTwoFactorCode(user.getPhoneNumber(), code);
    }

    /** Build an informative email subject based on the action context. */
    private String buildEmailSubject(String context) {
        return switch (context == null ? "" : context) {
            case "LOGIN" -> "[Kayedni] Login attempt — your verification code";
            case "DISABLE_METHOD" -> "[Kayedni] ⚠️ Security method removal requested";
            case "BACKUP_CODES" -> "[Kayedni] 🔑 Backup codes regeneration requested";
            default -> "[Kayedni] Your verification code";
        };
    }

    /** Build an informative, context-specific email body. */
    private String buildEmailBody(String context, String code, int ttlMinutes) {
        String codeBlock =
            "\n\nVerification code: " +
            code +
            "\n(Expires in " +
            ttlMinutes +
            " minutes)\n";
        String footer =
            "\nIf you did not initiate this action, please change your Kayedni password immediately and contact support.";

        return switch (context == null ? "" : context) {
            case "LOGIN" -> "Someone (hopefully you) is signing in to your Kayedni account." +
            codeBlock +
            "If this was not you, someone else may be trying to access your account. " +
            "Change your password immediately." +
            footer;
            case "DISABLE_METHOD" -> "A request was made to remove an email verification method from your Kayedni account." +
            codeBlock +
            "If you did not request this, your account security is at risk." +
            footer;
            case "BACKUP_CODES" -> "A request was made to regenerate the backup codes for your Kayedni account. " +
            "Your existing backup codes will be invalidated." +
            codeBlock +
            "If you did not request this, take action immediately." +
            footer;
            default -> "Your Kayedni security code for account verification." +
            codeBlock +
            footer;
        };
    }

    private List<String> generateBackupCodes() {
        List<String> codes = new ArrayList<>();
        String alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
        SecureRandom random = new SecureRandom();

        for (int i = 0; i < BACKUP_CODES_COUNT; i++) {
            StringBuilder raw = new StringBuilder();
            for (int j = 0; j < 8; j++) {
                raw.append(alphabet.charAt(random.nextInt(alphabet.length())));
            }
            codes.add(raw.substring(0, 4) + "-" + raw.substring(4));
        }

        return codes;
    }

    private void storeBackupCodes(User user, List<String> plainCodes) {
        String hashes = plainCodes
            .stream()
            .map(passwordEncoder::encode)
            .collect(Collectors.joining("\n"));
        user.setTwoFactorBackupCodesHash(hashes);
        user.setTwoFactorBackupCodesGeneratedAt(LocalDateTime.now());
    }

    private boolean verifyBackupCode(User user, String code) {
        if (
            user.getTwoFactorBackupCodesHash() == null ||
            user.getTwoFactorBackupCodesHash().isBlank()
        ) {
            return false;
        }
        return Arrays.stream(user.getTwoFactorBackupCodesHash().split("\\n"))
            .filter(v -> !v.isBlank())
            .anyMatch(hash -> passwordEncoder.matches(code, hash));
    }

    private boolean verifyAndConsumeBackupCode(User user, String code) {
        if (
            user.getTwoFactorBackupCodesHash() == null ||
            user.getTwoFactorBackupCodesHash().isBlank()
        ) {
            return false;
        }

        List<String> hashes = Arrays.stream(
            user.getTwoFactorBackupCodesHash().split("\\n")
        )
            .filter(v -> !v.isBlank())
            .collect(Collectors.toCollection(ArrayList::new));

        for (int i = 0; i < hashes.size(); i++) {
            if (passwordEncoder.matches(code, hashes.get(i))) {
                hashes.remove(i);
                user.setTwoFactorBackupCodesHash(String.join("\n", hashes));
                userRepository.save(user);
                return true;
            }
        }

        return false;
    }
}
