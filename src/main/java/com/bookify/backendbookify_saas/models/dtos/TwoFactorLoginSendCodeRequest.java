package com.bookify.backendbookify_saas.models.dtos;

import com.bookify.backendbookify_saas.models.enums.TwoFactorMethod;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TwoFactorLoginSendCodeRequest {

    @NotBlank(message = "The 2FA challenge token is required")
    private String twoFactorToken;

    @NotNull(message = "Two-factor method is required")
    private TwoFactorMethod method;
}
