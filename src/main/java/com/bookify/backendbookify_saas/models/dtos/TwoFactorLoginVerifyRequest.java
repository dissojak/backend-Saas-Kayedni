package com.bookify.backendbookify_saas.models.dtos;

import com.bookify.backendbookify_saas.models.enums.TwoFactorMethod;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TwoFactorLoginVerifyRequest {

    @NotBlank(message = "The 2FA challenge token is required")
    private String twoFactorToken;

    @NotBlank(message = "The verification code is required")
    private String code;

    private TwoFactorMethod method;
}