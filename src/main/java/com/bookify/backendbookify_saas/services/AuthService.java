package com.bookify.backendbookify_saas.services;

import com.bookify.backendbookify_saas.models.dtos.*;
import java.util.Map;

public interface AuthService {
    AuthResponse signup(SignupRequest request);
    AuthResponse login(LoginRequest request);
    AuthResponse verifyTwoFactorLogin(TwoFactorLoginVerifyRequest request);
    String sendTwoFactorLoginCode(TwoFactorLoginSendCodeRequest request);
    String activateAccount(String token);
    RefreshTokenResponse refreshToken(String refreshToken);
    String logout(String userId, String refreshToken);
    UserProfileResponse getCurrentUser(String userId);
    String generateRefreshTokenForUser(Long userId);
    PasswordResetResponse forgotPassword(ForgotPasswordRequest request);
    PasswordResetResponse resetPassword(ResetPasswordRequest request);
    Map<String, Object> switchContext(String userId, String activeMode);
    TwoFactorSetupResponse setupTwoFactor(String userId);
    TwoFactorSetupResponse enableTwoFactor(String userId, TwoFactorCodeRequest request);
    String sendTwoFactorSetupCode(String userId, TwoFactorSendCodeRequest request);
    String disableTwoFactor(String userId, TwoFactorCodeRequest request);
    TwoFactorBackupCodesResponse regenerateBackupCodes(String userId, TwoFactorCodeRequest request);
}
