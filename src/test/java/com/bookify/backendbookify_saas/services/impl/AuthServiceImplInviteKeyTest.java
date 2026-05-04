package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.email_SMTP.MailService;
import com.bookify.backendbookify_saas.models.dtos.*;
import com.bookify.backendbookify_saas.models.entities.*;
import com.bookify.backendbookify_saas.models.enums.InviteTokenStatus;
import com.bookify.backendbookify_saas.models.enums.RoleEnum;
import com.bookify.backendbookify_saas.models.enums.UserStatusEnum;
import com.bookify.backendbookify_saas.repositories.*;
import com.bookify.backendbookify_saas.security.JwtService;
import com.bookify.backendbookify_saas.services.BusinessInviteTokenService;
import com.bookify.backendbookify_saas.services.IndustryFeedbackService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceImplInviteKeyTest {

    @Mock private UserRepository userRepository;
    @Mock private ActivationTokenRepository activationTokenRepository;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private JwtService jwtService;
    @Mock private AuthenticationManager authenticationManager;
    @Mock private MailService mailService;
    @Mock private BusinessRepository businessRepository;
    @Mock private CategoryRepository categoryRepository;
    @Mock private StaffRepository staffRepository;
    @Mock private IndustryFeedbackService industryFeedbackService;
    @Mock private BusinessInviteTokenService inviteTokenService;

    @InjectMocks
    private AuthServiceImpl authService;

    @Test
    void signupForBusinessOwnerRequiresInviteKey() {
        SignupRequest request = buildOwnerSignupRequest(null);

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(any())).thenReturn("encoded");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(1L);
            return user;
        });

        IllegalArgumentException thrown = assertThrows(IllegalArgumentException.class, () -> authService.signup(request));
        assertEquals("inviteKey is required for Business Owner signup", thrown.getMessage());
        verify(inviteTokenService, never()).validateAndConsume(any(), any());
    }

    @Test
    void signupForBusinessOwnerConsumesInviteKeyAfterSuccessfulBusinessCreation() {
        SignupRequest request = buildOwnerSignupRequest("123456");

        User savedUser = new User();
        savedUser.setId(44L);
        savedUser.setStatus(UserStatusEnum.PENDING);
        savedUser.setRole(RoleEnum.BUSINESS_OWNER);
        savedUser.setEmail(request.getEmail());
        savedUser.setName(request.getName());

        Category category = new Category();
        category.setId(10L);
        category.setName("Beauty");

        Business business = new Business();
        business.setId(55L);
        business.setName(request.getBusiness().getName());

        BusinessInviteToken inviteToken = new BusinessInviteToken();
        inviteToken.setId(77L);
        inviteToken.setStatus(InviteTokenStatus.USED);

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(any())).thenReturn("encoded-password");
        when(userRepository.save(any(User.class))).thenReturn(savedUser);
        when(businessRepository.existsByOwner(savedUser)).thenReturn(false);
        when(businessRepository.findByName(request.getBusiness().getName())).thenReturn(Optional.empty());
        when(categoryRepository.findById(10L)).thenReturn(Optional.of(category));
        when(businessRepository.save(any(Business.class))).thenReturn(business);
        when(inviteTokenService.validateAndConsume("123456", 44L)).thenReturn(inviteToken);

        AuthResponse response = authService.signup(request);

        assertNotNull(response);
        assertEquals(44L, response.getUserId());
        assertEquals(RoleEnum.BUSINESS_OWNER, response.getRole());
        verify(inviteTokenService).validateAndConsume("123456", 44L);
        verify(mailService).sendActivationEmail(eq(request.getEmail()), eq(request.getName()), any());
        verify(jwtService, never()).generateTokenForSubject(any());
    }

    private static SignupRequest buildOwnerSignupRequest(String inviteKey) {
        SignupBusinessRequest business = SignupBusinessRequest.builder()
                .name("Test Business")
                .location("Rabat")
                .categoryId(10L)
                .build();

        return SignupRequest.builder()
                .name("Test Owner")
                .email("owner@example.com")
                .password("password123")
                .role(RoleEnum.BUSINESS_OWNER)
                .business(business)
                .inviteKey(inviteKey)
                .build();
    }
}
