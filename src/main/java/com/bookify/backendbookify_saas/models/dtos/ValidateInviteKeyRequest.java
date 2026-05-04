package com.bookify.backendbookify_saas.models.dtos;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ValidateInviteKeyRequest {

    @NotBlank
    @Pattern(regexp = "\\d{6,8}", message = "Invite key must be 6-8 digits")
    private String inviteKey;
}
