package com.bookify.backendbookify_saas.models.dtos;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class TwoFactorSetupResponse {

    private Boolean enabled;
    private String secret;
    private String manualEntryKey;
    private String otpauthUri;
    private String qrCodeDataUrl;
    private List<String> enabledMethods;
    private List<String> availableMethods;
    private List<String> backupCodes;
    private String message;
}
