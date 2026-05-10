package com.bookify.backendbookify_saas.models.dtos;

import com.bookify.backendbookify_saas.models.enums.TwoFactorMethod;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TwoFactorSendCodeRequest {

    @NotNull(message = "Two-factor method is required")
    private TwoFactorMethod method;

    /**
     * Reason/context for sending this code — used to compose a clear email message.
     * Expected values: "SETUP", "DISABLE_METHOD", "BACKUP_CODES".
     * Defaults to "SETUP" if not provided.
     */
    private String context;
}
