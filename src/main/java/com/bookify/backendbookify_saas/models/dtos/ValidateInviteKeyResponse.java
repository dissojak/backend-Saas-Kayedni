package com.bookify.backendbookify_saas.models.dtos;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ValidateInviteKeyResponse {
    private boolean valid;
    private String message;
}
